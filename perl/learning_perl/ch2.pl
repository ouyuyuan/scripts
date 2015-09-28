#! /usr/bin/perl -w
## Copyright(C) 2012 by Ou Yuyuan

# Description: Chaper 2 Scalar Data
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-09-25 09:24:49 CST
# Last Change: 2012-10-05 19:51:38 CST

use 5.010;
use strict;

$pi = 3.14;
$r = 12.5;
#$r = <STDIN>;

if ($r > 0) {
    $c = 2 * $pi * $r;
} else {
    $c = 0; }
#print $c . "\n";

#print "enter two numbers to multiply: ";
#$a = <STDIN>;
#$b = <STDIN>;

#print $a * $b . "\n";

$s = <STDIN>;
$k = <STDIN>;

print $s x $k;
