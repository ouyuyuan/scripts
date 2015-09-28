#!/usr/bin/env python

# Description: modify filenames of the nth cycling run
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-22 09:41:24 BJT
# Last Change: 2014-11-25 18:32:18 BJT

import os
import sys

def runCmd(cmd):
  print(cmd)
  stat = os.system(cmd)
  if stat != 0:
    print("Error happen when run: "+cmd)
    sys.exit()

class CycleOutput:
  def __init__(self, dataDir, nCycle):
    self.dataDir = dataDir
    self.nCycle  = nCycle
    self.nMon    = 720 # months in a cycle
    self.rstInt  = 24  # restart file interval
    self.monFiles    = []
    self.monFilesNew = []
    self.rstFiles    = []
    self.rstFilesNew = []

    for mon in range(1, self.nMon+1):
      fname    = self.dataDir+"N%08d.nc" % mon
      fnameNew = self.dataDir+"N%08d.nc" % (mon + self.nCycle*self.nMon)
      if os.path.isfile(fname):
        self.monFiles.append(fname)
        self.monFilesNew.append(fnameNew)
      else:
        print(fname+" donesn't exist! Stop.")
        sys.exit()

    for mon in range(self.rstInt, self.nMon+1, self.rstInt):
      fname = self.dataDir+"S%08d" % mon
      fnameNew = self.dataDir+"S%08d" % (mon+self.nCycle*self.nMon)
      if os.path.isfile(fname):
        self.rstFiles.append(fname)
        self.rstFilesNew.append(fnameNew)
      else:
        print(fname+" donesn't exist! Stop.")
        sys.exit()

  def modifyFilename(self):
    n = len(self.monFiles)
    for i in range(0,n):
      runCmd("mv "+self.monFiles[i]+" "+self.monFilesNew[i])

    n = len(self.rstFiles)
    for i in range(0,n):
      runCmd("mv "+self.rstFiles[i]+" "+self.rstFilesNew[i]) 

exp20_1 = CycleOutput("/media/pcom/transport/exp20/cycle_1/", 1)
exp20_1.modifyFilename()
