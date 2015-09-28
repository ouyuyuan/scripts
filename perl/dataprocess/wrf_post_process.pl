#!/usr/bin/perl -w

# Description: post processing of WRF output
#
#       Usage: 
#
#        Note: each WRF output files should contain 30 days for the merge part
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-11-23 21:02:32 CST
# Last Change: 2013-11-25 06:40:43 CST

use strict;
use 5.010;

# split files <<<1

my @files = glob("wrfout_*");

for my $file (@files) {
   my $cmd = "cdo splitmon $file $file" . "_month_";
   say $cmd;
#   system($cmd);
}

# merge the same month <<<1

my $year_sta = 1997;
my $year_end = 1998;
my $month_sta = 1;
my $month_end = 12;

my $year = $year_sta;
while ($year <= $year_end) {
   my $month = 1;
   while ($month <= 12 ) {
      my $fmt_month = sprintf("%02s",$month);
      my $fmt_year = sprintf("%04s",$year);
      my @files = glob("wrfout_*$fmt_year*_month_$fmt_month.nc");

      if ( $month == 1 ) {
         my $last_year = sprintf("%04s",$year-1);
         my @morefiles = glob("wrfout_*$last_year-12*_month_$fmt_month.nc");
         push(@files, @morefiles);
      }

      if (@files > 0) {
         my $month_file = "$fmt_year-$fmt_month.nc";
         my $cmd = "cdo mergetime @files $month_file";
         say $cmd;
         system($cmd);

         # cal. month mean <<<2

         $cmd = "cdo timmean $month_file month_mean_$month_file";
         say $cmd;
         system($cmd);
      }
      $month += 1;
   }
   $year += 1;
}
