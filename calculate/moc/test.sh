
models=( "soda" "licom" "pcom" "pcom_r" )
#basins=( "Global" "Atlantic" "Indian" "Pacific" )
#basins=( "Global" )
basins=( "Atlantic" )
script="test.ncl"
for model in "${models[@]}"
do
   for basin in "${basins[@]}"
   do
   #   run_ncl $script $model $basin & # run in parallel
      run_ncl $script $model  $basin # run in sequential
   done

done
