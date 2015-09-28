#!/bin/bash

ser_data="$HOME/mount/101/models/gpem/data/gpem.nc"
loc_data="$HOME/archive/data/gpem/gpem.nc"
#draw_script="zuv_predict.ncl"
draw_script="rh_tests.ncl"

cp -f $ser_data $loc_data
ncl $draw_script
