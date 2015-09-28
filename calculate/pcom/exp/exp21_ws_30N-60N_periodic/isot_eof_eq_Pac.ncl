
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:43:19 BJT
; Last Change: 2014-11-30 16:30:20 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

indir = getenv("NCL_ARG_1")

latVal = -0.5
lonW = 110.5
lonE = 290.5
tempL = 14.0
tempH = 22.0
outfile = getenv("NCL_ARG_1")+getenv("NCL_ARG_0_base")+".nc"

f = addfile(indir+"isothermal_line_depth.nc", "r")
depth = f->isot(:,{tempL:tempH},{latVal},{lonW:lonE})
delete(f)
depth = smth9(depth, 0.5, 0.25, False)

ran     = depth(tlev|:,lon|:,time|:)

; EOF
neof   = 2                                  ; Leading EOF only
optEOF = True       
optETS = False
eof    = eofunc_Wrap(ran, neof, optEOF)      
eof = -eof
ts = eofunc_ts_Wrap (ran, eof, optETS)
tsStd = dim_stddev_n(ts, 1)
eof = eof*conform(eof, tsStd, (/0/))
ts = dim_standardize_n( ts, 0, 1)      ; normalize

system("rm -f " + outfile)
f = addfile(outfile, "c")
f->eof = eof
f->ts = ts

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
