#! /usr/bin/perl

# Description: substitute words of the input files
#
#       Usage: ./xxx.pl
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-09-23 10:06:31 CST
# Last Change: 2012-11-17 09:35:26 CST

use 5.014;
use warnings;
use strict;

my $cite = "cites";
my $refs = "slide-refs";

my %citeCmd;
my %citeAuthor;
my %citeYear;

my @files = glob "slide-*.asy";

push(@ARGV, $_) for (@files);
#===============================================================================

# extract citeation info from drawing scritps
#-------------------------------------------------------------------------------
while (<>) {
    if (/(?<cmd>
        \\cite.*?
        {(?<id>.+?)})    # bibtex key
        /x) {
        $citeCmd{$+{id}} = $+{cmd};
    }
}

# write latex file
#-------------------------------------------------------------------------------
open OUT, ">>$cite.tex";
say OUT "$_\n" for (values %citeCmd);
close OUT;

#exit unless (keys %citeCmd) > 0;
&compilerefs;

# substitute correct text for citetation in drawing scripts
#-------------------------------------------------------------------------------

&extractBbl;

push(@ARGV, $_) for (@files);
$^I = ".bak";
while (<>) {
    if (/(?<cmd>
        \\cite.*?
        {(?<id>.+?)})    # bibtex key
        /x) {
        my $cmd = $+{cmd};
        my $a = $citeAuthor{$+{id}};
        my $b = $citeYear{$+{id}};
        if ($cmd =~ /\[(?<opt>.+)\]/) {
            $b = $b . ", $+{opt}";
        }

        my $show = "{\\color{cyan4} \\small \\em $a($b)}";
        $show    = "{\\color{cyan4} \\small \\em ($a, $b)}" if $cmd =~ /citep/;

        s/\\cite.+?}/$show/;
    }
    print;
}

# split pdf to get reference and remove files
#-------------------------------------------------------------------------------
system("pdftk A=$refs.pdf cat A2-end output slide-reference.pdf");
system("rm -f paps.bib $refs.tex $refs.pdf $refs.bbl");

system("mv *.bak bak/");

#===============================================================================
# compile slide with latex
sub compilerefs {
    my $template = "/home/ou/archive/coded/latex/templates/slides-reference.tex";
    my $bibfile  = "/home/ou/archive/paps/bib/paps.bib";

    system("cp $template ./$refs.tex");
    system("ln -sf $bibfile ./");

    system("pdflatex $refs.tex > /tmp/temp.txt");
    system("bibtex   $refs.aux > /tmp/temp.txt");
    system("pdflatex $refs.tex > /tmp/temp.txt");

    system("rm -f cites.aux");

    # remove files
    my @rmSuff  = qw/ .aux .blg .log .out /;
    for (@rmSuff) {
        my $file = $refs . "$_";
        system("rm $file") if -e $file;
    }
}

# extract info from .bbl file
sub extractBbl {
    open IN, "<$refs.bbl";
    
    while(<IN>) {
        if (/
            ^\\bibitem
            \[(?<author>.+?)
            \((?<year>.+?)\)\]
            {(?<id>.+?)}
            /x) {
            $citeAuthor{$+{id}} = $+{author};
            $citeYear{$+{id}} = $+{year};
        }
    }
    close IN;
}
