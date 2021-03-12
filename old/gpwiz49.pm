package gpwiz49;
###########################################################
#
#    gpwiz49.pm
#
#    Perl Package for GPWIZ49 users
#
#    Written by Mark Alston 2007
#
#    mark at beernut dot com
#   
#    Perl Class for sending control messages to GPWIZ49 controllers.
#    Very useful for automatically setting the DRS mode in linux :)
#    
#    This file must be saved in your perl library path to work.
# 
#    There are only two methods:
#     new('product_id') which tries to find the listed GPWIZ49 and opens it
#     and set_mode(mode) which sets the DRS mode to one of the following:
#
#    1 - 49 Way
#    2 - Progressive 49 way
#    3 - 8 Way
#    4 - 4 Way
#    5 - 4 Way Diagonal
#    6 - 2 Way Horizontal
#    7 - 2 Way Vertical
#    8 - 16 Way
#
#    Use my set49mode.pl and parse_controls.pl to actually use this package.  
#    Or write your own control program.  See if I care :)
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
use Device::USB;

our $timeout = 1000;
our $VERSION = '0.01';


sub new {
    my $class = shift;
    my $device = shift;
    my $usb = Device::USB->new();
#    $usb->debug_mode(2);

    my $dev = $usb->find_device(0xfafa,$device);
    if ( $dev eq "" ) {
	return -1
    }
    $dev->open() || return -1;

    $dev->detach_kernel_driver_np();
    my $return_claim = $dev->claim_interface(00);
#    print STDERR "claim returned: $return_claim\n";
#    print "Manufacturer:", $dev->manufacturer(), "\n";
#    print "Product:", $dev->product(), "\n";

    my $self = {};
    $self->{dev} = $dev;
    return bless $self, $class;
}

sub set_mode { 
    my $self = shift;
    my $command = shift;
    my $jstype = shift;
    my $command_string = {};

    if ( $jstype eq "happs49" ) {
	$command_string->{1} = join('', map { chr $_ } (0xCC, 0x01)); # Raw 49
	$command_string->{2} = join('', map { chr $_ } (0xCC, 0x02)); # Progressive 49
	$command_string->{3} = join('', map { chr $_ } (0xCC, 0x03)); # 8-way
	$command_string->{4} = join('', map { chr $_ } (0xCC, 0x04)); # 4-way
	$command_string->{5} = join('', map { chr $_ } (0xCC, 0x05)); # 4-way diag
	$command_string->{6} = join('', map { chr $_ } (0xCC, 0x06)); # 2-way Horiz
	$command_string->{7} = join('', map { chr $_ } (0xCC, 0x07)); # 2-way Vert
	$command_string->{8} = join('', map { chr $_ } (0xCC, 0x08)); # 16-way
    } elsif ( $jstype eq "williams49" ) {
	$command_string->{1} = join('', map { chr $_ } (0xCC, 0x0b)); # Raw 49
	$command_string->{2} = join('', map { chr $_ } (0xCC, 0x0c)); # Progressive 49
	$command_string->{3} = join('', map { chr $_ } (0xCC, 0x0d)); # 8-way
	$command_string->{4} = join('', map { chr $_ } (0xCC, 0x0e)); # 4-way
	$command_string->{5} = join('', map { chr $_ } (0xCC, 0x0f)); # 4-way diag
	$command_string->{6} = join('', map { chr $_ } (0xCC, 0x10)); # 2-way Horiz
	$command_string->{7} = join('', map { chr $_ } (0xCC, 0x11)); # 2-way Vert
	$command_string->{8} = join('', map { chr $_ } (0xCC, 0x12)); # 16-way
    } else {
	return -1
    }
   
	
# control_msg(int requesttype, int request, int value, int index, char *bytes, int size, int timeout);
    return -1 unless exists $command_string->{$command};
    $self->{dev}->control_msg(0x21,9,0x0000200, 0x0000000,$command_string->{$command},0x0000002,1000);
    $self->{dev}->release_interface(00);
    return 1;
}

