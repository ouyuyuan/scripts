
; Description: merge sst from from individual files
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 09:38:11 BJT
; Last Change: 2015-01-11 10:11:45 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir = getenv("NCL_ARG_1")
outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
f = addfile(datDir+"post/calc_002b_sst_cn.nc", "r")
sst = f->sst
delete(f)
sst = dtrend_n(sst,False,0)
system("rm -f "+outfile)
f = addfile(outfile,"c")
f->sst = sst
delete(f)
