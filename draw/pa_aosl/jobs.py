#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-16 06:59:29 BJT
# Last Change: 2015-04-16 18:15:09 BJT

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
    self.datDir = "/home/ou/archive/data/pcom/input/"
    self.imgDir = "/home/ou/archive/drawing/pcom/"
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

#ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
script = Script()
#script.img = "draw_01_cn_polar_map___Sou_basin.ncl"
#script.run("draw_01_cn_polar_map.ncl")

#script.img = "draw_02_vec_cn_polar_map_panel___Sou_force.ncl"
#script.run("draw_02_vec_cn_polar_map_panel.ncl")

exp = PcomExp("exp43_clm_simu_60yrs")
exp.img = "draw_015_lines_yLyR_panel___ohc___Sou"
exp.run("draw_015_lines_yLyR_panel.ncl")

#script.run("test.ncl")
