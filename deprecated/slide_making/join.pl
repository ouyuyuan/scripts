#! /usr/bin/perl

# Description: join compiled slides together using pdftk and jpdfbookmarks
#              this should run after all ther preparation work
#
#       Usage: ./xxx.pl
#
#         Out: slides-final.pdf
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-11-17 10:25:53 CST
# Last Change: 2013-11-28 22:09:27 CST

use 5.014;
use warnings;
use strict;

# def. vars <<<1

my $infoFile = "info.txt";
my ($filDir, $joiPdf);

# extract basic info <<<1

if (-e $infoFile) {
    &extractInfo;
} else {
    die "$infoFile doesn't exist!\n";
}

# join it <<<1

chdir $filDir;
system("pdftk `ls slide-*.pdf | sort` cat output $joiPdf");
system("jpdfbookmarks $joiPdf -a bookmarks.txt --force --out $joiPdf");
system("mv $joiPdf ../");

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
        if (/^final\sproduct:\s
            (.+?)
            \s*$/x) {
            $joiPdf = $1;
        }
    }
    close IN;
}
