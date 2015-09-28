#!/usr/bin/python

import os
import sys

#oriDir = "/WORK/home/qhyc1/zhangyu/ouniansen/output/EXP_600/"
#newDir = "/WORK/home/qhyc1/zhangyu/ouniansen/output/EXP_600_to_480_to_600/"
#ncpu   = 600

oriDir = "/WORK/home/qhyc1/zhangyu/ouniansen/output/EXP_480/"
newDir = "/WORK/home/qhyc1/zhangyu/ouniansen/output/EXP_600_to_480/"
ncpu   = 480

for i in range(ncpu):
  nc = "ORCAR12_00000720_restart_%04d.nc" % i
  print "cheching " + nc + "~ ~ ~ ~ ~ ~"
  cmd = "cmp " + oriDir + nc + " " + newDir + nc
  stat = os.system(cmd)
  if stat != 0:
    sys.exit()
