FROM ubuntu:16.04

# https://qiita.com/yagince/items/deba267f789604643bab
ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root

RUN apt-get -y update; \
    apt-get -y install --no-install-recommends ubuntu-desktop; \
    apt-get -y install \
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

