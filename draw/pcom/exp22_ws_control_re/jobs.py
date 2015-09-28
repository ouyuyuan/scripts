#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-12 20:05:41 BJT
# Last Change: 2014-11-16 19:20:09 BJT

import os
import sys

jobnames = [
'ohc',
]
actions = [
'calc', 
'draw',
]

class Job:
  def __init__(self,name):
    self.name = name
    self.datDir = '/home/ou/archive/data/pcom/exp22_ws_control_re/post/'
    self.imgDir = '/home/ou/archive/drawing/pcom/exp22_ws_control_re/'
    self.data = name + '.nc'
    self.img  = name
    self.drawscript = ''
    self.calcscript = ''

  def calc(self):
    scriptname = self.calcscript
    ext = scriptname.split('.')[-1]
    if ext == 'ncl':
      calculator = 'nclrun '
    elif ext == 'jnl':
      calculator = 'pyferret -nojnl -script '
    else:
      print('Unknown script extension: ' + ext)
      sys.exit()
    cmd = calculator + scriptname + ' ' + self.datDir + self.data
    print(cmd)
    os.system(cmd)

  def draw(self):
    os.system('mkdir -p ' + self.imgDir)
    cmd = 'nclrun ' + ' ' + self.drawscript + ' ' + \
        self.datDir + ' ' + self.imgDir
    print(cmd)
    os.system(cmd)

    if os.path.exists(self.imgDir+self.img+".eps"):
      cmd = 'eps2png_trim ' + self.imgDir + self.img
      print(cmd)
      os.system(cmd)

jobs = []

# add AO anomaly wind
#=====================
job            = Job('ohc')
#job.drawscript = 'ohc_global.ncl'; jobs.append(job)
#job.drawscript = 'ohc_basin.ncl'; jobs.append(job)
job.drawscript = 'ohc_1500_basin.ncl'; jobs.append(job)

# execute jobs
#===============
for job in jobs:
  if job.name in jobnames:
    if ('calc' in actions) & (job.calcscript != ''):
      job.calc()
    if ('draw' in actions) & (job.drawscript != ''):
      job.draw()

