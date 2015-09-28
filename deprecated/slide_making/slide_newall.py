#!/usr/bin/env python
#_*_coding:utf-8_*_

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-12-07 08:42:23 BJT
# Last Change: 2013-12-23 07:54:00 BJT

import re
import os
import sys
import glob
import argparse

def read_old_section(filename):
   class Old:
      def __init__(self):
         self.secs = []
         self.subsecs = {}
   old = Old()

   def strip_src(string):
      """Extract a title for bookmark(side bar)"""
      p = re.compile(r'^(?P<title>.*)<.*>')
      title = string.rstrip().lstrip()
      if p.match(title):
         title = p.match(title).group('title')
      return title

   p_sec = re.compile(r'^\w+')
   p_subsec = re.compile(r'^\s+')

   try:
      for line in open(filename, 'r'):
         if p_sec.match(line):
            sec = strip_src(line)
            old.secs.append(sec)
            if sec not in old.subsecs.keys():
               old.subsecs[sec] = []
         elif p_subsec.match(line):
            subsec = strip_src(line)
            old.subsecs[sec].append(subsec)
         else:
            print("Warning: unsupported line format: \n" + line)
   except IOError:
      pass

   return old

def scan_files(filenames, build_dir):
   class Scan:
      def __init__(self):
         self.secs = []
         self.subsecs = {}
         self.srcs = {}
         self.cite_cmd = {}
   scan = Scan()

   p_cite = re.compile(r'.*?(?P<citecmd>\\cite.*?\{(?P<bibtexkey>.+?)\})')
   p_hier = re.compile(r'^\W+@hierarchy:\s*(?P<hier>.+?)\s*$')
   p_lev  = re.compile(r'(?P<a>.+?)\s*\|\s*(?P<b>.+)')
   for file in filenames:
      for line in open(file,"r"):
         if p_hier.match(line):
            hier = p_hier.match(line).group('hier')
            if p_lev.match(hier): # a 2-level hierarchy
               sec = p_lev.match(hier).group('a')
               subsec = p_lev.match(hier).group('b')
            else:
               sec = hier
               subsec = ''

            scan.srcs[sec + subsec] = file

            if sec not in scan.secs:
               scan.secs.append(sec)
            if sec not in scan.subsecs.keys():
               scan.subsecs[sec] = []
            if subsec != '':
               scan.subsecs[sec].append(subsec)
         elif p_cite.match(line):
            k = p_cite.match(line).group('bibtexkey')
            v = p_cite.match(line).group('citecmd')
            scan.cite_cmd[k] = v
         else:
            pass

   return scan

class Asy_config:
   """ For asympote plot
   These settings will be written into a config file.
   e.g., type = '"scientific"' will be written as :
      slide.type = "scientific";
   Check in $coded/modules/myslide.asy for relative info.
   """
   def __init__(self):
      self.type = '"scientific"'  # remian " for asympote string type
      # self.x = '30cm'
asy_config = Asy_config()

class Slide:
   def __init__(self, page, sec='', subsec=''):
      self.page = page
      self.sec = sec
      self.subsec = subsec
      self.src = ''
      self.newname = ''

