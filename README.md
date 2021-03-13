# Mame Joymap Control

This is a set of programs for automating mame joymap creation for analog (and 49way, U360) joysticks. Also useful for automating the control of joystick rotation programs.

In addition there is a patch file to modify base mame for 7x7 joymaps.

The package requires perl with the XML::LibXML library.

## The package contains several files

| File | Usage |
| ---- | ----- |
| mame49way.patch | Patch file for mame to use 7x7 joymaps instead of 9x9. This makes the joymaps line up naturally with the output from 49 way joysticks using a controller like the GPWiz49. |
| parse_mamexml.pl | This program parses the mame.xml file from either running mame -listxml or downloading from https://www.progettosnaps.net/dats/MAME/ and generates output for a joymodes.ini file. |
| run_mame.sh | My current linux bash script that I use to run mame and automatically set the joymap. My script also does log rotation. | 
| joymap.pl | A helper program that takes a rom name and an ini file (generated using parse_mamexml.pl above), as well as an override file if desired, to output a proper joymap for mame's -joymap option. |
| rotator.pl | A helper program which uses the stored ini from parse_mamexml.pl above and calls the rotator program to set the appropriate mode. Rotator is a part of the ledspicer programs. https://github.com/meduzapat/LEDSpicer https://sourceforge.net/p/ledspicer/wiki/Programs/#rotator |
| daphne.sh | My current bash script for calling daphne. |
| joymodes.ini	| The saved output from my last run of parse_mamexml.pl |
| overrides.ini	|  My current overrride file. |

### Note that GPWiz suffers from a quirk where it will not work properly out of the box on linux.  
#### You must do the following to make it register the axis properly.

Create file /etc/modprobe.d/usbhid with the following:

```
options usbhid quirks=0xFAFA:0x0007:0x00000020,0xFAFA:0x0008:0x00000020
```

also add 

```
usbhid.quirks=0xFAFA:0x0007:0x00000020,0xFAFA:0x0008:0x00000020
```

to append line in /boot/syslinux/syslinux.cfg

## Copyright note

Ultimarc, Ultimarc brand and Ultimarc products are property of Ultimarc Limited Company.
For more information about Ultimarc visit their website at https://www.ultimarc.com

Led-Wiz™, GP-Wiz™, Roto-X™ are property of Ithaca Digital Visual Technologies Inc.
For more information about Led-Wiz visit their website at https://groovygamegear.com

All names used are trademarked by their respective trademark holders.
