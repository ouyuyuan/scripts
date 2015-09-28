#! /usr/bin/perl

# Description: comile one slide in the tmp directory
#
#       Usage: ./xxx.pl 3
#
#         Out: slide-*.pdf
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-11-04 19:28:16 CST
# Last Change: 2012-11-24 21:08:26 CST

use 5.014;
use warnings;
use strict;

use Cwd;

my $page = $ARGV[0];
my $infoFile = "info.txt";
my $adjust = "/home/ou/archive/coded/perl/slides/slides-adjust-source.pl";
my $join   = "/home/ou/archive/coded/perl/slides/slides-join.pl";
my $cwd = getcwd;
my ($filDir, $epsDir);

if (-e $infoFile) {
    &extractInfo;
} else {
    die "$infoFile doesn't exist!\n";
}

system("perl $adjust");
# compile embeded image
chdir $filDir;

$page = '0'.$page if $page < 10; 
my $asy = "slide-$page.asy";

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

sub extractInfo {
    open IN, "<$infoFile";
    while (<IN>) {
        if (/^temporal\sdirectory:\s
            (.+?)
            \s*$/x) {
            $filDir = $1;
        }
        if (/^image\sdirectory:\s
            (.+?)
            \s*$/x) {
            $epsDir = $1;
        }
    }
    close IN;
}

chdir $cwd;
system("perl $join");
