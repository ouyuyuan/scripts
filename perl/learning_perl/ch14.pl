#!/usr/bin/perl -w

# Description: Chapter 14 Strings and Sorting
#
#       Usage: ./xxx.pl [in_ch14.dat]
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-10-10 09:37:15 CST
# Last Change: 2012-10-10 10:47:47 CST

use 5.010;

use strict;


# exercise 1

my @numbers;

push @numbers, split while (<>);

printf "%20g\n", $_ for (sort { $a <=> $b } @numbers);


# exercise 2

my %last_name = qw/
    fred flintstone Wilma Flintstone Barney Rubble
    betty rubble Bamm-Bamm Rubble PEBBLES FLINTSTONE
    /;

my @keys = sort {
    "\L$last_name{$a}" cmp "\L$last_name{$b}"
        or
    "\L$a" cmp "\L$b"
    } keys %last_name;

say "$last_name{$_}, $_" for (@keys);


# exercise 3

print "Please enter a string: ";
chomp(my $string = <STDIN>);
print "Please enter a substring to search: ";
chomp(my $substr = <STDIN>);

say "Locations of '$substr' in '$string' were:";
{
    for (my $p = -1; ;) {
        $p = index($string, $substr, $p + 1);
        last if $p == -1;
        print "$p ";
    }
    say '';
}
