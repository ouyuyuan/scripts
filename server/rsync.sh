#!/bin/bash

sync_dir="finished/"

if [ -d $sync_dir ]; then
   echo "directory $sync_dir exist, cann't use rsync. Stop."
else
   mkdir $sync_dir 
   rsync -avz ou@172.16.0.101:~/models/pcom/work/moc_re_s/$sync_dir $sync_dir 
fi
