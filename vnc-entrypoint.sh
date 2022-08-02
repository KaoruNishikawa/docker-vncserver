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

PASSWDPATH=/root/.vnc/passwd
echo ${PASSWD:-password} | vncpasswd -f > $PASSWDPATH
chmod 600 $PASSWDPATH

gsettings set org.gnome.desktop.default-applications.terminal exec 'xterm'

vncserver $DISPLAYNO \
    -depth ${DEPTH:-16} \
    -geometry ${GEOMETRY:-1024x768}

trap "vncserver -kill $DISPLAYNO; exit 0" SIGINT SIGKILL SIGTERM
#tail -f /root/.vnc/*$DISPLAYNO.log
while true; do sleep 5; done
