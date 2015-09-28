#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-12 20:05:41 BJT
# Last Change: 2014-11-17 13:55:42 BJT

import os
import sys

jobnames = [
#'hgt_eof',
#'cal_slp_eof',
#'cal_ao_an_wind',
#'add_ao_an_wind',
#'ssh',
#'ohc',
'ohc_column',
#'t_lat_sec',
#'thc_depth',
#'thc_movement',
]
actions = [
'calc', 
'draw',
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

# 20 degC isothermal line
#=========================
job            = Job('thc_depth')
#job.img        = 'test_thc_depth'
job.data       = '20deg_iso_depth.nc'
job.drawscript = 'thc_depth.ncl'
jobs.append(job)

# sea surface height
#====================
job            = Job('ssh')
job.drawscript = 'ssh.ncl'
jobs.append(job)

# sea surface height
#====================
job            = Job('ohc')
job.data       = "ohc_64yr.nc"
job.drawscript = 'ohc.ncl'
jobs.append(job)

# sea surface height
#====================
job            = Job('ohc_column')
#job.img        = 'test_ohc_column'
job.drawscript = 'ohc_column.ncl'
jobs.append(job)

# temperature in a latitude section
#===================================
job            = Job('t_lat_sec')
job.drawscript = 't_lat_sec.ncl'
jobs.append(job)

# thermocline movement
#======================
job            = Job('thc_movement')
job.data       = "t_lat_sec.nc"
job.drawscript = 'thc_movement.ncl'
jobs.append(job)

# cal 1000mb height anomalies like NOAA CPC
#===========================================
job            = Job('hgt_eof')
job.data       = 'ao_hgt_eof.nc'
#job.calcscript = 'cal_hgt_eof.ncl'; jobs.append(job)

# cal slp EOF pattern and time series
#=====================================
job            = Job('cal_slp_eof')
job.data       = 'ao_slp_eof.nc'
#job.calcscript = 'cal_slp_eof.ncl'; jobs.append(job)
#job.img = 'ao_indices'; job.drawscript = 'ao_indices.ncl'; jobs.append(job)
job.img = 'ao_pattern'; job.drawscript = 'ao_pattern.ncl'; jobs.append(job)

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
    if ('calc' in actions) & (job.calcscript != ''):
      job.calc()
    if ('draw' in actions) & (job.drawscript != ''):
      job.draw()

