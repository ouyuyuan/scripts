#!/usr/bin/perl -w

# Description: Calculate yearly from monthly data of LICOM
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-09-17 20:52:01 CST
# Last Change: 2013-09-19 08:00:45 CST

use strict;
use 5.010;

my $year_sta = 1;
my $year_end = 250;
my $src_dir = "monthly";
my $des_dir = "yearly";

my $year = $year_sta;
while ($year <= $year_end) {
   my $fmt_year = sprintf("%04s",$year);
   my @files = glob("$src_dir/MMEAN$fmt_year-*.nc");
   my $cmd = "cdo ensmean @files $des_dir/year_$fmt_year.nc";

   say $cmd;
   system($cmd);

   $year += 1;
}
