#!/bin/bash

# Description: 
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-10-06 16:16:41 BJT
# Last Change: 2014-10-09 19:31:32 BJT

#*************************************
# draw the schematic of Drake passage
#*************************************

#cd draw/; nclrun drake_slice.ncl; cd ../

#*************************************************
# extract a slice of climatory u at Drake passage
#*************************************************

# cd calculate; nclrun u_drake_slice.ncl; cd ../

#**********************************************
# draw a slice of climatory u at Drake passage
#**********************************************

basename="u_drake_slice"
data_dir="/home/ou/archive/data/pcom/plot/core"
draw_dir="/home/ou/archive/drawing/pcom/core"

export NCL_ENV_datafile_name="$data_dir/$basename.nc"
export NCL_ENV_image_name="$draw_dir/$basename"

#cd draw/; nclrun $basename.ncl; cd ../
#cmd="eps2png_trim $NCL_ENV_image_name"; echo $cmd; $cmd

#***************************
# calculate Drake transport
#***************************

basename="drake_transport"
data_dir="/home/ou/archive/data/pcom/plot/core"
export NCL_ENV_datafile_name="$data_dir/$basename.nc"
export NCL_ENV_image_name="$draw_dir/$basename"

#cd calculate/; nclrun $basename.ncl; cd ../
cd draw/; nclrun $basename.ncl; cd ../
cmd="eps2png_trim $NCL_ENV_image_name"; echo $cmd; $cmd
cmd="eps2png_trim ${NCL_ENV_image_name}_core_axis"; echo $cmd; $cmd
