#! /usr/bin/perl

# Description: substitute words of the input files
#
#       Usage: ./xxx.pl
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-09-23 10:06:31 CST
# Last Change: 2012-11-21 20:18:26 CST

use 5.014;
use warnings;
use strict;

my $infoFile = "info.txt";
my $filDir;
my $outRef;
my $draws;

if (-e $infoFile) {
    &extractInfo;
} else {
    die "$infoFile doesn't exist!\n";
}

my $cite = "cites";
my $refs = "refs";

my %citeCmd;
my %citeAuthor;
my %citeYear;

my @files = glob "$draws";
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
open OUT, ">$filDir/$cite.tex";
say OUT "$_\n" for (values %citeCmd);
close OUT;

exit unless (keys %citeCmd) > 0;

&compilerefs;

# split pdf to get reference and remove files
#-------------------------------------------------------------------------------
system("pdftk A=$refs.pdf cat A2-end output $outRef.pdf");
system("mv $refs.bbl $outRef.bbl");
system("rm -f paps.bib $refs.tex $refs.pdf");


#===============================================================================

# compile slide with latex
sub compilerefs {
    chdir $filDir;
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

sub extractInfo {
    open IN, "<$infoFile";
    while (<IN>) {
        if (/^temporal\sdirectory:\s
            (.+?)
            \s*$/x) {
            $filDir = $1;
        }
        if (/^reference-slide:\s
            (.+?)
            \s*$/x) {
            $outRef = $1;
            $outRef =~ s/\.pdf//;
        }
        if (/^draws:\s
            (.+?)
            \s*$/x) {
            $draws= $1;
        }
    }
    close IN;
}
