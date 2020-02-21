# Set49Way-Linux

This is a set of programs for linux support of the GP-Wiz49
controllers.

I based my support heavily on the ideas of SirPoonga's set49mode
(although I didn't see a single line of his code since I knew it
wouldn't work on linux) and have stolen a couple of his ini files for
my own usage.

The package requires Device::USB and libusb and probably libusb-dev to
work.

Get them however is best for your distribution.
If using GroovyArcade do the following:

## Install Yay for aur repository installs
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si

## Install perl Device::USB and Inline for set49way.p
    yay -S perl-device-usb
    yay -S perl-inline
    pacman -S libusb

## The package contains several files

parse_controls.pl This program creates the needed ini file for the
                  set49mode program.  It requires mame_modes.ini, 
                  clones.ini, overrides.ini and controls.ini.
                  (Read the file for more info).

gpwiz49.pm        The perl package which does all the work of talking 
                  to the GPWIZ49.
                  (Thanks Randy for the very simple protocol).

set49mode.pl      The program that you would have your frontend call 
                  to set the mode. It is called like this: 
                  set49mode romname inifile jstype

set49mode.sh	  An example bash shell to use for your frontend to set
		  the 49way mode, run mame, and then reset back to 8-way
		  for your frontend again.
		  
clones.ini        My current clones.ini file but you should 
                  probably create your own using 
                  mame -listclones > clones.ini

override.ini      An example override.ini file that should be customized.
                  The file must exist even if there are not overrides.

mame_modes.ini    The map file from mame modes to GPWIZ49 DRS Modes
              .   Probably shouldn't mess with this one.

## Install

To install copy gpwiz49.pm into your perl libraries.  

Then copy the ini files into your standard mame dat file directory.

Then put set49mode into your file path (perhaps /usr/share/games or /usr/local/bin) and change it's ownership to root and make it suid root.
or use the set49mode.sh bash script to call set49waymode.pl

Before use you must first run: parse_controls.pl ini_file_directory > 49waymodes.ini to generate all the needed modes.  If you change override.ini you must run it again.
Copy this new file into your dat file directory and your are all set to run set49mode.

### Note that GPWiz suffers from a quirk where it will not work properly out of the box on linux.  
#### You must do the following to make it register the axis properly.

Create file /etc/modprobe.d/usbhid with the following:
    options usbhid quirks=0xFAFA:0x0007:0x00000020,0xFAFA:0x0008:0x00000020

also add
    usbhid.quirks=0xFAFA:0x0007:0x00000020,0xFAFA:0x0008:0x00000020
to append line in /boot/syslinux/syslinux.cfg
