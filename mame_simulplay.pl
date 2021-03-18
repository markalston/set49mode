#!/usr/bin/perl
###########################################################
#
#    mame_alternating.pl
#
#    Written by Mark Alston 2007
#
#    mark at beernut dot com
#   
#
#    This utility program parses the controls.ini file
#    and outputs all roms that are alternating players.
#
#   Usage is:
#     ./mame_alternating.pl [directory to ini files] 
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
use warnings;

if ($#ARGV ne 0){

print <<EndOfTxt;
mame_alternating.pl: Create ini file with all alternating games
usage alternating.pl directory

EndOfTxt
exit 0;
}
my $dir = $ARGV[0];

&create_gamelist;

sub create_gamelist{
    my $game="";
    my $output="";
    open(FD, "$dir/controls.ini");
    while(my $controls_line=<FD>){
	if ( $controls_line =~ s/\[(.*)\]/$1/ )  {
	    if ($output ne "" ) {
		print $output
	    }
	    $game = $controls_line;
	    $game =~ s/\s+$//;
	    $output = "";
	}
	if ($controls_line =~ /numPlayers=[2-4]/){
	    $output = "$game\n";
	    open(FD2, "$dir/clones.ini");	    
	    while (my $clones_line=<FD2>){
		my @clones = split (' ', $clones_line);
		if ( $clones[1] eq $game ) {
		    $output .= $clones[0] . "\n";
		}
	    }
	    close(FD2);
	}
	if ($controls_line =~ /alternating=1/){
	    $output = "";
	}
    }
    close(FD);
    if ($output ne "" ) {
	print $output
    }
    
    exit;
}
