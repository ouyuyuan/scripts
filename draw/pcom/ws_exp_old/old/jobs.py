#!/usr/bin/env python

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2014-10-24 08:39:35 BJT
# Last Change: 2014-10-24 15:16:55 BJT

import os
import sys

current_job = 'extract_wind_stress'

class Job:
    def __init__(self,name):
        self.name = name
        self.oscmd = ''

    def execute(self):
      if self.name == current_job:
        if self.oscmd == '':
            print(' oscmd hasnot been set yet. Cannot do any job ')
        else:
          print(self.oscmd)
          os.system(self.oscmd)

job1 = Job('extract_wind_stress')
job1.oscmd = 'nclrun extract_wind_stress.ncl'
job1.execute()
