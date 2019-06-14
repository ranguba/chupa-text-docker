# Copyright (C) 2017-2019  Kouhei Sutou <kou@clear-code.com>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

FROM debian:stretch
MAINTAINER groonga

RUN \
  echo "debconf debconf/frontend select Noninteractive" | \
    debconf-set-selections

RUN \
  echo "deb http://deb.debian.org/debian stretch-backports main" > \
    /etc/apt/sources.list.d/backports.list

RUN \
  apt update && \
  apt install -y -V \
    abiword \
    apache2 \
    apache2-dev \
    curl \
    g++ \
    gcc \
    git \
    libapr1-dev \
    libaprutil1-dev \
    libreoffice \
    make \
    ruby \
    ruby-dev \
    sudo \
    tzdata \
    xvfb \
    zlib1g-dev && \
  apt install -y -V -t stretch-backports \
    nodejs \
    npm && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/apt/archives/*

RUN gem install bundler
RUN npm install -g yarn

COPY \
   etc/sudoers.d/* \
  /etc/sudoers.d/
RUN \
  chmod 600 /etc/sudoers.d/* && \
  chown root:root /etc/sudoers.d/*

RUN \
  useradd \
    --create-home \
    chupa-text
RUN adduser chupa-text sudo

USER chupa-text
WORKDIR /home/chupa-text

ENV \
  RAILS_ENV=production \
  PATH=/var/lib/gems/2.3.0/bin:$PATH

ENV CHUPA_TEXT_DOCKER_VERSION=2019.06.12.1
RUN git clone --depth 1 https://github.com/ranguba/chupa-text-http-server.git

COPY \
   home/chupa-text/chupa-text-http-server/* \
  /home/chupa-text/chupa-text-http-server/
RUN \
  sudo chown -R chupa-text:chupa-text \
    /home/chupa-text/chupa-text-http-server/

WORKDIR /home/chupa-text/chupa-text-http-server
RUN \
  sudo apt update && \
  bundle install --without development test && \
  sudo gem install passenger && \
  sudo rm -rf /var/lib/apt/lists/* && \
  sudo rm -rf /var/cache/apt/archives/*

RUN \
  bin/rails assets:precompile

CMD ./start.sh
