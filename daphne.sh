#!/bin/sh
ROM=$1
cd /home/roms/daphne_files

xterm -T "Joymap" -e "/usr/local/bin/joymap -d /dev/input/js0 -L 5 -9 1 -A space -B Alt_L -8 Shift_L -D Escape" &
xterm -T "Joymap" -e "/usr/local/bin/joymap -d /dev/input/js1 -G KP_Divide -H KP_Multiply -E KP_Subtract -9 6 -K 2" &
sleep 0.25
if [ $ROM == 'dragonslair' ]
then
    daphne dle21 vldp -fullscreen -framefile ./DVD2DAPH/DL20/lair_dl20.txt
elif [ $ROM == 'spaceace' ]
then
    daphne sae vldp -fullscreen -framefile ./DVD2DAPH/SADVDROM/ace_dvdrom.txt
fi

sleep 0.25

killall -s SIGINT joymap


