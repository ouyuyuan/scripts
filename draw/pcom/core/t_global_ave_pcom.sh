#!/bin/bash

# Description: 
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-10-06 16:16:41 BJT
# Last Change: 2014-10-07 08:35:35 BJT

eps2png="Y"
data_dir="/home/ou/archive/data/pcom/plot/core"
draw_dir="/home/ou/archive/drawing/pcom/core"
res_template="/home/ou/archive/scripts/draw/nclres/xy_01.res"

shname=`basename $0`
basename="${shname%.*}"
export NCL_ENV_datafile_name="$data_dir/$basename.nc"
export NCL_ENV_image_name="$draw_dir/$basename"

if [ "$eps2png" == "Y" ]; then
  cmd="eps2png_trim $NCL_ENV_image_name"; echo $cmd; $cmd
  cmd="eps2png_trim ${NCL_ENV_image_name}_core_axis"; echo $cmd; $cmd 
  exit 0
fi

ln -sf $res_template $NCL_ENV_image_name.res
ln -sf $res_template ${NCL_ENV_image_name}_core_axis.res

cd draw/
ncl $basename.ncl
