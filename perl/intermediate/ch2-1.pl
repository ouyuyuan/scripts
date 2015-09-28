#! /usr/bin/perl

# Description: exercise 1, chapter 2 using modules
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-11-21 15:48:35 CST
# Last Change: 2012-11-21 16:16:43 CST

use 5.014;
use warnings;
use strict;

use Cwd;
use File::Spec::Functions;

my $cwd = getcwd;

for my $file (glob('.* *')) {
    print "    ", catfile($cwd, $file), "\n";
}
