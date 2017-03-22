""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"        File: coding.vim                                                    "
" Description:                                                               "
"                                                                            "
"       Usage:                                                               "
"                                                                            "
"      Author: OU Yuyuan <ouyuyuan@gmail.com>                                "
"     Created: Fri Apr 27 17:05:21 CST 2012                                "
" Last Change: 2014-01-20 15:26:03 BJT
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

python << EOF
import os
import sys
import re
import vim

# sys.path.append(os.path.expanduser("~/archive/coded/python"))
# import otweak as ok

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
            for line in open(self.rcFileDir + self.rcFileName, 'r'):
                #for line in open('/home/ou/.scriptrc', 'r'):
                try:
                    return var_pattern.match(line).group('value').rstrip()
                except:
                    pass
    readScriptrc = ReadScriptrc()
    return readScriptrc

class Source:
    def __init__(self):
        self.comment = {'py':'#','f90':'!','txt':'#','ly':'%','vim':r'"',\
                        'tex':'%','cls':'%','bashrc':'#','vimrc':r'"',\
                        'asy':r'//','ncl':';','ntx':'_','plx':'#','f03':'!',\
                        'emacs':';;;;','sh':'#','pl':'#','dot':r'//', "hs":r'--',
                        'rst':r'..', 'css':r' *', 'pm':'#', 'jnl':'!', 'mac':r' *', 'm':r'%'}
        # add a space after each program name
        self.makeway = {'py':'python3.2 ','f90':'ifort ','ly':'lilypond ',\
        'tex':'otweak.py ','asy':'asy -f pdf ','ncl':'ncl '}
        # add a space after each program name
        self.showway   = {'ly':['evince ','.pdf'],'tex':['evince ','.pdf'],\
        'asy':['evince ','.pdf'],'ncl':['evince ','.pdf']}
        self.textwidth = int(vim.eval("&tw"))

        self.curbuff    = lambda : vim.current.buffer
        self.path       = lambda : str(vim.current.buffer.name)
        #self.abspath    = lambda : os.path.abspath(os.path.expanduser(self.path()))
        self.abspath    = lambda : os.path.abspath(str(vim.current.buffer.name))
        self.directory  = lambda : os.path.dirname(str(vim.current.buffer.name))
        self.filename   = lambda : os.path.basename(str(vim.current.buffer.name))
        self.mainname   = lambda : os.path.basename(str(vim.current.buffer.name)).split('.')[0]
        self.filetype   = lambda : os.path.basename(str(vim.current.buffer.name)).split('.')[1]

        #        self.codeSignature  = ok.readScriptrc().get('CODES_SIGNATURE')
        #self.codeAuthorName = ok.readScriptrc().get('CODES_AUTHOR_NAME')
        self.codeSignature  = readScriptrc().get('CODES_SIGNATURE')
        self.codeAuthorName = readScriptrc().get('CODES_AUTHOR_NAME')

    def __str__(self):
        return  ' source file: %s \n in directory %s \n ' \
                %(self.filename(), self.directory())

    def beforeleave(self):
        if not self.filetype() or self.filetype() not in self.comment.keys():
            return None
        cb = self.curbuff()
        authorpattern = re.compile(r'^[\W_]*\s*author[\W_]?\s*(%s)?'%self.codeSignature,re.I)
        changepattern = re.compile(r'^[\W_]*\s*last\s*change[\W_]?\s*',re.I)
        tagpattern    = re.compile(r'^[\{\s]*tagline\s*\=\s*\"')
        filepattern   = re.compile(r'^(?P<filetag>[\W_]*\s*file\:\s*)(?P<mainname>\w+)',re.IGNORECASE)
        authorflag    = False
        changeflag    = False
        tagflag       = False
        fileflag      = False
        for line in range(0, 100):
            try:
                if authorpattern.match(cb[line]):
                    authorflag = True
                if changepattern.match(cb[line]):
                    changeline  = line
                    changeflag  = True
                    changematch = changepattern.match(cb[line]).group(0)
                if (tagpattern.match(cb[line]) and self.filetype() == 'ly'):
                    tagline  = line
                    tagflag  = True
                    tagmatch = tagpattern.match(cb[line]).group(0)
                if filepattern.match(cb[line]):
                    fileline  = line
                    fileflag  = True
                    filematch = filepattern.match(cb[line]).group('filetag')
                    mainname  = filepattern.match(cb[line]).group('mainname')
            except: # in case the file is less than 100 lines
                pass
        if authorflag:
            time = os.popen('date +20%y-%m-%d\ %H:%M:%S').read().rstrip()+' BJT'
            if changeflag:
                textwidth  = len(cb[changeline])
                newchange  = changematch.rstrip()
                newchange += ' ' + time
                spaces     = (textwidth - len(newchange) - len(self.comment[self.filetype()]))*' '
                newchange += spaces + '\n'
                cb[changeline] = newchange
            if tagflag:
                newtag = tagmatch + self.codeAuthorName + r' | ' + time + r' | LilyPond" }' + '\n'
                cb[tagline] = newtag
            if fileflag and mainname != self.mainname():
                textwidth = len(cb[fileline])
                newfile  = filematch.rstrip() + ' '
                newfile += self.filename()
                spaces    = (textwidth - len(newfile) - len(self.comment[self.filetype()]))*' '
                newfile += spaces + self.comment[self.filetype()] + '\n'
                cb[fileline] = newfile
            vim.command(':w') # this line must put in the end of the function

    def autocmd(self):
        for filetype in self.comment.keys():
            vim.command('autocmd! BufWrite *.' + filetype + ' :python src.beforeleave()')

    def inserttitle(self):
        commentchar = self.comment[self.filetype()]
        textwidth   = self.textwidth
        delimitline = commentchar

        description = commentchar + ' Description: '
        usage   = commentchar + '       Usage: '
        author  = commentchar + '      Author: '
        author += self.codeSignature
        created = commentchar + '     Created: '
        created+= os.popen('date +20%y-%m-%d\ %H:%M:%S').read().rstrip()+' BJT'
        change  = commentchar + ' Last Change: '
        change+= os.popen('date +20%y-%m-%d\ %H:%M:%S').read().rstrip()+' BJT'

        title = [ ]
        title.append('')
        title.append(description) 
        title.append(delimitline)
        if self.filetype() in ['sh','pl']:
            title.append(usage)
            title.append(delimitline)
        title.append(author)
        title.append(created)
        title.append(change)

        if self.filetype() in ["css",'mac']:
            title.insert(1,'/*');
            title.append(' */');
            title.append('');

