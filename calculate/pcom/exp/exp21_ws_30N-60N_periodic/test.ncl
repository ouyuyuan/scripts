
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:43:19 BJT
; Last Change: 2014-11-23 21:49:38 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

indir = getenv("NCL_ARG_1")

temp = 20
f = addfile(indir+"isothermal_line_depth.nc", "r")
depth = f->depth(:,{temp},:,:) ; 20 degC isothermal line
delete(f)

indir = "/home/ou/archive/data/pcom/exp17_ws_control_cycle_re/post/"
f = addfile(indir+"isothermal_line_depth.nc", "r")
depth_ctr = f->depth(:,{temp},:,:) ; 20 degC isothermal line
delete(f)

depth = smth9(depth, 0.5, 0.25, False)
depth_ctr =  smth9(depth_ctr, 0.5, 0.25, False)

diff = depth
diff = depth - depth_ctr
diff@long_name = "isothermal line depth differences, exp - (control run)"

diffAn = diff
diffAn = diff - conform(diff, dim_avg_n(diff, 0), (/1,2/))
diffAn@long_name = "anomaly of isothermal line depth difference compare to control run"

; EOF
neof   = 1                                  ; Leading EOF only
optEOF = True       
optETS = False
ran     = diffAn(lat|:,lon|:,time|:)                ; convenience, cleaner code
eof    = eofunc_Wrap(ran, neof, optEOF)      
;eof = -eof
ts = eofunc_ts_Wrap (ran, eof, optETS)
tsStd = dim_stddev_n(ts(0,:), 0)
eof = eof*tsStd
ts = dim_standardize_n( ts, 0, 1)      ; normalize

outfile = getenv("NCL_ARG_1")+getenv("NCL_ARG_0_base")+"_"+temp+".nc"
system("rm -f " + outfile)
f = addfile(outfile, "c")
f->diff = diff
f->diffAn = diffAn
f->eof = eof(0,:,:)
f->ts = ts(0,:)

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
