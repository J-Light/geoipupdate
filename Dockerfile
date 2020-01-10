FROM golang:alpine as build

ENV GEOIPUPDATE_VERSION 4.1.5

RUN apk add --update curl git
RUN git clone  --branch v${GEOIPUPDATE_VERSION} --depth 1 https://github.com/maxmind/geoipupdate.git /tmp/build

WORKDIR /tmp/build/cmd/geoipupdate
RUN go build

FROM alpine:latest
RUN apk add --update ca-certificates \
        && rm -rf /var/cache/apk/*  \
        && mkdir -p /usr/local/geoipupdate \
        && mkdir -p /etc/geoipupdate

COPY --from=build /tmp/build/cmd/geoipupdate/geoipupdate /usr/bin/
WORKDIR /usr/local/geoipupdate

ADD entry_point.sh /
CMD [ "/entry_point.sh"]
