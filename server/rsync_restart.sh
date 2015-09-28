#!/bin/bash

sync_dir="restart/"

mkdir $sync_dir 
rsync -avz ou@172.16.0.101:~/models/pcom/work/moc_re_s/$sync_dir $sync_dir 
