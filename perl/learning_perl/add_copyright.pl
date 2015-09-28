#!/usr/bin/perl -w
## Copyright(C) 2012 by Ou Yuyuan

# Description: Add copy right to files if there isn't one 
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-10-05 19:09:26 CST
# Last Change: 2012-10-21 09:52:38 CST

use 5.010;
use strict;

my %files;
foreach (@ARGV) {
    $files{$_} = ''; }

while (<>) {
    if (/^## Copyright/) { 
        delete $files{$ARGV}; } }

@ARGV = keys %files;
$^I = ".bak";
if ( @ARGV > 0 ) {
    while (<>) {
        if (/^#!/) {
            $_ .= "## Copyright(C) 2012 by Ou Yuyuan\n"; }
        print; } }
