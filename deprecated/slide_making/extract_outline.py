#!/usr/bin/env python
#_*_coding:utf-8_*_

# Description: extract outlines from hierarchy of *.asy
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-12-07 10:54:13 BJT
# Last Change: 2013-12-08 16:52:21 BJT

import re
import os
import sys
import glob
sys.path.append(os.getcwd())
import slide_config as cfg

# def. var <<<1
# re paterns
p_hier = re.compile(r'^\W+@hierarchy:\s*(?P<hier>.+?)\s*$')
p_lev  = re.compile(r'(?P<a>.+?)\s*\|\s*(?P<b>.+)')
sections = []
# the value of the dict is a list
subsections = {}

# capture hierarchy line <<<1
files = glob.glob(cfg.Path.draws)
for file in files:
   for line in open(file,"r"):
      if p_hier.match(line):
         hier = p_hier.match(line).group('hier') + '<' + file + '>'
# a 2-level hierarchy <<<2
         if p_lev.match(hier):
            sec = p_lev.match(hier).group('a')
            subsec = p_lev.match(hier).group('b')
# store subsections <<<2
            if sec not in subsections.keys():
               subsections[sec] = []
            subsections[sec].append(subsec)
         else:
            sec = hier
# store sections <<<2
         if sec not in sections:
            sections.append(sec)
         break

# read old order of outline <<<1
oldsections = []
oldsubsections = {}
p_sec = re.compile(r'^\w+')
p_subsec = re.compile(r'^\t')
sec = ""
try:
   for line in open(cfg.Path.outline, 'r'):
      if p_sec.match(line):
         sec = line.rstrip().lstrip()
         oldsections.append(sec)
      elif p_subsec.match(line):
         subsec = line.rstrip().lstrip()
         if sec not in oldsubsections.keys():
            oldsubsections[sec] = []
         oldsubsections[sec].append(subsec)
      else:
         print("Warning: unsupported line format: \n" + line)
except IOError:
   pass

# write outline to file <<<1
f = open(cfg.Path.outline, 'w')
# deal with the old sections <<<2
for sec in oldsections:
   if sec in sections:
      f.write("%s\n" % sec)
      if (sec in subsections.keys()) and (sec in oldsubsections.keys()):
# keep the old order for subsections
         for subsec in oldsubsections[sec]:
            if subsec in subsections[sec]:
               f.write("\t%s\n" % subsec)
               subsections[sec].remove(subsec)
# deal with the new subsections
      elif sec in subsections.keys():
         for subsec in subsections[sec]:
            f.write("\t%s\n" % subsec)
      else:
         pass
      sections.remove(sec)
# deal with the new sections <<<2
for sec in sections:
   f.write("%s\n" % sec)
   if sec in subsections.keys():
      for subsec in subsections[sec]:
         f.write("\t%s\n" % subsec)
f.close()
