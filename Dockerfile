FROM ubuntu:17.04
MAINTAINER groonga

RUN \
  apt update && \
  apt install -y -V \
    g++ \
    gcc \
    git \
    libreoffice \
    make \
    ruby \
    ruby-dev \
    sudo \
    xvfb \
    zlib1g-dev && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/apt/archives/*

RUN gem install bundler

COPY \
  files/etc/sudoers.d/* \
       /etc/sudoers.d/

RUN \
  useradd \
    --create-home \
    chupa-text
RUN adduser chupa-text sudo

USER chupa-text
WORKDIR /home/chupa-text

RUN git clone --depth 1 https://github.com/ranguba/chupa-text-http-server.git

COPY \
  files/home/chupa-text/chupa-text-http-server/* \
       /home/chupa-text/chupa-text-http-server/

WORKDIR /home/chupa-text/chupa-text-http-server
RUN \
  sudo apt update && \
  bundle install && \
  sudo rm -rf /var/lib/apt/lists/* && \
  sudo rm -rf /var/cache/apt/archives/*

ENV PATH=/var/lib/gems/2.3.0/bin:$PATH
