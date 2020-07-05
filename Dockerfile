FROM golang:alpine as build

RUN apk add --update curl git
RUN GEOIPUPDATE_VERSION=$(curl --silent "https://api.github.com/repos/maxmind/geoipupdate/releases/latest" \
    | grep '"tag_name":' \
    | sed -E 's/.*"([^"]+)".*/\1/') \
    && git clone  --branch ${GEOIPUPDATE_VERSION} --depth 1 https://github.com/maxmind/geoipupdate.git /tmp/build

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
