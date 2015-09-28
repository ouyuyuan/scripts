
; Description: add geostrophic wind stress anomaly represent AO
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-06 16:49:05 BJT
; Last Change: 2014-11-06 21:13:29 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

reffile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn_re_cycle.nc"
anfile = "/home/ou/archive/data/plot/pcom/ws_exp/ao_an_wind_eof.nc"
outfile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn_re_cycle_an_ao.nc"

f = addfile( anfile, "r" )
an_bcu_eof = f->an_bcu
an_bcv_eof = f->an_bcv
ts = f->ts_sd
delete(f)

system("cp -f " + reffile + " " + outfile)
f = addfile( outfile, "w" )
bcu = f->bcu
bcv = f->bcv

an = conform(bcu, doubletofloat(an_bcu_eof), (/1,2/))*conform(bcu, ts, 0)
an = where(ismissing(an),0,an)
bcu = bcu + an

an = conform(bcv, doubletofloat(an_bcv_eof), (/1,2/))*conform(bcv, ts, 0)
an = where(ismissing(an),0,an)
bcv = bcv + an

f->bcu = bcu
f->bcv = bcv
f@data = "add geostrophic wind stress anomaly of AO in north of 20N"

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
