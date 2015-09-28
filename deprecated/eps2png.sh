#!/bin/bash

# Description: convert a /path/to/filename.eps file to png/filename.png 
#              (for NCL scripts call)
#
#       Usage: xxx.sh /path/to/filename
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-05-29 07:35:52 CST
# Last Change: 2013-05-29 07:46:10 CST

path=$(dirname $1)
mainname=$(basename $1)

cd $path
mkdir -p png/
convert -density 150 $mainname.eps png/$mainname.png
