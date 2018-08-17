FROM ubuntu:18.04

LABEL "author"="github.com/sofianinho"
LABEL "system"="ubuntu 18.04"
LABEL "version"="iperf 3.6 (cJSON 1.5.2)"
LABEL "features"="CPU affinity setting, IPv6 flow label, SCTP, TCP congestion algorithm setting, sendfile / zerocopy, socket pacing, authentication"

ARG VERSION=3.6
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y \
  && apt-get install -y --no-install-recommends\
    autoconf \
    automake \
    build-essential \
    git \
    ca-certificates \
    curl \
    libssl-dev \
    libc6 \
    libsctp-dev \
  && mkdir /app && cd /app \
  && curl -L -s -O -J https://downloads.es.net/pub/iperf/iperf-$VERSION.tar.gz \
  && curl -L -s -O -J https://downloads.es.net/pub/iperf/iperf-$VERSION.tar.gz.sha256 \
  && echo "checking sh256 checksum" \
  && sha256sum iperf-$VERSION.tar.gz > test.sha256 \
  && diff test.sha256 iperf-$VERSION.tar.gz.sha256 \
  && tar xvfz iperf-$VERSION.tar.gz && rm iperf-$VERSION.tar.gz* test.sha256

WORKDIR /app/iperf-$VERSION

RUN ./configure \
  && make \
  && make install


FROM ubuntu:18.04

LABEL "author"="github.com/sofianinho"
LABEL "system"="ubuntu 18.04"
LABEL "version"="iperf 3.6 (cJSON 1.5.2)"
LABEL "features"="CPU affinity setting, IPv6 flow label, SCTP, TCP congestion algorithm setting, sendfile / zerocopy, socket pacing, authentication"


RUN mkdir -p /app/lib

COPY --from=0 /usr/local/bin/iperf3 /app/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1 /app/lib
COPY --from=0 /lib/x86_64-linux-gnu/libm.so.6 /app/lib
COPY --from=0 /lib/x86_64-linux-gnu/libdl.so.2 /app/lib
COPY --from=0 /usr/lib/x86_64-linux-gnu/libsctp.so.1 /app/lib
COPY --from=0 /usr/local/lib/libiperf.so.0 /app/lib

ENV PATH="/app:$PATH"
ENV LD_LIBRARY_PATH="/app/lib:$LD_LIBRARY_PATH"


EXPOSE 5201/tcp 5201/udp 5201/sctp

ENTRYPOINT ["iperf3"]

