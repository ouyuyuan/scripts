#! /usr/bin/perl

# Description: substitute variables in CSS, html
#
#       Usage: call from ../
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-04-09 18:00:47 CST
# Last Change: 2015-09-28 10:21:38 BJT

use 5.014;
use warnings;
use strict;

my $css_var_file = "css/variables.txt";
my $css_pre_file = "css/all.css";
my $build_dir = "build";
my $gallery_dir = "$build_dir/gallery";
my $html_var_file = "tools/variables.html";

my $css_file = "$build_dir/css/all.css";

my %css_vars;
my %html_vars;

# read css var <<<1

open IN, "<$css_var_file" or die "Can't not open $css_var_file.";
while (<IN>) {
    if (/\s*(.*?)\s*=\s*(.*?)\s*$/) {
        die "Name: \"$1\" already exists." if defined $css_vars{$1};
        $css_vars{$1} = $2;
    }
}
close(IN);

# read html var <<<1

my $key;
open IN, "<$html_var_file" or die "Can't not open $html_var_file.";
while (<IN>) {
    if (/\s*\[\$(.*?)\$\]/) {
        die "Name: \"$1\" already exists." if defined $html_vars{$1};
        $key = $1;
    } else{
        s/<!--.*-->//g;
        $html_vars{$key} .= $_ if defined $key;
    }
}
close(IN);

# subs. var in CSS <<<1

open IN, "<$css_pre_file";
open OUT, ">$css_file";
say OUT "";
say OUT "/* NOTE: */";
say OUT "/* Automatically created by Perl script. */";
say OUT "/* DONOT manually edit this. */";
say OUT "/* Edit the corresponding preprocessed file instead. */";
say OUT "";
while(<IN>) {
    if (/\[\$(.*?)\$\]/) {
        my $val = $css_vars{$1}//die "Unrecognized variable: \"$1\"";
        s/\[\$$1\$\]/$val/g;
    }
    print OUT $_;
}
close(IN);
close(OUT);

# subs. var in html files <<<1

my @pre_htmls;
my @htmls;

for (glob '*.html') {
    push(@pre_htmls, $_) if $_ ne $html_var_file;
}

for my $pre_html (@pre_htmls) {
#    my $html = (split "/", $pre_html)[-1];
    my $html = "$build_dir/$pre_html";

    if ($pre_html =~ /^gallery_(.*)/) {
      $html = "$build_dir/gallery/$1";
    }
    
    open IN, "<$pre_html";
    open OUT, ">$html";

    my $snippet = 0;
    my @snip_text;
    while(<IN>) {
        if ($snippet) {
           if (/\s*@\s*end\s+snippet\s*\]\s*$/) {
              $snippet = 0;
              &translate_snippet(@snip_text);
              @snip_text = "";
              shift @snip_text;
           } else {
              push(@snip_text,$_);
           }
           next;
        }
        if (/\s*\[\$(.*?)\$\]/) {
            my $string = $html_vars{$1}
             //die "Undefined variable of \"$1\" in $pre_html";
            
            if ($1 =~ /body-header/) {
                $string =~ s/href="$pre_html"/class="active" href="$pre_html"/;
            }
            print OUT $string;

        } elsif (/\s*\[@\s+begin\s+snippet\s*$/) {
           $snippet = 1;
        } else {
            s/<!--.*-->//g;
            print OUT $_;
        }
    }
    close(IN);
    close(OUT);
}

sub translate_snippet {
   my (@snippet) = @_;

   my $class = shift @snippet;
   $class =~ s/\s*class:\s*//;
   $class =~ s/\s*$//;

   my $mainname = shift @snippet;
   $mainname =~ s/\s*mainname:\s*//;
   $mainname =~ s/\s*$//;

   my $title = shift @snippet;
   $title =~ s/\s*title:\s*//;
   $title =~ s/\s*$//;

   my $text = shift @snippet;
   $text =~ s/\s*text:\s*//;
   $text =~ s/\s*$//;

   my @texts = $text;

   for my $line (@snippet) {
      $line =~ s/\s*//;
      $line =~ s/\s*$//;
      push(@texts,$line);
      shift @snippet;
   }

   say OUT "<table class=\"gallery\"><tr>";
   say OUT "   <td><a href=\"/images/$mainname.png\">";
   say OUT "      <img src=\"/images/$mainname.png\" border=\"0\"></a></td>";
   say OUT "   <td class=\"alt\">";
   say OUT "      <strong>$title</strong> <br>";
   say OUT "      <br>";
   for my $text (@texts) {
     say OUT "      $text<br>";
   }
   say OUT "      <br>";

   if ($class =~ /pcom accessment figure by ferret/) {
      say OUT "      <a href=\"/attach/coded/ferret/pcom/assess/$mainname.jnl\">[drawing code]</a>";
   }elsif ($class =~ /pcom figure by ferret/) {
      say OUT "      <a href=\"/external/scripts/$mainname.jnl\">[drawing code]</a>";
   }elsif ($class =~ /pcom figure by ncl/) {
      say OUT "      <a href=\"/external/scripts/$mainname.ncl\">[drawing code]</a>";
   } elsif ($class =~ /pcom schematic by asymptote/) {
      say OUT "      <a href=\"/external/scripts/$mainname.asy\">[drawing code]</a>";
   } else {
      say "Unrecognized snippet class: $class";
   }

   say OUT "    </td>";
   say OUT "  </tr></table>";
}
