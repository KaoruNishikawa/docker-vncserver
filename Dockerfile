FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qqy update && apt-get -qqy install locales; \
    locale-gen en_US en_US.UTF-8; \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8; \
    export LANG=en_US.UTF-8; \
    export LC_ALL=en_US.UTF-8

RUN apt-get -qqy update && apt-get -qqy install \
    tigervnc-standalone-server \
    ubuntu-mate-desktop

COPY vnc-entrypoint.sh /
COPY xstartup /.vnc/

ENTRYPOINT ["/vnc-entrypoint.sh"]

