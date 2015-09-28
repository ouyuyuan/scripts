#!/usr/bin/perl -w

# Description: Calculate yearly from monthly data of PCOM
#
#       Usage: ./xxx.pl
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-09-16 21:32:38 CST
# Last Change: 2013-09-17 18:48:50 CST

use strict;
use 5.010;

my $year = 1;
my $total_year = 100;
my $src_dir = "monthly";
my $des_dir = "yearly";

while ($year <= $total_year) {
   my $month = 1;
   my $total_mon;
   my $filename;
   my $cmd = "cdo ensmean ";

   while ($month <= 12) {
      $total_mon = ($year-1)*12 + $month;
      my $filename = sprintf("%s%08s%s","$src_dir/N",$total_mon,".nc");
#      say $filename;

      $cmd .= $filename . " ";
      $month += 1;
   }
   $cmd .= sprintf("%s%04s%s","$des_dir/year_",$year,".nc");

   say $cmd;
   system($cmd);

   $year += 1;
}
