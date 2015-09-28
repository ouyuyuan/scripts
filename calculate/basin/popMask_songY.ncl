;***********************************************
; ref. popmask_3.ncl
; generate a 0.125 X 0.125 basin for Song Yi
;
; Concepts illustrated:
;   - Using builtin functions to minimize computational load
;   - Selecting nearest gridpoint of POP file to a target grid point
;************************************************

;************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"    
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"  

;************************************************
; Create target grid. Here a rectilinear grid.
;************************************************
  keyi = "SongY"
  diri = "/home/ou/archive/data/pcom/input/"
  lat  = fspan(-90, 90, 180*8+1)
  lon  = fspan(-180, 180, 360*8)
;  print(lat+0)
;  print(lon+0)
;  exit

  nlat = dimsizes(lat)
  mlon = dimsizes(lon)

  msg  = -999
  pmsk = new ( (/nlat,mlon/), "integer", msg)
  pmsk!0   = "lat"
  pmsk!1   = "lon"
  pmsk&lat =  lat
  pmsk&lon =  lon

  
;************************************************
; Read POP variables
;************************************************
  diri  = "/home/ou/archive/data/pop/"
  fili  = "example.nc"
  pathi = diri+fili
  fin   = addfile(pathi,"r")
  rmask = fin->REGION_MASK        ; (384,320)
  lat2d = fin->TLAT               ;     "
  lon2d = fin->TLONG              ;     "

  dim2d = dimsizes(lat2d)         ; POP grid size
  jlat  = dim2d(0)                ; 384
  ilon  = dim2d(1)                ; 320

  printVarSummary(rmask)
  printMinMax(rmask, True)       ; -14 ==> 11
  printVarSummary(lat2d)
  printMinMax(lat2d, True)  
  
;************************************************
; Operations to improve speed:
;************************************************

  jlat2d = conform_dims( dim2d, ispan(0,jlat-1,1), 0)
  ilon2d = conform_dims( dim2d, ispan(0,ilon-1,1), 1)
  
  rmask_1d  = ndtooned(rmask)
  lat2d_1d  = ndtooned(lat2d)
  lon2d_1d  = ndtooned(lon2d)
  jlat2d_1d = ndtooned(jlat2d)
  ilon2d_1d = ndtooned(ilon2d)
  kpop_1d   = dimsizes(rmask_1d)   ; 384*320
 
;************************************************
; Closest POP mask value to target grid
; (a) loop over target grid 
; (b) for each target latitude; get subset indexes
; (c) calculate great circle distances for subset of data
; (d) ascertain the correct POP grid mask and assign
;************************************************
  wcStrt = systemfunc("date")
  
  latbuf = 3.0  ; arbitrary

  do nl=0,nlat-1
     latlo = lat(nl)-latbuf     ; latitude bound
     lathi = lat(nl)+latbuf
     kk    = ind(lat2d_1d.gt.latlo .and. lat2d_1d.lt.lathi)
     if (.not.ismissing(kk(0))) then
     
         do ml=0,mlon-1        
            gcdist = gc_latlon(lat(nl),lon(ml), lat2d_1d(kk),lon2d_1d(kk), 2, 2)
            if (.not.ismissing(gcdist(0))) then
                jlkk  = jlat2d_1d(kk)
  	        ilkk  = ilon2d_1d(kk)
                kkmin = minind(gcdist)
	        jl    = jlkk(kkmin)
	        il    = ilkk(kkmin)
                pmsk(nl,ml) = (/ rmask(jl,il) /) 
		delete([/jlkk,ilkk,kkmin/])
            end if          ; (.not.ismissing(gcdist(0)))
	    delete(gcdist)
         end do             ; ml loop
 
     end if                 ; (.not.ismissing(kk(0)))
     delete(kk)
  end do                    ; nl loop

  printVarSummary(pmsk)

  wallClockElapseTime(wcStrt, "Mask Creation: "+keyi, 0)
;************************************************
; Write netCDF
;************************************************
  filo  = "popMask."+keyi+".nc"
  system("/bin/rm -f "+filo)
  ncdf  = addfile(filo, "c")

  ncAtts= True
  ncAtts@title = "POP Mask at "+nlat+"x"+mlon+": "+keyi
  ncAtts@pop_source    = fili 
  ncAtts@pop_grid      = "nlat="+jlat+";  nlon="+ilon  
  ncAtts@creation_date = systemfunc("date")
  fileattdef( ncdf, ncAtts ) 

  pmsk@long_name = rmask@long_name

  ncdf->GMASK  = pmsk
