#! /usr/bin/perl

# Description: substitute words of the input files
#
#       Usage: ./xxx.pl filenames
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-09-23 10:06:31 CST
# Last Change: 2013-02-28 08:37:15 CST

use 5.014;
use warnings;
use strict;

$^I = ".bak";
while (<>) {
#    s/^\s*(\|1:\d\|2:\d\|3:\d\|)\s*$/${1}4:0\|\n/;
    s/<7:2>/<1:1>/;
#    s/,\|4:1\|/,1>/;
#    if(/^<1,\d,\d,\d>/) {
#        s/^<1,/</;
#    }
#    if (/abc(?<id><.+>)/) {
#        s/$+{id}/yes/;
#    }
#    s/<1:5:1:1:2>/<1:5:1>/;
    print;
}
