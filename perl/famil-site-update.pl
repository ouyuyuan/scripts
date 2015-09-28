#! /usr/bin/perl

# Description: famil site daily update
#
#       Usage: ./xxx.pl
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-12-09 08:54:49 CST
# Last Change: 2012-12-10 21:52:59 CST

use 5.014;
use warnings;
use strict;

use utf8;
binmode STDOUT, ':utf8';
binmode STDERR, ':utf8';
use open IN  => ':utf8', OUT => ':utf8';

my $updateTxt = "update_new.txt";

open IN, "<$updateTxt";
my @content = <IN>;
close IN;

my $date = shift @content;
chomp $date;
my ($y,$m,$d) = split '-', $date;
$date = "${y}年${m}月${d}日";

$^I = ".bak";

my $retain = 1; # switch for update
while (<>) {
    s/\r\n$/\n/; # convert DOS newline to unix newline
    print if $retain;

    if (/^(?<sp>\s*)<h3>模式发展每日更新/) {
        $retain = 0;
        my $spaces = $+{sp};

        say $spaces . '<div class="wrapper">';
        say $spaces . '<h3 class="color1">' . "$date</h3>";
        say $spaces . '<p>';
        print @content;
    }

    if(!$retain && /<\/p>/) {
        print;
        $retain = 1;
    }

    if (/^(?<sp>\s*)<h3>FAMIL发展历程/) {
        my $spaces = $+{sp};

        say "$spaces\t" . '<div class="col3 marg_right1">';
        say "$spaces\t\t" . '<h3 class="color1">' . "$date</h3>";
        say "$spaces\t\t" . '<p class="color2 pad_bot1">';
        print @content;
        say "$spaces\t\t" . '</p>';
        say "$spaces\t" . '</div>';
    }
}
