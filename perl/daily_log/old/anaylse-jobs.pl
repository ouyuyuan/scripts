#!/usr/bin/perl -w

# Description: Analyze jobs file to produce data for drawing
#
#       Usage: ./xxx.pl
#      Output: ~/archive/data/*log*.dat
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-11-27 10:02:25 CST
# Last Change: 2013-01-17 21:47:52 CST

use strict;
use 5.010;

my $data_dir  = "/home/ou/archive/data";

my $mainname  = "daily-log";
my $jobs_file = $data_dir . "/$mainname-jobs.dat";

my $outtime   = $data_dir . "/$mainname-time.dat";
my $out_arr   = $data_dir . "/$mainname-arrival.dat";

my %am_time; # morning
my %pm_time; # afternoon
my %ni_time; # night

my %am_arri; # arrival in a.m.
my %pm_arri;
my %ni_arri; # night

my %work;
my %learn;
my %othercls;

open IN, "<$jobs_file" or die "Can't open file $jobs_file: $!";

my @dates;
my %days;
my $cnt = 1;
$days{"12-10-01"} = $cnt;

push(@dates, "12-10-01");

my $init_arri = 25*60;
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
        unless ($date eq $dates[-1]) {
            push(@dates, $date); 
            $cnt += 1;
            $days{$date} = $cnt;
        }

        my ($h, $m) = split(/:/, $+{lt});
        my $time = $h*60 + $m;
        my $job = $+{job};

        $am_arri{$date} = $init_arri unless (defined $am_arri{$date});
        $pm_arri{$date} = $init_arri unless (defined $pm_arri{$date});
        $ni_arri{$date} = $init_arri unless (defined $ni_arri{$date});

        my ($bh, $bm) = split(/:/, $+{bt});
        given ($bh) {
            when ($_ < 12) { 
                $am_time{$date} += $time; 

                my $arri_now = $bh*60 + $bm;
                my $arri = $am_arri{$date};
                $am_arri{$date} = $arri_now if $arri > $arri_now;
            }
            when ($_ < 18) { 
                $pm_time{$date} += $time; 

                my $arri_now = $bh*60 + $bm;
                my $arri = $pm_arri{$date};
                $pm_arri{$date} = $arri_now if $arri > $arri_now;
            }
            default        { 
                $ni_time{$date} += $time; 

                my $arri_now = $bh*60 + $bm;
                my $arri = $ni_arri{$date};
                $ni_arri{$date} = $arri_now if $arri > $arri_now;
            }
        }

        given ($job) { # job class
            when (/<1:/) { $work     {$date} += $time; }
            when (/<3:/) { $learn    {$date} += $time; }
            default      { $othercls {$date} += $time; }
        }

    }
}

open OUTTIME, ">$outtime" or die "Can't open file: $!";

say OUTTIME "# yy-mm-dd|am_time(m)|pm_time|ni_time|work|learn|other";
for (@dates) {
    printf OUTTIME "%-s %4d %4d %4d %4d %4d %4d\n", $_, 
        $am_time{$_}//0, $pm_time{$_}//0, $ni_time{$_}//0, 
        $work{$_}//0, $learn{$_}//0, $othercls{$_}//0;
}
close OUTTIME;


open OUTARRIVE, ">$out_arr" or die "Can't open file: $!";

print OUTARRIVE "# yy-mm-dd|a.m. arrival|p.m.|n.i.\n";
for (@dates) {
    printf OUTARRIVE "%-s %4d %4d %4d\n", $_, 
        $am_arri{$_}//0, $pm_arri{$_}//0, $ni_arri{$_}//0;
}
close OUTARRIVE;
