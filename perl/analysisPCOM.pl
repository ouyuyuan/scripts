#!/usr/bin/perl -w

# Description: Analysis PCOM source code
#
#       Usage: ./xxx.pl *.f90 *.h
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-10-06 19:51:14 CST
# Last Change: 2012-10-18 19:16:25 CST

use strict;
use 5.010;
use File::Spec;

# build count dictionay
# total-lines, meaningful-lines, understoodr-lines, question-lines
my %total;
my %meaningful;
my %understood;
my %question; 

$total{$_} = 0 for(@ARGV); # need this to show 0 lines files

# omit empty and comment lines
while (<>) {
    unless (/
        (?:^\s*$)         # empty line
        |(?:^\s*!)        # comment line
        /x) {
        $total{$ARGV} += 1;
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
            $meaningful{$ARGV} += 1;
        }
    }
    $understood{$ARGV} += 1 if(/!<>understood$/); 
    $question{$ARGV} += 1 if(/!<>question/); 
}

# figure out column width in the output file
my $len = 0;
for (keys %total) {
    $len = length($_) if $len < length($_);
}

# sort 
my @names = sort { $total{$a} <=> $total{$b} } keys %total;

my $data_dir = $ENV{DATADIR};
my $filename = "analysisPCOM.dat";
#my $out = File:Spec->catfile($data_dir,$filename); # not work
my $out = $data_dir . "/$filename";
open OUT, ">$out";

say OUT "# filename | total | meaningful | understood | question|";
for (@names) {
    printf OUT "%-${len}s %4d %4d %4d %4d\n", $_, $total{$_}//0, 
        $meaningful{$_}//0, $understood{$_}//0, $question{$_}//0;
}
