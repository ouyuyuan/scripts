#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2015-03-04 20:19:48 BJT
# Last Change: 2015-09-08 17:34:07 BJT

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
#ishii.img = "ohc_basin___detrend"; ishii.run("ohc_basin.ncl")
#ishii.run("ohc_basin.ncl")

#ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
soda = Soda()
#soda.run("ohc_glo_wave.ncl")
#soda.run("ohc_glo_wave_piecewise_detrend.ncl")

#ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
exp = PcomExp("exp_spinup")
#exp = PcomExp("zy_ex_3g")

#exp.img = "core_01_lines_yLyR_t_s_glo_ave"
#exp.run("core_01_lines_yLyR.ncl")

#exp.img = "core_01b_drake_transport"
#exp.run("core_01b_lines_yTyB.ncl")

#exp.img = "core_02_cn_yUyB_panel_t_s_layer_ave"
#exp.run("core_02_cn_yUyB_panel.ncl")

#exp.img = "core_03_cn_lines_overlay_panel_sst_sss"
#exp.run("core_03_cn_map_lines_overlay_panel.ncl")

exp.img = "core_04_eq_Pacific_temp"
exp.run("core_04_cn_depth_lon_overlay_line_panel.ncl")

#exp.img = "core_04b_eq_Pacific_u"
#exp.run("core_04b_cn_depth_lon_panel.ncl")

#exp.img = "core_04c_moc"
#exp.run("core_04c_cn_depth_lon_panel.ncl")

#exp.run("test.ncl")
#exp.run("test2.ncl")

#ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
#script = Script()
#script.run("aao_index.ncl")
