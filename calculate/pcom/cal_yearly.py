#!/usr/bin/env python

# Description: cal. climate mean of PCOM monthly output data
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-12-12 10:02:20 BJT
# Last Change: 2014-11-02 17:20:52 BJT

import os
import sys

yr_sta = 501
yr_end = 550

for year in range(yr_sta, yr_end + 1):
  mn_sta = (year - 1) * 12 + 1
  mn_end = year * 12
  filenames = ''
  for i in range(mn_sta, mn_end + 1):
    f = "monthly/N%08d.nc " % i
    filenames += f
  cmd = 'cdo ensmean ' + filenames +  ' yearly/year_%04d.nc' % year
  print(cmd)
  os.system(cmd)
