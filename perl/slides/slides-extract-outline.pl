#! /usr/bin/perl

# Description: extract hierarchy info for slides of asymptote 
#
#       Usage: ./xxx.pl
#
#         Out: outlines.txt
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-11-03 20:28:42 CST
# Last Change: 2013-11-24 10:34:17 CST

use 5.014;
use warnings;
use strict;

my $infoFile = "info.txt";
my @infos;
my $fileol;
my $draws;

# extract basic info. about the slide <<<1

if (-e $infoFile) {
    &extractInfo;
} else {
    die "$infoFile doesn't exist!\n";
}

my $fileolbak = $fileol . ".bak";

my %subsecs;
my %scriptname;
my $hier;

# get hierarchy from each slide src code <<<1

for (glob "$draws") {
    push(@ARGV, $_);
}

while (<>) {
    if (/^\W+\@hierarchy:\s*(?<hier>.+?)\s*$/) { 
        $hier = $+{hier} . "<$ARGV>";

        if ($hier =~ /(?<a>.+?)\s*\|\s*(?<b>.+)/) { # 2 level
            push(@{$subsecs{$+{a}}}, $+{b});
        } else {
            push(@{$subsecs{$hier}}, undef);
        }
    }
}

if (-e $fileol) {
    rename $fileol => $fileolbak;
}

open OUTOL, ">$fileol";
for (keys %subsecs) {
    say OUTOL $_;
    for (@{$subsecs{$_}}) {
        say OUTOL "\t$_" if (defined $_);
    }
}
close(OUTOL);

&addust_outlines;

unlink $fileolbak;

#===============================================================================

# addjust to keep old order and delete old entries
#-------------------------------------------------------------------------------
sub addust_outlines {
    my @outnew;
    my @outold;

    my $section;

    open IN, "<$fileol";
    while (<IN>) {
        chomp;
        $section = $_ if /^\w+/;
        $_ = $section . $_ if /^\t/;;
        push(@outnew, $_);
    }
    close(IN);

    if (-e $fileolbak) {
        open IN, "<$fileolbak";
        while (<IN>) {
            chomp;
            $section = $_ if /^\w+/;
            $_ = $section . $_ if /^\t/;;
            push(@outold, $_);
        }
        close(IN);
    }

    my $i = 0;
    my $old;
    my $new;

    while ($i < @outold) {
        $old = $outold[$i];
        $old =~ s/<.*>//g;

        my $j = 0;
        while ($j < @outnew) {
            unless (defined $outnew[$j]) {
                $j += 1;
                next;
            }

            $new = $outnew[$j];
            $new =~ s/<.*>//g;

            if ($new eq $old) {
                $outold[$i] = $outnew[$j];
                $outnew[$j] = undef;
                $old = undef;
                last; 
            }
            $j += 1;
        }

        $outold[$i] = undef if defined $old;
        $i += 1;
    }

    push(@outold, $_) for (@outnew);

    open OUT, ">$fileol";
    for (@outold) {
        if (defined $_) {
            say OUT $_ unless /\t/;
            if (/\t/) {
                s/^.*\t/\t/;
                say OUT $_;
            }
        }
    }
    close(OUT);
}

# subroutines <<<1

# extract infos. from into.txt <<<2

sub extractInfo {
    open IN, "<$infoFile";
    while (<IN>) {
        if (/^outline\sfile:\s
            (?<ol>.+?)
            \s*$/x) {
            $fileol = $+{ol};
        }
        if (/^draws:\s
            (?<dr>.+?)
            \s*$/x) {
            $draws= $+{dr};
        }
    }
    close IN;
}
