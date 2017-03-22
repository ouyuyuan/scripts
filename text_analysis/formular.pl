#! /usr/bin/perl

# Description: write formular in a simple way 
#
#       Usage: simple_formular xxx.txt
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-12-27 18:12:59 BJT
# Last Change: 2014-01-11 19:54:18 BJT

use 5.010;
use warnings;
use strict;
use Cwd 'abs_path';

my $rest_dir = "/home/ou/docs/notes/math_display";
my $rest_file = "$rest_dir/source/formula.rst";
my $src_txt = abs_path($ARGV[0]);
my $compile_rest = "make html";
my $www_src = "/external/formular.txt";
my $cp_src = "/var/www/html$www_src";

my %symbols;

system("cp $src_txt $cp_src");

# substitute for sphinx
open IN, "<$src_txt";
open OUT, ">$rest_file";
say OUT "==========";
say OUT " Formulae ";
say OUT "==========";
say OUT "";
say OUT "[`formulae source`__]";
say OUT "";
say OUT "__ $www_src";
say OUT "";
my $math = 0;   # some math expression expand multiple lines
while (<IN>) {
    # substitutions definition
    if (/^\#\s*
        (.*?)      # simple symbol
        \s*:\s*
        (.*?)      # latex symbol
        \s*$/x) {
        $symbols{$1} = $2;

    # comments
    } elsif (/^\s*\#/) {
    # formula
    } elsif (/^\$\$/ || $math) {
        $math = 1;
        if (/^\$\$/) {
            say OUT "";
            say OUT ".. math::";
            say OUT "   :label:";
            say OUT "";
        }
        for my $old (keys %symbols) {
            my $new = $symbols{$old};
            s/\b$old\b/$new/g;
        }
        my $end_expr = 0;
        if (/\$\$$/) {
            $end_expr = 1;
            $math = 0;
        }

        s/\$\$//g; # substitute tex delimiter
        s/^\s+//;  # remove prefix white space
        print OUT "\t$_";
        if ($end_expr) {
           print OUT "\n"; 
         }

    # ordinary text
    } else {
        print OUT;
    }
}
close(IN);
close(OUT);

chdir($rest_dir) or die "$!";
system("$compile_rest");
