#!/bin/bash

# Description: create graph invoking dot
#
#       Usage: ./xxx.sh xxx.dot [format]
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-10-13 08:56:35 CST
# Last Change: 2013-01-10 17:50:41 CST

drawDir=$HOME/archive/drawing/pcom/phd_open
#format="eps"
format="png"

src=$1
mainname=${src/.dot/}

img="$mainname.$format"
#cmd="dot -T$format -Efontname=\"宋体\" $src -o $img"
cmd="dot -T$format -Efontname=\"文泉驿等宽微米黑\" $src -o $img"

echo $cmd
$cmd

cmd="mv -f $img $drawDir"
echo $cmd
$cmd

# when have Chinese characters, can not generate eps correctly
#cd $drawDir
#pwd
#echo "convert eps to png..."
#convert -density 300 $mainname.eps $mainname.png
#convert $mainname.png -trim $mainname.png
echo "done."
