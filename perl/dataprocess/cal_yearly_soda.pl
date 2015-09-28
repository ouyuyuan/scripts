#!/usr/bin/perl -w

# Description: Calculate yearly from monthly data of SODA
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-09-17 20:52:01 CST
# Last Change: 2013-09-17 21:07:27 CST

use strict;
use 5.010;

my $year_sta = 1871;
my $year_end = 2008;
my $src_dir = "monthly";
my $des_dir = "yearly";

my $year = $year_sta;
while ($year <= $year_end) {
   my $month = 1;
   my $filename;
   my $cmd = "cdo ensmean ";

   while ($month <= 12) {
      my $filename = sprintf("%s%4d%02d%s","$src_dir/SODA_2.2.4_",$year,$month,".cdf");
#      say $filename;

      $cmd .= $filename . " ";
      $month += 1;
   }
   $cmd .= sprintf("%s%04s%s","$des_dir/year_",$year,".nc");

   say $cmd;
   system($cmd);

   $year += 1;
}
