#!/usr/bin/perl
###########################################################
#
#    parse_contols.pl
#
#    Written by Mark Alston 2007
#
#    mark at beernut dot com
#   
#    Parse Mame Controls utility for linux GPWIZ49 or U360 users
#    
#
#    This utility program parses the controls.ini file
#    with help from clones.ini, which you need to create using 
#    <your mame program> -listclones > clones.ini 
#    As well as mame_modes.ini (included in this package) and 
#    overrides.ini (sample included in this package).
#    All these files must be in the same directory (preferably the 
#    same directory as you keep all your mame dat files).
#
#   Usage is:
#     ./parse_controls.pl [directory to ini files] > 49waymodes.ini
#
#
#    Copyright (c) 2007   Mark Alston
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
use warnings;

if ($#ARGV ne 0){

print <<EndOfTxt;
parse_controls.pl: Create ini file for set49way.pl
usage parse_controls.pl directory

EndOfTxt
exit 0;
}
my $dir = $ARGV[0];

&create_gamelist;

sub create_gamelist{
    my %modes;
    open(FD2, "$dir/mame_modes.ini");
    while (<FD2>) {
	    if ($_ =~ /(^[^;].*)=(.*)/) {
		my @line = split (/\=/);
		$modes{$line[0]} = $line[1];
	    }
    }
    close(FD2);

    open(FD, "$dir/controls.ini");
    while(<FD>){
	if ( $_ =~ s/\[(.*)\]/$1/ )  {
	    my $game = $_;
	    $game =~ s/\s+$//;
	    my @controls;
	    $controls[1] = "";
	    my $control_override = "";
	    my $override = "";
	    open(FD2, "$dir/override.ini");
	    while (<FD2>){
		if ($_ =~ /\[CONTROLS\]/) {
		    $override = "rom_only";
		}
		elsif ($_ =~ /\[CONTROLS_parent\]/) {
		    $override = "parent";
		}
		elsif ($_ =~ s/^$game=(.*)/$1/) {
		    $_ =~ s/\s+$//;
		    if ( $override eq "parent" ) {
			$controls[1] = $_;
		    } else {
			$control_override = $_;
		    }
		}
	    }
	    close(FD2);
	    if ( $controls[1] eq "" ) {
		while (<FD>){
		    if ($_ =~ s/^P1Controls=(.*)/$1/ ){
			my @P1Controls = split (/\|/);
			@controls = split (/\+/,$P1Controls[0]); 
			$controls[1] =~ s/(.*)\&.*/$1/;
			$controls[1] =~ s/\s+$//;
			if (defined($modes{$controls[1]})) {
			    $controls[1] = $modes{$controls[1]};
			    $controls[1] =~ s/\s+$//;
			} else {
			    $controls[1] = ""
			}
			last;
		    }
		}
	    }
	    if ( $controls[1] eq "" && $control_override eq "" ) {
		next;
	    }
	    if ( $control_override ne "" ) {
		print "$game=$control_override\n";
	    } else {
		print "$game=$controls[1]\n";
	    }
	    open(FD2, "$dir/clones.ini");

	    while (<FD2>){
		$control_override = "";
		my @clones = split (' ', $_);
		if ( $clones[1] eq $game ) {
		    open(FD3, "$dir/override.ini");
		    while (<FD3>){
			if ($_ =~ s/^$clones[0]=(.*)/$1/) {
			    $_ =~ s/\s+$//;
			    $control_override = $_;
			}
		    }
		    close(FD3);
		    if ($control_override ne "" ) {
			print "$clones[0]=$control_override\n";
		    } else {
			print "$clones[0]=$controls[1]\n";
		    }
		}
	    }
	    close(FD2);
	}
    }
}

