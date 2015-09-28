#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-11-16 06:59:29 BJT
# Last Change: 2014-12-01 08:53:41 BJT

import os
import sys

jobnames = [
#'ssh',
'ssh_eof',
]

def runCmd(cmd):
  print(cmd)
  stat = os.system(cmd)
  if stat != 0:
    print("Error happen when run: "+cmd)
    sys.exit()

class Job:
  def __init__(self,name):
    self.name = name
    self.datDir = '/home/ou/archive/data/pcom/moc_re_s/'
    self.calcscript = ''

  def calc(self):
    cmd = "mkdir -p " + self.datDir
    print(cmd); os.system(cmd)
    scriptname = self.calcscript
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
    runCmd(calculator + scriptname + ' ' + self.datDir)

# automatically execute jobs
#============================
for jobname in jobnames:
  job = Job(jobname)
  nclscript = jobname+'.ncl'
  pyscript  = jobname+'.py'
  if os.path.isfile(nclscript):
    job.calcscript = nclscript
    job.calc()
  elif os.path.isfile(pyscript):
    job.calcscript = pyscript
    job.calc()
  else:
    pass
