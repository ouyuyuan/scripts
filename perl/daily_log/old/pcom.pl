#!/usr/bin/perl -w

# Description: extract PCOM working infos
#
#       Usage: ./xxx.pl
#      Output: daily-log-pcom.dat
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-11-27 21:23:23 CST
# Last Change: 2012-11-27 22:12:33 CST

use strict;
use 5.010;

my $data_dir = "/home/ou/archive/data";

my $mainname = "daily-log";
my $jobfile  = $data_dir . "/$mainname-jobs.dat";
my $outfile  = $data_dir . "/$mainname-pcom.dat";

my %consumedTime;
my %readLines;

# get sorted dates
my @dates;
my %days;
&getDates;

open IN, "<$jobfile" or die "Can't open file $jobfile: $!";
while (<IN>) {
    if (/
        ^(?<date>\d\d-\d\d-\d\d)
        \s+(?<week>\w{3})
        \s+(?<bt>\d+:\d+)   # begin time
        \s+(?<et>\d+:\d+)   # end time
        \s+(?<lt>\d+:\d+)   # lasted time
        \s+(?<job><.*?>)    # job id
        /x) {
        my $date = $+{date}; 

        my ($h, $m) = split(/:/, $+{lt});
        my $time = $h*60 + $m;
        my $job = $+{job};

        if ($job =~ /<1:1:2>/) { 
            $consumedTime{$date} += $time;
            if (/^.*?<.*?>\s*
                (?<number>\d+) # how much read
                \s*\w+\s*$/x) {
                $readLines{$date} += $+{number};
            }
        }
    }
}

open OUT, ">$outfile" or die "Can't open file: $!";

print OUT "# yy-mm-dd|time|lines\n";
for (@dates) {
    printf OUT "%-s %4d %4d\n", $_, $consumedTime{$_}//0, $readLines{$_}//0;
}
close OUT;

sub getDates {
    my $cnt = 1;
    $days{"12-10-01"} = $cnt;
    push(@dates, "12-10-01");
    open IN, "<$jobfile" or die "Can't open file $jobfile: $!";

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
