#!/bin/bash

# Description: produce reference page for slides
#
#       Usage: ./xxx.sh slide-references
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-12-09 09:09:52 BJT
# Last Change: 2013-12-09 09:25:44 BJT

template="/home/ou/archive/scripts/slide_making/reference_template.tex"
bibfile="/home/ou/archive/paps/bib/paps.bib"
refs="slide_reference"
refs_page=$1

cp $template ./$refs.tex
ln -sf $bibfile ./

pdflatex $refs.tex > /tmp/temp.txt
bibtex $refs.aux > /tmp/temp.txt
pdflatex $refs.tex > /tmp/temp.txt

# split pdf to get reference page
pdftk A=$refs.pdf cat A2-end output $refs_page.pdf

mv $refs.bbl $refs_page.bbl
rm -f paps.bib cites.aux $refs.tex $refs.pdf $refs.aux $refs.blg $refs.log $refs.out
