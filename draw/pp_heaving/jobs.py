#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2015-04-12 10:40:38 BJT
# Last Change: 2015-08-03 16:12:20 BJT

import os
import sys

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
    self.imgDir = ""
    self.img = ""

  def run(self, scriptname, *args):
    self.name = scriptname
    if self.img == "":
      self.img = self.name.split('.')[0]
    if not os.path.isdir(self.datDir):
      runCmd("mkdir -p "+self.datDir)
    if not os.path.isdir(self.imgDir):
      runCmd("mkdir -p "+self.imgDir)

    ext = self.name.split('.')[-1]
    if ext == 'ncl':
      calculator = 'nclrun '
    elif ext == 'jnl':
      calculator = 'pyferret -nojnl -script '
    else:
      print('Unknown script extension: ' + ext)
      sys.exit()
    myargs = self.datDir+" "+self.imgDir+self.img
    if len(args)>0:
      for arg in args:
        myargs = myargs+" "+arg+" "
    runCmd(calculator + self.name + " " + myargs)

class PaperIssue(Script): #{{{1
  def __init__(self,name):
    Script.__init__(self)
    self.datDir = "/home/ou/archive/data/pp_"+name+"/"
    self.imgDir = "/home/ou/archive/drawing/pp_"+name+"/"

class PcomExp(Script): #{{{1
  def __init__(self,name):
    Script.__init__(self)
    self.datDir = "/media/wd/pcom/"+name+"/post/"
    self.imgDir = "/home/ou/archive/drawing/pcom/"+name+"/"

class Ishii(Script): #{{{1
  def __init__(self):
    Script.__init__(self)
    self.datDir = "/home/ou/archive/data/Ishii/post/"
    self.imgDir = "/home/ou/archive/drawing/Ishii/"

class Soda(Script): #{{{1
  def __init__(self):
    Script.__init__(self)
    self.datDir = "/home/ou/archive/data/soda/pcom_grid/post/"
    self.imgDir = "/home/ou/archive/drawing/soda/"

#---general script--------------------------------------{{{1
#script = Script()
#script.run("aao_index.ncl")

#---Ishii data------------------------------------------{{{1
#ishii = Ishii()
#ishii.img = "ohc_basin___detrend"; ishii.run("ohc_basin.ncl")
#ishii.run("ohc_basin.ncl")

#---Soda data-------------------------------------------{{{1
#case = Soda()
#case.run("ohc_glo_wave.ncl")
#case.run("ohc_glo_wave_piecewise_detrend.ncl")

#---set multiple case once------------------------------{{{1
for exp in [\
#  "exp43_clm_simu_60yrs",\
#  "exp44_clm_thermal",\
#  "exp45_clm_adi",\
#  'exp55_heaving_Pac_0S-30S',\
#  'exp56_heaving_Pac_0N-30N',\
#  'exp57_heaving_Pac_30N-60N',\
#  'exp60_heaving_Pac_20S-20N',\
#  'exp64_heaving_Pac_30S-30N_asy',\
#  'exp65_heaving_Pac_30S-30N_sym',\
#  'exp52_heaving_Atl_0S-30S',\
#  'exp58_heaving_Atl_0N-30N',\
#  'exp59_heaving_Atl_20S-20N',\
#  'exp62_heaving_Atl_30S-30N_asy',\
#  'exp63_heaving_Atl_30S-30N_sym',\
#  "exp51_heaving_20S-20N",\
#  'exp66_heaving_30N-60N',\
#  "exp67_heaving_30S-30N_asy",\
#  "exp68_heaving_30S-30N_sym",\
#  "exp69_heaving_0N-30N",\
#  "exp70_heaving_0S-30S",\
#  "exp53_heaving_Sou_40S-70S",\
#  "exp54_heaving_Ind_0S-30S",\
#  "exp61_heaving_Ind_20S-20N",\

#  "exp_spinup",\
#  "exp71_heaving_b_Pac_20S-20N",\
#  "exp72_heaving_b_Pac_0N-40N",\
#  "exp73_heaving_b_Pac_20N-60N",\
#  "exp74_heaving_b_Pac_40N-80N",\
#  "exp75_heaving_b_Pac_0S-40S",\
#  "exp76_heaving_b_Pac_20S-60S",\
#  "exp78_heaving_b_Atl_20S-20N",\
#  "exp79_heaving_b_Atl_0N-40N",\
#  "exp80_heaving_b_Pac_40S-40N_sym",\
#  "exp81_heaving_b_Pac_40S-40N_asy",\
#  "exp82_heaving_b_Atl_20N-60N",\

  "exp92_heaving_c_Pac_20S-20N",\
  "exp93_heaving_c_Pac_0N-40N",\
  "exp94_heaving_c_Pac_0S-40S",\
    ]:
  case = PcomExp(exp)
  for scr in [\
      "heaving_01_vec_line_panel_ws_an_eof",\
#      "heaving_01c_ws_an",\
#      "heaving_06f_cn_eof_moc_one_case",\
#      "heaving_09_one_case",\
#      "heaving_10_cn_lat_time_panel_ssh_etc",\
#      "heaving_11_cn_depth_lon_ohc",\
#      "test"
#      "heaving_01i_lines_ver_profile_ohc",\
      ]:
    case.img = scr
    case.run(scr+".ncl")

