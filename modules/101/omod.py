
# Description: libray of python functions for common usage
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2012-02-24 17:06:17 CST
# Last Change: 2013-11-29 07:09:25 CST

import os
import sys
#sys.path.append(os.path.expanduser('~/archive/coded/modules/'))
from termcolor import colored

# color text <<<1
#
# make text with colors, highlights, and other attributes                     

def color(text,*args):
    colors = ['grey','red','green','yellow','blue','magenta','cyan','white']
    highs = ['on_grey','on_red','on_green','on_yellow','on_blue','on_magenta',
          'on_cyan','on_white']
    attrs = ['bold','dark','underline','blink','reverse','concealed']
    attr = []
    high = 'none'
    if len(args) > 0:
        for arg in args:
            if arg in colors: color = arg
            elif arg in highs: high = arg
            elif arg in attrs: attr.append(arg)
            else:
                print('wrong arguments!')
                sys.exit(0)
        if len(attr) == 0 and high == 'none':
            text = colored(text,color)
        elif len(attr) > 0 and high == 'none':
            text = colored(text,color,attrs=attr)
        elif len(attr) == 0 and high != 'none':
            text = colored(text,color,high)
        else:
            text = colored(text,color,high,attrs=attr)
    return text

# some printing engraving <<<1

def regularEnd(string):
    smile = color('^_^','on_magenta','yellow','reverse','bold')
#    smile = color('^_^','on_red','magenta','reverse','bold')
    done = color('Done.','green','bold')
    text = color(string,'green','bold')
    ending = '\n' + ' ' + done + ' ' + text + ' ' + smile + '\n'
    print(ending)
def greenLine():
    line = '______________________________________________________________________\n'
    cline = color(line,'green','bold')
    print(cline)
def greenText(text):
    otext = color(text,'green','bold')
    print(otext)
def redText(text):
    otext = color(text,'red','bold')
    print(otext)
def magentaText(text):
    otext = color(text,'magenta','bold')
    print(otext)
def greenInput(prom):
    return input(color(prom,'green','bold'))

# pirnt dics in a readable way <<<1

def printDic(D):
    keys = sorted(D.keys())
    for key in keys:
        index = keys.index(key)
        k = key + ' -- '
        ke = k
        value = D[key]
        if index % 2 == 1:
            # put dark before blue will be different
            value = color(D[key],'blue','bold','dark')
            ke = color(k,'blue','bold','dark')
        else:
            # put dark before blue will be different
            value = color(D[key],'magenta','bold','dark')
            ke = color(k,'magenta','bold','dark')
        text = ' ' + ke + value
        print(text)

# change a line in a file <<<1
#                                                                             
# substiute the line in the 2nd argument with the line in the 3rd argument

def changeLine(filename,oldLine,newLine):
    newFile = []
    for line in open(filename):
        if line == oldLine:
            line = newLine
        newFile += line
    open(filename,'w').writelines(newFile)

# compile document with XeLaTeX, it will compile the given <<<1
#
# it will compile the given
# tex file and show the result pdf file, then recompile and
# reshow until you are satisfied                                               
#                                                                             
def xelatex(texFile):
    mainName = texFile.replace('.tex','')
    latex = 'xelatex ' + texFile
    sagetex = 'sage ' + mainName + '.sagetex.sage'
    asymptote = 'asy ' + mainName + '-*.asy'
    bibtex = 'bibtex ' + mainName
    makeindex = 'makeindex ' + mainName
    evince = 'evince ' + mainName + '.pdf'

    yesList = ['y','Y','yes','yeah','']
    noList = ['n','N','no','nop']

    index = False
    bib = False
    asy = False
    sage = False
    check = False
    os.system(latex)
#    os.system(latex)

    #-----------------------------------------------------------------------------
    # check for \printindex and \bibliography{*}                                     
    if not check:
        for line in open(texFile):
            # not [0:13], and '\b' is meaning begin , not the character
            # itself, so r is needed
            if line.replace(' ','')[0:14] == r'\bibliography{':
                index = True
            elif line.replace(' ','')[0:11] == '\printindex': # not [0:10]
                bib = True
            elif line.replace(' ','')[0:20] == r'\usepackage{sagetex}':
                sage = True
            elif line.replace(' ','')[0:22] == r'\usepackage{asymptote}':
                asy = True
            else:
                pass
        check = True
    if index: os.system(makeindex)
    if bib: os.system(bibtex)
    if sage: os.system(sagetex)
    if asy: os.system(asymptote)
    if bib or index:
        os.system(latex)
    os.system(latex)
    #show pdf file
    os.popen(evince)
    #-----------------------------------------------------------------------------
    # clean up                                                                    
    rmList  = ['.log','.out','.aux','.toc','.ilg','.idx','.ind','.bbl','.blg']
    rmList += ['.sagetex.sage','.sagetex.sout','.sagetex.out','.sagetex.py','.sagetex.scmd']
    rmList += ['.pre','.asy','-1.asy']
    for postfix in rmList:
        rmFile = mainName + postfix
        if os.path.exists(rmFile):
            if rmFile in [mainName+'.asy',mainName+'-1.asy']:
                os.system('rm '+mainName+'-*.asy')
                os.system('rm '+mainName+'-*.pdf')
            else:
                os.remove(rmFile)
