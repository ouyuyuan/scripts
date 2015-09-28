#!/usr/bin/env python

# Description: modify filenames by cdo splityear, shift one year ahead
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-22 09:41:24 BJT
# Last Change: 2014-11-28 08:26:07 BJT

import os
import sys

def runCmd(cmd):
  print(cmd)
  stat = os.system(cmd)
  if stat != 0:
    print("Error happen when run: "+cmd)
    sys.exit()

class cdoOutput:
  def __init__(self, dataDir):
    self.dataDir = dataDir
    self.nYear    = 64
    self.yrFiles    = []
    self.yrFilesNew = []

    for yr in range(0, self.nYear):
      fname    = self.dataDir+"cdo_output_%04d.nc" % yr
      fnameNew = self.dataDir+"year_%04d.nc" % (yr + 1)
      if os.path.isfile(fname):
        self.yrFiles.append(fname)
        self.yrFilesNew.append(fnameNew)
      else:
        print(fname+" donesn't exist! Stop.")
        sys.exit()

  def modifyFilename(self):
    n = len(self.yrFiles)
    for i in range(0,n):
      runCmd("mv "+self.yrFiles[i]+" "+self.yrFilesNew[i])

exp17 = cdoOutput("/home/ou/archive/data/pcom/exp17_ws_control_cycle_re/yearly/")
exp17.modifyFilename()
