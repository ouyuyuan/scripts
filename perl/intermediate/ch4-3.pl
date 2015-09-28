#! /usr/bin/perl

# Description: exercise 3, chapter 4 Introduction to Reference
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-12-29 18:52:05 CST
# Last Change: 2012-12-29 19:02:13 CST

use 5.014;
use warnings;
use strict;

my %gilligan_info = (
    name => 'Gilligan',
    hat => 'White',
    shirt => 'Red',
    position => 'First Mate',
);
my %skipper_info = (
    name => 'Skipper',
    hat => 'Black',
    shirt => 'Blue',
    position => 'Captain',
);
my %mr_howell = (
    name => 'Mr. Howell',
    hat  => undef,
    shirt => 'White',
    position => 'Passenger',
);

my @castaways = (\%gilligan_info, \%skipper_info, \%mr_howell);

for my $person (@castaways) {
    $person->{location} = ($person->{name} =~ /Howell/) ?
    "The Island Country Club" : "The Island";

    say "$person->{name} at $person->{location}.";
}
