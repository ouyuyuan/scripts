
# Description: run $script for all possible models
#
#       Usage: ./xxx.sh
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-03-30 21:39:00 BJT
# Last Change: 2014-04-09 15:42:59 BJT

models=( "soda" "licom" "pcom_n" "pcom_r" )
basins=( "Global" "Atlantic" "Indian" "Pacific" )
script="moc.ncl"
for model in "${models[@]}"
do
   for basin in "${basins[@]}"
   do
   #   nclrun $script $model $basin & # run in parallel
      nclrun $script $model  $basin # run in sequential
   done

done
