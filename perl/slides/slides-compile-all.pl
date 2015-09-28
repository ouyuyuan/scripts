#! /usr/bin/perl

# Description: compile all slides
#
#       Usage: ./xxx.pl
#
#         Out: outline.asy, slide-*.pdf, *.pdf(finnal product)
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-11-04 19:28:16 CST
# Last Change: 2012-11-28 10:52:50 CST

use 5.014;
use warnings;
use strict;

use Cwd;

my $infoFile = "info.txt";
my $cwd = getcwd;
my ($filDir, $title, $draws, $epsDir);

if (-e $infoFile) {
    &extractInfo;
} else {
    die "$infoFile doesn't exist!\n";
}

my $covPage  = "slide-01";
my $outPage  = "slide-02";

# create cover drawings
open OUT, ">$filDir/$covPage.asy";
say OUT "import myslide;";
say OUT "cover(\"\\bf $title\", false);";
say OUT "shipout(\"$covPage.pdf\");";
close OUT;

# create outline drawings
open OUT, ">$filDir/$outPage.asy";
say OUT "import myslide;";
say OUT "outline(false);";
say OUT "shipout(\"$outPage.pdf\");";
close OUT;

# run drawing scripts
chdir $filDir;
my @asys;
for (glob "$draws") {
    push(@asys, $_) if /\.asy/; 
}
# exec seems not run all the scripts, but just last of them
for my $asy (@asys) {
    # compile embeded image
    open INASY, "<$asy";
    while (<INASY>) {
        if (/
            graphic\("
            (?<eps>.+\.eps)
            /x) {
            my $eps = $+{eps};
            my $emb = $eps;
            $emb =~ s/\.eps/.asy/;
            $emb = "$cwd/$emb";
            if (-e $emb) {
                $eps = "$epsDir/$eps";
                if (-M $emb < -M $eps) {
                    chdir $cwd;
                    system("/usr/bin/asy -globalwrite $emb");
                    say "compiled $emb";
                    chdir $filDir;
                }
            }
        }
    }
    close INASY;

    system("/usr/bin/asy -f pdf $asy");
    say "compiled $asy";
}

sub extractInfo {
    open IN, "<$infoFile";
    while (<IN>) {
        if (/^temporal\sdirectory:\s
            (.+?)
            \s*$/x) {
            $filDir = $1;
        }
        if (/^title:\s
            (.+?)
            \s*$/x) {
            $title = $1;
        }
        if (/^draws:\s
            (.+?)
            \s*$/x) {
            $draws = $1;
        }
        if (/^image\sdirectory:\s
            (.+?)
            \s*$/x) {
            $epsDir = $1;
        }
    }
    close IN;
}
