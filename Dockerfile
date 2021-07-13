FROM centos:7

ARG VERSION="1.16.6"
LABEL build_version="Go version: ${VERSION}"
LABEL maintainer="Thomas Willi <twi@espros.com>"

RUN \
    echo "**** install dependencies ****" && \
    yum -y update  && \
    yum -y install \
        gtk2-devel \
        gtk3-devel \
        pango-devel \
        glib2-devel \
        gtksourceview2-devel \
        wget \
        tar \
        rsync \
        dh-autoreconf \
        curl-devel \
        expat-devel \
        gettext-devel \
        openssl-devel \
        perl-devel \
        zlib-devel \
        openssh \
        openssh-server \
        openssh-clients \
        make \
        gcc \
        perl-CPAN && \
    wget -q https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.23.0.tar.gz && \
    tar -xf git*.tar.gz && \
    cd git* && \
    ./configure && \
    make -s && \
    make -s install && \
    cd .. && rm -rf git* && \
    echo "**** install Go ****" && \
    wget -q https://dl.google.com/go/go${VERSION}.linux-amd64.tar.gz && \
    tar -xf go*.tar.gz -C /usr/local && \
    rm -rf go*.tar.gz

RUN \
    echo "**** Clean up ****" && \
    yum clean all && \
    rm -rf \
        /tmp/* \
        /var/tmp/*

ENV GOROOT="/usr/local/go"
ENV GOPATH="/go"
ENV PATH="PATH=${PATH}:/usr/local/go/bin"

RUN \
    mkdir -p \
        "$GOPATH/src" \
        "$GOPATH/bin" && \
    chmod -R 777 "$GOPATH"
