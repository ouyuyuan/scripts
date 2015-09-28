#! /usr/bin/perl

# Description: exercise 2, chapter 3 intermediate Fundations
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-12-17 18:57:36 CST
# Last Change: 2012-12-17 19:10:26 CST

use 5.014;
use warnings;
use strict;

print map { "    $_\n" } grep { -s $_ < 1000 } @ARGV;

chdir; # change to $HOME

while(1) {
    print "Please enter a regular expression> ";
    chomp (my $re = <STDIN>);

    last unless (defined $re && length $re);

    print 
        map { "    $_\n" }
        grep { eval {/$re/} }
        glob ".* *";
}
