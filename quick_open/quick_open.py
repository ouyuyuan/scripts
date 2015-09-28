#!/usr/bin/env python
#_*_coding:utf-8_*_

# Description: quick open frequently reference files and dirs
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: some day before 2012-10
# Last Change: 2013-12-24 20:37:01 BJT

import os
import sys
import omod as om
import argparse

# def. vars <<<1

file_dir = '/home/ou/archive'

files = { 
   'org/attach/fortran/peng2002/Fortran95.pdf': 'Fortran 95, 彭国伦',
   'org/attach/cdo/cdo.pdf': 'CDO manual',
   'org/attach/ncl/language_man_mini.pdf': 'NCL language grammar',
   'org/attach/git/ProGit.pdf': 'Git Pro book',
   'org/attach/python/pythonLearning_3rd.pdf': 'Learning Python',
   'org/attach/makefile/makemanual.pdf': 'GNU Makefile Manual',
   'org/attach/other/ferret_users_guide_v602.pdf': 'Ferret users guide',
   'docs/EmacsColors/EmacsColors.pdf': 'EmacsColors',
   }

dirs = { 
      '~/archive/org/attach/git/git-reference': "git reference",
   }

# show choices func. <<<1

def show_choice (dic, type):
   i = 1
   choices = {}
   names = {}
   for key in dic.keys():
      choices[str(i)] = key
      names[str(i)] = dic[key]
      i += 1

   om.greenLine()
   om.printDic(names)
   choice = raw_input(om.color('\n choose: ','green','bold'))

   if (type == "file"):
      os.chdir(file_dir)
      cmd = 'evince ' + choices[choice] + ' &'
   elif (type == "directory"):
      cmd = 'nautilus ' + choices[choice] + ' &'
   else:
      print("unhandled type")

   os.system(cmd)
   om.regularEnd('Have fun!')

# select files, dirs, etc <<<1

parser = argparse.ArgumentParser()
parser.add_argument('-f', "--file", help = "choose a file", action='store_true')
parser.add_argument('-d', "--directory", help = "choose a directory", action='store_true')
args = parser.parse_args()

if (args.file):
   show_choice (files, "file")
elif (args.directory):
   show_choice (dirs, "directory")
else:
   print("provide -h option for help")
