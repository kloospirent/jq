FROM debian:9

ENV installdir /opt

ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

RUN mkdir -p ${installdir}

# get dependencies, build, and remove anything we don't need for running jq.
# valgrind seems to have trouble with pthreads TLS so it's off.

RUN cd ${installdir} && \
    apt-get update && \
    apt-get install -y \
        build-essential \
        autoconf \
        libtool \
        git \
        bison \
        flex \
        python3 \
        python3-pip \
        wget && \
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
