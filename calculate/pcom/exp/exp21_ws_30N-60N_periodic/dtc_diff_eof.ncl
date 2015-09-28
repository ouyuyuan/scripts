
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:43:19 BJT
; Last Change: 2014-11-29 09:34:50 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure do_eof(f, dtc, patName, tsName)
begin
  an = dtc
  an = dtc - conform(dtc, dim_avg_n(dtc,0), (/1,2/))
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

  f->$patName$ = eof
  f->$tsName$ = ts
end

indir = getenv("NCL_ARG_1")

yearb = 41 ; drop the first 40 years
temp = 20 ; 20 degC isothermal line
latS = -20.5
latN = 20.5

f = addfile("/home/ou/archive/data/pcom/basin/basin.nc", "r")
basin = f->basin({latS:latN},:)
delete(f)

f = addfile(indir+"isothermal_line_depth.nc", "r")
dtc = f->isot({yearb-1:},{temp},{latS:latN},:) 
lat = f->lat({latS:latN})
delete(f)
dtc = smth9(dtc, 0.5, 0.25, False)
basinc = conform(dtc, basin, (/1,2/))
latc = conform(dtc, lat, (/1/))

f = addfile("/home/ou/archive/data/pcom/exp17_ws_control_cycle_re/post/isothermal_line_depth.nc", "r")
dtc_ctr = f->isot({yearb-1:},{temp},{latS:latN},:) 
delete(f)
dtc_ctr = smth9(dtc_ctr, 0.5, 0.25, False)

outfile = getenv("NCL_ARG_1")+getenv("NCL_ARG_0_base")+".nc"
system("rm -f " + outfile)
f = addfile(outfile, "c")

dtc = dtc - dtc_ctr
dtc = smth9(dtc, 0.5, 0.25, False)
do_eof(f, dtc, "eof_glo", "ts_glo")

dtc_Pac = dtc
dtc_Pac = where(basinc.eq.2, dtc, dtc@_FillValue)
do_eof(f, dtc_Pac, "eof_Pac", "ts_Pac")

dtc_Atl = dtc
dtc_Atl = where(basinc.eq.6, dtc, dtc@_FillValue)
do_eof(f, dtc_Atl, "eof_Atl", "ts_Atl")

dtc_Ind = dtc
dtc_Ind = where(basinc.eq.3, dtc, dtc@_FillValue)
do_eof(f, dtc_Ind, "eof_Ind", "ts_Ind")

dtc_Pac_N = dtc_Pac
dtc_Pac_N = where(latc.gt.0, dtc_Pac, dtc@_FillValue)
do_eof(f, dtc_Pac_N, "eof_Pac_N", "ts_Pac_N")

dtc_Pac_S = dtc_Pac
dtc_Pac_S = where(latc.lt.0, dtc_Pac, dtc@_FillValue)
do_eof(f, dtc_Pac_S, "eof_Pac_S", "ts_Pac_S")

dtc_Atl_N = dtc_Atl
dtc_Atl_N = where(latc.gt.0, dtc_Atl, dtc@_FillValue)
do_eof(f, dtc_Atl_N, "eof_Atl_N", "ts_Atl_N")

dtc_Atl_S = dtc_Atl
dtc_Atl_S = where(latc.lt.0, dtc_Atl, dtc@_FillValue)
do_eof(f, dtc_Atl_S, "eof_Atl_S", "ts_Atl_S")

dtc_Ind_N = dtc_Ind
dtc_Ind_N = where(latc.gt.0, dtc_Ind, dtc@_FillValue)
do_eof(f, dtc_Ind_N, "eof_Ind_N", "ts_Ind_N")

dtc_Ind_S = dtc_Ind
dtc_Ind_S = where(latc.lt.0, dtc_Ind, dtc@_FillValue)
do_eof(f, dtc_Ind_S, "eof_Ind_S", "ts_Ind_S")

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
