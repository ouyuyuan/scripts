#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-16 06:59:29 BJT
# Last Change: 2015-01-03 16:46:04 BJT

import os
import sys

def runCmd(cmd):
  print(cmd)
  stat = os.system(cmd)
  if stat != 0:
    print("Error happen when run: "+cmd)
    sys.exit()

class Ishii:
  def __init__(self,datDir):
    if os.path.isdir(datDir):
      self.datDir = datDir
    else:
      sys.exit()

  def run(self, scriptname, *args):
    ext = scriptname.split('.')[-1]
    if ext == 'ncl':
      calculator = 'nclrun '
    elif ext == 'jnl':
      calculator = 'pyferret -nojnl -script '
    elif ext == 'py':
      calculator = 'python '
    else:
      print('Unknown script extension: ' + ext)
      sys.exit()
    if len(args)==0:
      runCmd(calculator + scriptname + ' ' + self.datDir)
    else:
      myargs = " "
      for arg in args:
        myargs = myargs+" "+arg+" "
      runCmd(calculator + scriptname + myargs)

#=========================================
ishii = Ishii("/home/ou/archive/data/Ishii/")
#ishii.run("grid_info.ncl")
#ishii.run("basin.ncl")
#ishii.run("ohc.ncl")

yr_sta = 1945
yr_end = 2012
for year in range(yr_sta, yr_end + 1):
  nc = "sal.%04d.nc" % year
  fin = ishii.datDir+"yearly/"+nc
  fout= ishii.datDir+"pcom_grid/yearly/"+nc
  ishii.run("regrid2pcom.jnl", fin, fout)

#==============================================
#soda_pcom = ishii("/home/ou/archive/data/ishii/pcom_grid/")
#soda_pcom.run("ohc.ncl")
