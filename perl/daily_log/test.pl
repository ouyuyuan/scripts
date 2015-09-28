use 5.010;
use strict;
use Date::Calc qw( Today Delta_Days );

my ($year, $month, $day) = Today();

say $year, $month, $day;
