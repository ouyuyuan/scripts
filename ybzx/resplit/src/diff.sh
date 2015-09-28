#!/bin/bash
nc="ORCAR12_00000720_restart_$1.nc"
ncdump ~/zhangyu/ouniansen/EXP_480/$nc > ori.txt
ncdump EXP_480_to_480/$nc > tran.txt
vim -d ori.txt tran.txt
