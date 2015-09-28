#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-16 06:59:29 BJT
# Last Change: 2014-12-08 10:56:48 BJT

import os
import sys

def runCmd(cmd):
  print(cmd)
  stat = os.system(cmd)
  if stat != 0:
    print("Error happen when run: "+cmd)
    sys.exit()

class Exp:
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

  def mon2yearly(self, yrSta, yrEnd):
    os.chdir(self.datDir)
    for year in range(yrSta, yrEnd + 1):
      mnSta = (year - 1) * 12 + 1
      mnEnd = year * 12
      filenames = ''
      for i in range(mnSta, mnEnd + 1):
        f = "monthly/N%08d.nc " % i
        filenames += f
      cmd = 'cdo ensmean ' + filenames +  ' yearly/year_%04d.nc' % year
      print(cmd)
      os.system(cmd)

  def missing2fillvalue(self, yrSta, yrEnd):
    for year in range(yrSta, yrEnd + 1):
      fin = self.datDir+"output/year_%04d.nc " % year
      fout= self.datDir+"yearly/year_%04d.nc " % year
      self.run("missing2fillvalue.ncl", fin, fout)

exp_spinup = Exp("/snfs01/ou/models/pcom_1.0/exp/exp_spinup/")
#exp_spinup.mon2yearly(681, 696)
#exp_spinup.run("ohc.ncl", exp_spinup.datDir, "561", "620", "append")
#exp_spinup.run("ohc_Pac_tro.ncl", exp_spinup.datDir, "601", "620", "append")
#exp_spinup.run("sst.ncl", exp_spinup.datDir, "501", "620", "create")

exp34= Exp("/snfs01/ou/models/pcom_1.0/exp/exp34_ws_10S10N_4y/")
#exp34.missing2fillvalue(603, 603)
#exp34.run("ohc.ncl", exp34.datDir, "601", "610", "append")
#exp34.run("ohc_Pac_tro.ncl", exp34.datDir, "551", "610", "append")
#exp34.run("sst.ncl", exp34.datDir, "501", "610", "create")

exp24= Exp("/snfs01/ou/models/pcom_1.0/exp/exp24_taux_an_40y_N/output/")
#exp24.run("ohc.ncl", exp24.datDir, "561", "620", "append")
#exp24.run("ohc_Pac_tro.ncl", exp24.datDir, "601", "620", "append")
#exp24.run("sst.ncl", exp24.datDir, "501", "620", "create")
