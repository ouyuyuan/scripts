#!/bin/bash

for i in {1..87}
do
  filename=`printf N000060%02i.nc $i`
#  ls $filename
  if [ ! -f "$filename" ]; then
   echo "$filename doesnot found!"
  fi 
done
