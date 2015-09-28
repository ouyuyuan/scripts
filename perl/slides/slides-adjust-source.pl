#! /usr/bin/perl

# Description: adjust drawing scripts for compile
#              this should run after references has been created
#
#       Usage: ./xxx.pl
#
#         Out: modified slide-\d\d.asy[py..] in files/ directory
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-11-04 19:28:16 CST
# Last Change: 2013-01-18 16:10:47 CST

use 5.014;
use warnings;
use strict;

my $infoFile = "info.txt";
my $papDir  = "/home/ou/archive/paps";
my ($filDir, $outTxt, $epsDir, $bblFile);

if (-e $infoFile) {
    &extractInfo;
} else {
    die "$infoFile doesn't exist!\n";
}

my $outAsy  = "$filDir/outline.asy";
my $booTxt  = "$filDir/bookmarks.txt";
my $citFile = "$filDir/cites.tex";
my %newpage;

my %citeCmd;
my %citeAuthor;
my %citeYear;

# read infos from outlines.txt
#-------------------------------------------------------------------------------

my $page=2;  # after cover and outlines page
my $level;
my $lastlevel;
my $varname;
my $title;
my @srcFiles;

open IN,     "<$outTxt";
open OUTASY, ">$outAsy";
open OUTBOO, ">$booTxt";
while (<IN>) {
    chomp;
    $level = 1;
    $level = 2 if /^\t\w+/;

    $page += 1;
    if ( $level ==2 && $lastlevel ==1 ) { $page -= 1; }

    if (/<(?<fname>.*)>/) {
        $newpage{$+{fname}} = $page;
        push(@srcFiles, $+{fname});
    }

    $varname = 'entry'.$page;
    s/<.*>//g; # remove id mark

    say OUTBOO "$_/$page,FitPage";

    s/\t//;
    $title = $_;

    say OUTASY "outline $varname;";
    say OUTASY "$varname.title = \"$title\";";
    say OUTASY "$varname.level = $level;";
    say OUTASY "$varname.pagestart = $page;";
    say OUTASY "entrys.push($varname);";
    say OUTASY "";

    $lastlevel = $level;
}

close IN;
close OUTASY;

# link source code in bookmarks
say OUTBOO "Source Code/-1";
my $i = 2; # after cover and outlines
for my $src (@srcFiles) {
    $i += 1;
    say OUTBOO "\tSlide $i/-1,Launch,$src";

    # bookmark embeded image source
    open INSRC, "<$src";
    while (<INSRC>) {
        if (/
            graphic\("
            (?<eps>.+\.eps)
            /x) {
            my $emb = $+{eps};
            $emb =~ s/\.eps$/\.asy/;
            say OUTBOO "\t\t$emb/-1,Launch,$emb" if -e $emb;
        }
    }
    close INSRC;
}

# references
if (-e $citFile) {
    my %refPdf;
    system("mkdir paps/") unless -e "paps/";
    open IN, "<$citFile";
    while (<IN>) {
        if (/^\\cite.+{(?<id>.+?)}/) {
            my $pdfid = $+{id};
            my $pdffile = "$papDir/$pdfid.pdf";
            if (-e $pdffile) {
                $refPdf{$pdfid} = $pdffile;
                system("ln -sf $pdffile paps/$pdfid.pdf");
            }
        }
    }
    close IN;
    say OUTBOO "References/-1";
    for (sort(keys %refPdf)) {
        say OUTBOO "\t$_/-1,Launch,paps/$_.pdf";
    }
}

close OUTBOO;


# change filename of output, and substitute citation marks
#-------------------------------------------------------------------------------

my $newfile;
my $pdfname;
my $oldfile;

&extractBbl if -e $bblFile;

for (keys %newpage) {
    $oldfile = $_;

    my $page = $newpage{$_};
    $page = "0" . $page if $page < 10;
    $pdfname = "slide-" . $page . ".pdf";

    $newfile = $oldfile;
    $newfile =~ s/^.+\./slide-$page\./;
    open IN, "<$_";
    open OUT, ">$filDir/$newfile";

    my $shiname = "shipout(\"$pdfname\");\n";
    my $pagname = "pagenumber($page);\n";
    while (<IN>) {
        # change shipout command or other analogas command
        if (/^\s*SLIDENAME\s*=/ and ($ARGV =~ /.+\.py/)) {
            $_ = "SLIDENAME=\"$pdfname\"\n";
        }

        # substitute citation mark
        if (/(?<cmd>
            \\cite.*?
            {(?<id>.+?)})    # bibtex key
            /x) {
            my $cmd = $+{cmd};
            my $a = $citeAuthor{$+{id}};
            my $b = $citeYear{$+{id}};
            if ($cmd =~ /\[(?<opt>.+)\]/) {
                $b = $b . ", $+{opt}";
            }

#            my $show = "{\\color{red} \\small \\em $a($b)}";
#            $show    = "{\\color{red} \\small \\em ($a, $b)}" if $cmd =~ /citep/;
            my $show = "{\\color{red} \\em $a($b)}";
            $show    = "{\\color{red} \\em ($a, $b)}" if $cmd =~ /citep/;

            s/\\cite.+?}/$show/;
        }

        # link include graph
        if (/
            graphic\("
            (?<eps>.+\.eps)
            /x) {
            my $eps = $+{eps};
            system("ln -sf $epsDir/$eps $filDir/$eps");
        }


        print OUT;
    }
    if ($oldfile =~ /.+\.asy/) {
        say OUT "$pagname";
        say OUT "$shiname";
    }
    
    close(IN);
    close(OUT);
}


# extract info from .bbl file
#-------------------------------------------------------------------------------
sub extractBbl {
    open IN, "<$bblFile";
    
    while(<IN>) {
        if (/
            ^\\bibitem
            \[(?<author>.+?)
            \((?<year>.+?)\)\]
            {(?<id>.+?)}
            /x) {
            $citeAuthor{$+{id}} = $+{author};
            $citeYear{$+{id}} = $+{year};
        }
    }
    close IN;
}

sub extractInfo {
    open IN, "<$infoFile";
    while (<IN>) {
        if (/^temporal\sdirectory:\s
            (.+?)
            \s*$/x) {
            $filDir = $1;
        }
        if (/^outline\sfile:\s
            (.+?)
            \s*$/x) {
            $outTxt = $1;
        }
        if (/^image\sdirectory:\s
            (.+?)
            \s*$/x) {
            $epsDir = $1;
        }
        if (/^reference-slide:\s
            (.+?)\.pdf
            \s*$/x) {
            $bblFile = "$1.bbl";
        }
    }
    $bblFile = "$filDir/$bblFile";
    close IN;
}
