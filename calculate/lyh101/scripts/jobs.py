#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-16 06:59:29 BJT
# Last Change: 2015-07-22 17:00:48 BJT

import os
import sys

data_root = "/snfs01/lyh/ou/data/"

def runCmd(cmd): #{{{1
  print(cmd)
  stat = os.system(cmd)
  if stat != 0:
    print("Error happen when run: "+cmd)
    sys.exit()

class Script: #{{{1
  def __init__(self):
    self.name = ""
    self.datDir = ""

  def run(self, scriptname, *args):
    self.name = scriptname
    if not os.path.isdir(self.datDir):
      print(self.datDir+"donesn't exist! Stop.")
      sys.exit()
    ext = self.name.split('.')[-1]
    if ext == 'ncl':
      calculator = 'nclrun '
    elif ext == 'jnl':
      calculator = 'pyferret -nojnl -script '
    elif ext == 'py':
      calculator = 'python '
    else:
      print('Unknown script extension: ' + ext)
      sys.exit()
    myargs = self.datDir
    if len(args)>0:
      for arg in args:
        myargs = myargs+" "+arg+" "
    runCmd(calculator + self.name + " " + myargs)

  def cal_climate(self, yb, ye):
     os.chdir(self.datDir)
     filenames = ''
     for i in range(yb, ye + 1):
       f = "yearly/year_%04d.nc " % i
       filenames += f
     cmd = 'cdo ensmean '+filenames+' post/climate_y%04d-y%04d.nc' % (yb,ye)
     runCmd(cmd)

class Ishii(Script): #{{{1
  def __init__(self):
    Script.__init__(self)
    self.datDir = data_root+"Ishii/"

  def grb2nc(self, varName, yb, ye):
    for yr in range(yb, ye + 1):
      grb = self.datDir+"grb/"+varName+".%4d.grb" % yr
      nc  = self.datDir+"monthly/"+varName+".%4d.nc"  % yr
      runCmd('cdo -f nc copy '+grb+' '+nc)

class Ishii_pcom(Ishii): #{{{1
  def __init__(self):
    Script.__init__(self)
    self.datDir = data_root+"Ishii/pcom_grid/"

class PcomExp(Script): #{{{1
  def __init__(self, expName):
    Script.__init__(self)
    self.datDir = data_root+"pcom/"+expName+"/"

class Soda(Script): #{{{1
  def __init__(self):
    Script.__init__(self)
    self.datDir = data_root+"soda/pcom_grid/"

class Woa(Script): #{{{1
  def __init__(self):
    Script.__init__(self)
    self.datDir = data_root+"woa09/pcom_grid/"

#process Ishii data-------------------------------------{{{1
#ishii = Ishii()

#ishii.grb2nc("temp", 1945, 2012)
#ishii.grb2nc("sal", 1945, 2012)
#ishii.run("grid_info.ncl")
#ishii.run("basin.ncl")
#ishii.run("ohc.ncl", "1945", "2012")
#ishii.run("sst.ncl", "1945", "2012")
#ishii.run("Sou_time_space.ncl", "1945", "2012")
#ishii.run("ohc_v2.ncl", "___Sou_1500")

#ishii = Ishii_pcom()
#ishii.run("calc_001_ohc.ncl", "1945", "2012")
#ishii.run("calc_002_sst.ncl", "1945", "2012")


#set multiple expriment case-60 years experiments-------{{{1
for exp in [\
#  "exp43_clm_simu_60yrs",\
#  "exp44_clm_thermal",\
#  "exp45_clm_adi",\
 'exp55_heaving_Pac_0S-30S',\
 'exp56_heaving_Pac_0N-30N',\
# 'exp57_heaving_Pac_30N-60N',\
 'exp60_heaving_Pac_20S-20N',\
# 'exp64_heaving_Pac_30S-30N_asy',\
# 'exp65_heaving_Pac_30S-30N_sym',\
# 'exp52_heaving_Atl_0S-30S',\
# 'exp58_heaving_Atl_0N-30N',\
# 'exp59_heaving_Atl_20S-20N',\
# 'exp62_heaving_Atl_30S-30N_asy',\
# 'exp63_heaving_Atl_30S-30N_sym',\
#  "exp51_heaving_20S-20N",\
#  "exp66_heaving_30N-60N",\
#  "exp67_heaving_30S-30N_asy",\
#  "exp68_heaving_30S-30N_sym",\
#  "exp69_heaving_0N-30N",\
#  "exp70_heaving_0S-30S",\
#  "exp53_heaving_Sou_40S-70S",\
#  "exp54_heaving_Ind_0S-30S",\
#  "exp61_heaving_Ind_20S-20N",\
# 'exp_spinup',\
  ]:
  case = PcomExp(exp)
  for scr in [\
    'calc_001e_cn_depth_time_ohc',\
#    'calc_004_merge_ws_anom',\
#    'calc_004b_merge_ssh',\
#    'calc_006b_dtc',\
#    'calc_006c_bsf',\
#    'calc_006d_ohc',\
##    'calc_001f_ohc_4d',\
#    'calc_006e_dvol',\
#    'calc_006f_ohc_depth_lon',\
#    'calc_006g_ohc_depth_lat',\
#    'calc_006h_dtc_flux',\
#    'calc_10b_moc_years',\
#    'calc_17_cn_lat_time_dv',\
    ]:
    if (scr == 'calc_006d_ohc'):
