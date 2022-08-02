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

VNC_COMMAND="vncserver $DISPLAYNO \
    -depth ${DEPTH:-16} \
    -geometry ${GEOMETRY:-1024x768}"

eval $VNC_COMMAND

trap "vncserver -kill $DISPLAYNO; exit 0" SIGINT SIGKILL SIGTERM
#tail -f /root/.vnc/*$DISPLAYNO.log
while true
do
    sleep 15s
    if vncserver $DISPLAYNO > /dev/null 2>&1
    then
        rm /tmp/.X11-unix/X* /tmp/.X*-lock
        pkill Xtightvnc
        eval $VNC_COMMAND
    fi
done

