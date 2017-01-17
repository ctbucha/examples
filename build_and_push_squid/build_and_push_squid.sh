#!/bin/bash

# This script is used to build Squid inside a container and then push the
# resulting deb files to a private apt repo.

UBUNTU_PACKAGE_S3_BUCKET=examplebucket-ubuntu-packages
SQUID_ARCH=amd64
SQUID_PACKAGES=(
  squid-common_3.5.12-1ubuntu7.2_all.deb
  squid_3.5.12-1ubuntu7.2_amd64.deb
  squidclient_3.5.12-1ubuntu7.2_amd64.deb
)
CONTAINER_ARTIFACT_PATH=/build-scripts/build/squid3/
LOCAL_ARTIFACT_PATH=build/
IMAGE_NAME=secure_nat_builder
IMAGE_VERSION=0.0.1
APT_CODENAME=xenial
APT_COMPONENT=myrepo
APT_KEY=23955501

# Build Squid while building container
docker build -t $IMAGE_NAME:$IMAGE_VERSION .

# Copy Squid package artifacts (deb) to local host from container
container_id=$(docker create $IMAGE_NAME:$IMAGE_VERSION)
mkdir -p $LOCAL_ARTIFACT_PATH
for pkg in ${SQUID_PACKAGES[*]}; do
  docker cp $container_id:$CONTAINER_ARTIFACT_PATH/$pkg $LOCAL_ARTIFACT_PATH
done
docker rm -v $container_id

# Push Squid packages to ubuntu repo on S3
#
# Requires deb-s3:
#   $ gem install deb-s3
#
# Set AWS_PROFILE env var on this script to set which AWS profile to use to
# access the S3 bucket.
for pkg in ${SQUID_PACKAGES[*]}; do
  deb-s3 upload \
    --bucket $UBUNTU_PACKAGE_S3_BUCKET \
    --arch $SQUID_ARCH \
    --codename $APT_CODENAME \
    --component $APT_COMPONENT \
    --sign $APT_KEY \
    $LOCAL_ARTIFACT_PATH/$pkg
done
