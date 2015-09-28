#!/usr/bin/env python

# Description: change output name for continue restart running 
#              the period is 60 years, ie, 720 month
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-21 22:05:56 BJT
# Last Change: 2014-11-21 22:10:36 BJT

import os
import sys

ncycle = 1 # 60 years one cycle
yb = 55
ye = 64

filenames = ''
for i in range(yb, ye + 1):
  f = "yearly/year_%04d.nc " % i
  filenames += f
cmd = 'cdo ensmean ' + filenames +  ' climate_y%04d-y%04d.nc' % (yb,ye)
print(cmd)
os.system(cmd)
