#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-12-12 10:02:20 BJT
# Last Change: 2014-11-23 21:27:54 BJT

import os
import sys

yr_sta = 61
yr_end = 120
datDir = "/media/pcom/exp21_ws_30N-60N_periodic/"

os.chdir(datDir)

def runCmd(cmd):
  print(cmd)
  stat = os.system(cmd)
  if stat != 0:
    print("Error happen when run: "+cmd)
    sys.exit()

for year in range(yr_sta, yr_end + 1):
  mn_sta = (year - 1) * 12 + 1
  mn_end = year * 12
  filenames = ''
  for i in range(mn_sta, mn_end + 1):
    f = "N%08d.nc " % i
    filenames += f
  runCmd('cdo ensmean ' + filenames +  ' yearly/year_%04d.nc' % year)
