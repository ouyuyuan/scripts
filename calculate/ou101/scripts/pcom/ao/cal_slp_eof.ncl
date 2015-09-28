
; Description: reference eof_4.ncl at NCL official cite
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-05 15:06:11 BJT
; Last Change: 2014-11-06 07:35:23 BJT
;==============================================================

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; ==============================================================
; User defined parameters that specify region of globe and
; ==============================================================
  outfile = getenv("NCL_ARG_1")
  system("rm -f " + outfile)
  fout = addfile(outfile, "c")

  latS   = 20.
  latN   = 90. 

;  yrStrt = 1979
;  yrLast = 2000
  yrStrt = 1948
  yrLast = 2011

  ymStrt = yrStrt*100 +  1
  ymLast = yrLast*100 + 12

  neof   = 1                                  ; Leading EOF only
  optEOF = True       
  optETS = False

; ==============================================================
; Open the file: Read only the user specified period and level
; ==============================================================
  dir = "/home/ou/archive/data/ncep/"
  f      = addfile (dir+"slp.mon.mean.nc", "r")

  TIME   = f->time
  YYYY   = cd_calendar(TIME,-1)/100                 ; entire file
  iYYYY  = ind(YYYY.ge.yrStrt .and. YYYY.le.yrLast)

  x      = f->slp(iYYYY,{latS:latN},:)
;  printVarSummary(x)                                ; (time, lat,lon)

; ==============================================================
; compute climatology and Anomalies
; ==============================================================
  xClm   = clmMonTLL(x)                             ; (12,lat,lon)
;  printVarSummary(xClm)

  xAnom  = calcMonAnomTLL ( x, xClm)                ; (time, lat,lon)
;  printVarSummary(xAnom)         
;  printMinMax(xAnom, True)
;  fout->an = xAnom

; =================================================================
; create weights:  sqrt(cos(lat))   [or sqrt(gw) ]
; =================================================================
  rad    = 4.*atan(1.)/180.
  clat   = xAnom&lat            
  clat   = sqrt( cos(rad*clat) )                 ; gw for gaussian grid
;  printVarSummary(clat)

; =================================================================
; weight all observations 
; =================================================================
  xw     = xAnom*conform(xAnom, clat, 1)
  copy_VarMeta(x, xw)
  xw@long_name = "Wgt: "+x@long_name

; =================================================================
; Reorder (lat,lon,time) the *weighted* input data
; Compute EOFs & Standardize time series
; =================================================================
  wx     = xw(lat|:,lon|:,time|:)                ; convenience, cleaner code
  delete(xw)

  eof    = eofunc_Wrap(wx, neof, optEOF)      
  eof = -eof ; make match the pattern sign of CPC
;  fout->eof = eof(0,:,:)

  eof_ts = eofunc_ts_Wrap (wx, eof, optETS)
;  fout->ts = eof_ts(0,:)

;  printVarSummary( eof )                         ; examine EOF variables
;  printVarSummary( eof_ts )

  eof_ts = dim_standardize_n( eof_ts, 0, 1)      ; normalize
  fout->ts_sd = eof_ts(0,:)

; =================================================================
; Regress
; =================================================================

  eof_regres = eof                               ; create an array w meta data
  do ne=0,neof-1
     eof_regres(ne,:,:) = (/ regCoef(eof_ts(ne,:), xAnom(lat|:,lon|:,time|:)) /)
  end do
  eof_regres@units = "hPa"
  fout->eof_regres = eof_regres(0,:,:)
