
use 5.010;
use warnings;
use strict;
use Cwd 'abs_path';

my $rest_file = "/home/ou/archive/notes/math_display/source/maxima.rst";
my $mac_scr = abs_path($ARGV[0]);
my $filtered_mac = "filtered_by_perl.mac";
my $result_file = "maxima.out";
my $rst_dir="/home/ou/archive/notes/math_display";
my $compile_rst="mathjaxmake";

say $mac_scr;

