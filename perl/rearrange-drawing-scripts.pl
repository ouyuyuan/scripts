#! /usr/bin/perl

# Description: post process drawing scripts for slides
#
#       Usage: ./xxx.pl
#
#         Out: outlines.asy, modified slide-*.asy slide-*.pdf
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-11-04 19:28:16 CST
# Last Change: 2012-11-17 09:35:49 CST

use 5.014;
use warnings;
use strict;

my $papsDir  = "/home/ou/archive/paps";
my $citeFile = "cites.tex";

my $varname;
my $level;
my $lastlevel;
my $title;
my $page;

my %newpage;

# create infos for outline-slide
#-------------------------------------------------------------------------------
open OUTASY, ">outlines.asy";
open IN, "<outlines.txt";
while (<IN>) {
    $level = 1;
    $level = 2 if /^\t\w+/;

    $page += 1;
    if ( $level ==2 && $lastlevel ==1 ) { $page -= 1; }

    if (/<(?<fname>.*)>/) {
        $newpage{$+{fname}} = $page;
        push(@ARGV, $+{fname});
    }

    $varname = 'entry'.$page;

    chomp;
    s/<.*>//g; # remove id mark
    s/\t//;
    $title = $_;

    unless ($title =~ /^cover|^outline/i) {
        say OUTASY "outline $varname;";
        say OUTASY "$varname.title = \"$title\";";
        say OUTASY "$varname.level = $level;";
        say OUTASY "$varname.pagestart = $page;";
        say OUTASY "entrys.push($varname);";
        say OUTASY "";
    }

    $lastlevel = $level;
}
close(OUTASY);
close(IN);


# change filename of output pdf in each drawing script
#-------------------------------------------------------------------------------

my $newfile;
my $changed;
my $pdfname;
my $oldfile;
for (keys %newpage) {
    $changed = undef;
    $oldfile = $_;

    my $page = $newpage{$_};
    $page = "0" . $page if $page < 10;
    $pdfname = "slide-" . $page . ".pdf";

    $newfile = $_ . ".new";
    open IN, "<$_";
    open OUT, ">$newfile";

    if (/.+\.asy/) {
        my $outname = "shipout(\"$pdfname\"); // THIS LINE CHANGED BY PERL!\n";
        while (<IN>) {
            if (/^\s*shipout\s*\(/) {
                $_ = $outname;
                $changed = 1;
            }
            print OUT;
        }
        
        say OUT "$outname" unless (defined $changed);

    } elsif (/.+\.py/) {
        while (<IN>) {
            if (/^\s*SLIDENAME\s*=/) {
                $_ = "SLIDENAME=\"$pdfname\" # THIS LINE CHANGED BY PERL!\n";
            }
            print OUT;
        }
    } else {
        die "Unrecogized drawing script! Exit!\n";
    }
    
    close(IN);
    close(OUT);

    system 'mv', $oldfile, "bak/" . $oldfile . ".bak";
    system 'mv', $newfile, $oldfile;
}


# create bookmarks for jpdfbookmarks
#-------------------------------------------------------------------------------
&create_bmark;

sub create_bmark {
    my $bmpage;
    my $bmtitle;
    my @src;

    open OUTBM, ">bookmarks.txt";
    open IN, "<outlines.txt";
    while (<IN>) {
        if (/<(?<file>.+)>/) {
            push(@src, $+{file});
            s/<.*>//g; # remove id mark
        }

        $bmtitle = $_;
        chomp($bmtitle);
        $bmpage += 1;

        $level = 1;
        $level = 2 if /^\t\w+/;
        if ( $level ==2 && $lastlevel ==1 ) { $bmpage -= 1; }

        unless ($bmtitle =~ /^cover|^outline/i) {
            say OUTBM "$bmtitle/$bmpage,FitPage";
        }

        $lastlevel = $level;
    }

    close(IN);

    # source code
    say OUTBM "Source Codes/-1";
    my $i=1;
    for (@src) {
        say OUTBM "\tSlide $i/-1,Launch,$_" if $i > 2;
        $i += 1;
    }

    # references
    if (-e $citeFile) {
        my %refPdf;
        system("mkdir paps/") unless -e "paps/";
        open IN, "<$citeFile";
        while (<IN>) {
            if (/^\\cite.+{(?<id>.+?)}/) {
                my $pdfid = $+{id};
                my $pdffile = "$papsDir/$pdfid.pdf";
                if (-e $pdffile) {
                    $refPdf{$pdfid} = $pdffile;
                    system("ln -sf $pdffile paps/$pdfid.pdf");
                }
            }
        }
        close IN;
        say OUTBM "References/-1";
        for (sort(keys %refPdf)) {
            say OUTBM "\t$_/-1,Launch,paps/$_.pdf";
        }
    }

    close(OUTBM);

}

# run drawing scripts
#-------------------------------------------------------------------------------
&run_scripts;

sub run_scripts {
    my @asys;
    my @pys;

    push(@asys, $_) for (glob "slide-*.asy");
    push(@pys, $_) for (glob "slide-*.py");

    # exec seems not run all the scripts, but just last of them
    system("/usr/bin/asy -f pdf $_") for (@asys);
#    system("python $_") for (@pys);
}
