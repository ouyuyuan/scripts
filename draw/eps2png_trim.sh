#!/bin/bash

# Description: convert a /path/to/filename.eps file to filename.png, and trim
#                 white space 
#              (intend for NCL scripts call)
#
#       Usage: xxx.sh /path/to/filename
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-05-29 07:35:52 CST
# Last Change: 2013-12-24 22:06:50 BJT

path=$(dirname $1)
mainname=$(basename $1)

cd $path
mkdir -p eps/
if [ ! -e "$mainname.eps" ]; then
  echo "eps2png_trim: $mainname.eps doesnot exist."
  exit
fi
convert -density 300 $mainname.eps $mainname.png
convert $mainname.png -trim $mainname.png
mv $mainname.eps eps/
