#!/usr/bin/perl -w

# Description: Chapter 16 Process management
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-10-14 09:58:22 CST
# Last Change: 2012-10-14 10:13:09 CST

use strict;
use 5.010;

# exercise 3
#
if ( `date` =~ /^(Sat|Sun)/ ) {
    say "Go play!";
} else {
    say "Get to work!"
}

# exercise 2
#
open STDOUT, ">ls.out" or die "Can't write to 'ls.out': $!";
open STDERR, ">ls.err" or die "Can't write to 'ls.err': $!";

chdir "/" or die "Can't chdir to root directory: $!";
#!system "ls -l" or die "Can't execute 'ls': $!"; # attention to '!'
exec "ls -l" or die "Can't execute 'ls': $!"; 
# Perl will exit after this line
