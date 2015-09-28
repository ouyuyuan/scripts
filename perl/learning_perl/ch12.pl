#!/usr/bin/perl -w

# Description: Chapter 12 File Tests
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-10-06 19:02:26 CST
# Last Change: 2012-10-06 19:50:04 CST

use 5.010;

use strict;

die "I need some file names!\n" unless @ARGV;

my $oldest_file = $ARGV[0];
my $oldest_age  = -M $oldest_file;

for (@ARGV) {
    if (! -e) {
        say "$_ not exsist!";
        last;
    } else {
        print "$_ is: ";
        print "readable " if -r;
        print "writeable " if -w _;
        print "executable " if -x _;
        say '';
    }

    my $age = -M _;
    ($oldest_file, $oldest_age) = ($_, $age) if $age > $oldest_age;
}

say "$oldest_file is the oldest file, and its age is $oldest_age days."
