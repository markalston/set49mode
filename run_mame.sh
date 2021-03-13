#!/bin/bash
ROM=$1
LOGPATH=/home/roms/MAME/logs
DEBUG=1
MAME=mame
JOYMAP=$(/usr/local/bin/joymap.pl $ROM /home/roms/MAME/ini/joymodes.ini /home/roms/MAME/ini/overrides.ini)

if [ $ROM == 'dragonslair' ] || [ $ROM == 'spaceace' ]
then
    /usr/local/bin/rotator.pl 8
    /usr/local/bin/daphne.sh $ROM
    /usr/local/bin/rotator.pl 49    
    exit
fi

if [ $JOYMAP == '49' ] || [ $JOYMAP == 'mouse' ] || [$JOYMAP == 'analog']
then
    /usr/local/bin/rotator.pl $JOYMAP
    JOYMAPCMD=''
else
    /usr/local/bin/rotator.pl 49    
    JOYMAPCMD="-joymap $JOYMAP"
fi

if [ $ROM == 'qbert' ] 
then
    ledspicerd &
fi

#  Rotate and keep last 8 logs
#
for i in {8..0}; do mv $LOGPATH/$ROM-$i.log.gz $LOGPATH/$ROM-$((i+1)).log.gz; done
mv $LOGPATH/$ROM.log $LOGPATH/$ROM-0.log
gzip $LOGPATH/$ROM-0.log

if [ $DEBUG -eq 1 ]
then
   $MAME -noskip_gameinfo -v $JOYMAPCMD $ROM 2>&1 > $LOGPATH/$ROM.log
else
    $MAME $JOYMAPCMD $ROM 2>&1 > $LOGPATH/$ROM.log
fi

if [ $ROM == 'qbert' ] 
then
    killall ledspicerd
fi

/usr/local/bin/rotator.pl 49


