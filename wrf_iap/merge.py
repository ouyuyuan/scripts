#!/usr/bin/python

import os

path = "/media/output4/pre/"

for char in ['a', 'b', 'c', 'd', 'e']:
  for num in ['1', '2', '3', '4', '5', '6']:
    files = path + char + '_' + num + '/pre.*' 
    nc    = path + '/pre_' + char + num + '.nc'
    cmd   = 'cdo mergetime ' + files + ' ' + nc
    print cmd
#      os.system(cmd)
