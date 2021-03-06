FROM danday74/nginx-lua

RUN apt-get update
RUN apt-get install -y curl dnsmasq dnsutils

RUN echo "listen-address=127.0.0.1" >> /etc/dnsmasq.conf
RUN echo "user=root" >> /etc/dnsmasq.conf
RUN echo "prepend domain-name-servers 127.0.0.1;" >> /etc/dhcp/dhclient.conf
RUN echo "nameserver 127.0.0.1" >> /etc/resolvconf/resolv.conf.d/base

ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.8.2
ENV DOCKER_SHA256 97a3f5924b0b831a310efa8bf0a4c91956cd6387c4a8667d27e2b2dd3da67e4d

RUN curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-$DOCKER_VERSION" -o /usr/local/bin/docker \
        && echo "${DOCKER_SHA256}  /usr/local/bin/docker" | sha256sum -c - \
        && chmod +x /usr/local/bin/docker

ADD nginx.conf /nginx/conf/nginx.conf
RUN mkdir /nginx/lua
ADD lookup.lua /nginx/lua/lookup.lua

CMD dnsmasq && nginx -g "daemon off;"
