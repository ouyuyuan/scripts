#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-16 06:59:29 BJT
# Last Change: 2015-04-21 20:53:46 BJT

import os
import sys

def runCmd(cmd):
  print(cmd)
  stat = os.system(cmd)
  if stat != 0:
    print("Error happen when run: "+cmd)
    sys.exit()

datDir = "/snfs01/lyh/ou/data/soda/"
yb = 1871
ye = 2008

for year in range(yb, ye + 1):
  nc   = "year_%04d.nc" % year
  print('processing ' + nc + ' ~ ~ ~ ~ ~ ~')
  fin  = datDir+"yearly/"+nc
  fout = datDir+"pcom_grid/yearly/"+nc
  self.run("regrid2pcom.jnl", fin, fout)
  cmd  = 'ferret -nojnl -script regrid2pcom.jnl ' + fin + ' ' + fout
