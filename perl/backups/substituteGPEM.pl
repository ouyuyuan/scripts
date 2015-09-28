#! /usr/bin/perl

# Description: substitute words of the input files
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2013-01-10 10:56:04 CST
# Last Change: 2013-01-11 22:23:17 CST

use 5.014;
use warnings;
use strict;

$^I = ".bak";
while (<>) {
    s/\ba3\b/c3/;
    print;
}
