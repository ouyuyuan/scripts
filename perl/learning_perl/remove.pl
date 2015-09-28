#!/usr/bin/perl -w

# Description: remove files given in comman line
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-10-08 10:43:21 CST
# Last Change: 2012-10-12 08:32:40 CST

for (@ARGV) {
    unlink or warn "Can't remove '$_': $!, continuing...";
}
