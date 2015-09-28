#! /usr/bin/perl

# Description: use local mathjax instead of cdn of Sphinx
#
#       Usage: ./xxx.pl xxx.txt *.html
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-04-26 19:40:21 CST
# Last Change: 2013-04-26 20:22:39 CST

use 5.014;
use warnings;
use strict;

my $alt_txt = shift @ARGV;

open IN, "<$alt_txt";
my @content = <IN>;
close IN;

$^I = ".bak";

while (<>) {
    if (/^\s*<script.*cdn\.mathjax\.org.*\/script>\s*$/) {
        print @content;

    } else {
        print;
    }
}
