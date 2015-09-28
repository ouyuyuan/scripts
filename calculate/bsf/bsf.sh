#!/bin/bash

# Description: run bsf.ncl for all possible models
#
#       Usage: ./xxx.sh
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-03-30 21:39:00 BJT
# Last Change: 2014-04-14 15:19:38 BJT

models=( "soda" "licom" "pcom" "pcom_r" )
script="bsf.ncl"
for model in "${models[@]}"
do
#   nclrun $script $model & # run in parallel
   nclrun $script $model   # run in sequential
done
