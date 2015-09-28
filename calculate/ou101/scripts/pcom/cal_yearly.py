#!/usr/bin/env python

# Description: cal. climate mean of PCOM monthly output data
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-12-12 10:02:20 BJT
# Last Change: 2014-12-12 19:22:51 BJT

import os
import sys

#datDir = "/snfs01/ou/models/pcom_1.0/exp/exp24_taux_an_40y_N/output"
datDir = "/snfs01/ou/models/pcom_1.0/exp/exp_spinup"
#datDir = "/snfs01/ou/models/pcom_1.0/exp/exp17_ws_control_cycle_re"
yr_sta = 1
yr_end = 15

os.chdir(datDir)
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
