#!/usr/bin/env python

# Description: cal. climate mean of PCOM monthly output data
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-12-12 10:02:20 BJT
# Last Change: 2014-11-28 17:19:26 BJT

import os
import sys

yb = 61
ye = 120

datDir = "/home/ou/archive/data/pcom/exp21_ws_30N-60N_periodic/"
os.chdir(datDir)

filenames = ''
for i in range(yb, ye + 1):
  f = "yearly/year_%04d.nc " % i
  filenames += f
cmd = 'cdo ensmean ' + filenames +  ' post/climatory_y%04d-y%04d.nc' % (yb,ye)
print(cmd)
os.system(cmd)
