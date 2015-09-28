#!/usr/bin/perl -w

# Description: Chapter 11 Perl Modules
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-10-06 10:39:57 CST
# Last Change: 2012-10-06 19:01:54 CST

use 5.010;
use strict;
use Module::CoreList;

my %modules = %{ $Module::CoreList::version{5.010} };

say join "\n", keys %modules;
