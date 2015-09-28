#!/bin/bash

# Description: plot daily agenda
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-11-28 15:51:24 CST
# Last Change: 2014-03-19 08:22:11 BJT

asy_dir="$HOME/archive/scripts/agenda"

cd $asy_dir
/usr/bin/asy -globalwrite -nosafe agenda.asy

#evince $HOME/archive/drawing/agenda.pdf &
#cp -f $HOME/archive/drawing/agenda.pdf $HOME
