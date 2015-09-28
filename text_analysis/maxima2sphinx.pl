#! /usr/bin/perl

# Description: process calculation output of maxima to Sphinx math format
#
#       Usage: xxx.pl xxx.mac
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-06-05 20:09:53 CST
# Last Change: 2013-12-27 18:25:17 BJT

use 5.010;
use warnings;
use strict;
use Cwd 'abs_path';

my $rest_file = "/home/ou/archive/notes/math_display/source/maxima.rst";
my $scr_dir = "/home/ou/archive/scripts";
my $www_scr_dir = "/attach/scripts";
my $mac_scr = abs_path($ARGV[0]);
my $filtered_mac = "filtered_by_perl.mac";
my $result_file = "maxima.out";
my $rst_dir="/home/ou/archive/notes/math_display";
my $compile_rst="mathjaxmake";

my %symbols;

# filter input mac script and feed it to Maxima
open IN, "<$mac_scr";
open OUT, ">$filtered_mac";
say OUT 'outfile: "maxima.out"; with_stdout(outfile); file_output_append: true;';
while (<IN>) {
#    s/(tex\(.*\));/with_stdout(outfile,$1);/;
    if (/(^\s*".*"\s*);/) {   # "abc" will not be displayed in output file
       $_ = "with_stdout(outfile,print($1));\n";
    } else {
       s/(^.+);/with_stdout(outfile,$1);/;
    }
    print OUT;
}
close(IN);
close(OUT);
system("maxima -qb $filtered_mac");

# get substitutions
open IN, "<$mac_scr";
while (<IN>) {
    if (/^\/\*\$\s*
        (.*?)      # maxima symbol
        \s*:\s*
        (.*?)      # latex symbol
        \s*\$\*\//x) {
        $symbols{$1} = $2;
    }

}
close(IN);

# modify identifiers according to Maxima's default behaviour in tex() output
for (keys %symbols) {
    my $val = $symbols{$_};
    s/_/\\\\_/g;                  # Maxima change "_" to "\_", Perl need escape "\"
    s/([a-zA-Z])([0-9])/$1_$2/g;  # Maxima change "A1" to "A_1"
    $symbols{$_} = $val;
#    say;
#    say $symbols{$_};
}

# substitute for sphinx
open IN, "<$result_file";
open OUT, ">$rest_file";
say OUT "===============================";
say OUT " Results of Maxima Calculation ";
say OUT "===============================";
say OUT "";
say OUT "[`Maxima code`__]";
say OUT "";
$mac_scr =~ s/$scr_dir/$www_scr_dir/;
say OUT "__ $mac_scr";
say OUT "";
my $math = 0;   # some math expression expand multiple lines
while (<IN>) {
    # latex expression
    s/\\%k_2\b/c_2/g;
    s/_{(.+?)}/$1/g; # Maxima will change f12 to f_{12} in tex output
    if (/^\$\$/ || $math) {
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

        # substitute predefined consant symbols for ode solution
        s/\\%k_1\b/c_1/g;
        s/\\%k_2\b/c_2/g;

        # substitute list delimiter
#        if (/^\$\$\s*\\left\[/ && /\\right\]\s*\$\$$/) {
        if (/^\$\$\s*\\left\[/ || /\\right\]\s*\$\$$/) {
            s/\$\$\s*\\left\[//g;
            s/\\right\]\s*\$\$//g;
        }
#        if (/^\s*\\left\[/ && /\\right\]\s*$/) {
        if (/^\s*\\left\[/ || /\\right\]\s*$/) {
            s/^\s*\\left\[//g;
            s/\\right\]\s*$//g;
        }

        # process verbatim
        s/\\begin{verbatim}//g;
        s/:=/=/g;
        s/;$//;
        s/\*//g;
        s/\\end{verbatim}//g;

        s/\$\$//g; # substitute tex delimiter
        s/^\s+//;  # remove prefix white space
        print OUT "\t$_";
        print OUT "\n" if $end_expr;

    # ordinary text
    } else {
        print OUT;
    }
}
close(IN);
close(OUT);

chdir($rst_dir) or die "$!";
system("$compile_rst");
