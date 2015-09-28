#!/usr/bin/perl -w

# Description: Report all symbolic links in the current directory
#
#       Usage: ./xxx.pl
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-10-08 14:48:52 CST
# Last Change: 2012-10-08 14:55:35 CST

use 5.010;

use strict;

for (<.* *>) {
    my $dest = readlink;
    say "$_ -> $dest" if $dest;
}
