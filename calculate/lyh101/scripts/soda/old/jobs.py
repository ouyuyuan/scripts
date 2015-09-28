#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-16 06:59:29 BJT
# Last Change: 2015-04-21 19:51:53 BJT

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
    self.datDir = datDir
    if not os.path.isdir(datDir):
      runCmd("mkdir -p "+self.datDir)

  def run(self, scriptname, *args):
    self.name = scriptname
    ext = self.name.split('.')[-1]
    if ext == 'ncl':
      calculator = 'nclrun '
    elif ext == 'jnl':
      calculator = 'ferret -nojnl -script '
    elif ext == 'py':
      calculator = 'python '
    else:
      print('Unknown script extension: ' + ext)
      sys.exit()
    myargs = self.datDir
    if len(args)>0:
      for arg in args:
        myargs = myargs+" "+arg+" "
    runCmd(calculator + self.name + " " + myargs)

  def regrid2pcom(self, yb, ye):
    for year in range(yb, ye + 1):
      nc = "year_%04d.nc" % year
      print('processing ' + nc + ' ~ ~ ~ ~ ~ ~')
      fin = self.datDir+"yearly/"+nc
      fout= self.datDir+"pcom_grid/yearly/"+nc
      self.run("regrid2pcom.jnl", fin, fout)

#=========================================
case = Soda("/snfs01/lyh/ou/data/soda/")
#case = Soda("/home/ou/archive/data/soda/pcom_grid/")

case.run("grid_info.ncl")

#case.regrid2pcom(1871, 2008)
#case.run("ohc.ncl")
