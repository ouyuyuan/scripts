#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-16 06:59:29 BJT
# Last Change: 2015-09-09 14:44:38 BJT

import os
import sys

def runCmd(cmd):
  print(cmd)
  stat = os.system(cmd)
  if stat != 0:
    print("Error happen when run: "+cmd)
    sys.exit()

class Soda:
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
#soda = Soda("/home/ou/archive/data/soda/")
#soda.run("grid_info.ncl")
#soda.run("ohc.ncl")

#yr_sta = 1871
#yr_end = 1885
#yr_end = 2008
#for year in range(yr_sta, yr_end + 1):
#  nc = "year_%04d.nc" % year
#  fin = soda.datDir+"yearly/"+nc
#  fout= soda.datDir+"pcom_grid/yearly/"+nc
#  soda.run("regrid2pcom.jnl", fin, fout, "u")

#==============================================
soda_pcom = Soda("/media/wd/soda/pcom_grid/")
soda_pcom.run("moc.ncl")
