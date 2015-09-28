#!/usr/bin/env python
#_*_coding:utf-8_*_
"""
        File: pseudocode.py
 Description: produce tex source for pseudocode

       Usage:

      Author: OU Yuyuan <ouyuyuan@gmail.com>
     Created: Tue Jun  5 07:41:55 UTC+8 2012
 Last Change: 2012-09-27 17:13:25 CST      
"""

import re,os,sys,pickle
import otweak as ok

class Part:
    def __init__(self,level,title):
        self.level   = level # latex 中的结构(section, subsection, subsub...)
        self.title   = title # latex 结构标题
        self.para    = []    # .txt 中，以空行隔开的为一个段落
        self.suppart = None  # 上一层结构
        self.subpart = {}    # 子部分

    def __str__(self):
        print 'level: ', self.level
        print 'title: ', self.title
        print 'paragraphs: ', len(self.para)
        print 'subpart: ', self.subpart.keys()

dbvar = [] # for debug in ipython
def debug(var):
    dbvar.append(var)

def part2tex(texBody,part):
    l = part.level
    if   l == 0:             # 确定latex中的结构层次
        title = r'\section{' + part.title + '}'
    elif l == 1:
        title = r'\section{' + part.title + '}'
    elif l == 2:
        title = r'\subsection{' + part.title + '}'
    elif l == 3:
        title = r'\subsubsection{' + part.title + '}'
    elif l > 3:
        title = r'\subsubsection*{' + part.title + '}'
    else:
        err = "Wrong part-level range! Exiting."
        print >> sys.stderr, err
        sys.exit(1)

    texBody.append('\n'+title+'\n')
    texBody.append('\n'+r'\begin{enumerate}'+'\n')

    for para in part.para:  # 一个段落就当成一个计算步骤
        texBody.append(r'\item '+'\n')
        texBody += para

    texBody.append(r'\end{enumerate}'+'\n')

    for key in part.subpart.keys(): # 子部分递归调用
        subpart = part.subpart[key]
        part2tex(texBody,subpart)

class Pseudo:
    def __init__(self,mainName):
        self.mainName = mainName
        self.part     = Part(0,'总览') # 算法最顶层标题

    def findSubpart(self,part,key): # 找出跳转来自何处
        if key in part.subpart.keys():
            subpart = part.subpart[key]
        else:
            if part.suppart == None:
                err = 'cannot fine a subpart container error! Exiting...'
                print >> sys.stderr, err
                sys.exit(1)
            subpart = self.findSubpart(part.suppart,key) # 递归在上一层找
        return subpart

    def checkLine(self,part,line):
        result = {}
        result['part'] = part

        linePattern = re.compile(r"""^(?P<indent>\s*)   # 行开头有缩进
                (\*(?P<fromtag>\w+)\*)?    # 由上一级结构跳转而来
                (\|(?P<totag>\w+)\|)?      # 有跳到下一级结构的标签
                (?P<linetext>.+)           # 正文(必须为最后一组，因有.) 
                \s*$""", re.UNICODE|re.DOTALL|re.VERBOSE)
        m = linePattern.match(line)
        if not m:
            err = 'unexpected line in pseudocode file! Exiting... '
            print >> sys.stderr, err
            sys.exit(1)

        newline = []
        if m.group('indent'):   # keep the indent structure
            indent = '\n' r'\verb+'+m.group('indent')+'+'
            newline.append(indent)

        if m.group('fromtag'): # 一个子部分开始
            tag = m.group('fromtag')
            subpart = self.findSubpart(part, tag)
            result['part'] = subpart

        newline.append(m.group('linetext'))

        if m.group('totag'):
            tag = m.group('totag')
            label = r'\label{sec:'+tag+r'back}\fcolorbox{gray}{peachpuff2}{\large $\longrightarrow$P.\pageref{sec:'+tag+'}}\n'
            newline.append(label)

            level = part.level+1 # 准备好一个新的子部分
            label = r'\label{sec:'+tag+'}'+r'$\longleftarrow$P.\pageref{sec:'+tag+'back}'
            title = m.group('linetext').rstrip() + ' ' + label
            newsub = Part(level,title)
            newsub.suppart = part
            part.subpart[tag] = newsub

        newline = ''.join(newline)
        result['newline'] = newline
        return result

    def builtPart(self):
        filename = self.mainName + '.txt'
        f = open(filename)
        text = f.readlines()
        f.close()

        n = len(text)
        part = self.part
        para = []
        for i in range(1,n-2): # omit the first and last two lines
            if (text[i].replace(' ','') == '\n') or (i == n-2): # paragraph end
                if len(para) > 0: part.para.append(para)
                para = [] # 新段落开始
            else:
                checkResult = self.checkLine(part,text[i])
                line = checkResult['newline']
                part = checkResult['part']
                para.append(line)


    def exportTex(self,part):
        texAll = []

        clsDir = ok.readScriptrc().get("TEX_CLS_ROOT")
        if clsDir == None:
            err = "variable TEX_CLS_ROOT not set in ~/.scriptrc! Exit..."
            print >> sys.stderr, err
            sys.exit(1)
        clsDir = os.path.expanduser(clsDir)
        if clsDir[-1] == '/':
            clsDir = clsDir[:-1]

        texHead = r"""\documentclass{"""+clsDir+r"""/pseudocode}
\usepackage{imakeidx}
\usepackage{hyperref}
\makeindex[program=xindy,columns=3,intoc,columnseprule]
\hypersetup{
colorlinks,
citecolor=cyan4,
filecolor=blue2,
linkcolor=red2,
urlcolor=green4
}

\begin{document}
\maketitle
\tableofcontents
\newpage

"""
        texAll.append(texHead)

        texBody = []
        part2tex(texBody,part) # get texBody
        texAll += texBody

        texTail = r"""
\bigskip
\clearpage
\addcontentsline{toc}{section}{参考文献}
\bibliography{pseudocode}
\printindex
\end{document}"""
        texAll.append('\n'+texTail)

        filename = self.mainName + '.tex'
        f = open(filename,'w')
        f.writelines(texAll)
        f.close()

def main():
    mainName = 'pseudocode'
    pseudo = Pseudo(mainName)
    pseudo.builtPart()

    picFile = pseudo.mainName+'.pkl'
    f = open(picFile,'wb')
    pickle.dump(pseudo,f)
    f.close()

    f = open(picFile,'rb')
    part = pickle.load(f).part
    f.close()

    pseudo.exportTex(part)

if __name__ == '__main__':
        main()
