#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-10-24 08:39:35 BJT
# Last Change: 2014-11-09 10:59:10 BJT

import os
import sys

jobnames = [
'ws_an_evolve',
]
actions = [
'calc', 
'draw',
]

class Job:
  def __init__(self,name):
    self.name = name
    self.datadir = '/home/ou/archive/data/plot/pcom/ws_exp/'
    self.imgdir = '/home/ou/archive/drawing/pcom/ws_exp/an_60S30S_periodic/'
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
    cmd = calculator + scriptname + ' ' + self.datadir + self.data
    print(cmd)
    os.system(cmd)

  def draw(self):
    cmd = 'nclrun ' + ' ' + self.drawscript + ' ' + \
        self.datadir + self.data + ' ' + self.imgdir + self.img
    print(cmd)
    os.system(cmd)

    if os.path.exists(self.imgdir+self.img+".eps"):
      cmd = 'eps2png_trim ' + self.imgdir + self.img
      print(cmd)
      os.system(cmd)

jobs = []

# zonal wind profile evolving with time
job            = Job('ws_an_evolve')
job.calcscript = 'cal_ws_an_evolve.ncl'
#job.drawscript = 'ws_an_evolve.ncl'
jobs.append(job)

# execute jobs
#===============
for job in jobs:
  if job.name in jobnames:
    if ('calc' in actions) & (job.calcscript != ''):
      job.calc()
    if ('draw' in actions) & (job.drawscript != ''):
      job.draw()

