#!/usr/bin/perl -w
## Copyright(C) 2012 by Ou Yuyuan

# Description: Chapter 7 In the World of Regular Expressions
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-10-04 17:19:48 CST
# Last Change: 2012-10-05 19:26:52 CST

use 5.010;
use strict;

while (<>) {
    if (/[Ff]red/) {
        print "Contains '[Ff]red': "; print; }
    if (/\./) { 
        print "Contains '.': "; print; }
    if (/[A-Z][a-z]+/) { 
        print "Has first-capitalized word: "; print; }
    if (/(\S)\1/) { 
        print "Has non-whitespace side by side characters: "; print; }
    if (/fred/) {
        if (/wilma/) {
            print "Contains both 'fred' and 'wilma': "; print; } } }
