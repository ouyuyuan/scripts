#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-10-24 08:39:35 BJT
# Last Change: 2014-11-06 20:55:23 BJT

import os
import sys

jobnames = [
#'cal_hgt_eof',
#'cal_slp_eof',
#'cal_ao_an_wind',
'add_ao_an_wind',
]

class Job:
  def __init__(self,name):
    self.name = name
    self.datadir = '/home/ou/archive/data/plot/pcom/ws_exp/'
    self.imgdir = '/home/ou/archive/drawing/pcom/ws_exp/ao/'
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

# cal 1000mb height anomalies like NOAA CPC
#===========================================
job            = Job('cal_hgt_eof')
job.data       = 'ao_hgt_eof.nc'
job.calcscript = 'cal_hgt_eof.ncl'
jobs.append(job)

# cal slp EOF pattern and time series
#=====================================
job            = Job('cal_slp_eof')
job.data       = 'ao_slp_eof.nc'
job.calcscript = 'cal_slp_eof.ncl'
jobs.append(job)

# cal. wind anomaly of AO
#=========================
job            = Job('cal_ao_an_wind')
job.data       = 'ao_an_wind_eof.nc'
job.calcscript = 'cal_ao_an_wind.jnl'
jobs.append(job)

# add AO anomaly wind
#=====================
job            = Job('add_ao_an_wind')
job.calcscript = 'add_ao_an_wind.ncl'
jobs.append(job)


# execute jobs
#===============
for job in jobs:
  if job.name in jobnames:
    if job.calcscript != '':
      job.calc()
    if job.drawscript != '':
      job.draw()

