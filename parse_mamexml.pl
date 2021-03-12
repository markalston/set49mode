#!/usr/bin/perl
###########################################################
#
#    parse_mamexml.pl
#
#    Written by Mark Alston 2021
#
#    mark at beernut dot com
#   
#    Parse Mame Controls utility for analog joystick users.
#    
#
#    This utility program generate output showing joystick ways for each rom.
#    Normally you would direct this output to a file for later automation usage.
#
#   You first need to have the mame.xml file either from running
#      mame -listxml > mame.xml
#   or you can download it from https://www.progettosnaps.net/dats/MAME/
#      
#   point this program to that file.
#
#   Usage is:
#     ./parse_mamexml.pl mame.xml > output.ini
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
use XML::LibXML;
use feature 'say';

if ($#ARGV ne 0){

print <<EndOfTxt;
parse_mamexml.pl: Create ini file for joymap automation.
usage parse_mame.xml input.xml > output.ini

EndOfTxt
exit 0;
}

my $file = $ARGV[0];

&create_gamelist;

sub create_gamelist{
    my $dom = XML::LibXML->load_xml(location => $file);
    MACHINELOOP: foreach my $machine ($dom->findnodes('//machine')) {
	my $done = 0;
	eval {
    	    my @ports = $machine->findnodes('./port');
	    foreach my $port (@ports) {
		my $tag = $port->getAttribute('tag');
		if (index($tag,'49WAY') != -1)  {
		    say  $machine->getAttribute("name"). "=49";
		    next OUTERLOOP;
		}
	    }
	    my @controls = $machine->findnodes('./input/control');
	    foreach my $control (@controls) {
		my $type = $control->getAttribute('type');
		if ($type eq 'joy') {
		    my $ways = $control->getAttribute('ways');
		    if ( $ways eq "" ) { next; }
		    say  $machine->getAttribute("name"). "=" . $ways;
		} elsif ($type eq 'stick') {
		    say  $machine->getAttribute("name"). "=analog";
		}
		last;		    		
	    }
	}
    }
}

