#! /usr/bin/perl -w
# Description: 
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-09-23 10:06:31 CST
# Last Change: 2013-02-25 20:36:22 CST

use 5.010;
use strict;
say "Hello, world!\n";

use getConfig;

my $dat = get_config("data directory")."yes";

say $dat;
