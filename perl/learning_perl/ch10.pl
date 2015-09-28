#!/usr/bin/perl -w

# Description: Chapter 10 More Control Structures
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-10-06 08:49:28 CST
# Last Change: 2013-01-15 16:50:45 CST

use 5.010;
use strict;

my $secret = int(1 + rand 100);
my $Debug = $ENV{DEBUG}//1;
say "Don't tell anyone, but the secret number is $secret." if $Debug;

my $guess;
while (1) {
    print"Please guess a number from 1 to 100: ";
    chomp($guess = <STDIN>);
    if ($guess =~ /quit|exit|^\s*$/i) {
        say "Sorry you give up. The secret number is $secret.";
        last;
    } elsif ($guess == $secret) {
        say "That was it!";
        last
    } elsif ($guess > $secret) {
        say "Too large. Try again!";
    } elsif ($guess < $secret) {
        say "Too small. Try again!";
    } else {
        say "Input a number or 'quit'";
    }
}
