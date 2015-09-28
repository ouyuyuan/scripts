#!/usr/bin/perl

# Description: plot daily agenda
#
#       Usage: ./xxx.pl
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-12-01 13:32:33 CST
# Last Change: 2013-10-14 08:18:22 CST

use strict;
use 5.014;
use warnings;

use Date::Calc qw( Today Delta_Days);

my $asyDir  = "/home/ou/archive/coded/asymptote";
my $drawDir = "/home/ou/archive/drawing";
my $agenda  = "agenda";

chdir $asyDir;

system("/usr/bin/asy -globalwrite -nosafe $agenda.asy"); 
system("evince $drawDir/$agenda.pdf &");
