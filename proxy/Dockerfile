# Copyright (C) 2017-2025  Sutou Kouhei <kou@clear-code.com>
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

FROM ubuntu:24.04
MAINTAINER groonga

RUN \
  echo "debconf debconf/frontend select Noninteractive" | \
    debconf-set-selections

RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime

RUN \
  apt update && \
  apt install -y -V \
    squid && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/apt/archives/*

COPY start.sh /

CMD ./start.sh
