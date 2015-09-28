#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-10-24 08:39:35 BJT
# Last Change: 2014-12-01 10:57:33 BJT

import os
import sys

jobnames = [
#'ohc',
#'ws_profile',
#'ws_profile_relative',
#'ws_an',
#'an_ts',
#'dtc_eof_tro_Pac',
#'dtc_diff_eof_Pac_N',
#'dtc_diff_eof_Pac_S',
#'dtc_diff_eof_Atl_N',
#'dtc_diff_eof_Atl_S',
#'dtc_diff_eof_Ind_N',
#'dtc_diff_eof_Ind_S',
#'dtc_depth_tro_Pac',
#'ssh_tro_Pac',
#'ssh_diff_eof_Pac_N',
#'ssh_diff_eof_Pac_S',
#'isot_eof_eq_Pac',
#'isot_diff_eof_eq_Pac_W',
#'isot_diff_eof_eq_Pac_E',
#'sst_tro_Pac',
#'v_20N',
#'v_20N_diff',
'v_transport_diff',
#'dtc_depth_eq_Pac',
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
    self.datDir = '/home/ou/archive/data/pcom/exp21_ws_30N-60N_periodic/post/'
    self.imgDir = '/home/ou/archive/drawing/pcom/exp21_ws_30N-60N_periodic/'
    self.drawscript = ''

  def draw(self):
    runCmd("mkdir -p " + self.imgDir)
    runCmd('nclrun '+' '+self.drawscript+' '+self.datDir+' '+self.imgDir)

# automatically execute jobs
#============================
for jobname in jobnames:
  nclscript = jobname+'.ncl'
  if os.path.isfile(nclscript):
    job = Job(jobname)
    job.drawscript = nclscript
    job.draw()
