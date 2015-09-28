#!/usr/bin/perl -w

# Description: link a file, analagous to 'ln' in shell
#
#       Usage: ./xxx.pl [-s] source destination
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-10-08 14:21:31 CST
# Last Change: 2013-01-17 19:57:51 CST

use 5.010;

use strict;

use File::Spec;

use File::Basename qw/basename/;

my $symlink = ($ARGV[0] eq '-s');

shift @ARGV if $symlink;

my ($src, $dest) = ($ARGV[0], $ARGV[1]);

if (-d $dest) {
    my $basename = basename $src;
    $dest = File::Spec->catfile($dest, $basename);
}

if ($symlink) {
    symlink $src, $dest
        or die "Can't make soft link '$dest' for '$src': $!";
} else {
    link $src, $dest 
        or die "Can't make hard link '$dest' for '$src': $!";
}
