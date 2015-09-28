#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-10-24 08:39:35 BJT
# Last Change: 2014-11-15 20:28:36 BJT

import os
import sys

jobnames = [
'nino',
#'sketch_region',
]

class Job:
  def __init__(self,name):
    self.name = name
    self.datadir = '/home/ou/archive/data/plot/pcom/enso/'
    self.imgdir = '/home/ou/archive/drawing/pcom/enso/'
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

# cal nino3.4 indices
#=====================
job            = Job('nino')
#job.calcscript = 'cal_nino.ncl'
job.drawscript = 'nino.ncl'
jobs.append(job)

# sketch plot of a region
#==========================
job            = Job('sketch_region')
job.drawscript = 'sketch_region.ncl'
jobs.append(job)

# execute jobs
#===============
for job in jobs:
  if job.name in jobnames:
    if job.calcscript != '':
      job.calc()
    if job.drawscript != '':
      job.draw()

