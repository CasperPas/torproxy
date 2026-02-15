FROM alpine:latest
LABEL maintainer="Jeff Le <me@jeffle.dev>"

# Install tor and privoxy
RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash curl privoxy shadow tini tor tzdata

COPY proxyconfig.sh /tmp/
RUN /tmp/proxyconfig.sh

COPY torproxy.sh /usr/bin/

EXPOSE 8118 9050 9051

HEALTHCHECK --interval=60s --timeout=15s --start-period=20s \
            CMD curl -sS --http1.1 --socks5-hostname localhost:9050 \
            'https://check.torproject.org/api/ip' | grep -q '"IsTor":true'

VOLUME ["/etc/tor", "/var/lib/tor"]

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/torproxy.sh"]
