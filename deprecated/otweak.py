#!/usr/bin/python
##############################################################################
#        File: otweak.py                                                     #
# Description: common functins used by user written scripts                  #
#                                                                            #
#      Author: OU Yuyuan (ouyuyuan AT lasg DOT iap DOT ac DOT cn)            #
#     Created: Fri Apr 27 14:18:32 UT+8 2012                                 #
# Last Change: Mon May 21 17:20:15 UTC+8 2012                                #
##############################################################################

import os
import sys
import re

##############################################################################
#
# read settings in .scriptrc file in the home directory
#
def readScriptrc():
    class ReadScriptrc:
        def __init__(self):
            self.rcFileName = '.scriptrc'
            self.rcFileDir  = os.path.expanduser('~/')
        def get(self,variable):
            variable = variable
            var_pattern = re.compile(r'^%s\s*\=\s*(?P<value>.*)'%(variable))
            for line in open(self.rcFileDir+self.rcFileName,'r'):
                try:
                    return var_pattern.match(line).group('value').rstrip()
                except:
                    pass
    readScriptrc = ReadScriptrc()
    return readScriptrc

##############################################################################
#
# change the post suffiex for all match files in the CURRENT directory
#
def changeSuffix(old_suffix,new_suffix):
    old_suffix = old_suffix
    new_suffix = new_suffix
    cmd = 'ls *.'+old_suffix
    old_names = os.popen(cmd).read().strip().split('\n')
    for old_name in old_names:
        new_name = old_name[:old_name.rindex('.')+1]+new_suffix
        os.rename(old_name, new_name)

##############################################################################
#                                                                             
# compile document with XeLaTeX
#                                                                             
def latex(path):
    class TexProject:
        def __init__(self,path):
            self.absPath = os.path.abspath(os.path.expanduser(path))
            self.dirName = os.path.dirname(self.absPath)
            self.fileName = os.path.basename(self.absPath)
            self.mainName = self.fileName.replace('.tex','')
            self.oldFiles = os.popen('ls '+self.mainName+'*.*').\
                    read().rstrip().split('\n')

        def make(self):
            my_compile = lambda x, y: os.system(x + ' ' + y)

            os.chdir(self.dirName)
            my_compile('xelatex', self.fileName)

            index_pattern = re.compile(r'^\s*\\printindex\s*')
            bib_pattern   = re.compile(r'^\s*\\bibliography\{.+\}')
            sage_pattern  = re.compile(r'^\s*\\usepackage\{sagetex\}')
            asy_pattern   = re.compile(r'^\s*\\usepackage\{asymptote\}')

            for line in open(self.fileName,'r'):
                if   index_pattern.match(line):
                    my_compile('makeindex',self.mainName)
                elif bib_pattern.match(line):
                    my_compile('bibtex', self.mainName)
                elif sage_pattern.match(line):
                    my_compile('sagetex', self.mainName+'.sagetex.sage')
                elif asy_pattern.match(line):
                    my_compile('asy', self.mainName+'-*.asy')
            my_compile('xelatex', self.fileName)
            my_compile('xelatex', self.fileName)

        def showPdf(self):
            os.chdir(self.dirName)
            os.popen('evince '+self.mainName+'.pdf &')

        def removeFiles(self):
            os.chdir(self.dirName)
            related_files = os.popen('ls '+tex_project.mainName+'*.*').\
                read().rstrip().split('\n')
            [os.remove(name) for name in list(set(related_files) - \
                set(tex_project.oldFiles) - \
                set([tex_project.fileName, tex_project.mainName+'.pdf']))]

    tex_project = TexProject(path)
    tex_project.make()
    tex_project.showPdf()
    tex_project.removeFiles()


##############################################################################
##############################################################################
#
#
if  __name__ == "__main__":
    args = sys.argv[1:]
    if args[0] == 'suffix':
        changeSuffix(args[1],args[2])
    elif args[0].split('.')[-1] == 'tex':
        latex(args[0])
    elif args[0] == 'help':
        usage = {}
        usage['suffix txt ntx'] = 'change .txt file(s) to .ntx file(s) in the current directory'
        usage['~/temp/temp.tex'] = 'compile corresponding tex file with xelatex'
        usage['help'] = 'show this help information'
        print(78*'-')
        print(' Usage:')
        for key in usage.keys():
            print(4*' '+key+':')
            print(8*' '+usage[key])
        print(78*'-')
    else:
        pass
