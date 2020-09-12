FROM debian:10-slim as build

#LABEL MAINTAINER=cincan.io
#Based on the work of cincan.io, all credit to them for original Dockerfile
LABEL maintainer="chris.bensch@gmail.com"

RUN apt-get update && apt-get install -y --no-install-recommends \
    libboost-regex-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-filesystem-dev \
    libssl-dev \
    build-essential \
    cmake \
    git \
    ca-certificates

RUN git clone --depth=1 https://github.com/JusticeRage/Manalyze.git /Manalyze && \
    cd /Manalyze && \
    cmake . && make && make install

FROM debian:10-slim as env

COPY --from=build /usr/local/bin /usr/local/bin
COPY --from=build /usr/local/lib /usr/local/lib
COPY --from=build /etc/manalyze /etc/manalyze

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libboost-regex1.67-dev \
    libboost-program-options1.67.0 \
    libboost-system1.67.0 \
    libboost-filesystem1.67.0 \
    libssl1.1 && \
    ldconfig && \
    adduser --shell /sbin/nologin --disabled-login --gecos "" appuser && \
    mkdir -p /home/appuser/

WORKDIR /usr/local/bin
COPY "manalyze-switch.sh" "manalyze-switch.sh"
RUN chmod +x manalyze-switch.sh

USER appuser
WORKDIR /home/appuser

ENTRYPOINT ["/usr/local/bin/manalyze-switch.sh"]
