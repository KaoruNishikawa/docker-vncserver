#!/bin/bash

usage="\n
docker run -it -v \$HOME:\$HOME --network=host --restart=on-failure:3 --rm ghcr.io/KaoruNishikawa/vncserver:latest [-n int] [-d int] [-g intxint]\n\n
where\n
\t -n  Display number (default 1 if available)\n
\t -d  VNC desktop pixel depth in bits (default 16)\n
\t -g  Size of VNC desktop in widthxheight format (default 1024x768)\n
"
echo -e $usage

while getopts 'n:d:g:' option
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
        echo -e '\n'
        [ $PASSWD1 = $PASSWD2 ] && break
        echo "Please try again."
    done
    echo $PASSWD1 | vncpasswd -f > $PASSWDPATH
fi
chmod 600 $PASSWDPATH

VNC_COMMAND="vncserver $DISPLAYNO \
    -depth ${DEPTH:-16} \
    -geometry ${GEOMETRY:-1024x768}"

eval $VNC_COMMAND

echo -e '\033[46mCtrl+C : Terminate the VNC server.\033[0m'
echo -e '\033[46mCtrl+P then Ctrl+Q : Run the server in background.\033[0m'

trap "vncserver -kill $DISPLAYNO; exit 0" SIGINT SIGKILL SIGTERM
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

