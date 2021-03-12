#!/bin/bash
ROM=$1
/usr/local/bin/set49way.pl $ROM /home/roms/MAME/ini/49waymodes.ini happs49
mame64 $ROM
/usr/local/bin/set49way.pl 8-Way /home/roms/MAME/ini/49waymodes.ini happs49

