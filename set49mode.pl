#!/usr/bin/perl
###########################################################
#
#    set49mode.pl
#
#    Perl program for GPWIZ49 users
#
#    Written by Mark Alston 2007
#
#    mark at beernut dot com
#   
#    Perl program for sending control messages to GPWIZ49 controllers.
#    Very useful for automatically setting the DRS mode in linux :)
#    
#  Usage: set49mode.pl gamerom inifile jstype
#
#            inifile - full path to your saves 49waymodes.ini file
#            jstype  - either williams49 or happs49
#   This program looks up the given game rom in the inifile 
#   created by parse_controls.pl and sets all your GPWIZ49 
#   controllers to the correct mode.
#  
#   Being a userland USB driver it needs to be suid root.
#     chown root set49mode.pl
#     chmod u+s set49mode.pl
#
#   It also automatically reloads usbhid module after running 
#   which is required for the GPWIZ49s to be redetected after 
#   changing modes.
#  
#   The program gets some warnings from USB::Device but these don't
#   seem to cause any problems.  You could go into the USB::Device file 
#   and turn off warnings if you want.
#
#   I make no guarantees for it's safety and security so read the code
#   and decide for yourself.
#
#
##################################################################
#MIT License
#
#Copyright (c) 2020 markalston
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.
###########################################################

use strict;
use gpwiz49;

$ENV{PATH} = "/sbin:/usr/local/bin";

if ($#ARGV < 2){

print <<EndOfTxt;
set49mode.pl: Set 49way mode for GPWIZ49
usage set49waymode.pl gamerom inifile jstype

EndOfTxt
exit 0;
}
my $jstype = $ARGV[2];
my $inifile = $ARGV[1];
my $game = $ARGV[0];

my %modes;
$modes{'Raw49'} = 1;
$modes{'Progressive49'} = 2;
$modes{'8-Way'} = 3;
$modes{'4-Way'} = 4;
$modes{'Diagonals'} = 5;
$modes{'2-Way Horizontal'} = 6;
$modes{'2-Way Vertical'} = 7;
$modes{'16-Way'} = 8;

# If we are passed a GPWIZ49 mode then just set the mode to that.
# else, find the mode from the rom name.
my $gpwizmode = "";
if (exists $modes{$game}) {
    $gpwizmode = $game;
} else {
    open(FD, "$inifile");
    while (<FD>) {
	
	if ($_ =~ s/^$game=(.*)/$1/) {
	    $gpwizmode = $_;
	    $gpwizmode =~ s/\s+$//;
	}
    }
    close(FD);
}


# If no rom matches set the joysticks to 8-way mode as a default.
if ($gpwizmode eq "") {
    $gpwizmode = "8-Way";
}

# Try to set all the joysticks.
# Don't know of any games where the joysticks are set differently.
#
#0x0007 Joystick 1
#0x0008 Joystick 2
#0x0009 Joystick 3
#0x000a Joystick 4 - I think, I am guessing on this one.
# Add all the joysticks you have to the array below.

my @joysticks = (0x0007, 0x0008, 0x0009, 0x000a);
foreach (@joysticks) {
    my $gpwiz = gpwiz49->new($_);
    if ($gpwiz ne -1) {
	$gpwiz->set_mode($modes{$gpwizmode},$jstype);
    }
}
system("/sbin/modprobe -r usbhid");
system("/sbin/modprobe usbhid");
exit 0;

