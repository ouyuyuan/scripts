#!/usr/bin/perl -w

# Description: extract oceanography learning infos
#
#       Usage: ./xxx.pl
#      Output: daily-log-oceanography.dat
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-11-27 21:23:23 CST
# Last Change: 2013-01-02 15:51:59 CST

use strict;
use 5.010;

my $data_dir = "/home/ou/archive/data";

my $mainname = "daily-log";
my $jobfile  = $data_dir . "/$mainname-jobs.dat";
my $outfile  = $data_dir . "/$mainname-oceanography.dat";

my $beginDate = "12-10-11";

my %consumedTime;
my %readPages;

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
        next if $days{$date} < $days{$beginDate};

        my ($h, $m) = split(/:/, $+{lt});
        my $time = $h*60 + $m;
        my $job = $+{job};

        if ($job =~ /<1:2:2>/) { 
            $consumedTime{$date} += $time;
            if (/^.*?<.*?>\s*
                (?<number>\d+) # how much read
                \s*\w+\s*$/x) {
                $readPages{$date} += $+{number};
            }
        }
    }
}

open OUT, ">$outfile" or die "Can't open file: $!";

print OUT "# yy-mm-dd|time|pages\n";
for (@dates) {
    next if $days{$_} < $days{$beginDate};
    printf OUT "%-s %4d %4d\n", $_, $consumedTime{$_}//0, $readPages{$_}//0;
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
