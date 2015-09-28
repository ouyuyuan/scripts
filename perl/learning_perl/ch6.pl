#!/usr/bin/perl -w
## Copyright(C) 2012 by Ou Yuyuan

# Description: Chaper 6 Hashes
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-10-03 13:59:41 CST
# Last Change: 2012-10-05 10:39:57 CST

use 5.010;
use strict;

#____________________________exercise 1_______________________________
print "\n","_" x 30, "exercise 1", "_" x 30, "\n";

my %last_name = qw/
    John Green
    Tom Fat
    Jim White
    /;

print "Feed me the first name: ";
chomp(my $name = <STDIN>);
print "That's $name $last_name{$name}.\n";

#____________________________exercise 2_______________________________
print "\n","_" x 30, "exercise 2", "_" x 30, "\n";

my %count;
print "Enter some words with separate line. Then press Ctrl-D:\n";
chomp(my @words = <STDIN>);

foreach (@words) {
    $count{$_} += 1; }

foreach (sort keys %count) {
    print "$_ appeared $count{$_} time(s).\n"; }

#____________________________exercise 3_______________________________
print "\n","_" x 30, "exercise 3", "_" x 30, "\n";

$ENV{"TEST"} = "LOOK AT YOU!";
my @keys = sort keys %ENV;

my $longest= 0;
foreach (@keys) {
        $longest = length($_) if $longest < length($_); }

foreach (@keys) {
    printf "%-${longest}s %s\n", $_, $ENV{$_}; }
