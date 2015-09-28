#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-16 06:59:29 BJT
# Last Change: 2014-12-07 07:28:10 BJT

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

exp_spinup = Exp("/home/ou/archive/data/pcom/exp_spinup/")
#exp_spinup.run("ohc.ncl")

exp24= Exp("/home/ou/archive/data/pcom/exp24_taux_an_40y_N/")
#exp24.run("yearly_var2d.ncl")