#      case.run(scr+'.ncl', '601', '720', '0', '700')
#      case.run(scr+'.ncl', '601', '720', '0', '300')
#      case.run(scr+'.ncl', '601', '720', '0', '1500')
#      case.run(scr+'.ncl', '601', '720', '300', '1500')
#      case.run(scr+'.ncl', '601', '720', '700', '1500')
       pass
    else:
#      case.run(scr+'.ncl', '601', '660')
      pass

#set multiple expriment case-120 years experiments------{{{1
for exp in [\
# 'exp_spinup',\
  "exp71_heaving_b_Pac_20S-20N",\
  "exp72_heaving_b_Pac_0N-40N",\
#  "exp73_heaving_b_Pac_20N-60N",\
#  "exp74_heaving_b_Pac_40N-80N",\
  "exp75_heaving_b_Pac_0S-40S",\
#  "exp76_heaving_b_Pac_20S-60S",\
  "exp78_heaving_b_Atl_20S-20N",\
  "exp79_heaving_b_Atl_0N-40N",\
#  "exp80_heaving_b_Pac_40S-40N_sym",\
#  "exp81_heaving_b_Pac_40S-40N_asy",\
#  "exp82_heaving_b_Atl_20N-60N",\
  "exp89_heaving_b_Atl_0S-40S",\
  ]:
  case = PcomExp(exp)
  for scr in [\
    'calc_001e_cn_depth_time_ohc',\
#    'calc_004_merge_ws_anom',\
#    'calc_004b_merge_ssh',\
#    'calc_006b_dtc',\
#    'calc_006c_bsf',\
#    'calc_006d_ohc',\
#    'calc_006e_dvol',\
#    'calc_006f_ohc_depth_lon',\
#    'calc_006g_ohc_depth_lat',\
#    'calc_006h_dtc_flux',\
#    'calc_10b_moc_years',\
#    'calc_17_cn_lat_time_dv',\
    ]:
    if (scr == 'calc_006d_ohc'):
      case.run(scr+'.ncl', '601', '720', '0', '700')
#      case.run(scr+'.ncl', '601', '720', '0', '300')
#      case.run(scr+'.ncl', '601', '720', '0', '1500')
#      case.run(scr+'.ncl', '601', '720', '300', '1500')
#      case.run(scr+'.ncl', '601', '720', '700', '1500')
#       pass
    else:
      case.run(scr+'.ncl', '601', '720')
#      case.run(scr+'.ncl', '501', '560')
#      pass

#set multiple expriment case, 240 years experiments-----{{{1
for exp in [\
  'exp_spinup',\
#  "exp77_heaving_b_40S-80S",\
  ]:
  case = PcomExp(exp)
  for scr in [\
    'calc_001e_cn_depth_time_ohc',\
#    'calc_004_merge_ws_anom',\
#    'calc_004b_merge_ssh',\
#    'calc_006b_dtc',\
#    'calc_006c_bsf',\
#    'calc_006d_ohc',\
#    'calc_006e_dvol',\
#    'calc_006f_ohc_depth_lon',\
#    'calc_006g_ohc_depth_lat',\
#    'calc_006h_dtc_flux',\
#    'calc_10b_moc_years',\
#    'calc_17_cn_lat_time_dv',\
    ]:
    if (scr == 'calc_006d_ohc'):
      case.run(scr+'.ncl', '601', '840', '0', '700')
