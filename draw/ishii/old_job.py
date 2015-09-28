#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-16 06:59:29 BJT
# Last Change: 2015-06-29 09:36:24 BJT

import os
import sys

def runCmd(cmd):
  print(cmd)
  stat = os.system(cmd)
  if stat != 0:
    print("Error happen when run: "+cmd)
    sys.exit()

class Ishii:
  def __init__(self,name):
    datDir = "/home/ou/archive/data/Ishii/post/"
    if os.path.isdir(datDir):
      self.datDir = datDir
    else:
      print(datDir+"donesn't exist! Stop.")
      sys.exit()
    imgDir = "/home/ou/archive/drawing/Ishii/"
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

exp_spinup = Exp("exp_spinup")
#exp_spinup.run("ohc_global.ncl")
#exp_spinup.run("ohc_depths.ncl")
#exp_spinup.run("ohc_depths_detail.ncl")
#exp_spinup.run("ohc_depths_detrend.ncl")
#exp_spinup.run("ohc_depths_detrend_detail.ncl")
#exp_spinup.run("ohc_depths_Pac.ncl")

exp24 = Exp("exp24_taux_an_40y_N")
#exp24.run("ohc_global.ncl")
#exp24.run("ohc_depths.ncl")
#exp24.run("ohc_depths_detail.ncl")
#exp24.run("ohc_depths_detrend.ncl")
#exp24.run("ohc_depths_detrend_detail.ncl")
#exp24.run("ohc_depths_Pac.ncl")

exp33 = Exp("exp33_ws_60S30S_40y") # the true period is 40y, actrually
exp33.run("ohc_global.ncl")
#exp33.run("ohc_depths.ncl")
#exp33.run("ohc_depths_detail_exp33.ncl")
#exp33.run("ohc_depths_detrend.ncl")
#exp33.run("ohc_depths_detrend_detail.ncl")
#exp33.run("ohc_depths_Pac_exp33.ncl")

exp34 = Exp("exp34_ws_10S10N_4y")
#exp34.run("ohc_global.ncl")
#exp34.run("ohc_depths.ncl")
#exp34.run("ohc_depths_detail.ncl")
#exp34.run("ohc_depths_detail_exp34.ncl")
#exp34.run("ohc_depths_detrend.ncl")
#exp34.run("ohc_depths_detrend_detail.ncl")
#exp34.run("ohc_depths_Pac_exp34.ncl")
