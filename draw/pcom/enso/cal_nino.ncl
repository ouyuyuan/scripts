
; Description: ref. ref/indices_nino_1.ncl, ref/indices_oni_1.ncl
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-15 15:13:24 BJT
; Last Change: 2014-11-15 20:27:00 BJT
;----------------------------------------------------------------------

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl" 

procedure cal_indices(arg)
;---------------------------------------------------------------------------
begin

  nrun = arg@nrun
  latS  = -5.0
  latN  =  5.0
  lonL  = 190.0
  lonR  = 240.0
  
  ymStrt= 194801
  ymLast= 200812    

  clStrt= arg@clStrt
  clLast= arg@clLast

  in     = addfile(arg@infile, "r")

;*********************************
; The index code below assumes that each year has 12 months 
;*********************************
  X      = in->bct(:,{latS:latN},{lonL:lonR})

  YYYYMM = cd_calendar(X&t, -1)      ; ALL dates assciated with X
  tStrt  = ind(YYYYMM.eq.ymStrt)        ; indices of selected times
  tLast  = ind(YYYYMM.eq.ymLast)
  delete(YYYYMM)

  x      = X(tStrt:tLast,:,:)           ; subset to desired time interval
  yyyymm = cd_calendar(x&t, -1) 
  dimx   = dimsizes(x)
  ntim   = dimx(0)

  delete(X)                             ; no longer needed

;*********************************
; time indices for base climatology 
;*********************************

  iClmStrt = ind(yyyymm.eq.clStrt)     
  iClmLast = ind(yyyymm.eq.clLast)    

;*********************************
; Climatology and anomalies from base climatology   
;*********************************

  xClm     = clmMonTLL(x(iClmStrt:iClmLast,:,:))

  xAnom    = calcMonAnomTLL (x,  xClm ) 
  xAnom@long_name = "SST Anomalies"

;*********************************
; Unweighted areal averages & anomalies (time series)
; Small latitudinal extent so no need to weight    
;*********************************

  x_avg     = wgt_areaave_Wrap(x    , 1.0, 1.0, 1)
  x_avg@long_name = "areal avg"

  xAnom_avg = wgt_areaave_Wrap(xAnom, 1.0, 1.0, 1)
  xAnom_avg@long_name = "areal avg anomalies"

;  printVarSummary(xAnom_avg)

;*********************************
; Compute standardized anomalies; use clm period    
;*********************************

  xAnom_std = xAnom_avg
  xAnom_std = xAnom_avg/stddev(xAnom_avg(iClmStrt:iClmLast))
  xAnom_std@long_name = "areal avg standardized anomalies"
;  printVarSummary(xAnom_std)

;*********************************
; Perform an unweighted nrun-month running average on the index
; 2 months lost at start & end if endopt=0  ... reflective if endopt=1
;*********************************

  endopt    = 1
  ii = ind(.not.ismissing(xAnom_std))
  xAnom_std(ii) = runave_n_Wrap (xAnom_std(ii), nrun, endopt, 0)

;  print(yyyymm+"   "+x_avg+"   "+xAnom_avg+"   "+xAnom_std)

;*************************************************************************
; Create netCDF: avg, anomalies, standardizes index
;*************************************************************************
  yyyymm!0 = "t"
  yyyymm&t= x_avg&t

  cdfName = getenv("NCL_ARG_1")

  if (arg@createOutfile .eq. True) then
    system("/bin/rm -f "+cdfName)         ; remove any pre-existing file
    ncdf     = addfile(cdfName ,"c")      ; open output netCDF file
  ; make time and UNLIMITED dimension     ; recommended  for most applications
    filedimdef(ncdf,"t",-1,True)

    ncdf->yyyymm      =  yyyymm
    ncdf->sst_region =  x_avg
  else
    ncdf     = addfile(cdfName ,"w")      ; open output netCDF file
  end if

  ncdf->$arg@sstAnomName$    =  xAnom_avg
  ncdf->$arg@ninoIndicesName$ =  xAnom_std
end

;---------------------------------------------------------------------------
; There are four region based indices used to monitor the tropical Pacific: 
; Nino 1+2 (0-10S, 90W-80W), Nino 3 (5N-5S, 150W-90W), 
; Nino 3.4/ONI (5N-5S, 170W-120W) and Nino 4 (5N-5S, 160E-150W)
;---------------------------------------------------------------------------

arg = True
arg@infile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn_re.nc"

; NINO 3.4 indices
;==========================================================================
arg@createOutfile = True
arg@nrun  = 5             ; length of running average
arg@clStrt= 195001          ; climatology start    
arg@clLast= 197912          ;             last
arg@sstAnomName  =  "sst_anom_nino34"
arg@ninoIndicesName =  "nino34"
cal_indices(arg)

; ONI index
;===========================================================================
;---------------------------------------------------------------------------
; NOAA's operational definitions of El Niño and La Niña conditions are based
; upon the Oceanic Niño Index [ONI]. The ONI is defined as the 3-month running
; means of SST anomalies in the Niño 3.4 region [5N-5S, 120-170W]. The anomalies
; are derived from the 1971-2000 SST climatology.
;
; The Niño 3.4 anomalies may be thought of as representing the average equatorial
; SSTs across the Pacific from about the dateline to the South American coast.
; To be classified as a full-fledged El Niño and La Niña episode the ONI must excee
; d +0.5 [El Niño] or -0.5 [La Niña] for at least five consecutive months. 
;---------------------------------------------------------------------------
arg@createOutfile = False
arg@nrun  = 3             ; length of running average
arg@clStrt= 197101          ; climatology start    
arg@clLast= 200012          ;             last
arg@sstAnomName  =  "sst_anom_oni"
arg@ninoIndicesName =  "oni"
cal_indices(arg)
