#!/usr/bin/perl -w
## Copyright(C) 2012 by Ou Yuyuan

# Description: Chapter 4 Subroutines
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-09-30 09:43:51 CST
# Last Change: 2012-10-05 10:39:14 CST

use 5.010;
use strict;

#____________________________exercise 1_______________________________
print "\n","_" x 30, "exercise 1", "_" x 30, "\n";
my @nums = qw/ 1 3 5 7 9/;
my $num_total = &total(@nums);
print "The total of \@nums is $num_total.\n";

print "Enter some numbers on separated lines:\n";
chomp(my @in = <STDIN>);
print "The sum of those numbers(@in) is ", &total(@in), ".\n";

sub total {
    my $sum = 0; # return 0 instead of undef when @_ empty
    foreach (@_) {
        $sum += $_; } 
    $sum; }     # this line must be

#____________________________exercise 2_______________________________
print "\n","_" x 30, "exercise 2", "_" x 30, "\n";
print "The numbers from 1 to 1000 add up to ", &total(1..1000), ".\n";

#____________________________exercise 3_______________________________
print "\n","_" x 30, "exercise 3", "_" x 30, "\n";
sub above_average {
    my @above;
    # the second @_ will give the number of elements in parametric list
    my $average = &total(@_) / @_;
    foreach (@_) {
        if ($_ > $average) {
            push @above, $_; } }
    @above; }

@nums=1..10;
my @above = &above_average(@nums);
print "Number(s) above the average of @nums is:\n@above.\n";

@nums=(100, 1..10);
my @above = &above_average(@nums);
print "Number(s) above the average of @nums is:\n@above.\n";

#____________________________exercise 4_______________________________
print "\n","_" x 30, "exercise 4", "_" x 30, "\n";
sub greet {
    state $last_person;
    my $guest = shift;
    print "Hi! $guest! ";
    if (defined $last_person) {
        print "$last_person is also here!\n";
    } else {
        print "You are the first one here!\n"; } 
    $last_person = $guest; }

&greet("Fred");
&greet("Barney");

#____________________________exercise 5_______________________________
print "\n","_" x 30, "exercise 5", "_" x 30, "\n";

sub greet_all {
    state @guests;
    my $guest = shift;
    print "Hi! $guest! ";
    if (defined @guests) {
        print "I've seen: @guests\n";
    } else {
        print "You are the first one here!\n"; } 
    push @guests, $guest; }

&greet_all("Fred");
&greet_all("Barney");
&greet_all("Willma");
&greet_all("Ou");
