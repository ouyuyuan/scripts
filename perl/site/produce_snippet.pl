#! /usr/bin/perl

# Description: produce snippet from txt in current dir. for subsitution
#
#       Usage: ./xxx.pl
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-09-03 15:43:34 CST
# Last Change: 2013-09-03 20:42:52 CST

use 5.014;
use warnings;
use strict;

my @txts;
my @htmls;

for (glob '*.txt') {
    push(@txts, $_);
}

for my $txt (@txts) {
    my $html = $txt;
    $html =~ s/\.txt/\.html/;
    $html = "../gallery_$html";

    open IN, "<$txt";
    my @text = <IN>;
    close(IN);

    open OUT, ">$html";

   say OUT "<!DOCTYPE html>";
   say OUT "<html>";
   say OUT "[\$html-head\$]";
   say OUT "<body>";
   say OUT "  [\$noscript\$]";
   say OUT "<div class=\"main\">";

   say OUT "  [@ begin snippet";
   say OUT @text;
   say OUT "   @ end snippet]";

   say OUT "</div>";
   say OUT "[\$body-foot-script\$]";
   say OUT "</body>";
   say OUT "</html>";

}
