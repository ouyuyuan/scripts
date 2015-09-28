
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:43:19 BJT
; Last Change: 2014-11-23 21:35:50 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

indir = getenv("NCL_ARG_1")

temp = 20
f = addfile(indir+"isothermal_line_depth.nc", "r")
depth = f->depth(:,{temp},:,:) ; 20 degC isothermal line
delete(f)
depth = smth9(depth, 0.5, 0.25, False)

an = depth
an = depth - conform(depth, dim_avg_n(depth,0), (/1,2/))
;an = where(ismissing(an),0,an)

; EOF
neof   = 2                                  ; Leading EOF only
optEOF = True       
optETS = False
ran    = an(lat|:,lon|:,time|:)                ; convenience, cleaner code
eof    = eofunc_Wrap(ran, neof, optEOF)      
eof = -eof
ts = eofunc_ts_Wrap (ran, eof, optETS)
tsStd = dim_stddev_n(ts, 1)
eof = eof*conform(eof, tsStd, (/0/))
ts = dim_standardize_n( ts, 0, 1)      ; normalize

outfile = getenv("NCL_ARG_1")+getenv("NCL_ARG_0_base")+"_"+temp+".nc"
system("rm -f " + outfile)
f = addfile(outfile, "c")
f->an = an
f->eof = eof
f->ts = ts

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
