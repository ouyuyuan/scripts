#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2015-04-12 10:40:38 BJT
# Last Change: 2015-08-10 21:01:53 BJT

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
    self.datDir = "/home/ou/archive/data/pcom/"+name+"/post/"
    self.imgDir = "/home/ou/archive/drawing/pcom/"+name+"/"

#set multiple case once---------------------------------{{{1
for exp in [\
  "exp43_clm_simu_60yrs",\
  "exp44_clm_thermal",\
  "exp45_clm_adi",\
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
    ]:
  case = PcomExp(exp)
  for scr in [\
#      "heaving_01_vec_line_panel_ws_an_eof",\
#      "heaving_01c_ws_an",\
#      "heaving_06f_cn_eof_moc_one_case",\
#      "heaving_09_one_case",\
#      "heaving_10_cn_lat_time_panel_ssh_etc",\
#      "heaving_11_cn_depth_lon_ohc",\
#      "test"
      "heaving_01i_lines_ver_profile_ohc",\
      ]:
    case.img = scr
#    case.run(scr+".ncl")

#set paper issue----------------------------------------{{{1
case = PaperIssue("heaving_0.4")
case.run("01_lines_ver_profile_ohc.ncl")
#case.run("02_cn_depth_ohc.ncl")
#case.run("03_cn_eof_moc.ncl")
#case.run("04_lines_ws_profile.ncl")
#case.run("test.ncl")

#set one case-------------------------------------------{{{1
#case = PcomExp("exp_spinup")
#-------------------------------------------------------{{{1
# vim:fdm=marker:fdl=0:
# vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
