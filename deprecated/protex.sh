#!/bin/bash

# Description: use protex to create auto doc of fortran code for developers 
#
#       Usage: ./xxx.sh
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-05-17 08:32:52 BJT
# Last Change: 2014-05-17 08:41:44 BJT

src_dir="$HOME/mount/101/models/newpcom/src/pcom"
protex="$HOME/archive/codes/protex_modified/protex"
mod_scr="$HOME/archive/scripts/text_analysis/modify_protex_output.pl"
preamble="$HOME/archive/scripts/text_analysis/protex_preamble.tex"

title_txt="title.txt"
ori_out="protex"
mod_out="output"

if [[ ! -f $title_txt ]]; then
  echo "I cann't find $title_txt in the current directory. Stop"
fi

$protex -f $title_txt $src_dir/*.h $src_dir/*.f90 > $ori_out.tex
$mod_scr $preamble $ori_out.tex > $mod_out.tex
pdflatex $mod_out.tex
pdflatex $mod_out.tex
pdflatex $mod_out.tex
