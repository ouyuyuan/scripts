#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-16 06:59:29 BJT
# Last Change: 2014-11-16 16:27:41 BJT

import os
import sys

jobnames = [
#'climatory',
'ohc',
]

class Job:
  def __init__(self,name):
    self.name = name
    self.datadir = '/home/ou/archive/data/pcom/exp22_ws_control_re/post/'
    self.imgdir = self.datadir+'img/'
    self.data = name
    self.img  = name
    self.drawscript = ''
    self.calcscript = ''

  def calc(self):
    cmd = "mkdir -p " + self.datadir
    print(cmd); os.system(cmd)
    scriptname = self.calcscript
    ext = scriptname.split('.')[-1]
    if ext == 'ncl':
      calculator = 'nclrun '
    elif ext == 'jnl':
      calculator = 'pyferret -nojnl -script '
    elif ext == 'py':
      calculator = 'python '
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

# climatory
#=====================
job            = Job('climatory')
job.calcscript = 'climatory.ncl'
jobs.append(job)

# yearly
#=====================
job            = Job('ohc')
job.calcscript = 'ohc.ncl' 
jobs.append(job)

# execute jobs
#===============
for job in jobs:
  if job.name in jobnames:
    if job.calcscript != '':
      job.calc()
    if job.drawscript != '':
      job.draw()

