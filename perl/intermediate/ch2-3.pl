#! /usr/bin/perl

# Description: exercise 3, chapter 2 using modules
# 
#     CAUTION:  can run this script becasue 
#               ISBN module not installed correctly due to unknown reason
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-11-21 16:17:15 CST
# Last Change: 2012-11-21 16:44:14 CST

use 5.014;
use warnings;
use strict;

use Business::ISBN;

my $isbn = Business::ISBN−>new( $ARGV[0] );
print "ISBN is " . $isbn−>as_string . "\n";
print "Country code: " . $isbn−>country_code . "\n";
print "Publisher code: " . $isbn−>publisher_code . "\n";
