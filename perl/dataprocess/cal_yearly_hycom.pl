#!/usr/bin/perl -w

# Description: Calculate yearly from monthly data of HYCOM
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-09-17 20:52:01 CST
# Last Change: 2013-09-22 08:42:58 CST

use strict;
use 5.010;
use warnings;

my $year_sta = 1979;
my $year_end = 2003;
my $src_dir = "vvel";
my $des_dir = "yearly/$src_dir";

my $year = $year_sta;
while ($year <= $year_end) {
   my @files = glob("$src_dir/archv.$year*.nc");
   my $cmd = "cdo ensmean @files $des_dir/year_$year.nc";
   say $cmd;
   system($cmd);
   $year += 1;
}
