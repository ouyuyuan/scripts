#!/usr/bin/perl -w

# Description: count fortran lines
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2012-10-06 19:51:14 CST
# Last Change: 2013-03-23 19:58:16 CST

use strict;
use 5.010;
use File::Spec;

# build count dictionay
# total-lines
my $total;
my $meaningful;

# omit empty and comment lines
while (<>) {
    unless (/
        (?:^\s*$)         # empty line
        |(?:^\s*!)        # comment line
        /x) {
        $total += 1;
        unless (/
            (?:^\s*end)       # end ... line
            |(?:^\s*allocate) # allocate array
            |(?:^\s*integer)  # variable declaration
            |(?:^\s*real)
            |(?:^\s*character)
            |(?:^\s*logical)
            |(?:^\s*implicit) # implicit none
            |(?:^\s*include)  # include files
            |(?:^\s*namelist) # namelist variable
            |(?:^\s*close)    # close file
            |(?:^\s*continue) # continue statement
            |(?:^\s*return)   # return statement
            |(?:^\s*common)   # common data block
            /xi) {
            $meaningful += 1;
        }
    }
}

say "total lines: ", $total, "\nmeaningful lines: ", $meaningful
