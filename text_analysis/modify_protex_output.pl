#! /usr/bin/perl

# Description: modify original output of protex for a more beautiful doc
#
#       Usage: ./xxx.pl $preamble.txt $appendix.tex $input.tex > $output.tex
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-05-17 08:48:42 BJT
# Last Change: 2014-10-17 17:40:45 BJT

use 5.014;
use warnings;
use strict;

my $preamble = shift @ARGV;
my $appendix = shift @ARGV;

open IN, "<$preamble";
my @content = <IN>;
close IN;

open IN, "<$appendix";
my @content_app = <IN>;
close IN;

while (<>) {
    if (/\\markboth{}{}\s*$/) {
        print;
        print "\n%-----------begin ADD by perl--------------\n";
        print @content;
        print "%-----------end ADD by perl----------------\n\n";
    } elsif (/\\end{document}\$*$/) {
        print "\n%-----------begin ADD by perl--------------\n";
        print @content_app;
        print "%-----------end ADD by perl----------------\n\n";
        print;
    } elsif (/\\def\\\[{\\left\ \[}\s*$/) {
      # preserve the original meaning of \[
    } elsif (/\\def\\\]{\\right\ \]}\s*$/) {
      # preserve the original meaning of \]
    } else {
        print;
    }
}
