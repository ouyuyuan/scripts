#!/bin/bash

# Description: 
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-10-13 16:41:52 BJT
# Last Change: 2014-10-13 16:48:31 BJT

ori_data_dir="/media/pcom/ws_control"
plot_data_dir="/home/ou/archive/data/pcom/plot/ws_control"
post_data_dir="/home/ou/archive/data/pcom/ws_control"
draw_dir="/home/ou/archive/drawing/pcom/ws_control"

# extract data from pcom input for plotting
#==========================================
#cd calc/; nclrun forcing.ncl; cd ../

# plot a plot like Large2008 Fig.6 for comparision
#=================================================
basename="Large2008"
export NCL_ENV_datafile_name="$data_dir/$basename.nc"
export NCL_ENV_image_name="$draw_dir/$basename"
#cd draw/; ncl $basename.ncl; cd ../
#cmd="eps2png_trim $NCL_ENV_image_name"; echo $cmd; $cmd

# plot year mean wind stress forcing in PCOM
#===========================================
basename="forcing_control"
export NCL_ENV_datafile_name="$data_dir/vec_mag_y.nc"
export NCL_ENV_image_name="$draw_dir/$basename"
#cd draw/; ncl $basename.ncl; cd ../
#cmd="eps2png_trim $NCL_ENV_image_name"; echo $cmd; $cmd

# calculate thermalcline
#========================
basename="thc"
infile="/home/ou/archive/data/pcom/moc_re_s/post/climate_mean_0491-0500.nc"
outfile="$data_dir/${basename}_ferret.nc"
#cd calc; pyferret -nojnl -script $basename.jnl $infile $outfile; cd ../

infile=$outfile
outdir=$data_dir
cd calc; nclrun $basename.ncl $infile $outdir; cd ../
