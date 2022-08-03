#!/bin/bash

while getopts 'n:d:g:p:' option
do
    case "$option" in
        n) DISPLAYNO=$OPTARG ;;
        d) DEPTH=$OPTARG ;;
        g) GEOMETRY=$OPTARG ;;
    esac
done

if [ ! -z $DISPLAYNO ] && [[ ! $DISPLAYNO == :* ]]
then
    DISPLAYNO=:$DISPLAYNO
fi

PASSWDPATH=/root/.vnc/passwd
if [ ! -f $PASSWDPATH ]
then
    # https://stackoverflow.com/questions/22249029/how-to-safely-confirm-a-password-by-entering-it-twice-in-a-bash-script
    while true
    do
        read -s -p "Set VNC password: " PASSWD1
        echo
        read -s -p "Enter password again: " PASSWD2
        echo
        [ $PASSWD1 = $PASSWD2 ] && break
        echo "Please try again."
    done
    echo $PASSWD | vncpasswd -f > $PASSWDPATH
fi
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

