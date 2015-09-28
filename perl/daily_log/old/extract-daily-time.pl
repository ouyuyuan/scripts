#!/usr/bin/perl -w

# Description: Analyze log file to extract CDL file for ncgen
#
#       Usage: ./xxx.pl
#      Output: daily-log.cdl
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-12-23 20:11:08 CST
# Last Change: 2012-12-23 22:20:10 CST

use strict;
use 5.010;

use Date::Calc qw( Today Delta_Days );

# def variables <<<1

my $dat_dir = "/home/ou/archive/data";
my $log_dir = "/home/ou/archive/org/log";

my $outfile = "$dat_dir/daily-log.cdl";

my %manga;
my %doesotrue;
my %fitness;

# glob log files <<<1
chdir $log_dir;
for (glob 'w*.org') {
    push(@ARGV, $_) if /w\d+\.org/;
}

# check lines of logs <<<1

open OUTJOB, ">$outjob" or die "Can't open file: $!";
print OUTJOB "# date|week|begin|end|lasted|job|done";

while (<>) {

    # extract job-id <<<2

    if (/^\*+\s+    # org level
        .*?
        (<[:\d]+>)  # job id
        /x) {
        $jobtag = $1;
    }

    # extract job time <<<2

    if (/^\s*CLOCK:\s*/) { # clock tag
        if (/^\s*CLOCK:\s*
            \[20(?<jobdate>\d\d-\d\d-\d\d)
            \s(?<week>\w{3})\s
            (?<bt>\d+:\d+)        # begin time
            .*?(?<et>\d+:\d+)     # end time
            .*?(?<lt>\d+:\d+)\s*$ # lasted time
            /x) {
            printf OUTJOB "\n%-s %s %6s %6s %6s %-15s", $+{jobdate}, $+{week},
                $+{bt}, $+{et}, $+{lt}, $jobtag;
        } else { 
            die "some thing wrong in clock in $_\n"; 
        }
    }

    # get date info <<<2

    # dates and total days since 2012-10-01
    if (/
        ^\*\s+                        # mark of top layer of org-mode
        <20(?<date>\d{2}-\d{2}-\d{2}) # date of log
        /x) {
        $date = $+{date};
        $cnt += 1;
        $days{$date} = $cnt;
    }

    # yes or no activity <<<2

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

# write yes or no file <<<1
open OUTYEN, ">$outyen" or die "Can't open file: $!";
say OUTYEN "# yy-mm-dd|cell-news|manga|doesotrue|fitness";

# sort dates
my @dates = sort { $days{$a} <=> $days{$b} } keys %days;

my $len = length($dates[0]) + 2;
for (@dates) {
    printf OUTYEN "%-${len}s %2d %2d %2d %2d\n", $_, $CellNews{$_}//0,
        $manga{$_}//0, $doesotrue{$_}//0, $fitness{$_}//0;
}
close OUTYEN;
