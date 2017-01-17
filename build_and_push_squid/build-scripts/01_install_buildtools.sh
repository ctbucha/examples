#!/bin/bash

# install build tools
apt-get update -y
apt-get -y install apt-utils devscripts build-essential fakeroot debhelper dh-autoreconf cdbs wget

# install build dependences for squid
patch /etc/apt/sources.list < sources.list.patch
apt-get update -y
apt-get -y build-dep squid

# install additional packages for new squid
apt-get -y install nettle-dev libgnutls28-dev libssl-dev libdbi-perl
