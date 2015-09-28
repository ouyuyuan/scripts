#! /usr/bin/perl

# Description: filter .. math:: part
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-01-06 21:18:41 BJT
# Last Change: 2014-01-11 10:22:18 BJT

use 5.010;
use warnings;
use strict;

my $src_rest = $ARGV[0];
my $filtered = $ARGV[1];

my %symbols;

# substitute for sphinx
open IN, "<$src_rest";
open OUT, ">$filtered";

my $ismath = 0;
while (<IN>) {
   # math environment begins
   if (/^\s*\.\.\smath::\s*$/) {
      $ismath = 1;
   } 

   if ($ismath) {
      if (/^\s*\.\.\smath::\s*$/) {
         print OUT;

      # substitutions definition
      } elsif (/^\s+\.\.\s*(.+?)\s*:\s*(.+?)\s*$/) {
         $symbols{$1} = $2;

      # formula
      } elsif(/^\s+.+$/) {
         for my $old (keys %symbols) {
            my $new = $symbols{$old};
            s/\b$old\b/$new/g;
         }
         print OUT "$_";

      # empty line
      } elsif(/^\s*$/) {
         print OUT;

      # math environment ends
      } else {
         $ismath = 0;
         print OUT;
     }

   } else {
      print OUT;
   }
}

close(IN);
close(OUT);
