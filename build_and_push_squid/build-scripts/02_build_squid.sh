#!/bin/bash

# Run this on an Ubuntu 16.04 machine to create the following packages:
# - squid-common_3.5.12-1ubuntu7.2_all.deb
# - squid_3.5.12-1ubuntu7.2_amd64.deb
# - squidclient_3.5.12-1ubuntu7.2_amd64.deb

# drop squid3 build folder
rm -R build/squid3

# we will be working in a subfolder make it
mkdir -p build/squid3

# copy the patch to the working folder
cp rules.patch build/squid3/rules.patch

# decend into working directory
pushd build/squid3

# get squid3 from ubuntu repository
wget http://us.archive.ubuntu.com/ubuntu/pool/main/s/squid3/squid3_3.5.12-1ubuntu7.2.dsc
wget http://us.archive.ubuntu.com/ubuntu/pool/main/s/squid3/squid3_3.5.12.orig.tar.gz
wget http://us.archive.ubuntu.com/ubuntu/pool/main/s/squid3/squid3_3.5.12-1ubuntu7.2.debian.tar.xz

# unpack the source package
dpkg-source -x squid3_3.5.12-1ubuntu7.2.dsc

# modify configure options in debian/rules, add --enable-ssl --enable-ssl-crtd
patch squid3-3.5.12/debian/rules < ../../rules.patch

# build the package
cd squid3-3.5.12 && dpkg-buildpackage -rfakeroot -b

# and revert
popd
