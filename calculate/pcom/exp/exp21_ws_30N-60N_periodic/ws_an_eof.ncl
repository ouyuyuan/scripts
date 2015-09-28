
; Description: wind stress anomaly to control run, EOF 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:43:19 BJT
; Last Change: 2014-11-23 07:09:08 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

indir = "/home/ou/archive/data/pcom/input/"

f = addfile(indir+"pcom_bcf_mn_re_cycle.nc", "r")
bcu_old = f->bcu(0:719,:,:)
delete(f)

f = addfile(indir+"pcom_bcf_mn_re_cycle_30N-60N_periodic.nc", "r")
bcu_new = f->bcu(0:719,:,:)
delete(f)

an = bcu_new
an = bcu_new - bcu_old
an@long_name = "zonal wind stress anomaly"

; EOF
neof   = 1                                  ; Leading EOF only
optEOF = True       
optETS = False
anAnom = an 
anAnom = an - conform(an, dim_avg_n(an,0), (/1,2/))
wan     = an(lat|:,lon|:,t|:)                ; convenience, cleaner code
eof    = eofunc_Wrap(wan, neof, optEOF)      
eof = -eof
ts = eofunc_ts_Wrap (wan, eof, optETS)
tsStd = dim_stddev_n(ts, 1)
eof = eof*tsStd
ts = dim_standardize_n( ts, 0, 1)      ; normalize

outfile = getenv("NCL_ARG_1")+getenv("NCL_ARG_0_base")+".nc"
system("rm -f " + outfile)
f = addfile(outfile, "c")
f->an = an
f->eof = eof(0,:,:)
f->ts = ts(0,:)

f@data = "zonal mean wind stress anomaly of exp21_ws_30N-60N_periodic,"+\
" compare to control run"
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
