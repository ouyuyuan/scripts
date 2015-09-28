#!/bin/bash

# Description: diagnositc the output of the testing running, by making some plot
#              compaired to the original data
#
#       Usage: ./xxx.sh
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-08-18 09:59:08 BJT
# Last Change: 2014-08-18 18:22:10 BJT

obuntu_dir="/home/ou/archive/data/roms/latte/101"
bcm_dir="ou@172.16.0.101:models/roms_734/Apps/latte/out"
draw_dir="/home/ou/archive/drawing/roms/zxzq/"
fname="lattec_his_nof.nc"

echo "cp data from 101 server..."
scp $bcm_dir/$fname $obuntu_dir/

nclrun diff_s20m.ncl $obuntu_dir/$fname
nclrun diff_t20m.ncl $obuntu_dir/$fname
nclrun diff_u20m.ncl $obuntu_dir/$fname

nautilus $draw_dir
