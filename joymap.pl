#!/usr/bin/perl
###########################################################
#
#    joymap.pl
#
#    Perl program to Automate setting command line option joymap
#
#    Written by Mark Alston 2021
#
#    mark at beernut dot com
#   
#  Usage: joymap.pl gamerom [inifile] [overrides.ini]
#
#            gamerom - the rom you desire to play
#                      or a valid joymode to immediately set that mod.
#
#            inifile - full path to your saves joymodes.ini file
#
#            overrides.ini - (optional) full path to your overrides file
#
#   This program looks up the given game rom in the overrides and inifile 
#   and returns the correct joymap for that game.
#  
#
#    Copyright (c) 2021   Mark Alston
###
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Library General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
#
###########################################################

use strict;

my %joymap;

# These returns are for leaving the 49 way stick alone with no map.
#  If you are using a GPWiz Raw49 may be useful for joystick games while
#  Progressive49 is what you want for 49 way games.
#  If you are not using a GPWiz you may want to change these to = ''
#
$joymap{'49'} = '49';
$joymap{'analog'} = 'mouse';

###############################################################################
#
#    IMPORTANT INFO!!!
#
#    Uncomment the joymap lines in one of the following two blocks depending on
#     your usage.  If you have patched mame for 7x7 maps use the 49 way joymaps.
#     If you are using a standard analog stick or a U360, use the second block.
#
#    Also, edit these maps at will for you personal feel.
#
#    Good information about these maps and how to write them is at:
#  http://www.retrogamedeconstructionzone.com/2019/11/joystick-mapping-in-mame.html
#
###############################################################################

###############################################################################
#
#   49 way stick joymaps for use only with mame patched for 7x7 maps
#
#    Do not use these maps with standard mame.
#
###############################################################################
#
#
$joymap{'2'} = '4445666.......';
# 2-Way Horizontal Looser Map
$joymap{'2 loose'} = '44s5s66.......';
$joymap{'vertical2'} = '8.8.8.5.2.2.2.';
# 2-Way Vertical Looser Map
$joymap{'vertical2 loose'} = '8.8.s.5.s.2.2.';
$joymap{'3 (half4)'} = 's88888s.4s888s6.44s5s66.4455566.44s5s66.4s222s6.s22222s.';
$joymap{'4'} = 's88888s.4s888s6.44s5s66.4455566.44s5s66.4s222s6.s22222s.';
$joymap{'4x'} = '444s888.444s888.4445888.ss555ss.2225666.222s666.222s666';
# 4-way with tiny diagonals
$joymap{'4d'} = '7888889.4s888s6.44s5s66.4455566.44s5s66.4s222s6.1222223.';
$joymap{'5 (half8)'} = '778..445'; 
$joymap{'8'} = '778..445'; 

################################################################################
#
#   9x9 joymaps for U360 or any other analog stick.
#
#   Unless you have patched mame for 7x7 maps, these are the ones you want uncommented.
#
#    Leave commented out for patched mame.
#    
#
###############################################################################
#
#$joymap{'2'} = '444456666.......';
#$joymap{'2 loose'} = '444s5s666.......';
#$joymap{'vertical2'} = '8.8.8.8.5.2.2.2.2.';
#$joymap{'vertical2 loose'} = '8.8.8.s.5.s.2.2.2.';
#$joymap{'3 (half4)'} = 's8.4s8.44s8.4445';
#$joymap{'4'} = 's8.4s8.44s8.4445';
#$joymap{'4x'} = '4444s8888.444408888.444458888.444555888.ss5.222555666.222256666.222206666.222206666';
## 4 way mode with tiny diagonals.
#$joymap{'4d'} = '78.4s8.44s8.4445';
#$joymap{'5 (half8)'} = '7778..4445'; 
#$joymap{'8'} = '7778..4445'; 

###################################################################################
#
#  End of editiable settings.
#
###################################################################################

my $inifile = '/dev/null';
my $overrides = '/dev/null';
my $game = $ARGV[0];

if ($#ARGV > 0){
    $inifile = $ARGV[1];
}
if ($#ARGV > 1){
    $overrides = $ARGV[2];
} 

# If we are passed a joystick mode then just set the mode to that.
# else, find the mode from the rom name.
my $joymode = "";
if (exists $joymap{$game}) {
    $joymode = $game;
} else {
    open(FD, "$overrides");
    while (<FD>) {
	if ($_ =~ s/^$game=(.*)/$1/) {
	    $joymode = $_;
	    $joymode =~ s/\s+$//;
	    print $joymap{$joymode};
	    exit 0;
	}
    }
    close(FD);
    
    open(FD, "$inifile");
    while (<FD>) {
	
	if ($_ =~ s/^$game=(.*)/$1/) {
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

print $joymap{$joymode};
exit 0;

