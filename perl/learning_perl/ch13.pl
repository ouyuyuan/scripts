#!/usr/bin/perl -w

# Description: Chapter 13 Directory Operations
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-10-08 10:10:05 CST
# Last Change: 2012-10-08 10:42:54 CST

use 5.010;

use strict;

# input a directory
say "which directory to list? (Default is your HOME directory.)";
chomp(my $dir = <STDIN>);

# whether input is empty
if ($dir =~ /^\s*$/) {
    chdir or die "Can't chdir to your HOME directory: $!";
} else {
    chdir $dir or die "Can't chdir to $dir: $!";
}

# list files in alphabetical order
## use glob
#my @files = <* .*>; # automatically sort
#say for (@files);

## use directory handle
opendir DOT, "." or die "Can't opendir dot: $!";
for (sort readdir DOT) {  # won't automatically sort
    next if (/^\./);      # skip hidden files
    say;
}
