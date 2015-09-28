#!/usr/bin/perl -w

# Description: split WRF output into month files
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-11-23 21:02:32 CST
# Last Change: 2013-11-23 21:16:42 CST

use strict;
use 5.010;

my @files = glob("wrfout_*");

for my $file (@files) {
   my $cmd = "cdo splitmon $file $file" . "_month_";
   say $cmd;
   system($cmd);
}