#---set multiple case once, 240 years experiments-------{{{1
for exp in [\

#  "exp_spinup",\
  "exp77_heaving_b_40S-80S",\
    ]:
  case = PcomExp(exp)
  for scr in [\
#      "heaving_01_vec_line_panel_ws_an_eof",\
#      "heaving_01cb_ws_an",\
#      "heaving_06i_cn_eof_moc_one_case",\
#      "heaving_09_one_case",\
#      "heaving_10_cn_lat_time_panel_ssh_etc",\
#      "heaving_10d_cn_lat_time_ssh_etc",\
#      "heaving_11_cn_depth_lon_ohc",\
#      "test"
      ]:
    case.img = scr
#    case.run(scr+".ncl")

#set paper issue----------------------------------------{{{1
case = PaperIssue("heaving")
#case.run("heaving_01d_ws_an_profile.ncl")
#case.run("heaving_01db_ws_curl.ncl")
#case.run("heaving_01e_lines_ssh_etc.ncl")
#case.run("heaving_01f_lines_moc.ncl")
#case.run("heaving_01g_lines_ver_profile_ohc.ncl")
#case.run("heaving_01gb_lines_ver_profile_ohc.ncl")
#case.run("heaving_01gc_lines_ver_profile_ohc.ncl")
#case.run("heaving_01h_lines_ver_profile_vhf.ncl")
#case.run("heaving_01j_lines_ver_profile_ohc.ncl")
#case.run("heaving_01k_lines_ver_int_ohc.ncl")
#case.run("heaving_01kb_lines_ver_int_ohc.ncl")
#case.run("heaving_01kc_lines_ver_int_ohc.ncl")
#case.run("heaving_01m_lines_ver_ohc.ncl")
#case.run("heaving_04c_cn_lat_time_obs_ws.ncl")
#case.run("heaving_04d_cn_lat_time_obs_curl.ncl")
#case.run("heaving_09_one_case.ncl")
#case.run("heaving_06g_cn_eof_moc_multi_case.ncl")
#case.run("heaving_06h_cn_eof_ohc.ncl")
#case.run("heaving_06j_cn_eof_moc_Sou.ncl")
#case.run("heaving_10b_cn_lat_time_moc.ncl")
#case.run("heaving_10c_cn_lat_time_moc_net.ncl")
#case.run("heaving_12_cn_map_bsf.ncl")
#case.run("heaving_11b_cn_depth_lon_ohc.ncl")
#case.run("heaving_11c_cn_depth_lat_ohc.ncl")
#case.run("test.ncl")

#set one case-------------------------------------------{{{1
#case = PcomExp("exp_spinup")
#case = PcomExp("zy_e_3g")

#case = PcomExp("exp51_heaving_20S-20N")
#case = PcomExp("exp55_heaving_Pac_0S-30S")
#case = PcomExp("exp56_heaving_Pac_0N-30N")
#case = PcomExp("exp57_heaving_Pac_30N-60N")
#case = PcomExp("exp59_heaving_Atl_20S-20N")
#case = PcomExp("exp60_heaving_Pac_20S-20N")
#case = PcomExp("exp64_heaving_Pac_30S-30N_asy")
#case = PcomExp("exp65_heaving_Pac_30S-30N_sym")
#case = PcomExp("exp71_heaving_b_Pac_20S-20N")

#run external script for a case-------------------------{{{1
#case.img = "heaving_01_ws_an"
#case.run("heaving_01_vec_line_panel_ws_an_eof.ncl")

#case.img = "heaving_01b_ws_an"
#case.run("heaving_01b_vec_ws_an.ncl")

#case.img = "heaving_02_states"
#case.run("heaving_02_cn_map_panel_states.ncl")

#case.img = "heaving_02b_diff_states"
#case.run("heaving_02b_cn_map_panel_diff_states.ncl")

#case.img = "heaving_03_time_coef"
#case.run("heaving_03_line_time_coef.ncl")

#case.img = "heaving_04_dvol"
#case.run("heaving_04_cn_lat_time_panel_dvol.ncl")

#case.img = "heaving_04b_dvol_P"
#case.run("heaving_04b_cn_lat_time_panel_dvol_P.ncl")

#case.img = "heaving_05_pht"
#case.run("heaving_05_cn_lat_time_panel_pht.ncl")

#case.img = "heaving_06_moc_eof"
#case.run("heaving_06_cn_eof_moc.ncl")

#case.img = "heaving_06b_moc_P"
#case.run("heaving_06b_cn_eof_moc_P.ncl")

#case.img = "heaving_06c_dtc_P"
#case.run("heaving_06c_cn_eof_dtc_P.ncl")

#case.img = "heaving_06d_bsf_P"
#case.run("heaving_06d_cn_eof_bsf_P.ncl")

#case.img = "heaving_06e_ssh_P"
#case.run("heaving_06e_cn_eof_ssh_P.ncl")

#case.img = "heaving_07_ohc"
#case.run("heaving_07_cn_depth_time_ohc.ncl")

#case.img = "heaving_07b_vhf"
#case.run("heaving_07b_cn_depth_time_vhf.ncl")

#case.img = "heaving_07c_ohc_P"
#case.run("heaving_07c_cn_depth_time_ohc_P.ncl")

#case.img = "heaving_08_Pac_ws_an"
#case.run("heaving_08_vec_panel_Pac_ws_an.ncl")


#---run test script-------------------------------------{{{1
#case.run("test.ncl")
#case.run("test2.ncl")
#-------------------------------------------------------{{{1
# vim:fdm=marker:fdl=0:
# vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
