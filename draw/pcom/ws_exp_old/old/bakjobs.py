#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-10-13 19:31:39 BJT
# Last Change: 2014-10-24 08:25:10 BJT

import os
import sys

# calc. yearly mean data
#========================
#datadir='/media/pcom/ws_control/'
#datadir = '/media/pcom/modify_ver_mix/'
#datadir = '/media/pcom/ws_an_eq/'
datadir = '/media/scidata/pcom/zhangyu/ex_3g/'
#yr_sta = 1
#yr_end = 50
yr_sta = 1
yr_end = 60

for year in range(yr_sta, yr_end + 1):
  mn_sta = (year - 1) * 12 + 1
  mn_end = year * 12
  filenames = ''
  for i in range(mn_sta, mn_end + 1):
    f = datadir + "monthly/N%08d.nc " % i
    filenames += f
  cmd = 'cdo ensmean ' + filenames +  ' ' + datadir +'yearly/year_%04d.nc' % year
#  print(cmd); os.system(cmd)

# calc. climatory mean
#======================
#yr_sta = 41
#yr_end = 50
yr_sta = 51
yr_end = 60

outdir = '/home/ou/archive/data/pcom/climate/zy_ex_3g/'
climate = outdir + 'year_mean_%03d-%03d.nc' % (yr_sta, yr_end)
filenames = ''
for i in range(yr_sta, yr_end + 1):
  f = datadir + "yearly/year_%04d.nc " % i
  filenames += f
cmd = 'cdo ensmean ' + filenames +  ' ' + climate
#print(cmd); os.system(cmd)

# calc. thermalcline
#====================
#infile = '/home/ou/archive/data/pcom/moc_re_s/post/climate_0041-0050.nc'
#infile = '/home/ou/archive/data/pcom/moc_re_s/post/climate_mean_0491-0500.nc'
#infile = '/home/ou/archive/data/soda/climate/climate_1981-2000.nc'
#infile = climate
#outfile = outdir + prefix + 'thc_%04d-%04d_ferret.nc' % (yr_sta, yr_end)
#outfile = outdir + 'soda_thc_1981-2000.nc'
#cmd = 'pyferret -nojnl -script calc_thc.jnl ' + infile + ' ' + outfile
cmd = 'pyferret -nojnl -script calc_thc_soda.jnl ' + infile + ' ' + outfile
#print(cmd); os.system(cmd)

# process data for plot
#=======================
cmd = 'nclrun create_plot_data.ncl'
#print(cmd); os.system(cmd)
