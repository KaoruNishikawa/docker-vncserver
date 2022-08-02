FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root

RUN apt-get -qqy update; \
    apt-get -qqy install --no-install-recommends ubuntu-desktop; \
    apt-get -qqy install \
        gnome-panel \
        gnome-settings-daemon \
        gnome-terminal \
        metacity \
        nautilus \
        tightvncserver; \

COPY vnc-entrypoint.sh /
COPY xstartup /root/.vnc/

ENTRYPOINT ["/vnc-entrypoint.sh"]

