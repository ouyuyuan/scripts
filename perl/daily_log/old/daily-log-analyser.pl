#!/usr/bin/perl -w

# Description: Analyze log file to produce data for drawing
#
#       Usage: ./xxx.pl
#      Output: ~/archive/data/*log*.dat
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-10-06 19:51:14 CST
# Last Change: 2013-01-17 21:47:29 CST

use strict;
use 5.010;

my $data_dir   = "/home/ou/archive/data";
my $log_dir    = "/home/ou/archive/org/log";

my $mainname = "daily_log";
my $outcdl = "$data_dir/$mainname.cdl";
my $outyn = "$data_dir/${mainname}_yesno.txt";
my $outjob = "$data_dir/${mainname}_jobs.txt";

open OUTYN, ">$outyn"   or die "Can't open file: $!";
open OUTJOB, ">$outjob" or die "Can't open file: $!";

print OUTJOB "# date|week|begin|end|lasted|job|done";

my %days;

my $date;
my $jobtag;
my %CellNews;
my %manga;
my %doesotrue;
my %fitness;

my $cnt;

# extract info from logs
chdir $log_dir;
for (glob 'w*.org') {
    push(@ARGV, $_) if /w\d+\.org/;
}

while (<>) {

    {
        # extract jobs
        if (/^\*+\s+    # level begin
            .*?(?<job><[:\d]+>)    # job tag
            /x)
        {
            $jobtag = $+{job};
        }

        if (/^\s*CLOCK:\s*/) # clock tag
        {
            if (/^\s*CLOCK:\s*
                \[20(?<jobdate>\d\d-\d\d-\d\d)
                \s(?<week>\w{3})\s
                (?<bt>\d+:\d+)        # begin time
                .*?(?<et>\d+:\d+)     # end time
                .*?(?<lt>\d+:\d+)\s*$ # lasted time
                /x) 
            {
                printf OUTJOB "\n%-s %s %6s %6s %6s %-15s", $+{jobdate}, $+{week},
                    $+{bt}, $+{et}, $+{lt}, $jobtag;
            } else { 
                die "some thing wrong in clock in $_\n"; 
            }
        }

        if (/^\s*(?<done>\d+\s*\w+)\s*$/) # how much done
        {   print OUTJOB ' '.$+{done};  }
    }

    # dates and total days since 2012-10-01
    if (/
        ^\*\s+                        # mark of top layer of org-mode
        <20(?<date>\d{2}-\d{2}-\d{2}) # date of log
        /x) {
        $date = $+{date};
        $cnt += 1;
        $days{$date} = $cnt;
    }

    # yes or no activity
    if (/
        ^\s*
        \|1:(?<news>\d)
        \|2:(?<manga>\d)
        \|3:(?<doeso>\d)
        \|4:(?<fitness>\d)
        \|\s*$
        /x) {
        $CellNews{$date}  = $+{news};
        $manga{$date}     = $+{manga};
        $doesotrue{$date} = $+{doeso};
        $fitness{$date}   = $+{fitness};
    }
}
close OUTJOB;

# sort dates
my @dates = sort { $days{$a} <=> $days{$b} } keys %days;

my $len = length($dates[0]) + 2;
say OUTYN "# yy-mm-dd|cell-news|manga|doesotrue|fitness";
for (@dates) {
    printf OUTYN "%-${len}s %2d %2d %2d %2d\n", $_, $CellNews{$_}//0,
        $manga{$_}//0, $doesotrue{$_}//0, $fitness{$_}//0;
}
close OUTYN;

&analyze_time;

sub analyze_time
{
    my %am; # morning
    my %am_arri; # arrival in a.m.
    my %pm; # afternoon
    my %pm_arri;
    my %ni; # night
    my %ni_arri; # night

    for (@dates) {
        $am_arri{$_} = 24*60+60;
        $pm_arri{$_} = 24*60+60;
        $ni_arri{$_} = 24*60+60;
    }
    
    my %work;
    my %learn;
    my %othercls;

    my %readpaper;
    my %pcom;
    my %dynamics;
    my %dpo;       # Descriptive Physical Oceanography
    my %research;
    my %math;
    my %physics;
    my %programming;
    my %othersub;

    my %DailyScore;
    my %PaperScore;
    my %BookScore;
    my %CodeScore;

    open IN, "<$outjob" or die "Can't open file $outjob: $!";

    while (<IN>)
    {
        if (/
            ^(?<date>\d\d-\d\d-\d\d)
            \s+(?<week>\w{3})
            \s+(?<bt>\d+:\d+)   # begin time
            \s+(?<et>\d+:\d+)   # end time
            \s+(?<lt>\d+:\d+)   # lasted time
            \s+(?<job><.*?>)    # job id
            /x) 
        {
            my $date = $+{date};
            my ($h, $m) = split(/:/, $+{lt});
            my $time = $h*60 + $m;
            my $job = $+{job};

            my ($bh, $bm) = split(/:/, $+{bt});
            given ($bh)
            {
                when ($_ < 12) { 
                    $am{$date} += $time; 

                    my $arri_now = $bh*60 + $bm;
                    my $arri = $am_arri{$date};
                    $am_arri{$date} = $arri_now if $arri > $arri_now;
                }
                when ($_ < 18) { 
                    $pm{$date} += $time; 

                    my $arri_now = $bh*60 + $bm;
                    my $arri = $pm_arri{$date};
                    $pm_arri{$date} = $arri_now if $arri > $arri_now;
                }
                default        { 
                    $ni{$date} += $time; 

                    my $arri_now = $bh*60 + $bm;
                    my $arri = $ni_arri{$date};
                    $ni_arri{$date} = $arri_now if $arri > $arri_now;
                }
            }

            given ($job) # job class
            {
                when (/<1:/) { $work     {$date} += $time; }
                when (/<3:/) { $learn    {$date} += $time; }
                default      { $othercls {$date} += $time; }
            }

            given ($job) # job subject
            {
                when (/<1:5:/) { $readpaper   {$date} += $time; }
                when (/<1:1:2>/) { $pcom        {$date} += $time; }
                when (/<1:2:1>/) { $dynamics    {$date} += $time; }
                when (/<1:2:2>/) { $dpo         {$date} += $time; }
                when (/<3:4:/) { $math        {$date} += $time; }
                when (/<3:5:/) { $physics     {$date} += $time; }
                when (/<3:3:/) { $programming {$date} += $time; }
                when (/<7:/)   { $research    {$date} += $time; }
                default        { $othersub    {$date} += $time; }
            }

            # calculate scores
            if (/^.*?<.*?>\s*
                (?<number>\d+) # how much been accomplished for a job
                \s*\w+\s*$/x)
            {
                my $UnitScore;
                my $num = $+{number};
                my $dl60 = ($days{$date} < 60) ? 1 : 0;
                my $score;
                given ($job)
                {
                    when (/<1:5:/) 
                    { 
                        $UnitScore = 2; # 2 points per page
                        $score = $num * $UnitScore;
                        $PaperScore{$date} += $score;
                        $DailyScore{$date} += $score;
                    }
                    when (/<1:1:2>/) # PCOM reading 
                    {
                        $UnitScore = 0.5; # 0.5 points per code line
                        $score = $num * $UnitScore * $dl60;
                        $CodeScore{$date} += $score;
                        $DailyScore{$date} += $score;
                    }
                    when (/<1:2:1>/)  # Holton dynamics
                    {
                        $UnitScore = 2; # 2 points per page
                        $score = $num * $UnitScore * $dl60;
                        $BookScore{$date} += $score;
                        $DailyScore{$date} += $score;
                    }
                    when (/<1:2:2>/)  # Talley DPO
                    {
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

    open OUTTIME, ">$outtime" or die "Can't open file: $!";

    say OUTTIME "# yy-mm-dd|am(m)|pm|ni|work|learn|other";
    for (@dates) {
        printf OUTTIME "%-s %4d %4d %4d %4d %4d %4d\n", $_, 
            $am{$_}//0, $pm{$_}//0, $ni{$_}//0, 
            $work{$_}//0, $learn{$_}//0, $othercls{$_}//0;
    }
    close OUTTIME;


    open OUTSUBTIME, ">$outsubtime" or die "Can't open file: $!";

    print OUTSUBTIME "# yy-mm-dd|readpaper|pcom|dynamics|oceanography|";
    print OUTSUBTIME "|math|physics|programming|research|other\n";
    for (@dates) {
        printf OUTSUBTIME "%-s %4d %4d %4d %4d %4d %4d %4d %4d %4d\n", $_, 
            $readpaper{$_}//0, $pcom{$_}//0, $dynamics{$_}//0, 
            $dpo{$_}//0, $math{$_}//0, $physics{$_}//0, 
            $programming{$_}//0, $research{$_}//0, $othersub{$_}//0;
    }
    close OUTSUBTIME;


    open OUTSCORES, ">$outscores" or die "Can't open file: $!";

    print OUTSCORES "# yy-mm-dd|dailyscore|readpaper|booklearning|codereading\n";
    for (@dates) {
        printf OUTSCORES "%-s %4d %4d %4d %4d\n", $_, $DailyScore{$_}//0, 
            $PaperScore{$_}//0, $BookScore{$_}//0, $CodeScore{$_}//0;
    }
    close OUTSCORES;

    open OUTTREND, ">$outtrend" or die "Can't open file: $!";

    print OUTTREND "# yy-mm-dd|a.m. arrival|p.m.|n.i.\n";
    for (@dates) {
        printf OUTTREND "%-s %4d %4d %4d\n", $_, 
            $am_arri{$_}//0, $pm_arri{$_}//0, $ni_arri{$_}//0;
    }
    close OUTTREND;
}
