#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-07 20:17:56 BJT
# Last Change: 2014-11-18 09:38:28 BJT

import os
import sys

jobnames = [
#'stress_profile_an',
#'stress_an',
#'sketch_slice',
#'t_lat_sec',
#'thc_movement',
#'thc_movement_lon',
#'t_lon_sec',
#'t_lon_sec_diff',
#'thc_depth',
#'ssh',
'ohc',
#'ohc_column',
]
actions = [
'calc', 
'draw',
]

class Job:
  def __init__(self,name):
    self.name = name
    self.datadir = '/home/ou/archive/data/plot/pcom/ws_exp/'
    self.imgdir = '/home/ou/archive/drawing/pcom/ws_exp/an_15S15N/'
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

# zonal wind stress profile, anomaly to control run
job            = Job('stress_profile_an')
job.data       = 'stress_zonal_profile.nc'
job.drawscript = 'stress_profile_an.ncl'
jobs.append(job)

# zonal climatory wind stress, anomaly to control run
job            = Job('stress_an')
job.drawscript = 'stress_an.ncl'
jobs.append(job)

# sketch of slice
job            = Job('sketch_slice')
job.drawscript = 'sketch_slice.ncl'
jobs.append(job)

# temperature in a latitude section
job            = Job('t_lat_sec')
job.drawscript = 't_lat_sec.ncl'
jobs.append(job)

# thermocline movement
#======================
job            = Job('thc_movement')
job.data       = "t_lat_sec.nc"
job.drawscript = 'thc_movement.ncl'
jobs.append(job)

# thermocline movement, meridional
#==================================
job            = Job('thc_movement_lon')
job.data       = "temp_lon_section.nc"
job.drawscript = 'thc_movement_lon.ncl'
jobs.append(job)

# temperature at a meridional slice of the Pacific ocean
#========================================================
job            = Job('t_lon_sec')
job.data       = 'temp_lon_section.nc'
job.drawscript = 't_lon_sec.ncl'
jobs.append(job)

# temperature at a meridional slice of the Pacific ocean
# different of control run and experiment
#========================================================
job            = Job('t_lon_sec_diff')
job.data       = 'temp_lon_section.nc'
job.drawscript = 't_lon_sec_diff.ncl'
jobs.append(job)

# 20 degC isothermal line
#=========================
job            = Job('thc_depth')
job.data       = '20deg_iso_depth.nc'
job.drawscript = 'thc_depth.ncl'
jobs.append(job)

# dtdz in pacific equator
job            = Job('dtdz_pacific_eq')
job.data       = 'dtdz_eq.nc'
job.calcscript = 'calc_dtdz_eq.jnl'
job.drawscript = 'dtdz_pacific_eq.ncl'
jobs.append(job)

# dtdz in pacific meridional section
job            = Job('dtdz_pacific_lon')
job.data       = 'dtdz_lon.nc'
job.calcscript = 'calc_dtdz_lon.jnl'
job.drawscript = 'dtdz_pacific_lon.ncl'
jobs.append(job)

# sea surface height
#====================
job            = Job('ssh')
job.drawscript = 'ssh.ncl'
jobs.append(job)

# sea surface height
#====================
job            = Job('ohc')
job.drawscript = 'ohc.ncl'
jobs.append(job)

# sea surface height
#====================
job            = Job('ohc_column')
job.drawscript = 'ohc_column.ncl'
jobs.append(job)

# execute jobs
#===============
for job in jobs:
  if job.name in jobnames:
    if ('calc' in actions) & (job.calcscript != ''):
      job.calc()
    if ('draw' in actions) & (job.drawscript != ''):
      job.draw()

