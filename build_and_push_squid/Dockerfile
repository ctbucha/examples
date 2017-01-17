FROM ubuntu:xenial

COPY build-scripts build-scripts

WORKDIR build-scripts
RUN ./01_install_buildtools.sh
RUN ./02_build_squid.sh
