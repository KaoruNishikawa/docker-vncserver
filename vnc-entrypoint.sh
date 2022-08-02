#!/bin/bash

while getopts 'n:d:g:p:' option
do
    case "$option" in
    	n) DISPLAYNO=$OPTARG ;;
    	d) DEPTH=$OPTARG ;;
    	g) GEOMETRY=$OPTARG ;;
    	p) PASSWD=$OPTARG ;;
    esac
done

if [ ! -z $DISPLAYNO ] && [[ ! $DISPLAYNO == :* ]]
then
    DISPLAYNO=:$DISPLAYNO
fi

gsettings set org.mate.applications-terminal exec xfce4-terminal
gsettings set org.mate.background show-desktop-icons false
killall caja

PASSWDPATH=/.vnc/passwd
echo ${PASSWD:-passwd} | vncpasswd -f > $PASSWDPATH

vncserver $DISPLAYNO \
    -depth ${DEPTH:-16} \
    -geometry ${GEOMETRY:-1024x768} \
    -localhost no \
    -passwd $PASSWDPATH \
	-xstartup /.vnc/xstartup

trap "vncserver -kill $DISPLAYNO; exit 0" SIGINT SIGKILL SIGTERM
while :; do sleep 10s; done

