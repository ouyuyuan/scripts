#!/usr/bin/python

import os
import sys

#oriDir = "/WORK/home/qhyc1/zhangyu/ouniansen/output/EXP_600/"
#newDir = "/WORK/home/qhyc1/zhangyu/ouniansen/output/EXP_600_to_480_to_600/"
#ncpu   = 600

#oriDir = "/WORK/home/qhyc1/zhangyu/ouniansen/output/EXP_480/"
oriDir = "/WORK/home/qhyc1/zhangyu/ouniansen/EXP_480/"
newDir = "/WORK/home/qhyc1/zhangyu/ouniansen/output/EXP_480_to_480/"
ncpu   = 480

for i in range(ncpu):
#for i in range(311,340):
  nc = "ORCAR12_00000720_restart_%04d.nc" % i
  print "cheching " + nc + "~ ~ ~ ~ ~ ~"
  cmd = "cmp " + oriDir + nc + " " + newDir + nc
  stat = os.system(cmd)
  if stat != 0:
    cmd = "ncdump "+oriDir+nc+" > ori.txt"
    os.system(cmd)

    cmd = "ncdump "+newDir+nc+" > tran.txt"
    os.system(cmd)

    cmd = "vim -d ori.txt tran.txt"
    #os.system(cmd)

    #sys.exit()
