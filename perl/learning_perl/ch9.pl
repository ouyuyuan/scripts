#!/usr/bin/perl -w
## Copyright(C) 2012 by Ou Yuyuan

# Description: Chapter 9 Processing Text with Regular Expressions
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-10-05 17:22:57 CST
# Last Change: 2012-10-21 09:45:14 CST

use 5.010;
use strict;

my $in = $ARGV[0];
unless (defined $in) {
    die "Usage: $0 filename"; }

my $out = $in;
$out =~ s/(\.\w+)?$/.out/;

unless (open IN, "<$in") {
    die "Can't open '$in': $!"; }
unless (open OUT, ">$out") {
    die "Can't open '$out': $!"; }

my $what = "fred|barney";
while (<>) {
    if (/($what){3}/) {
        print "Matched: $`<$&>$'"; }
    s/fred/\0/gi; # use NUL character(\0) as a place holder for 'fred'
    s/wilma/Fred/gi;
    s/\0/Wilma/g;
    print OUT $_; }
