#!/usr/bin/perl -w
## Copyright(C) 2012 by Ou Yuyuan

# Description: Chapter 5 Input and Output
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-10-02 16:31:14 CST
# Last Change: 2012-10-05 10:39:35 CST

use 5.010;
use strict;

#____________________________exercise 1_______________________________
print "\n","_" x 30, "exercise 1", "_" x 30, "\n";
if (@ARGV == 0) {
    print "Feed me some lines, then press Ctrl-D:\n";
print reverse <>;

#____________________________exercise 2_______________________________
print "\n","_" x 30, "exercise 2", "_" x 30, "\n";
print "Feed me some lines, then press Ctrl-D:\n";
chomp(my @lines = <STDIN>);
print "1234567890" x 5 . "\n";
printf "%20s\n"x@lines, @lines;

#____________________________exercise 3_______________________________
print "\n","_" x 30, "exercise 3", "_" x 30, "\n";
print "Feed me the width and some lines, then press Ctrl-D:\n";
chomp(my @lines = <STDIN>);
my $width = shift @lines;
print "1234567890" x (($width + 9)/10) . "\n";
printf "%${width}s\n"x@lines, @lines;
