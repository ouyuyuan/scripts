#!/usr/bin/env python
#_*_coding:utf-8_*_

# Description: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-12-07 08:42:23 BJT
# Last Change: 2013-12-14 08:43:34 BJT

import re
import os
import sys
import glob
import argparse

class Path:
   """ For dirs, files, scripts, etc path
   """
# set paths <<<1
   build = 'build/'
   paps_dir = '/home/ou/archive/paps'
   asy_config = build + 'slide_config.asy'
   cite_tex = build + 'cites.tex'
   bookmark = build + 'bookmarks.txt'
   bookmark_ref = build + 'bookmarks_references.txt'
   outline = 'outline.txt'
   reference = 'slide-references'
   draws = glob.glob('slide-*.asy')
   coded = '/home/ou/archive/coded/slide_making/'

class Slide:
   secs = []
   subsecs = {}
   srcs = {}
   class Asy_config:
      """ For asympote plot
      These settings will be written into slide_config.asy.
      Check in $coded/modules/myslide.asy for relative info.
      """
# set asymptote configs
      type = '"scientific"'  # remian " for asympote string type
#   x = '30cm'

# intialization <<<1

def initialize():
   """Extract infos. for other options"""

# get outline structure <<<2

   def strip_src(string):
      """Extract a title for bookmark(side bar)"""
      p = re.compile(r'^(?P<title>.*)<.*>')
      title = string.rstrip().lstrip()
      if p.match(title):
         title = p.match(title).group('title')
      return title

   def get_src(string, sec='', subsec=''):
      """Extract draw scipt for a slide"""
      p = re.compile(r'^.+?<(?P<src>.*)>')
      k = sec + subsec
      v = ''
      if p.match(string):
         v = p.match(string).group('src')
      Slide.srcs[k] = v

# read old outline from file <<<3

   oldsections = []
   oldsubsections = {}

   p_sec = re.compile(r'^\w+')
   p_subsec = re.compile(r'^\s+')
   try:
      for line in open(Path.outline, 'r'):
         if p_sec.match(line):
            sec = strip_src(line)
            oldsections.append(sec)
            if sec not in oldsubsections.keys():
               oldsubsections[sec] = []
         elif p_subsec.match(line):
            subsec = strip_src(line)
            oldsubsections[sec].append(subsec)
         else:
            print("Warning: unsupported line format: \n" + line)
   except IOError:
      pass

# extract hierarchy line from asy script <<<3

   p_hier = re.compile(r'^\W+@hierarchy:\s*(?P<hier>.+?)\s*$')
   p_lev  = re.compile(r'(?P<a>.+?)\s*\|\s*(?P<b>.+)')
   newsections = []
   newsubsections = {}
   for file in Path.draws:
      for line in open(file,"r"):
         if p_hier.match(line):
            hier = p_hier.match(line).group('hier')
            if p_lev.match(hier): # a 2-level hierarchy
               sec = p_lev.match(hier).group('a')
               subsec = p_lev.match(hier).group('b')
            else:
               sec = hier
               subsec = ''

            if sec not in newsections:
               newsections.append(sec)
            if sec not in newsubsections.keys():
               newsubsections[sec] = []
            if subsec != '':
               newsubsections[sec].append(subsec)

            if subsec == '':
               Slide.srcs[sec] = "%s/%s" % (os.getcwd(), file)
            else:
               k = "%s | %s" % (sec, subsec)
               Slide.srcs[k] = "%s/%s" % (os.getcwd(), file)

            break

# merge old and new outline <<<3

   def merge_list(new, old):
      """merge new and old list, keep the old order, remove the old items"""
      a = [i for i in old if i in new]
      b = [i for i in new if i not in old]
      return (a + b)

   Slide.secs = merge_list(newsections, oldsections)
   for sec in Slide.secs:
      if newsubsections.has_key(sec) and oldsubsections.has_key(sec):
         Slide.subsecs[sec] = merge_list(newsubsections[sec],oldsubsections[sec])
      elif newsubsections.has_key(sec):
         Slide.subsecs[sec] = newsubsections[sec]
      elif oldsubsections.has_key(sec):
         Slide.subsecs[sec] = oldsubsections[sec]
      else:
         Slide.subsecs[sec] = []

# write slide_config.asy <<<1

def produce_asy_config():
   os.system('mkdir -p ' + Path.build)
   asy_config = open(Path.asy_config, 'w')
   for k, v in Slide.Asy_config.__dict__.items():
      if not (k.startswith('__') and k.endswith('__')):
         asy_config.write ("%s%s%s%s;\n" % ('slide.', k, ' = ', v))
   asy_config.close()

# create outline <<<1

def create_outline():

# write outline.txt <<<2

   f = open(Path.outline, 'w')
   for sec in Slide.secs:
      if Slide.srcs.has_key(sec):
         src = os.path.basename(Slide.srcs[sec])
         f.write("%s<%s>\n" % (sec, src))
      else:
         f.write("%s\n" % sec)
      for subsec in Slide.subsecs[sec]:
         k = "%s | %s" % (sec, subsec)
         src = os.path.basename(Slide.srcs[k])
         f.write("\t%s<%s>\n" % (subsec, src))
   f.close()

