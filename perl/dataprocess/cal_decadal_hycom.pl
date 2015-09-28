#!/usr/bin/perl -w

# Description: Calculate decadal from yearly data of HYCOM
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-09-18 14:38:34 CST
# Last Change: 2013-09-22 17:38:59 CST

use strict;
use 5.010;
use warnings;

my $year_sta = 1981;
my $year_end = 2000;
my $var = "vvel";
my $src_dir = "yearly/$var";
my $des_dir = "decadal/$var";
my $ndecade = int(($year_end - $year_sta + 1)/10);
my $decade = 1;

while ($decade <= $ndecade) {
   my $year;
   my $filename;
   my $cmd = "cdo ensmean ";
   my $cnt = 1;

   while ($cnt <= 10) {
      $year = $year_sta-1 + ($decade-1)*10 + $cnt;
      my $filename = sprintf("%s%4d%s","$src_dir/year_",$year,".nc");

      $cmd .= $filename . " ";
      $cnt += 1;
   }
   $cmd .= sprintf("%s%02s%s","$des_dir/decade_",$decade,".nc");

   say $cmd;
   system($cmd);

   $decade += 1;
}
