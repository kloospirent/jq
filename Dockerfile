FROM ubuntu:16.04

ENV installdir /opt
ENV outdir /code

ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

RUN mkdir -p ${installdir}
RUN mkdir -p ${outdir}

ENV CC=/export/crosstools/spirent-yocto-1.5/x86_64/bin/x86_64-gcc

# get dependencies, build, and remove anything we don't need for running jq.
# valgrind seems to have trouble with pthreads TLS so it's off.

# setup build environment
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        autoconf \
        libtool \
        git \
        bison \
        flex \
        python3 \
        python3-pip \
        wget

ENV ARTIFACTORY=http://artifactory.cal.ci.spirentcom.com/artifactory

RUN mkdir -p /export/crosstools && \
    wget $ARTIFACTORY/crosstools/crosstools-yocto-1.5-x86_64-gcc-8.2.0.tar.xz && \
    tar -C /export/crosstools -xf crosstools-yocto-1.5-x86_64-gcc-8.2.0.tar.xz && \
    rm crosstools-yocto-1.5-x86_64-gcc-8.2.0.tar.xz

RUN cd ${installdir} && \
    pip3 install pipenv && \
    git clone https://github.com/SpirentOrion/jq.git && \
    cd jq && \
    git submodule update --init && \
    autoreconf -fi && \
    ./configure --with-oniguruma=builtin --disable-docs && \
    make -j8 && \
    make check && \
    make install && \
    apt-get purge -y \
        build-essential \
        autoconf \
        libtool \
        bison \
        git \
        flex \
        python3 \
        python3-pip && \
    apt-get autoremove -y