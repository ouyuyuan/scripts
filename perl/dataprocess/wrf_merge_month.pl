#!/usr/bin/perl -w

# Description: merge several files to a single month, often used after splitmon
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-11-23 21:02:32 CST
# Last Change: 2013-11-24 16:38:16 CST

use strict;
use 5.010;

my $year = 1998;
my $month_sta = 1;
my $month_end = 12;

my $month = $month_sta;
while ($month <= $month_end) {
   my $fmt_month = sprintf("%02s",$month);
   my $fmt_year = sprintf("%04s",$year);
   my @files = glob("wrfout_*$fmt_year*_month_$fmt_month.nc");
   if ( $month == 1 ) {
      my $last_year = sprintf("%04s",$year-1);
      my @morefiles = glob("wrfout_*$last_year-12*_month_$fmt_month.nc");
      push(@files, @morefiles);
   }
   my $cmd = "cdo mergetime @files $fmt_year-$fmt_month.nc";

   say $cmd;
   system($cmd);

   $month += 1;
}
