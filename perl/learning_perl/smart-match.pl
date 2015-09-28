#!/usr/bin/perl -w

# Description: Exercise 5 of chapter 15
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-10-13 17:39:22 CST
# Last Change: 2012-10-13 18:47:12 CST

use strict;
use 5.010;

my $favorite = 10;

given ($ARGV[0]) {
    when( ! /^\s*\d+\s*$/ ) {
        say "not a number!";
    }
    
    when( $favorite ) {
        say "$_ is my favorite number!";
        continue;
    }

    my @divisors = &divisors($ARGV[0]);
    my @empty;

    when( @divisors ~~ @empty ) {
        say "$_ is a prime number.";
    }

    when( @divisors ~~ 2 ) { 
        # not work
        # the answer in the book is wrong
        # so ~~ operator can't replace 'in' in python
        say "$_ is even.";
        continue;
    }

    when( not @divisors ~~ 2 ) {
        say "$_ is odd.";
        continue;
    }
    
    default {
        say "$_ is divisible by @divisors.";
    }
}

sub divisors {
    my $number = shift;
    my @divisors;
    for (2 .. sqrt($number)) {
        if ( not $number % $_ ) {
            push @divisors, $_;
            push @divisors, $number/$_;
        }
    }
    return @divisors;
}
