#! /usr/bin/perl -w

# Description: substitute identifier of the input files
#
#       Usage: ./xxx.pl grep/sub/bak *.files
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2013-01-10 10:56:04 CST
# Last Change: 2013-06-16 16:39:49 CST

use 5.010;
use strict;
use File::Copy;
use Term::ANSIColor qw(:constants);
$Term::ANSIColor::AUTORESET = 1;

$^I = ".bak";
my $bak_dir = "backups/";
my $id_list = "to_be_sub_ids.txt";
my %subs;

# get subst. hash

open IN, "<$id_list" || die "can open";
while(<IN>) {
    if ( /^
        \s*(.*?)\s*         # old identifiers to be substituted
        :     
        \s*(.*?)\s*         # new identifiers to substitute
        $/x ) {
        $subs{$1} = $2;
    }
}
close(IN);

my $type = shift @ARGV;
my @files = @ARGV;
if ($type eq 'grep') {
    for my $file (@files) {
        open IN, "<$file";
        my $cnt = 0;
        while(<IN>) {
            $cnt += 1;
            my $line = $_;
            for my $id (keys %subs, values %subs) {
                if ($line =~ /(.*)(\b$id\b)(.*)/) {
                    print BOLD $file, "\t Line ";
                    print BOLD GREEN "$cnt: ";
                    print $1;
                    print BOLD RED $2;
                    print "$3\n";
                } 
            }
        }
        close(IN);
    }

}elsif ($type eq 'sub') {
    system("mkdir -p $bak_dir");
#    @ARGV = @f90s;

    while (<>) {
        for my $old (keys %subs) {
            my $new = $subs{$old};
            s/\b$old\b/$new/g;
        }
        print;
    }

    move $_, $bak_dir for glob '*'.$^I;

} elsif ($type eq 'bak') {
    for my $file (@files) {
        copy "$bak_dir/$file$^I", "./$file";
    }
} else {
    die "Wrong argument";
}
