
; Description: extract a variable from cfsr grib data to make forcing file
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-08-31 20:11:56 BJT
; Last Change: 2014-08-31 20:12:36 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

function rdVar4D (f:file, vName:string, time:integer) 
; read GRIB 4D variable and assign new dimension names
begin 
  var = f->$vName$; read variable
  var!0 = "time"     ; assign 'conventional' dimension names 
  var!1 = "lev"  
  var!2 = "lat"  
  var!3 = "lon"
  var&time = time    ; assign time coord variable                 
  return(var)                                                             
end    

begin  
;***********************************************
; read in data from GRIB file
;***********************************************
   gribdir  = "./"
   gribfil  = "monthly_1979_1151.tar.grb"
   grib_in  = addfile(gribdir+gribfil, "r")

  ;print( grib_in )                       ; file overview

   TIME  = grib_in->initial_time0_hours   ; time as "hours since"  
   lat   = grib_in->g0_lat_2              ; latitude          
   lon   = grib_in->g0_lon_3              ; longitude           
   lev   = grib_in->lv_ISBL1              ; level

   lat!0 = "lat"                          ; assign new dimension name
   lon!0 = "lon"                          
   lev!0 = "lev"                                                          
   TIME!0= "time"

   time  = cd_calendar(TIME, -3)          ; change to date syntax
   time!0= "time"
   time@units = "yyyymmddhh"

   TMP   = rdVar4D (grib_in, "T_GDS0_ISBL" ,time)
   Z     = rdVar4D (grib_in, "Z_GDS0_ISBL" ,time) 
                                    
;***********************************************
; create parameters and output file
;*********************************************** 
    ntim  = dimsizes(time)              
    klev  = dimsizes(lev)                                                
    nlat  = dimsizes(lat)                                                
    mlon  = dimsizes(lon)                                                
         
    system("'rm' -f monthly_1979_1151.nc")     ; remove pre-exit file (if any)
    ncdf  = addfile("monthly_1979_1151.nc","c")  ; create output file  

;***************************************************
; define file options [Version a033]
;***********************************************
    setfileoption(ncdf, "prefill", False)
    setfileoption(ncdf, "suppressclose", True)
    setfileoption(ncdf, "definemode", True)

;***********************************************
; assign file attributes 
;***********************************************                     
    fAtt               = True                        
    fAtt@title         = "GRIB-to-netCDF: Efficient Approach"          
                
    fAtt@source_file   = "monthly_1979_1151.tar.grb"
    fAtt@Conventions   = "None"                                        
                
    fAtt@creation_date = systemfunc("date")  
    fileattdef( ncdf, fAtt )            

;***********************************************
; predefine coordinate information                
;***********************************************
    dimNames = (/"time", "lat", "lon",  "lev" /)                        
    dimSizes = (/ ntim ,  nlat,  mlon,  klev  /)                         
    dimUnlim = (/ True , False, False,  False /)                         
    filedimdef(ncdf, dimNames  , dimSizes,  dimUnlim )                   
    filevardef(ncdf, "time"  , typeof(time), getvardims(time) )            
    filevarattdef(ncdf, "time", time)                               
    filevardef(ncdf, "lev"  , typeof(lev) , getvardims(lev) ) 
    filevarattdef(ncdf, "lev", lev)  
    filevardef(ncdf, "lat", typeof(lat), getvardims(lat) )
    filevarattdef(ncdf, "lat", lat) 
    filevardef(ncdf, "lon", typeof(lon), getvardims(lon) ) 
    filevarattdef(ncdf, "lon", lon)      

;***********************************************
; predefine variable sizes
;*********************************************** 
    filevardef(ncdf,"TIME",typeof(TIME), getvardims(TIME) ) 
    filevarattdef(ncdf,"TIME",TIME) 

    filevardef(ncdf,"T",typeof(TMP), getvardims(TMP) ) 
    filevarattdef(ncdf,"T",TMP) 

    filevardef(ncdf,"Z",typeof(Z),getvardims(Z) )
    filevarattdef(ncdf,"Z",Z)

;***********************************************
; terminate define mode: not necessary but for clarity
;*********************************************** 
    setfileoption(ncdf, "definemode", False) 

;***********************************************
; write data values to predefined locations  
; (/ .../) operator transfer values only                     
;***********************************************
    ncdf->time   = (/ time /)     
    ncdf->lev    = (/ lev /)                                               
    ncdf->lat    = (/ lat /)                                              
    ncdf->lon    = (/ lon /)                                              

    ncdf->TIME   = (/ TIME/)
    ncdf->T      = (/ TMP /)                                              
    ncdf->Z      = (/  Z  /)
end             
