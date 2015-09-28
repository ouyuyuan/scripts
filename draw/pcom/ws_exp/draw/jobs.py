#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-16 06:59:29 BJT
# Last Change: 2014-12-25 07:05:01 BJT

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
      print(datDir+"donesn't exist! Stop.")
      sys.exit()
    if not os.path.isdir(self.imgDir):
      runCmd("mkdir "+self.imgDir)

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
spinup = PcomExp("exp_spinup")
#spinup.img = "ohc_glo_wave___120years"; spinup.run("ohc_glo_wave.ncl")
#spinup.img = "ohc_glo_wave___soda_len"; spinup.run("ohc_glo_wave.ncl")
#spinup.run("ohc_glo_wave.ncl")
#spinup.run("ohc_basin.ncl")
#spinup.img = "ohc_basin___detrend"; spinup.run("ohc_basin.ncl")
#spinup.run("ohc_tro_Pac.ncl")
#spinup.img = "ohc_tro_Pac___detrend"; spinup.run("ohc_tro_Pac.ncl")
#spinup.run("Sou_time_space.ncl")

#ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
exp24 = PcomExp("exp24_taux_an_40y_N")
#exp24.run("ohc_glo_wave.ncl")
#exp24.run("ohc_wave_diff.ncl")
#exp24.run("ohc_basin.ncl")
#exp24.img = "ohc_basin___diff"; exp24.run("ohc_basin.ncl")
#exp24.run("ohc_tro_Pac.ncl")
#exp24.img = "ohc_tro_Pac___diff"; exp24.run("ohc_tro_Pac.ncl")

#ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
exp33 = PcomExp("exp33_ws_60S30S_40y")
#exp33.run("ohc_glo_wave.ncl")
#exp33.run("ohc_wave_diff.ncl")
#exp33.run("ohc_basin.ncl")
#exp33.img = "ohc_basin___diff"; exp33.run("ohc_basin.ncl")
#exp33.run("ohc_tro_Pac.ncl")
#exp33.img = "ohc_tro_Pac___diff"; exp33.run("ohc_tro_Pac.ncl")

#ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
exp34 = PcomExp("exp34_ws_10S10N_4y")
#exp34.run("ohc_glo_wave.ncl")
#exp34.run("ohc_wave_diff.ncl")
#exp34.run("ohc_basin.ncl")
#exp34.img = "ohc_basin___diff"; exp34.run("ohc_basin.ncl")
#exp34.run("ohc_tro_Pac.ncl")
#exp34.img = "ohc_tro_Pac___diff"; exp34.run("ohc_tro_Pac.ncl")

#ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
exp39 = PcomExp("exp39_clm_warm")
#exp39.run("ohc_glo_wave.ncl")
#exp39.run("ohc_wave_diff.ncl")
#exp39.run("ohc_basin.ncl")
#exp39.img = "ohc_basin___diff"; exp39.run("ohc_basin.ncl")
#exp39.run("ohc_tro_Pac.ncl")
#exp39.img = "ohc_tro_Pac___diff"; exp39.run("ohc_tro_Pac.ncl")

#ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
exp40 = PcomExp("exp40_ws_aao")
#exp40.run("aao_index.ncl")
