#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-16 06:59:29 BJT
# Last Change: 2015-01-21 09:39:20 BJT

import os
import sys

data_root = "/snfs01/ou/models/pcom_1.0/exp/"

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
    self.img = ""

  def run(self, scriptname, *args):
    self.name = scriptname
    if self.img == "":
      self.img = self.name.split('.')[0]
    if not os.path.isdir(self.datDir):
      print(datDir+"donesn't exist! Stop.")
      sys.exit()
    if not os.path.isdir(self.imgDir):
      runCmd("mkdir "+self.imgDir)

    ext = self.name.split('.')[-1]
    if ext == 'ncl':
      calculator = 'nclrun '
    elif ext == 'jnl':
      calculator = 'pyferret -nojnl -script '
    else:
      print('Unknown script extension: ' + ext)
      sys.exit()
    myargs = self.datDir+" "+self.imgDir+self.img
    if len(args)>0:
      for arg in args:
        myargs = myargs+" "+arg+" "
    runCmd(calculator + self.name + " " + myargs)

class PcomExp(Script):
  def __init__(self,name):
    Script.__init__(self)
    self.datDir = data_root+name+"/"
    self.imgDir = self.datDir+"plot/"

#ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
#exp = PcomExp("exp_spinup")
#exp = PcomExp("exp_taux_an_40y_N")
#exp = PcomExp("exp24_taux_an_40y_N")
#exp = PcomExp("exp33_ws_60S30S_40y")
#exp = PcomExp("exp34_ws_10S10N_4y")
#exp = PcomExp("exp36_simu_60yrs")
#exp = PcomExp("exp39_clm_warm")
#exp = PcomExp("exp40_ws_30N60N_4y")
#exp = PcomExp("exp40b_ws_30N60N_20y")
#exp = PcomExp("exp43_clm_simu_60yrs")
#exp = PcomExp("exp44_clm_thermal")
#exp = PcomExp("exp45_clm_adi")
#exp = PcomExp("exp48_osc_yr_bcf")
exp = PcomExp("exp49_bcp_season")

#exp.img = "ohc_glo_wave___120years"
#exp.run("draw_01_nino_index.ncl", "6001", "6468", "oldCalc", "X11")
exp.run("draw_01_nino_index.ncl", "6001", "6144", "oldCalc", "X11")
