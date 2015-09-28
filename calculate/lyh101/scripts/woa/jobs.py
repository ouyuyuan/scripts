#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-16 06:59:29 BJT
# Last Change: 2015-04-18 14:04:45 BJT

import os
import sys

def runCmd(cmd):
  print(cmd)
  stat = os.system(cmd)
  if stat != 0:
    print("Error happen when run: "+cmd)
    sys.exit()

class Woa:
  def __init__(self,datDir):
    if os.path.isdir(datDir):
      self.datDir = datDir
    else:
      print(datDir + ' not exisit!')
      sys.exit()

  def run(self, scriptname, *args):
    ext = scriptname.split('.')[-1]
    if ext == 'ncl':
      calculator = 'nclrun '
    elif ext == 'jnl':
      calculator = 'ferret -nojnl -script '
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

  def regrid2pcom(self, nc):
      fin = self.datDir + nc
      fout= self.datDir + "pcom_grid/" + nc
      if "temperature" in nc:
        self.run("regrid2pcom_temp.jnl", fin, fout)

#=========================================
woa = Woa("/snfs01/lyh/ou/data/woa09/")

woa.regrid2pcom("temperature_annual_1deg.nc")
