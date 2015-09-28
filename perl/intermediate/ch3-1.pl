#! /usr/bin/perl

# Description: exercise 1, chapter 3 intermediate Fundations
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-12-17 18:57:36 CST
# Last Change: 2012-12-17 19:05:08 CST

use 5.014;
use warnings;
use strict;

print map { "    $_\n" } grep { -s $_ < 1000 } @ARGV;
