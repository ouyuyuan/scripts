#! /usr/bin/perl -w

# Description: edit context of the input files
#
#       Usage: ./xxx.pl edit/bak
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2013-01-10 10:56:04 CST
# Last Change: 2013-04-18 06:56:29 CST

use 5.010;
use strict;
use File::Copy;
use Term::ANSIColor qw(:constants);
$Term::ANSIColor::AUTORESET = 1;

$^I = ".bak";
my $bak_dir = "backups/";

my @files = (glob '*.f90');

if ($ARGV[0] eq 'edit') {
    system("mkdir -p $bak_dir");
    @ARGV = @files;

    while (<>) {
        s/real\(kind=kindnum\)/real/g;
        s/real\(kind=8\)/real/g;
        print;
    }

    move $_, $bak_dir for glob '*.f90'.$^I;

} elsif ($ARGV[0] eq 'bak') {
    for my $file (@files) {
        copy "$bak_dir/$file$^I", "./$file";
    }
} else {
    die "Wrong argument";
}
