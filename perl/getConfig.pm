#!/usr/bin/perl -w

# Description: get account specific configurations
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-01-26 19:55:52 CST
# Last Change: 2013-02-25 17:04:38 CST

package getConfig;
use 5.010;
use strict;
use base 'Exporter';
our @EXPORT = qw/ get_config /;

# def vars <<<1

# get configure infos <<<2

my $conf_file = "/home/ou/.ou.conf";
my %config;
open IN, "<$conf_file";
while(<IN>) {
    if ( /^\s*set\s*  # config mark
        (.*):         # config
        \s*(.*?)      # value
        \s*$/ix ) {
        $config{$1} = $2;
    }
}
close(IN);

sub get_config {
    my $str = shift;
    my $val = $config{$str}//die "Unknown config: \"$str\"";
}
