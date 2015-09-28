#! /usr/bin/perl -w
## Copyright(C) 2012 by Ou Yuyuan

# Description: Chaper 3 Lists and Arrays
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-09-27 20:53:31 CST
# Last Change: 2012-10-05 10:38:52 CST

use 5.010;
use strict;

# exercise 1
#print reverse <STDIN>;

# exercise 2
#@names = qw/ dumy_item fred betty barney dino wilma pebbles bamm-bamm /;
#chomp(@idx = <STDIN>);
#foreach (@idx) {
#    print $names[$_] . ' '; }
#    print "\n";

# exercise 3
#chomp(@strings = <STDIN>);
#print sort @strings;

print sort <STDIN>;