#      case.run(scr+'.ncl', '601', '840', '0', '300')
#      case.run(scr+'.ncl', '601', '840', '0', '3000')
#      case.run(scr+'.ncl', '601', '840', '300', '1500')
#      case.run(scr+'.ncl', '601', '840', '700', '1500')
#       pass
    else:
      case.run(scr+'.ncl', '601', '840')
#      pass

#set experiment case------------------------------------{{{1
#case = Soda()
#case = Woa()
#case = PcomExp("exp_spinup")
#case = PcomExp("zy_ex_3g")
#case = PcomExp("exp24_taux_an_40y_N")
#case = PcomExp("exp33_ws_60S30S_40y")
#case = PcomExp("exp34_ws_10S10N_4y")
#case = PcomExp("exp36_simu_60yrs")

#case = PcomExp("exp38_acc_constant_force")
#case.datDir = "/media/wd/pcom/exp38_acc_constant_force/"

#case = PcomExp("exp39_clm_warm")
#case = PcomExp("exp40_ws_30N60N_4y")
#case = PcomExp("exp40b_ws_30N60N_20y")
#case = PcomExp("exp43_clm_simu_60yrs")
#case = PcomExp("exp44_clm_thermal")
#case = PcomExp("exp45_clm_adi")
#case = PcomExp("exp51_heaving_20S-20N")
#case = PcomExp("exp55_heaving_Pac_0S-30S")
#case = PcomExp("exp56_heaving_Pac_0N-30N")
#case = PcomExp("exp57_heaving_Pac_30N-60N")
#case = PcomExp("exp60_heaving_Pac_20S-20N")
#case = PcomExp("exp64_heaving_Pac_30S-30N_asy")
#case = PcomExp("exp65_heaving_Pac_30S-30N_sym")
#run internal function----------------------------------{{{1
#case.cal_climate(1961,1990)

#run external script------------------------------------{{{1
#case.run("calc_001_ohc.ncl", "501", "758")
#case.run("calc_001c_ohc.ncl", "501", "747")
#case.run("calc_001d_ohc_isothermal.ncl", "667", "758", "merge")

#case.run("calc_001e_cn_depth_time_ohc.ncl", "601", "720")

#case.run("calc_002_sst.ncl", "501", "758")
#case.run("calc_002b_sst_cn.ncl", "501", "639")
#case.run("calc_002c_sst_boxes.ncl", "501", "747")
#case.run("Sou_time_space.ncl", "501", "747")

#case.run("calc_004_merge_ws_anom.ncl", "601", "720")

#case.run("calc_004b_merge_ssh.ncl", "601", "720")

#case.run("calc_005_temp_depth_time.ncl", "640", "640", "merge")

#case.run("calc_006_isothermal_depth.ncl", "601", "660")

#case.run("calc_006b_dtc.ncl", "601", "720")

#case.run("calc_006c_bsf.ncl", "601", "720")

#case.run("calc_006d_ohc.ncl", "601", "660", "0", "700")

#case.run("calc_007_ave_isothermal.ncl")
#case.run("calc_08_glo_vol_ave.ncl","60","pt")
#case.run("calc_08_glo_vol_ave.ncl","60","sa")

#case.run("calc_09_layer_ave.ncl","800")
#case.run("calc_10_moc.ncl")

#case.run("calc_10b_moc_years.ncl", "601", "720")

#case.run("calc_11_drake_transport.ncl", "1", "800")

#case.run("calc_13_cn_dtc.ncl", "temperature_annual_1deg.nc")
#case.run("calc_13_cn_dtc.ncl", "post/climate_y0591-y0600.nc")
#case.run("calc_13_cn_dtc.ncl", "post/climate_y1949-y2008.nc")

#case.run("calc_14_cn_bsf.ncl", "post/climate_y1961-y1990.nc")

#case.run("calc_15_cn_ohc.ncl", "post/climate_y0591-y0600.nc", "0", "700")
#case.run("calc_15_cn_ohc.ncl", "temperature_annual_1deg.nc", "0", "700")

#case.run("calc_16_eof_dtc_diff.ncl")

#case.run("calc_17_cn_lat_time_dv.ncl","601","720")

#case.run("calc_18_cn_lat_time_pht.ncl","601","660")


#run test script----------------------------------------{{{1
#case.run("test.ncl")
#case.run("test.ncl", "post/climate_y0601-y0660.nc")

#-------------------------------------------------------{{{1
# vim:fdm=marker:fdl=0:
# vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
