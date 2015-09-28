#!/usr/bin/perl -w

# Description: read configuration files, produce Fortran namelists for licom
#
#       Usage: ./xxx.pl config-file namelists-file
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-04-03 20:50:18 CST
# Last Change: 2013-04-07 09:24:00 CST

use 5.010;
use strict;

# def var <<<1

my $config = $ARGV[0];
my $namelists = $ARGV[1];

my $restart = "Use restart field";

# write namelists <<<1

open OUT, ">$namelists";
say OUT "# Automatically created from $config

&integrate
    restart = " . get_setting($restart)    . "
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

        # restart or not <<<3

        when (/$restart/) { 
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
