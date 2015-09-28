
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:43:19 BJT
; Last Change: 2014-11-30 20:10:33 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure do_eof(f, isot, patName, tsName)
begin
  an = isot
  an = isot - conform(isot, dim_avg_n(isot,0), (/1,2/))
  ;an = where(ismissing(an),0,an)

  ; EOF
  neof   = 2
  optEOF = True       
  optETS = False
  ran    = an(tlev|:,lon|:,time|:)                ; convenience, cleaner code
  eof    = eofunc_Wrap(ran, neof, optEOF)      
;  eof = -eof
  ts = eofunc_ts_Wrap (ran, eof, optETS)
  tsStd = dim_stddev_n(ts, 1)
  eof = eof*conform(eof, tsStd, (/0/))
  ts = dim_standardize_n( ts, 0, 1)      ; normalize

  f->$patName$ = eof
  f->$tsName$ = ts
end

inDir = getenv("NCL_ARG_1")
nc = "isothermal_line_depth.nc"

latVal = -0.5
tempL = 14.0
tempH = 22.0

outfile = getenv("NCL_ARG_1")+getenv("NCL_ARG_0_base")+".nc"

f = addfile(inDir+nc, "r")
isot = f->isot(40:,{tempL:tempH},{latVal},:)
delete(f)

inDir = "/home/ou/archive/data/pcom/exp17_ws_control_cycle_re/post/"
f = addfile(inDir+"../../exp17_ws_control_cycle_re/post/"+nc, "r")
isot_ctr = f->isot(40:,{tempL:tempH},{latVal},:)
delete(f)

isot = smth9(isot, 0.5, 0.25, False)
isot_ctr =  smth9(isot_ctr, 0.5, 0.25, False)

diff = isot
diff = isot - isot_ctr

system("rm -f " + outfile)
f = addfile(outfile, "c")

diff_Pac = diff(:,:,{110.5:290.5})
lon = diff_Pac&lon
lonc = conform(diff_Pac, lon, 2)

diff_W = diff_Pac
diff_W = where(lonc.lt.180.5, diff_Pac, diff_Pac@_FillValue)

diff_E = diff_Pac
diff_E = where(lonc.gt.180.5, diff_Pac, diff_Pac@_FillValue)

do_eof(f, diff_Pac, "eof", "ts")
do_eof(f, diff_W, "eof_W", "ts_W")
do_eof(f, diff_E, "eof_E", "ts_E")

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
