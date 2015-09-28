#!/usr/bin/python

##############################################################################
#        File: backup.py                                                     #
# Description: backup file(s) with a time suffix to the specified directory  #
#                                                                            #
#       Usage: backup.py file1 [file2] [file3] ...                           #
#                                                                            #
#      Author: OU Yuyuan (ouyuyuan AT lasg DOT iap DOT ac DOT cn)            #
#     Created: Tue Apr 24 12:22:01 UT+8 2012                                 #
# Last Change: Tue Apr 24 14:11:19 UT+8 2012                                 #
##############################################################################

import sys,os,time,shutil

backup_dir = os.path.expanduser('~/ou/backup/')
src_files  = sys.argv[1:]            # files to be backup
max_length = max(map(len,src_files)) # get max length of file names

print(" backup the following file(s) to directory: " + backup_dir)
for file_name in src_files:
    time_suffix =\
    time.strftime('%Y-%m-%d-%X',time.localtime(os.path.getmtime(file_name)))
    backup_file = file_name + '.' + time_suffix

    if file_name[0] == '.':          # change hidden file to visible
        backup_file = file_name[1:] + '.' + time_suffix

    add_space = (max_length-len(file_name))*' '  # for output align
    if os.path.isfile(backup_dir + backup_file): # do not re-backup
        print(file_name + add_space + ' -->> ' + \
        '(already backup when last modified)')
    else:
        shutil.copy(file_name, backup_dir + backup_file)
        print(file_name + add_space + ' -->> ' + add_space + backup_file)
