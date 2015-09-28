
; Description: EOF of depth of thermocline difference between the experiments
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:43:19 BJT
; Last Change: 2015-04-27 10:41:11 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; EOF for a given (time, lat, lon), and write it to a file
procedure do_eof(f, var)
;{{{
local var, an, eof, ts, ran
begin
  an = var
  an = var - conform(var, dim_avg_n(var,0), (/1,2/))
  ;an = where(ismissing(an),0,an)

  ; EOF
  neof   = 2
  optEOF = True       
  optETS = False
  ran    = an(lat|:,lon|:,time|:)                ; convenience, cleaner code
  eof    = eofunc_Wrap(ran, neof, optEOF)      
;  eof = -eof
  ts = eofunc_ts_Wrap (ran, eof, optETS)
  tsStd = dim_stddev_n(ts, 1)
  eof = eof*conform(eof, tsStd, (/0/))
  ts = dim_standardize_n( ts, 0, 1)      ; normalize

  f->pattern = eof
  f->ts = ts
end
;}}}

datDir = getenv("NCL_ARG_1")
nc = "calc_006_isothermal_depth.nc"
inFileExp = datDir + "post/" + nc
inFileRef = datDir + "../exp_spinup/post/" + nc
outfile = datDir + "post/" +getenv("NCL_ARG_0_base")+".nc"

temp = 20 ; 20 degC isothermal line

f = addfile(inFileExp, "r")
dtc = f->isot(:,{temp},:,:) 
delete(f)

f = addfile(inFileRef, "r")
dtcRef = f->isot(:,{temp},:,:) 
delete(f)

system("rm -f " + outfile)
f = addfile(outfile, "c")

dtc = dtc - dtcRef
f->diff = dtc
do_eof(f, dtc)

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
