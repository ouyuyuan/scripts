#! /usr/bin/perl

# Description: exercise 2, chapter 2 using modules
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-11-21 16:17:15 CST
# Last Change: 2012-11-21 16:38:58 CST

use 5.014;
use warnings;
use strict;

use local::lib;
use Module::CoreList;
use List::Util qw/ max /;

my @modules = sort keys $Module::CoreList::version{5.014002};
my $max_length = max map { length } @modules;

for my $module (@modules) {
    printf "%*s %s\n", -$max_length, $module, Module::CoreList->first_release(
        $module);
}
