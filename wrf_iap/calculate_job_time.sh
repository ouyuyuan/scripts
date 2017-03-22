#!/bin/bash

beg=`date +"%Y-%m-%d %H:%M:%S"`
beg_s=`date +%s -d "$beg"`

# example command
#yhrun -n 16 -p TH_NET ./real.exe
#read -n 1 -p "Press any key to continue..."
./oceanS < ocean_upwelling.in

end=`date +"%Y-%m-%d %H:%M:%S"`
end_s=`date +%s -d "$end"`

used=`expr $end_s - $beg_s`

echo "begin time: "
echo $beg

echo ""
echo ""
echo "end time: "
echo $end

echo "Time used (seconds): "
echo $used
#echo "Time used (hours): "
#echo "$used/3600" | bc -l
