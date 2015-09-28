#!/bin/bash

# Description: run all the tests for plotting
#
#       Usage: ./xxx.sh
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-04-16 15:32:59 CST
# Last Change: 2013-04-16 15:34:38 CST

for file in *.ncl
    do ncl ${file}
done
