#!/usr/bin/perl -w

# Description: cal. month mean from a month file
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-11-23 21:02:32 CST
# Last Change: 2013-11-24 19:27:44 CST

use strict;
use 5.010;

my $year = "1998";
my $month_sta = 5;
my $month_end = 12;

my @files = glob("199?-??.nc");

for my $file (@files) {
   my $cmd = "cdo timmean $file month_mean_$file";

   say $cmd;
   system($cmd);
}
