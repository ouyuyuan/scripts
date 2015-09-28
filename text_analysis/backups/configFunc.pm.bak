#!/usr/bin/perl -w

# Description: read configuration files
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-01-26 19:55:52 CST
# Last Change: 2013-04-03 20:42:08 CST

package configFunc;
use 5.010;
use strict;
use base 'Exporter';
our @EXPORT = qw/ get_setting /;

my $conf_file = "model.config";
my %setting;
open IN, "<$conf_file";
while(<IN>) {
    if ( /^\s*set\s*  # setting mark
        (.*):         # setting
        \s*(.*?)      # value
        \s*$/ix ) {
        $setting{$1} = $2;
    }
}
close(IN);

sub get_setting {
    my $str = shift;
    my $val = $setting{$str}//die "Unknown setting: \"$str\"";
}
