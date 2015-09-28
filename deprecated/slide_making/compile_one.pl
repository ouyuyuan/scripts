#! /usr/bin/perl

# Description: comile one slide in the tmp directory
#
#       Usage: ./xxx.pl 3
#
#         Out: slide-*.pdf
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-11-04 19:28:16 CST
# Last Change: 2013-12-23 20:21:59 BJT

use 5.014;
use warnings;
use strict;

use Cwd;

# def. vars <<<1

my $page = $ARGV[0];
my $infoFile = "info.txt";
my $adjust = "/home/ou/archive/scripts/slide_making/adjust_source.pl";
my $join   = "/home/ou/archive/scripts/slide_making/join.pl";
my $cwd = getcwd;
my ($filDir, $epsDir);

# extract basic infos <<<1

if (-e $infoFile) {
    &extractInfo;
} else {
    die "$infoFile doesn't exist!\n";
}

# adjust slide <<<1

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

# compile slide <<<1

system("/usr/bin/asy -f pdf $asy");
say "compiled $asy";

# subroutines <<<1

# extract slide infos <<<2

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

# join slides <<<1

chdir $cwd;
system("perl $join");
