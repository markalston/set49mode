#!/usr/bin/perl
###########################################################
#
#    rotator.pl
#
#    Perl program to Automate usage of rotator from LEDSpicer project
#
#    Written by Mark Alston 2021
#
#    mark at beernut dot com
#   
#    
#  Usage: rotator.pl gamerom inifile [overrides]
#
#            inifile - full path to your saves joymodes.ini file
#            overrides - full path to your optional overrides file
#
#   This program looks up the given game rom in the inifile (and overrides)
#   and uses rotator to set your controllers to the correct mode.
#
#   If called with no arguments or no matching rom is found the joysticks
#   are set to the default 8 way mode.
#
#    Copyright (c) 2021   Mark Alston
###
#
#    Permission is hereby granted, free of charge, to any person obtaining a copy
#    of this software and associated documentation files (the "Software"), to deal
#    in the Software without restriction, including without limitation the rights
#    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#    copies of the Software, and to permit persons to whom the Software is
#    furnished to do so, subject to the following conditions:
#
#    The above copyright notice and this permission notice shall be included in all
#    copies or substantial portions of the Software.
#
#    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#    SOFTWARE.
#
###########################################################

use strict;

$ENV{PATH} = "/sbin:/usr/local/bin";

my $inifile = '/dev/null';
my $overrides = '/dev/null';

my $rom = $ARGV[0];


if ($#ARGV > 0){
    $inifile = $ARGV[1];    
} 
if ($#ARGV > 1){
    $overrides = $ARGV[2];
} 

my %modes;
$modes{'1'} = 2;
$modes{'2'} = 2;
$modes{'strange2'} = 2;
$modes{'vertical2'} = 'vertical2';
$modes{'3 (half4)'} = 4;
$modes{'4'} = 4;
$modes{'4d'} = 4;
$modes{'4x'} = '4x';
$modes{'5 (half8)'} = 8;
$modes{'8'} = 8;
#$modes{'16'} = 16;
$modes{'16'} = 49;
$modes{'49'} = 49;
$modes{'analog'} = 'mouse';
$modes{'mouse'} = 'mouse';

# If we are passed a joystick mode then just set the mode to that.
# else, find the mode from the rom name.
my $joymode = "";
if (exists $modes{$rom}) {
    $joymode = $rom;
} else {
   
    open(FD, "$inifile");
    while (<FD>) {
	
	if ($_ =~ s/^$rom=(.*)/$1/) {
	    $joymode = $_;
	    $joymode =~ s/\s+$//;
	}
    }
    close(FD);

    open(FD, "$overrides");
    while (<FD>) {
	if ($_ =~ s/^$rom=(.*)/$1/) {
	    $joymode = $_;
	    $joymode =~ s/\s+$//;
	}
    }
    close(FD);
}

# If no rom matches set the joysticks to 8-way mode as a default.
if ($joymode eq "") {
    $joymode = "8";
}

system("/usr/local/bin/rotator -r $modes{$joymode}");

exit 0;

