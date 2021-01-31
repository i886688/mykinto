FROM golang:alpine AS builder
RUN apk update && apk add --no-cache git bash curl
WORKDIR /go/src/v2ray.com/core
RUN git clone --progress https://github.com/v2fly/v2ray-core.git . && \
    bash ./release/user-package.sh nosource noconf codename=$(git describe --tags) buildname=docker-fly abpathtgz=/tmp/v2ray.tgz

FROM alpine
COPY --from=builder /tmp/v2ray.tgz /tmp
RUN mkdir -p /usr/bin/v2ray && \
    tar xvfz /tmp/v2ray.tgz -C /usr/bin/v2ray && \
    rm -rf /tmp/v2ray.tgz
    
WORKDIR /usr/bin/v2ray
RUN ls | grep -v v2ray | xargs rm

ADD v2ray.sh /v2ray.sh
RUN chmod +x /v2ray.sh
CMD /v2ray.sh
