#!/usr/bin/perl

# Description: create schedule.asy from schedule.org 
#
#       Usage: ./xxx.pl
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-12-01 13:32:33 CST
# Last Change: 2013-01-21 09:24:02 CST

use strict;
use 5.014;
use warnings;

use Date::Calc qw( Today Delta_Days );

# def variables <<<1

my $orgDir  = "/home/ou/archive/org";
my $orgFile = "$orgDir/schedule.org";

my ($year, $month, $day) = Today();
$month = "0$month" if $month<10;
$day   = "0$day" if $day<10;
my $asyFile = "$orgDir/log/schedules/schedule-$year-$month-$day.asy";
my $schFile = "tmp_files/schedules.asy";

# analyse schedule.org <<<1

open IN,  "<$orgFile" or die "Can't open file $orgFile: $!";
open OUT, ">$asyFile" or die "Can't open file $asyFile: $!";
my ($content, $id);
while(<IN>) {
    
    # get task title <<<2
    
    if (/^\*+\s+      # start of org level
        (.*?)$        # task content
        /x) {
        $content = $1;
    }

    # get schedule time <<<2

    if (/^\s*<                          # time tag
        (?<date>\d{4}-\d{2}-\d{2})\s+   # date
        (?<week>\w{3})\s+               # week
        (?<time>\d\d:\d\d-\d\d:\d\d)\s+ # time period
        \+(?<cyn>\d)(?<cyu>\w)>         # cycle number and unit
        /x) {
        my($beginDate, $beginWeek, $timePeriod, $cyn, $cyu) = 
        ($+{date}, $+{week}, $+{time}, $+{cyn}, $+{cyu});

        $cyn *= 7 if $cyu eq 'w';
        my($y1,$m1,$d1) = split('-',$beginDate);
        my $Dd = Delta_Days($y1,$m1,$d1, $year,$month,$day);

        # output asy struct <<<3

        # Is today in the job cycle?
        if ( ($Dd>= 0) && ($Dd % $cyn == 0) ) {
            say OUT "schedule sche;";
            say OUT "sche.content = \"$content\";";
            say OUT "sche.time = \"$timePeriod\";";
            say OUT "sches.push(sche);";
            say OUT "";
        }
    }
}

close IN;
close OUT;

system("cp -f $asyFile $schFile") if -e "tmp_files/";
