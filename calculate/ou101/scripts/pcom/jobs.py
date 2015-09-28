#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-16 06:59:29 BJT
# Last Change: 2015-07-16 13:09:04 BJT

import os
import sys

def runCmd(cmd): #{{{1
  print(cmd)
  stat = os.system(cmd)
  if stat != 0:
    print("Error happen when run: "+cmd)
    sys.exit()

class Exp: #{{{1
  def __init__(self,datDir):
    if os.path.isdir(datDir):
      self.datDir = datDir
    else:
      print(datDir + " doesn't exist! Stop.")
      sys.exit()

  def run(self, scriptname, *args):
    ext = scriptname.split('.')[-1]
    if ext == 'ncl':
      calculator = 'nclrun '
    elif ext == 'jnl':
      calculator = 'pyferret -nojnl -script '
    elif ext == 'py':
      calculator = 'python '
    else:
      print('Unknown script extension: ' + ext)
      sys.exit()
    if len(args)==0:
      runCmd(calculator + scriptname + ' ' + self.datDir)
    else:
      myargs = " "
      for arg in args:
        myargs = myargs+" "+arg+" "
      runCmd(calculator + scriptname + myargs)

  def mon2yearly(self, yrSta, yrEnd):
    os.chdir(self.datDir)
    for year in range(yrSta, yrEnd + 1):
      mnSta = (year - 1) * 12 + 1
      mnEnd = year * 12
      filenames = ''
      for i in range(mnSta, mnEnd + 1):
        f = "monthly/N%08d.nc " % i
        filenames += f
      cmd = 'cdo ensmean ' + filenames +  ' yearly/year_%04d.nc' % year
      print(cmd)
      os.system(cmd)

  def missing2fillvalue(self, yrSta, yrEnd):
    for year in range(yrSta, yrEnd + 1):
      fin = self.datDir+"output/year_%04d.nc " % year
      fout= self.datDir+"yearly/year_%04d.nc " % year
      self.run("missing2fillvalue.ncl", fin, fout)

#-----------------------------------------------------------
#---set multiple expriment case-------------------------{{{1
for exp in [\
#  "exp52_heaving_Atl_0S-30S",\
#  "exp58_heaving_Atl_0N-30N",\
#  "exp59_heaving_Atl_20S-20N",\
#  "exp62_heaving_Atl_30S-30N_asy",\
#  "exp63_heaving_Atl_30S-30N_sym",\

#   "exp54_heaving_Ind_0S-30S",\
#   "exp61_heaving_Ind_20S-20N",\

#  "exp55_heaving_Pac_0S-30S",\
#  "exp56_heaving_Pac_0N-30N",\
#  "exp57_heaving_Pac_30N-60N",\
#  "exp60_heaving_Pac_20S-20N",\
#  "exp64_heaving_Pac_30S-30N_asy",\
#  "exp65_heaving_Pac_30S-30N_sym",\

#  "exp51_heaving_20S-20N",\
#  "exp53_heaving_Sou_40S-70S",\
#  "exp66_heaving_30N-60N",\
#  "exp67_heaving_30S-30N_asy",\
#  "exp68_heaving_30S-30N_sym",\
#  "exp69_heaving_0N-30N",\
#  "exp70_heaving_0S-30S",\

#   "exp71_heaving_b_Pac_20S-20N",\
#   "exp72_heaving_b_Pac_0N-40N",\
#   "exp73_heaving_b_Pac_20N-60N",\
#   "exp74_heaving_b_Pac_40N-80N",\
#   "exp75_heaving_b_Pac_0S-40S",\
#   "exp76_heaving_b_Pac_20S-60S",\
#   "exp77_heaving_b_40S-80S",\
#   "exp78_heaving_b_Atl_20S-20N",\
#   "exp79_heaving_b_Atl_0N-40N",\
#   "exp80_heaving_b_Pac_40S-40N_sym",\
#   "exp81_heaving_b_Pac_40S-40N_asy",\
#   "exp82_heaving_b_Atl_20N-60N",\
#   "exp83_heaving_b_Atl_40N-80N",\
#   "exp84_heaving_b_20S-20N",\
#   "exp85_heaving_b_0S-40S",\
   "exp89_heaving_b_Atl_0S-40S",\
  ]:
  case = Exp("/snfs01/ou/models/pcom_1.0/exp/"+exp+"/")
  case.missing2fillvalue(601, 720)

#---set experiment case---------------------------------{{{1
case = Exp("/snfs01/ou/models/pcom_1.0/exp/exp_spinup/")
#case = Exp("/snfs01/ou/models/pcom_1.0/exp/exp23_clm_diff_ws/")
#case = Exp("/snfs01/ou/models/pcom_1.0/exp/exp24_taux_an_40y_N/")
#case = Exp("/snfs01/ou/models/pcom_1.0/exp/exp25_clm_diff/")
#case = Exp("/snfs01/ou/models/pcom_1.0/exp/exp34_ws_10S10N_4y/")
#case = Exp("/snfs01/ou/models/pcom_1.0/exp/exp35_acc_only_Sou/output/")
#case = Exp("/snfs01/ou/models/pcom_1.0/exp/exp36_simu_60yrs/")
#case = Exp("/snfs01/ou/models/pcom_1.0/exp/exp37_acc_natural_sal/")
#case = Exp("/media/wd/pcom/exp38_acc_constant_force/")
#case = Exp("/snfs01/ou/models/pcom_1.0/exp/exp39_clm_warm/")
#case = Exp("/snfs01/ou/models/pcom_1.0/exp/exp40_ws_30N60N_4y/")
#case = Exp("/snfs01/ou/models/pcom_1.0/exp/exp40b_ws_30N60N_20y/")
#case = Exp("/snfs01/ou/models/pcom_1.0/exp/exp43_clm_simu_60yrs/")
#case = Exp("/snfs01/ou/models/pcom_1.0/exp/exp44_clm_thermal/")
#case = Exp("/snfs01/ou/models/pcom_1.0/exp/exp45_clm_adi/")
#case = Exp("/snfs01/ou/models/pcom_1.0/exp/exp51_heaving_20S-20N/")
#case = Exp("/snfs01/ou/models/pcom_1.0/exp/exp59_heaving_Atl_20S-20N/")

#case.mon2yearly(801, 867)
#case.missing2fillvalue(601, 720)

#-------------------------------------------------------{{{1
# vim:fdm=marker:fdl=0:
# vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
