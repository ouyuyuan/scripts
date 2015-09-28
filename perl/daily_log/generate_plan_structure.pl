#!/usr/bin/perl

# Description: generate the structure for plotting plans 
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-03-08 21:06:33 CST
# Last Change: 2013-03-25 16:59:49 CST

use strict;
use 5.014;
use warnings;

use Date::Calc qw( Today Delta_Days );

my $outfile = "remaining_days_struct.asy";
my @plans;

# plans <<<1

my %life = ( 
    title => 'LIFE',
    rfill => 'gray96',
    pfill => 'gray0',
    bdate => '1986-06-01',
    edate => '2047-06-01',
);
push @plans, \%life;

my %phd = ( 
    title => 'PHD',
    rfill => 'DarkSeaGreen2',
    pfill => 'IndianRed1',
    bdate => '2012-10-01',
    edate => '2014-03-14',
);
push @plans, \%phd;

my %job = ( 
    title => 'LICOM',
    rfill => 'SteelBlue2',
    pfill => 'orchid4',
    bdate => '2013-03-24',
    edate => '2013-04-24',
);
push @plans, \%job;


my ($yn, $mn, $dn) = Today();
$mn = "0$mn" if $mn<10;
$dn = "0$dn" if $dn<10;

open OUT, ">$outfile" or die "Can't open file $outfile: $!";
for my $plan (@plans) {

    # calculate days <<<1

    my ($yb, $mb, $db) = split('-',$plan->{'bdate'});
    my ($ye, $me, $de) = split('-',$plan->{'edate'});

    my $pdays = Delta_Days($yb, $mb, $db, $yn, $mn, $dn);
    my $tdays = Delta_Days($yb, $mb, $db, $ye, $me, $de);
    my $rdays = $tdays - $pdays;

    $plan->{'tdays'} = $tdays;
    $plan->{'rdays'} = $rdays;

    # write out structure <<<1

    say OUT "plan plan;";
    say OUT "plan.title = \"$plan->{'title'}\";";
    say OUT "plan.bdate = \"$plan->{'bdate'}\";";
    say OUT "plan.edate = \"$plan->{'edate'}\";";

    say OUT "plan.rfill = $plan->{'rfill'};";
    say OUT "plan.pfill = $plan->{'pfill'};";
    say OUT "plan.tdays = $plan->{'tdays'};";
    say OUT "plan.rdays = $plan->{'rdays'};";

    say OUT "plans.push(plan);";
    say OUT "";
}
close(OUT);