#        if self.filetype() == 'py':
#            pytitle = ['"""']
#            for line in title[1:-1]:
#                pytitle.append(line.replace(commentchar,'').rstrip())
#            pytitle.append('"""')
#            title = pytitle
        appendline = 0
        while re.match(r'^[\W_]\!',self.curbuff()[appendline]):
            appendline +=1
        while re.match(r'^[\W_]_\*_',self.curbuff()[appendline]):
            appendline +=1
        if self.filetype() == 'cls' and re.match(r'^\s*\%+',self.curbuff()[appendline]):
            appendline +=1
        elif self.filetype() == 'ntx' and re.match(r'^\*\w+\*',self.curbuff()[appendline]):
            appendline +=1
        else: pass
        self.curbuff().append(title,appendline)
        vim.command(":w")

    def mapping(self):
        try: 
            if self.filetype() not in self.comment.keys():
                return None
        except:
            return None

        commandmaps = {}
        commandmaps['ti<CR>']  = ':python src.inserttitle()<CR>'
        for key in commandmaps.keys():
            vim.command('cnoremap ' + key + ' ' + commandmaps[key])

src = Source() 
# run some autocommand according to the file type
src.autocmd()
# all the mapping dictionary can be found at the end part of the mapping 
# function in the Source class definition
src.mapping()

EOF
