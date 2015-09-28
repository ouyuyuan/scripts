#! /bin/bash

# Description: mount a directory on a server to the local machine
#
#       Usage: ./xxx.sh dir
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-03-04 17:49:03 CST
# Last Change: 2013-03-11 08:38:24 CST

remoteDir="ou@172.16.0.101:$1"
localDir="$HOME/mount/101/$1"

mkdir -p $localDir

sshfs $remoteDir $localDir -o transform_symlinks
