#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-10-24 08:39:35 BJT
# Last Change: 2014-11-30 16:35:37 BJT

import os
import sys

jobnames = [
#'ohc',
#'ws_profile',
#'dtc_eof_tro_Pac',
'isot_eof_eq_Pac',
#'v_20N',
]

def runCmd(cmd):
  print(cmd)
  stat = os.system(cmd)
  if stat != 0:
    print("Error happen when run: "+cmd)
    sys.exit()

class Job:
  def __init__(self,name):
    self.name = name
    self.datDir = '/home/ou/archive/data/pcom/exp17_ws_control_cycle_re/post/'
    self.imgDir = '/home/ou/archive/drawing/pcom/exp17_ws_control_cycle_re/'
    self.drawscript = ''

  def draw(self):
    runCmd("mkdir -p " + self.imgDir)
    runCmd('nclrun '+' '+self.drawscript+' '+self.datDir+' '+self.imgDir)

jobs = []

# automatically execute jobs
#============================
for jobname in jobnames:
  nclscript = jobname+'.ncl'
  if os.path.isfile(nclscript):
    job = Job(jobname)
    job.drawscript = nclscript
    job.draw()
