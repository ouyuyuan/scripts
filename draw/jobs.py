#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-16 06:59:29 BJT
# Last Change: 2014-12-12 15:49:11 BJT

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
    self.imgDir = ""

  def run(self):
    if not os.path.isdir(self.datDir):
      print(datDir+"donesn't exist! Stop.")
      sys.exit()
    if not os.path.isdir(self.imgDir):
      runCmd("mkdir "+imgDir)

    ext = self.script.split('.')[-1]
    if ext == 'ncl':
      calculator = 'nclrun '
    elif ext == 'jnl':
      calculator = 'pyferret -nojnl -script '
    else:
      print('Unknown script extension: ' + ext)
      sys.exit()
    runCmd(calculator+self.name+' '+self.datDir+' '+self.imgDir)

class Ishii(Script):
  def __init__(self,name):
    Script.__init__(self,name)
    self.datDir = "/home/ou/archive/data/Ishii/"
    self.imgDir = "/home/ou/archive/drawing/Ishii/"

ishii = Ishii()
ishii.run("ohc_basin.ncl")
