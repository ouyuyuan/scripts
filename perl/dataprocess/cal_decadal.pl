#!/usr/bin/perl -w

# Description: Calculate decadal from yearly data of PCOM
#
#       Usage: ./xxx.pl
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-09-16 21:32:38 CST
# Last Change: 2013-09-17 18:44:37 CST

use strict;
use 5.010;

my $decade = 1;
my $nyear = 100;
my $ndecade = int($nyear/10);
my $src_dir = "yearly";
my $des_dir = "decadal";

while ($decade <= $ndecade) {
   my $year = 1;
   my $total_year;
   my $filename;
   my $cmd = "cdo ensmean ";

   while ($year <= 10) {
      $total_year = ($decade-1)*10 + $year;
      my $filename = sprintf("%s%04s%s","$src_dir/year_",$total_year,".nc");

      $cmd .= $filename . " ";
      $year += 1;
   }
   $cmd .= sprintf("%s%02s%s","$des_dir/decade_",$decade,".nc");

   say $cmd;
   system($cmd);

   $decade += 1;
}
