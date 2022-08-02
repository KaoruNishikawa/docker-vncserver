FROM ubuntu:16.04

# https://qiita.com/yagince/items/deba267f789604643bab
ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root

RUN apt-get -qqy update; \
    apt-get -qqy install --no-install-recommends ubuntu-desktop; \
    apt-get -qqy install \
    gnome-panel \
    gnome-settings-daemon \
    gnome-terminal \
    locales \
    metacity \
    nautilus \
    tightvncserver; \
    locale-gen en_US en_US.UTF-8; \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# https://qiita.com/seigot/items/b16d137e2d2a5220c031
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

COPY vnc-entrypoint.sh /
COPY xstartup /root/.vnc/

ENTRYPOINT ["/vnc-entrypoint.sh"]

HEALTHCHECK ---interval=30s --timeout=15s --start-period=15s --retries=1 \
    CMD if test -f /root/.vnc/*.pid; then rm /tmp/.X11-unix/X* /tmp/.X*-lock && vncserver $VNCARGS; fi

