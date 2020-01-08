FROM alpine:latest

ENV GEOIPUPDATE_VERSION 4.1.5

RUN wget https://github.com/maxmind/geoipupdate/releases/download/v${GEOIPUPDATE_VERSION}/geoipupdate_${GEOIPUPDATE_VERSION}_linux_amd64.tar.gz -O geoupdate.tar.gz \
&& GEO_DIR=$(tar -tf geoupdate.tar.gz | head -1 | cut -f1 -d /) \
&& tar -xf geoupdate.tar.gz \
&& mv ${GEO_DIR}/geoipupdate /usr/local/bin/geoipupdate \
&& mkdir -p /usr/local/etc \
&& rm -vrf ${GEO_DIR}

CMD ["geoipupdate", "-v"]