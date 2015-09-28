#! /usr/bin/perl

# Description: exercise 2, chapter 4 Introduction to Reference
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-12-17 18:57:36 CST
# Last Change: 2012-12-26 19:02:08 CST

use 5.014;
use warnings;
use strict;

my @gilligan  = qw(red_shirt hat lucky_socks water_bottle);
my @professor = qw(sunscreen water_bottle slide_rule batteries radio);
my @skipper   = qw(blue_shirt hat jacket preserver sunscreen);
my %all = (
    "Gilligan" => \@gilligan,
    "Skipper"  => \@skipper,
    "Professor"=> \@professor,
);

check_items_for_all(\%all);

sub check_items_for_all {
    my $all = shift;
    for my $person (keys %$all) {
        check_required_items($person, $all->{$person});
    }
}

sub check_required_items {
    my $who = shift;
    my $items = shift;
    my @required = qw(preserver sunscreen water_bottle jacket);
    my @missing = ();
    
    for my $item (@required) {
        unless (grep $item eq $_, @$items) {
            say "$who is missing $item.";
            push @missing, $item;
        }
    }

    if (@missing) {
        say "Adding (@missing) to (@$items) for $who.";
        push @$items, @missing;
    }
}
