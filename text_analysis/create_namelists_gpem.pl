#!/usr/bin/perl -w

# Description: read configuration files, produce Fortran namelists
#
#       Usage: ./xxx.pl config-file namelists-file
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-04-03 20:50:18 CST
# Last Change: 2013-04-07 07:56:14 CST

use 5.010;
use strict;

# def var <<<1

my $config = $ARGV[0];
my $namelists = $ARGV[1];

my $inte_time = "Integrate time step";
my $out_zuv   = "Output z, u, v every";
my $out_sta   = "Output statistic variables every";
my $tot_time  = "Total integrate time";
my $filter    = "Use filter";

# write namelists <<<1

open OUT, ">$namelists";
say OUT "# Automatically created from $config

&integrate
    dt         = " . get_setting($inte_time) . "
    nt_out_zuv = " . get_setting($out_zuv)   . "
    nt_out_sta = " . get_setting($out_sta)   . "
    nt_end     = " . get_setting($tot_time)  . "
    use_filter = " . get_setting($filter)    . "
/";

close(OUT);

# fetch setting sub <<<1

sub get_setting {

    my $str = shift;
    state %settings;
    state $first = 1;

    if ($first) {
        scan_config(\%settings);
        $first = 0;
    }
    
    my $val = $settings{$str}//die "Unexist setting: \"$str\"";

    # for each setting <<<2

    given ($str) {

        # integrate time <<<3

        when (/$inte_time/) { 
            if ( $val =~ /(\d+)\s*seconds?$/i ) {
                $val = $1;
            } else {
                die "Unrecognized value in setting: \"$str\"";
            }
        }

        # output zuv <<<3

        when (/($out_zuv)|($out_sta)|($tot_time)/) { 
            if ( $val =~ /(\d*\.?\d+)\s*
                ((seconds?)|(minutes?)|(hours?)|(days?))
                $/ix ) {
                $val = $1;

                given ($2) {
                    my $dt = get_setting($inte_time);

                    when (/second/i) {
                        $val = int($val/$dt+0.5);
                    }
                    when (/minute/i) {
                        $val = int(60*$val/$dt+0.5);
                    }
                    when (/hour/i) {
                        $val = int(60*60*$val/$dt+0.5);
                    }
                    when (/day/i) {
                        $val = int(24*60*60*$val/$dt+0.5);
                    }
                    default { die "Wrong in units transversion."; }
                }

            } else {
                die "Unrecognized value in setting: \"$str\"";
            }
        }

        # filter or not <<<3

        when (/$filter/) { 
            if      ( $val =~ /yes/i ) {
                $val = ".true.";
            } elsif ( $val =~ /no/i ) {
                $val = ".false.";
            } else {
                die "Unrecognized value in setting: \"$str\"";
            }
        }

        default { die "Uncover setting in script branch." ; }
    }

    $val;
}

# scan config file <<<1

sub scan_config {
    
    my $ref = shift;

    open IN, "<$config" or die "Cann't nor find file: \"$config\"";

    while(<IN>) {
        next if /^\s*#/;
        next if /^\s*$/;
        if ( /^
            \s*(.*?)\s*:    # setting
            \s*(.*?)\s*     # value
            $/ix ) {
            $ref->{$1} = $2;
        }
    }

    close(IN);

}
