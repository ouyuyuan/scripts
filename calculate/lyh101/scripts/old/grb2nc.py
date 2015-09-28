#!/usr/bin/env python

# Description: cal. climate mean of PCOM monthly output data
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-12-12 10:02:20 BJT
# Last Change: 2014-12-10 15:51:43 BJT

import os
import sys

yr_sta = 1945
#yr_end = 1945
yr_end = 2012

for year in range(yr_sta, yr_end + 1):
  grb = "grb/temp.%4d.grb" % year
  nc = "nc/temp.%4d.nc" % year
  yearly = "yearly/temp.%4d.nc" % year
  cmd = 'cdo -f nc copy '+grb+' '+nc
  print(cmd); os.system(cmd)
  cmd = 'cdo yearmean '+nc+' '+yearly
  print(cmd); os.system(cmd)

  grb = "grb/sal.%4d.grb" % year
  nc = "nc/sal.%4d.nc" % year
  yearly = "yearly/sal.%4d.nc" % year
  cmd = 'cdo -f nc copy '+grb+' '+nc
  print(cmd); os.system(cmd)
  cmd = 'cdo yearmean '+nc+' '+yearly
  print(cmd); os.system(cmd)
