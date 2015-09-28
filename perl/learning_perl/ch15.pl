#!/usr/bin/perl -w

# Description: Chapter 15 Smart-Matching and given-when
#
#       Usage: ./xxx.pl filenames 
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-10-11 16:31:43 CST
# Last Change: 2012-10-13 17:40:14 CST

use strict;

use 5.010;


# exercise 3

for (@ARGV) {
    print "$_ is: ";

    when (! -e )  { say"not exist!"; }
    when ( -r _ ) { print "readable "; continue }
    when ( -w _ ) { print "writable "; continue }
    when ( -x _ ) { print "executable "; continue }
    default       { say ''; }
}

# exercise 1

my $secret = int(1 + rand 100);
my $Debug = $ENV{DEBUG}//1;
say "Don't tell anyone, but the secret number is $secret." if $Debug;

my $guess;
while (1) {
    my $quit = 0;
    print"Please guess a number from 1 to 100: ";
    chomp($guess = <STDIN>);
    given ($guess) {
        when (/quit|exit|^\s*$/i) {
            say "Sorry you give up. The secret number is $secret.";
            $quit = 1;
        }
        when (! /^\s*\d+\s*$/) { 
            say "Please input a number or 'quit'";
        }
        when ($_ == $secret) { 
            say "That was it!"; # $_ is needed
            $quit = 1;
        }
        when ($_ > $secret)  {
            say "Too large. Try again!";
        }
        when ($_ < $secret)  { 
            say "Too small. Try again!"; 
        }
        default {
            say "Unexpected input. Stop.";
            $quit = 1;
        }
    }
    last if $quit;
}


# exercise 2

for (1..110) {
    print "$_ is divisible by: ";
    when (not $_ % 3) { print "3 "; continue }
    # not precedence is less than !
    when (! ($_ % 5)) { print "5 "; continue }
    when (not $_ % 7) { print "7 "; continue }
    default         { say ''; }
}
