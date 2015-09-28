#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-16 06:59:29 BJT
# Last Change: 2015-04-21 16:05:21 BJT

import os
import sys

def runCmd(cmd):
  print(cmd)
  stat = os.system(cmd)
  if stat != 0:
    print("Error happen when run: "+cmd)
    sys.exit()

class Script:
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

class PaperIssue(Script):
  def __init__(self,name):
    Script.__init__(self)
    self.datDir = "/home/ou/archive/data/pp_"+name+"/"
    self.imgDir = "/home/ou/archive/drawing/pp_"+name+"/"

class PcomExp(Script):
  def __init__(self,name):
    Script.__init__(self)
    self.datDir = "/home/ou/archive/data/pcom/"+name+"/post/"
    self.imgDir = "/home/ou/archive/drawing/pcom/"+name+"/"

class Ishii(Script):
  def __init__(self):
    Script.__init__(self)
    self.datDir = "/home/ou/archive/data/Ishii/post/"
    self.imgDir = "/home/ou/archive/drawing/Ishii/"

class Soda(Script):
  def __init__(self):
    Script.__init__(self)
    self.datDir = "/home/ou/archive/data/soda/pcom_grid/post/"
    self.imgDir = "/home/ou/archive/drawing/soda/"

#ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
ishii = Ishii()
#ishii.img = "ohc_basin___Chen2014"; ishii.run("ohc_basin.ncl")
#ishii.img = "ohc_basin___detrend"; ishii.run("ohc_basin.ncl")
#ishii.run("ohc_basin.ncl")
#ishii.run("ohc_glo_wave.ncl")
#ishii.run("ohc_glo_wave_piecewise_detrend.ncl")
#ishii.run("Sou_time_space.ncl")
#ishii.img = "Sou_time_space___White1996"; ishii.run("Sou_time_space.ncl")
#ishii.img = "Sou_time_space_3d___White1996"; ishii.run("Sou_time_space_3d.ncl")
#ishii.run("ohc_depths_time.ncl")
#ishii.run("sst_wave.ncl")
#ishii.img = "ohc_wave___Sou"; ishii.run("ohc_wave.ncl")

#ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
soda = Soda()
#soda.run("ohc_glo_wave.ncl")
#soda.run("ohc_glo_wave_piecewise_detrend.ncl")

#ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
#exp = PcomExp("exp_spinup")
exp = PcomExp("exp24_taux_an_40y_N")
#exp = PcomExp("exp33_ws_60S30S_40y")
#exp = PcomExp("exp34_ws_10S10N_4y")
#exp = PcomExp("exp36_simu_60yrs")
#exp = PcomExp("exp39_clm_warm")
#exp = PcomExp("exp40_ws_30N60N_4y")
#exp = PcomExp("exp40b_ws_30N60N_20y")
#exp = PcomExp("exp43_clm_simu_60yrs")
#exp = PcomExp("exp44_clm_thermal")
#exp = PcomExp("exp45_clm_adi")

#exp.img = "ohc_glo_wave___soda_len"
#exp.img = "ohc_glo_wave___120years"
#exp.run("ohc_glo_wave.ncl")

#exp.run("ohc_wave_diff.ncl")

#exp.img = "draw_001_ohc_basin___diff"
#exp.img = "draw_001_ohc_basin___revise"
#exp.img = "ohc_basin___detrend"
#exp.run("draw_001_ohc_basin.ncl")

#exp.img = "ohc_tro_Pac___detrend"
#exp.img = "draw_004_ohc_tro_Pac___diff"
#exp.run("draw_004_ohc_tro_Pac.ncl")

#exp.img = "draw_012_cn_depths_time_panel___ohc___Sou"
#exp.run("draw_012_cn_depths_time_panel.ncl")

#exp.img = "draw_013_line_wavelet___nino34"
#exp.run("draw_013_line_wavelet.ncl")

#exp.run("Sou_time_space.ncl")

#exp.img = "draw_013_line_wavelet___nino34___120yr"
#exp.run("draw_013_line_wavelet.ncl")

#exp.img = "draw_016_cn_depth_time___ohc___Sou.ncl"
#exp.run("draw_016_cn_depth_time.ncl")

#exp.img = "draw_017_lines_panel___ohc___Sou.ncl"
#exp.run("draw_017_lines_panel.ncl")

#exp.img = "draw_017_02_lines_panel_dtc___nino_timescale"
#exp.img = "draw_017_02_lines_panel_dtc___decadal_timescale"
#exp.run("draw_017_02_lines_panel_dtc.ncl")
#exp.img = "draw_017c_lines_panel_ohc___vol"
#exp.img = "draw_017c_lines_panel_ohc_isothermal___nino34"
#exp.run("draw_017c_lines_panel_ohc_isothermal.ncl")

#exp.run("draw_018_vec_line_panel_ws_eof.ncl")

#exp.run("draw_019_line_wavelet_panel_nino34.ncl")
#exp.run("draw_019b_line_wavelet_panel_ohc_isot20.ncl")
#exp.run("draw_019c_line_wavelet_panel_ninos.ncl")
#exp.run("draw_019d_line_wavelet_panel_boxes.ncl")
#exp.run("draw_020_cn_depths_time_panel_ohc_tro_Pac.ncl")

#exp.run("draw_021_cn_depth_time_temp_nino_filter.ncl")

exp.run("test.ncl")

#ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
script = Script()
#script.run("aao_index.ncl")
