#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-10-24 08:39:35 BJT
# Last Change: 2014-11-16 10:05:49 BJT

import os
import sys

jobnames = [
#'climate_forcing',
#'uv_stress',
#'stress_zonal_profile',
#'stress_zonal_profile_ini',
#'stress_zonal_profile_an',
#'stress_profile_an',
#'anomaly_ue',
#'stress_an',
#'stress_zonal_avg_evolve',
#'schematic_slice',
#'t_lat_sec',
#'t_pacific_eq',
#'t_pacific_eq_exp',
#'t_pacific_eq_exp_diff',
#'t_pacific_eq_for_cmp',
#'t_pacific_lon',
#'t_pacific_lon_exp',
#'t_pacific_lon_exp_diff',
#'20deg_iso_depth',
#'20deg_iso_depth_exp',
#'20deg_iso_depth_exp_diff',
#'20deg_iso_depth_2_plot',
#'dtdz_pacific_eq',
#'dtdz_pacific_lon',
#'ssh',
#'bcp_gradient',
#'bcp_gradient_float',
#'geostrophic_wind',
#'ohc',
'ohc_64yr',
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
    self.imgdir = '/home/ou/archive/drawing/pcom/ws_exp/'
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

# climatory wind stress forcing of PCOM control run
job            = Job('climate_forcing')
job.data       = 'wind_stress.nc'
job.calcscript = 'extract_wind_stress.ncl'
jobs.append(job)

# zonal and meridional  Wind stress forcing, alike Large2008 Fig.6
job            = Job('uv_stress')
job.data       = 'wind_stress.nc'
job.img        = 'uv_stress'
job.calcscript = 'extract_wind_stress.ncl'
job.drawscript = 'uv_stress.ncl'
jobs.append(job)

# zonal average climatory wind stress (only account zonal wind stress)
job            = Job('stress_zonal_profile')
job.calcscript = 'calc_stress_zonal_avg.ncl'
#job.drawscript = 'stress_zonal_profile.ncl'
jobs.append(job)

# zonal average climatory wind stress, initial field
job            = Job('stress_zonal_profile_ini')
job.data       = 'stress_zonal_profile.nc'
job.drawscript = 'stress_zonal_profile_ini.ncl'
jobs.append(job)

# zonal average climatory wind stress, anomaly to control run
job            = Job('stress_zonal_profile_an')
job.data       = 'stress_zonal_profile.nc'
job.drawscript = 'stress_zonal_profile_an.ncl'
jobs.append(job)

# zonal wind stress profile, anomaly to control run
job            = Job('stress_profile_an')
job.data       = 'stress_zonal_profile.nc'
#job.calcscript = 'calc_stress_zonal_avg.ncl'
job.drawscript = 'stress_profile_an.ncl'
jobs.append(job)

# anomalous wind stress introduced Ekman pumping
#================================================
job            = Job('anomaly_ue')
job.data       = 'stress_zonal_profile.nc'
#job.calcscript = 'calc_stress_zonal_avg.ncl'
job.drawscript = 'anomaly_ue.ncl'
jobs.append(job)

# zonal climatory wind stress, anomaly to control run
job            = Job('stress_an')
job.calcscript = 'calc_stress_an.ncl'
#job.drawscript = 'stress_an.ncl'
jobs.append(job)

# zonal wind profile evolving with time
job            = Job('stress_zonal_avg_evolve')
job.data       = 'stress_zonal_avg_evolve.nc'
job.img        = 'stress_zonal_avg_evolve'
job.calcscript = 'calc_stress_zonal_avg_evolve.ncl'
job.drawscript = 'stress_zonal_avg_evolve.ncl'
jobs.append(job)

# schematic of slice
job            = Job('schematic_slice')
job.drawscript = 'schematic_slice.ncl'
jobs.append(job)

# temperature in a latitude section
job            = Job('t_lat_sec')
job.data       = 't_lat_sec.nc'
job.calcscript = 'extract_t_lat_sec.ncl'
#job.drawscript = 't_lat_sec.ncl'
jobs.append(job)

# temperature in upper Pacific at equator
job            = Job('t_pacific_eq')
job.data       = 'temp_equator.nc'
job.img        = 't_pacific_eq'
job.calcscript = 'extract_equator_temp.ncl'
job.drawscript = 't_pacific_eq.ncl'
jobs.append(job)

# temperature in upper pacific equator, rearrange for comparision
job            = Job('t_pacific_eq_for_cmp')
job.data       = 'temp_equator.nc'
job.drawscript = 't_pacific_eq_for_cmp.ncl'
jobs.append(job)

# temperature in upper Pacific at equator, experiment result
job            = Job('t_pacific_eq_exp')
job.data       = 'temp_equator.nc'
job.drawscript = 't_pacific_eq_exp.ncl'
jobs.append(job)

# temperature in upper Pacific at equator, experiment minus control run
job            = Job('t_pacific_eq_exp_diff')
job.data       = 'temp_equator.nc'
job.drawscript = 't_pacific_eq_exp_diff.ncl'
jobs.append(job)

# temperature at a meridional slice of the Pacific ocean
job            = Job('t_pacific_lon')
job.data       = 'temp_lon_section.nc'
job.img        = 't_pacific_lon'
job.calcscript = 'extract_temp_lon_sec.ncl'
#job.drawscript = 't_pacific_lon.ncl'
jobs.append(job)

# temperature at a meridional slice of the Pacific ocean, experiment result
job            = Job('t_pacific_lon_exp')
job.data       = 'temp_lon_section.nc'
job.calcscript = 'extract_temp_lon_sec.ncl'
job.drawscript = 't_pacific_lon_exp.ncl'
jobs.append(job)

# temperature at a meridional slice of the Pacific ocean, experiment result
job            = Job('t_pacific_lon_exp_diff')
job.data       = 'temp_lon_section.nc'
job.calcscript = 'extract_temp_lon_sec.ncl'
job.drawscript = 't_pacific_lon_exp_diff.ncl'
jobs.append(job)

# 20 degC isothermal line
job            = Job('20deg_iso_depth')
job.calcscript = 'calc_20deg_iso.jnl'
#job.drawscript = '20deg_iso_depth.ncl'
jobs.append(job)

# 20 degC isothermal line
job            = Job('20deg_iso_depth_exp')
job.data       = '20deg_iso_depth.nc'
job.calcscript = 'calc_20deg_iso.jnl'
job.drawscript = '20deg_iso_depth_exp.ncl'
jobs.append(job)

# 20 degC isothermal line
job            = Job('20deg_iso_depth_exp_diff')
job.data       = '20deg_iso_depth.nc'
job.calcscript = 'calc_20deg_iso.jnl'
job.drawscript = '20deg_iso_depth_exp_diff.ncl'
jobs.append(job)

# 20 degC isothermal line, 2 subplot
job            = Job('20deg_iso_depth_2_plot')
job.data       = '20deg_iso_depth.nc'
job.drawscript = '20deg_iso_depth_2_plot.ncl'
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
job.calcscript = 'extract_ssh.ncl'
#job.drawscript = 'ssh.ncl'
jobs.append(job)

# calc. pressure gradient 
#=========================
job            = Job('bcp_gradient')
job.calcscript = 'calc_bcp_gradient.jnl'
jobs.append(job)

# change double to float 
#========================
job            = Job('bcp_gradient_float')
job.calcscript = 'change_bcp_gradient_to_float.ncl'
jobs.append(job)

# mid-latitude geostrophic wind and its anomaly
#===============================================
job            = Job('geostrophic_wind')
job.calcscript = 'calc_geostrophic_wind.ncl'
jobs.append(job)

# ocean heat content 
#================================================
job            = Job('ohc')
job.calcscript = 'calc_ohc.ncl'
jobs.append(job)

# ocean heat content 
#================================================
job            = Job('ohc_64yr')
job.calcscript = 'calc_ohc_64yr.ncl'
jobs.append(job)

# ocean heat content , water column
#================================================
job            = Job('ohc_column')
job.calcscript = 'calc_ohc_column.jnl'
jobs.append(job)

# execute jobs
#===============
for job in jobs:
  if job.name in jobnames:
    if ('calc' in actions) & (job.calcscript != ''):
      job.calc()
    if ('draw' in actions) & (job.drawscript != ''):
      job.draw()