# create outline.asy and bookmarks.txt <<<2

   def write_asy_entry(f, title, level, page):
      asy_var = 'entry' + str(page)
      f.write("outline %s;\n" % asy_var)
      f.write('%s.title = "%s";\n' % (asy_var, title))
      f.write('%s.level = %d;\n' % (asy_var, level))
      f.write('%s.pagestart = %d;\n' % (asy_var, page))
      f.write('entrys.push(%s);\n' % asy_var)
      f.write('\n')

   def write_bookmark_entry(f, title, level, page):
      if level == 1:
         f.write("%s/%d,FitPage\n" % (title, page))
      elif level == 2:
         f.write("\t%s/%d,FitPage\n" % (title, page))
      else:
         print("unhandled level")
         sys.exit()

   def bookmark_title(string):
      """Extract a title for bookmark(side bar)"""
      p = re.compile(r'^(?P<title>.*)<.*>')
      title = string.rstrip().lstrip()
      if p.match(title):
         title = p.match(title).group('title')
      return title

   def extract_src(string, page):
      p = re.compile(r'^\t*(?P<title>.*)<(?P<src>.*)>')
      if p.match(string):
         entry = 'Slide ' + str(page)
         src_slides.append(entry)
         srcs[entry] = p.match(string).group('src')

   src_slides = []
   srcs = {}
   f_ol = open(Path.build + 'outline.asy','w')
   f_bm = open(Path.bookmark, 'w')
   page = 2  # the page of outline
   for sec in Slide.secs:
      title = bookmark_title(sec)
      page += 1
      write_asy_entry(f_ol, title, 1, page)
      write_bookmark_entry(f_bm, title, 1, page)
      extract_src(sec, page)
      for i in range(0, len(Slide.subsecs[sec])):
         subsec = Slide.subsecs[sec][i]
         title = bookmark_title(subsec)
         page += 1
         if i == 0:
            page -= 1 # first item have the same page as section
         write_asy_entry(f_ol, title, 2, page)
         write_bookmark_entry(f_bm, title, 2, page)
         extract_src(subsec, page)
   f_ol.close()

# write source codes of to bookmarks.txt <<<2
   f_bm.write("Source Code/-1\n")
   for slide in src_slides:
      f_bm.write("\t%s/-1,Launch,%s\n" % (slide, srcs[slide]))
   f_bm.close()

# cat reference part <<<2
   cmd = "cat %s >> %s" % (Path.bookmark_ref, Path.bookmark)
   os.system(cmd)
#   p = re.compile(r'^\\cite.+?\{(?P<bibkey>.+?)\}')
#   bibkeys = []
#   try:
#      for line in open(Path.cite_tex, 'r'):
#         if p.match(line):
#            k = p.match(line).group('bibkey')
#            pdf = "%s/%s.pdf" % (Path.paps_dir, k)
#            if os.path.isfile(pdf):
#               bibkeys.append(k)
#   except IOError:
#      pass

#   f_bm.write("References/-1\n")
#   bibkeys.sort()
#   for k in bibkeys:
#      f_bm.write("\t%s/-1,Launch,paps/%s.pdf\n" % (k, k))

# create reference page <<<1
def create_references():
# extract cite info  <<<2
   p = re.compile(r'.*?(?P<citecmd>\\cite.*?\{(?P<bibtexkey>.+?)\})')
   cite_cmd = {}
   for file in Path.draws:
      for line in open(file,"r"):
         if p.match(line):
            k = p.match(line).group('bibtexkey')
            v = p.match(line).group('citecmd')
            cite_cmd[k] = v

   f = open(Path.cite_tex, 'w')
   for v in cite_cmd.values():
      f.write("%s\n\n" % v)
   f.close()

# link papers in paps/ dir.
   os.system('mkdir -p paps/')
   bibkeys = []
   for k in cite_cmd.keys():
      pdf = "%s/%s.pdf" % (Path.paps_dir, k)
      cmd = "ln -sf %s paps/%s.pdf" % (pdf, k)
      if os.path.isfile(pdf):
         os.system(cmd)
         bibkeys.append(k)

# write the reference part for bookmarks.txt
   bibkeys.sort()
   f = open(Path.bookmark_ref, 'w')
   f.write("References/-1\n")
   for k in bibkeys:
      f_bm.write("\t%s/-1,Launch,paps/%s.pdf\n" % (k, k))
   f.close()

# compile tex <<<2
   os.chdir(Path.build)
   cmd = Path.coded + 'produce_reference_page.sh ' + Path.reference
   os.system(cmd)

initialize()
# parsing input options <<<1
parser = argparse.ArgumentParser()
parser.add_argument('-o', "--outline", 
      help="extract slides outline", action='store_true')
parser.add_argument('-r', "--reference", 
      help="produce reference page, if any", action='store_true')
args = parser.parse_args()

if (args.outline):
   create_outline()
if (args.reference):
   create_references()