class Present:
   def __init__(self, title, outname):
      self.title = title
      self.outname = outname
      self.build_dir = "build"
      self.paper_dir = '/home/ou/archive/paps'
      self.outline = 'outline.txt'

      self.scripts_dir = '/home/ou/archive/scripts/slide_making'
      self.cite_tex = self.build_dir + '/cites.tex' # hard-coded in tex template
      self.reference_compile_sh = self.scripts_dir + '/produce_reference_page.sh'
      self.reference_mainname = 'slide_references'

      self.draws = glob.glob('slide-*.asy')
      self.srcs = {}
      self.secs = []
      self.subsecs = {}
      self.cite_cmd = {}
      self.slides = []

   def create_asy_config(self):
      f = open(self.build_dir + '/slide_config.asy', 'w')
      for k, v in asy_config.__dict__.items():
         if not (k.startswith('__') and k.endswith('__')):
            f.write ("%s%s%s%s;\n" % ('slide.', k, ' = ', v))
      f.close()

   def get_sections(self, scan):
      old = read_old_section(self.outline)
      new = scan

      def merge_list(new, old):
         """merge new and old list, keep the old order, remove the old items"""
         a = [i for i in old if i in new]
         b = [i for i in new if i not in old]
         return (a + b)

      self.secs = merge_list(new.secs, old.secs)
      self.subsecs = {}

      for sec in self.secs:
         if new.subsecs.has_key(sec) and old.subsecs.has_key(sec):
            self.subsecs[sec] = merge_list(new.subsecs[sec],old.subsecs[sec])
         elif new.subsecs.has_key(sec):
            self.subsecs[sec] = new.subsecs[sec]
         elif old.subsecs.has_key(sec):
            self.subsecs[sec] = old.subsecs[sec]
         else:
            self.subsecs[sec] = []

   def create_slide_objects(self):
      self.slides.append(Slide(1)) # cover
      self.slides.append(Slide(2)) # outline
      page = 2  # the page of outline
      for sec in self.secs:
         page += 1
         if len(self.subsecs[sec]) == 0:
            self.slides.append(Slide(page, sec, ''))
         else:
            for i in range(0, len(self.subsecs[sec])):
               subsec = self.subsecs[sec][i]
               page += 1
               if i == 0: # first item have the same page as section
                  page -= 1 
               self.slides.append(Slide(page, sec, subsec))
      page += 1 # reference page
      self.slides.append(Slide(page, '', ''))

   def modify_slide_objects(self):
      for slide in self.slides:
         slide.newname = 'slide_%02d.asy' % slide.page # rename slide for build
         k = slide.sec + slide.subsec
         if k in self.srcs.keys():
            slide.src = self.srcs[k] # slide draw script

   def create_outline(self):
      f = open(self.outline, 'w')
      for sec in self.secs:
         if self.srcs.has_key(sec):
            src = os.path.basename(self.srcs[sec])
            f.write("%s<%s>\n" % (sec, src))
         else:
            f.write("%s\n" % sec)
         for subsec in self.subsecs[sec]:
            src = self.srcs[sec + subsec]
            f.write("\t%s<%s>\n" % (subsec, src))
      f.close()

   def create_references(self):
      f = open(self.cite_tex, 'w')
      for v in self.cite_cmd.values():
         f.write("%s\n\n" % v)
      f.close()

      os.chdir(self.build_dir)
      cmd = '%s %s' % (self.reference_compile_sh, self.reference_mainname)
      os.system(cmd)

   def filter_srcs(self):
      def scan_bbl(filename):
         # pattern e.g.: \bibitem[刘海洋(2009)]{Liu2009asy}
         p = re.compile(r'^\\bibitem\[(?P<author>.+?)\((?P<year>.+?)\)\]\{(?P<id>.+?)\}')
         try:
            for line in open(filename, 'r'):
               if p.match(line):
                  print(line)
         except IOError:
            pass

      filename = '%s/%s.bbl' % (self.build_dir, self.reference_mainname)

   def init(self):
      os.system('mkdir -p %s' % self.build_dir)
      self.create_asy_config()

      scan = scan_files(self.draws, self.build_dir)
      self.get_sections(scan)
      self.srcs = scan.srcs
      self.cite_cmd = scan.cite_cmd

      self.create_slide_objects()
      self.modify_slide_objects()
      self.create_outline()

title = r'Climate Mean Accessment of PCOM \\ after 300-year-integration' 
outname = 'seminar_02_ou_2013-12'
present = Present(title, outname)
present.init()

parser = argparse.ArgumentParser()
parser.add_argument('-r', "--reference", 
      help="produce reference page, if any", action='store_true')
args = parser.parse_args()

if (args.reference):
   present.create_references()

present.filter_srcs()
