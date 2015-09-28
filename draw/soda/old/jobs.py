#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-16 06:59:29 BJT
# Last Change: 2014-12-09 15:53:02 BJT

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
      print(datDir+"donesn't exist! Stop.")
      sys.exit()
    imgDir = "/home/ou/archive/drawing/soda/"
    if not os.path.isdir(imgDir):
      runCmd("mkdir "+imgDir)
    self.imgDir = imgDir

  def run(self, scriptname):
    ext = scriptname.split('.')[-1]
    if ext == 'ncl':
      calculator = 'nclrun '
    elif ext == 'jnl':
      calculator = 'pyferret -nojnl -script '
    else:
      print('Unknown script extension: ' + ext)
      sys.exit()
    runCmd(calculator+scriptname+' '+self.datDir+' '+self.imgDir)

soda = Soda("/home/ou/archive/data/soda/post/")
#soda.run("ohc_global.ncl")

soda_pcom = Soda("/home/ou/archive/data/soda/pcom_grid/post/")
soda_pcom.run("ohc_global.ncl")
#soda_pcom.run("ohc_global_rm_anthropogenic.ncl")
