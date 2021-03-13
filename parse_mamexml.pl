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

