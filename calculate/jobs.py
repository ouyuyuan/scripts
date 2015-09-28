#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-16 06:59:29 BJT
# Last Change: 2014-12-12 16:10:31 BJT

import os
import sys

def runCmd(cmd):
  print(cmd)
  stat = os.system(cmd)
  if stat != 0:
    print("Error happen when run: "+cmd)
    sys.exit()

class Script:
  def __init__(self):
    self.name = ""
    self.datDir = ""

  def run(self, scriptname, *args):
    self.name = scriptname
    if not os.path.isdir(self.datDir):
      print(self.datDir+"donesn't exist! Stop.")
      sys.exit()
    ext = self.name.split('.')[-1]
    if ext == 'ncl':
      calculator = 'nclrun '
    elif ext == 'jnl':
      calculator = 'pyferret -nojnl -script '
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

class Ishii(Script):
  def __init__(self):
    Script.__init__(self)
    self.datDir = "/home/ou/archive/data/Ishii/"

ishii = Ishii()
#ishii.run("ohc.ncl", "1945", "2012")
ishii.run("sst.ncl", "1945", "2012")
#ishii.run("grid_info.ncl")
