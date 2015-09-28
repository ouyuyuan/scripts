#!/usr/bin/env python

# Description: cal. climate mean of PCOM monthly output data
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-12-12 10:02:20 BJT
# Last Change: 2014-06-11 06:42:03 BJT

import os
import sys

dc_sta = 1
dc_end = 50

for decade in range(dc_sta, dc_end + 1):
  yr_sta = (decade - 1) * 10 + 1
  yr_end = decade * 10
  filenames = ''
  for i in range(yr_sta, yr_end + 1):
    f = "year_%04d.nc " % i
    filenames += f
  cmd = 'cdo ensmean ' + filenames +  ' decade_%02d.nc' % decade
  print(cmd)
  os.system(cmd)
