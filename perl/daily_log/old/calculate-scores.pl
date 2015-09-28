#!/usr/bin/perl -w

# Description: calculate scores from jobs file
#
#       Usage: ./xxx.pl
#      Output: daily-log-scores.dat
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-11-27 14:31:20 CST
# Last Change: 2012-11-27 19:33:44 CST

use strict;
use 5.010;

my $data_dir   = "/home/ou/archive/data";

my $mainname   = "daily-log";
my $outjob     = $data_dir . "/$mainname-jobs.dat";
my $outscores  = $data_dir . "/$mainname-scores.dat";

my $beginDate = "12-10-08";
my $endDate   = "12-11-20";

my %DailyScore;
my %PaperScore;
my %BookScore;
my %CodeScore;

# get sorted dates
my @dates;
my %days;
&getDates;

open IN, "<$outjob" or die "Can't open file $outjob: $!";

while (<IN>) {
    if (/
        ^(?<date>\d\d-\d\d-\d\d).+?
        (?<job><.*?>)    # job id
        /x) {
        my $date = $+{date}; 
        next if $days{$date} < $days{$beginDate};
        last if $days{$date} > $days{$endDate};
        my $job = $+{job};

        if (/^.*?<.*?>\s*
            (?<number>\d+) # how much been accomplished for a job
            \s*\w+\s*$/x) {
            my $UnitScore;
            my $num = $+{number};
            my $dl60 = ($days{$date} < 60) ? 1 : 0;
            my $score;
            given ($job) {
                when (/<1:5:/) { 
                    $UnitScore = 2; # 2 points per page
                    $score = $num * $UnitScore;
                    $PaperScore{$date} += $score;
                    $DailyScore{$date} += $score;
                }
                when (/<1:1:2>/) { # PCOM reading 
                    $UnitScore = 0.5; # 0.5 points per code line
                    $score = $num * $UnitScore * $dl60;
                    $CodeScore{$date} += $score;
                    $DailyScore{$date} += $score;
                }
                when (/<1:2:1>/) { # Holton dynamics
                    $UnitScore = 2; # 2 points per page
                    $score = $num * $UnitScore * $dl60;
                    $BookScore{$date} += $score;
                    $DailyScore{$date} += $score;
                }
                when (/<1:2:2>/) { # Talley DPO
                    $UnitScore = 2; # 2 points per page
                    $score = $num * $UnitScore * $dl60;
                    $BookScore{$date} += $score;
                    $DailyScore{$date} += $score;
                }
                default { }
            }
        }
    }
}
close IN;

open OUTSCORES, ">$outscores" or die "Can't open file: $!";

print OUTSCORES "# yy-mm-dd|dailyscore|readpaper|booklearning|codereading\n";
for (@dates) {
    next if $days{$_} < $days{$beginDate};
    last if $days{$_} > $days{$endDate};
    printf OUTSCORES "%-s %4d %4d %4d %4d\n", $_, $DailyScore{$_}//0, 
        $PaperScore{$_}//0, $BookScore{$_}//0, $CodeScore{$_}//0;
}
close OUTSCORES;

sub getDates {
    my $cnt = 1;
    $days{"12-10-01"} = $cnt;
    push(@dates, "12-10-01");
    open IN, "<$outjob" or die "Can't open file $outjob: $!";

    while (<IN>) {
        if (/
            ^(?<date>\d\d-\d\d-\d\d)
            /x) {
            my $date = $+{date}; 
            unless ($date eq $dates[-1]) {
                push(@dates, $date); 
                $cnt += 1;
                $days{$date} = $cnt;
            }
        }
    }
    close IN;
}
