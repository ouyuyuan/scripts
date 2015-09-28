#!/usr/bin/env python

# Description: remove restart files, only remain those per 10 years
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-22 09:41:24 BJT
# Last Change: 2015-06-28 06:25:40 BJT

import os
import sys
import math

def runCmd(cmd):
  print(cmd)
  stat = os.system(cmd)
  if stat != 0:
    print("Error happen when run: "+cmd)
    sys.exit()

class RestartFiles:
  def __init__(self, datDir, currentRst):
    self.datDir = datDir
    self.rstFiles = os.listdir(datDir)
    self.currentRst = currentRst

  def removeThem(self):
    os.chdir(self.datDir)
    n = len(self.rstFiles)
    for i in range(0,n):
      fname = self.rstFiles[i]
      mon = int(fname[1:])
      if mon < self.currentRst:
        if math.fmod(mon,120) > 0.0 :
          runCmd("rm "+self.rstFiles[i])

exp = RestartFiles("/snfs01/ou/models/pcom_1.0/exp/exp_spinup/restart/", 10405)
#exp = RestartFiles("/snfs01/ou/models/pcom_1.0/exp/exp23_clm_diff_ws/restart/", 6744)
#exp = RestartFiles("/snfs01/ou/models/pcom_1.0/exp/exp24_taux_an_40y_N/restart/", 7656)
#exp = RestartFiles("/snfs01/ou/models/pcom_1.0/exp/exp25_clm_diff/restart/", 6768)
#exp = RestartFiles("/snfs01/ou/models/pcom_1.0/exp/exp34_ws_10S10N_4y/restart/", 7464)
#exp = RestartFiles("/snfs01/ou/models/pcom_1.0/exp/exp29_ws_60S30S_2y/restart/", 7248)
#exp = RestartFiles("/snfs01/ou/models/pcom_1.0/exp/exp36_simu_60yrs/restart/", 6720)
#exp = RestartFiles("/snfs01/ou/models/pcom_1.0/exp/exp43_clm_simu_60yrs/restart/", 6720)
#exp = RestartFiles("/snfs01/ou/models/pcom_1.0/exp/exp44_clm_thermal/restart/", 6744)
#exp = RestartFiles("/snfs01/ou/models/pcom_1.0/exp/exp45_clm_adi/restart/", 6744)
#exp = RestartFiles("/snfs01/ou/models/pcom_1.0/exp/exp49_bcp_season/restart/", 6144)
exp.removeThem()
