#! /usr/bin/perl

# Description: process calculation output of Sage to ReSTructure format
#
#       Usage: xxx.pl xxx.sage
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-06-11 07:54:57 CST
# Last Change: 2013-06-11 16:14:33 CST

use 5.010;
use warnings;
use strict;

my $rest_file = "/home/ou/archive/notes/cas_out/source/sage.rst";
my $sage_scr = $ARGV[0];
my $result_file = "sage.out";

my %symbols;

# get substitutions
open IN, "<$sage_scr";
while (<IN>) {
    if (/^\s*\#\s*\$
        (.*?)      # sage symbol
        \s*:\s*
        (.*?)      # latex symbol
        \s*\$\s*$/x) {
        $symbols{$1} = $2;
    }

}
close(IN);

# substitute for sphinx
open IN, "<$result_file";
open OUT, ">$rest_file";
say OUT "============================";
say OUT " Results of Sage caculation ";
say OUT "============================";
say OUT "";
say OUT "[`sage code`__]";
say OUT "";
say OUT "__ /attach/coded/sage/numer_ex/$sage_scr";
say OUT "";
while (<IN>) {
    # latex expression
    if (/^\t.+$/) {
        say OUT "";
        say OUT ".. math::";
        say OUT "   :label:";
        say OUT "";
        for my $old (keys %symbols) {
            my $new = $symbols{$old};
            s/\b$old\b/$new/g;
        }
        say OUT;

    # ordinary text
    } else {
        print OUT;
    }
}
close(IN);
close(OUT);
