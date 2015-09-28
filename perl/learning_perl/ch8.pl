#!/usr/bin/perl -w
## Copyright(C) 2012 by Ou Yuyuan

# Description: Chapter 8 Matching with Regular Expressions
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-10-05 10:25:12 CST
# Last Change: 2012-10-05 10:47:52 CST

use 5.010;
use strict;

while (<>) {
    chomp;
    if (/match/) {
        print "$_ matched: |$`<$&>$'|\n"; }
    if (/a\b/) {
        print "$_ matched: |$`<$&>$'|\n"; }
    if (/(\b\w*a\b)/) {
        print "$_ matched: \$1 contains '$1'\n"; }
    if (/(?<word>\b\w*a\b)/) {
        print "$_ matched: 'word' contains '$+{word}'\n"; }
    if (/
        (\b\w*a\b)  # $1: word ending up with 'a'
        (.{0,5})    # $2: the following 5 characters
        /xs         # $3: allow whitespace and match a newline
        ) {
            print "$_ matched: '$2' is following '$1'\n"; }
    if (/\s+$/) {
        print "$_#\n"; } }
