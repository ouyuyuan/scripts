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
# Last Change: 2012-11-21 18:35:43 CST

use 5.014;
use warnings;
use strict;

my $infoFile = "info.txt";
my ($filDir, $joiPdf);

if (-e $infoFile) {
    &extractInfo;
} else {
    die "$infoFile doesn't exist!\n";
}

chdir $filDir;
system("pdftk `ls slide-*.pdf | sort` cat output $joiPdf");
system("jpdfbookmarks $joiPdf -a bookmarks.txt --force --out $joiPdf");
system("mv $joiPdf ../");

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
