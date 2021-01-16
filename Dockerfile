FROM debian:stretch
RUN apt-get update && \
    apt-get install -y \
      git bats ffmpeg curl libxml2-utils python3-mutagen
RUN mkdir -p /opt/dikoreco
WORKDIR /opt/dikoreco
