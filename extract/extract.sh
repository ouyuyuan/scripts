#!/bin/bash

# Description: automatically extract according file extension
#
#       Usage: xxx.sh filename [.extension]
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-05-21 09:41:44 CST
# Last Change: 2013-05-21 10:07:10 CST

filename=$1

ext="${filename#*.}"

if [ -n "$2" ]; then
    ext=$2
fi

#echo $ext

if [ "$ext" == ".tar" ]; then
    tar -xvf $filename
elif [ "$ext" == ".tar.gz" ]; then
    tar -zxvf $filename
elif [ "$ext" == ".gz" ]; then
   gunzip $filename
else
    echo "Unrecognized extension: $ext"
fi
