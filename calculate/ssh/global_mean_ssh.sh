#!/bin/bash

# Description: 
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-04-11 18:06:46 BJT
# Last Change: 2014-04-11 20:36:10 BJT

nclscript=${0##*/}
#nclscript=`basename $0`
nclscript="`pwd`/${nclscript%.sh}.ncl"

sda="/media/scidata"
soda_dir_sda="$sda/soda"
pcom_r_dir_sda="$sda/pcom/res_s"
pcom_n_dir_sda="$sda/pcom/fix_fkh"
licom_dir_sda="$sda/licom/unmodified"

da="/home/ou/archive/data"
soda_dir_da="$da/soda/climate/calculated"
pcom_r_dir_da="$da/pcom/climate/res_s/calculated"
pcom_n_dir_da="$da/pcom/climate/fix_fkh/calculated"
licom_dir_da="$da/licom/climate/unmodified/calculated"

outfile="post/ssh_trend.nc"

cd $soda_dir_sda
pwd
nclrun $nclscript soda
cmd="cp -f $outfile $soda_dir_da"
echo $cmd
$cmd

cd $pcom_r_dir_sda
pwd
nclrun $nclscript pcom 
cmd="cp -f $outfile $pcom_r_dir_da"
echo $cmd
$cmd

cd $pcom_n_dir_sda
pwd
nclrun $nclscript pcom 
cmd="cp -f $outfile $pcom_n_dir_da"
echo $cmd
$cmd

cd $licom_dir_sda
pwd
nclrun $nclscript licom
cmd="cp -f $outfile $licom_dir_da"
echo $cmd
$cmd
