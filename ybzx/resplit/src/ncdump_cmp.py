#!/usr/bin/python

import os
import sys

oriDir = "/WORK/home/qhyc1/zhangyu/ouniansen/EXP_480/"
newDir = "/WORK/home/qhyc1/zhangyu/ouniansen/test/EXP_600_to_480/"
ncpu   = 480

for i in range(ncpu):
  nc = "ORCAR12_00000720_restart_%04d.nc" % i
  print "cheching " + nc + "~ ~ ~ ~ ~ ~"

  cmd = "ncdump -h "+oriDir+nc+" > ori.txt"
  os.system(cmd)
  cmd = "ncdump -h "+newDir+nc+" > tran.txt"
  os.system(cmd)
  cmd = "cmp ori.txt tran.txt"
  stat = os.system(cmd)
  if stat != 0:
    cmd = "vim -d ori.txt tran.txt"
    #os.system(cmd)

    #sys.exit()

for i in range(ncpu):
  nc = "ORCAR12_00000720_restart_ice_%04d.nc" % i
  print "cheching " + nc + "~ ~ ~ ~ ~ ~"

  cmd = "ncdump -h "+oriDir+nc+" > ori.txt"
  os.system(cmd)
  cmd = "ncdump -h "+newDir+nc+" > tran.txt"
  os.system(cmd)
  cmd = "cmp ori.txt tran.txt"
  stat = os.system(cmd)
  if stat != 0:
    cmd = "vim -d ori.txt tran.txt"
    #os.system(cmd)

    #sys.exit()
