#!/usr/bin/perl -w

# Description: Chapter 17 Some Advanced Perl Techniques
#
#       Usage: ./xxx.pl in_ch17.txt
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-10-14 19:18:44 CST
# Last Change: 2012-10-14 19:30:00 CST

use strict;
use 5.010;

my $filename = "in_ch17.txt";
open FILE, $filename or die "Can't open '$filename': $!";

chomp( my @text = <FILE> );

while(1) {
    print "Please enter a pattern: ";
    chomp( my $pat = <STDIN> );

    last if $pat =~ /^\s*$/;

    my @matches = eval { grep /$pat/, @text; };
    if ($@) {
        say "Error: $@";
    } else {
        my $cnt = @matches;
        print "There are $cnt matches: \n", map "$_\n", @matches;
    }
}
