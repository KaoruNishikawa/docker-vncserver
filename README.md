# docker-vncserver

VNC server runs on docker.

## Installation

If you don't have docker, install it first.

## Usage

Run the following command and connect to the display at `1xx.xx.xx.xx:5920` (IP address : specified port) using [VNC Viewer](https://www.realvnc.com/en/connect/download/viewer/).

```shell
docker run -it -v $HOME:$HOME -p 5920:5901 --restart=on-failure:3 ghcr.io/KaoruNishikawa/docker-vncserver:latest
```

## Build from source

```shell
git clone https://github.com/KaoruNishikawa/docker-vncserver.git
cd docker-vncserver
docker build . -t vncserver:0.1.0
```

## Acknowledgments

The following resources construct this project.

- [docker-ubuntu-desktop](https://github.com/queeno/docker-ubuntu-desktop)

