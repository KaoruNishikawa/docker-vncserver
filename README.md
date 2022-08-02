# docker-vncserver

VNC server runs on docker.

## Installation

If you don't have docker, install it first.

```shell
git clone https://github.com/KaoruNishikawa/docker-vncserver.git
cd docker-vncserver
docker build . -t vncserver:0.1.0
```

## Usage

Run the following command and connect to the display at `vnc://1xx.xx.xx.xx:5921`.

```shell
docker run -d -v $HOME:$HOME --network=host vncserver:0.1.0 -n 21
```

## Acknowledgments

The following resources constructs this project.

- [docker-ubuntu-desktop](https://github.com/queeno/docker-ubuntu-desktop)
