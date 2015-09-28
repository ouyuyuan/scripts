
; Description: get lat/lon corners of RHO points from WRF output 
;              (for seagrid "load boundary")
;
;            1 ---------- 4
;              |        |
;        Eta   |        |        O:  Origin of ROMS (Xi,Eta) coordinates
;              |        |
;            2 ---------- 3
;              O
;                  Xi
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-08-08 21:11:19 BJT
; Last Change: 2014-08-19 20:31:52 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
  fname = "/home/ou/archive/data/roms/hyzx/wrf_grid.nc"

  f = addfile( fname, "r" )
  lat = f->XLAT(:,:)
  lon = f->XLONG(:,:)
  delete(f)

  dims = dimsizes(lat)
  nlat = dims(0)
  nlon = dims(1)

  lat1 = lat(nlat-1,0)
  lon1 = lon(nlat-1,0)

  lat2 = lat(0,0)
  lon2 = lon(0,0)

  lat3 = lat(0,nlon-1)
  lon3 = lon(0,nlon-1)

  lat4 = lat(nlat-1,nlon-1)
  lon4 = lon(nlat-1,nlon-1)

  fmt = "%7.6f"
  
  print( sprintf(fmt, lon1) + "  " + sprintf(fmt, lat1) )
  print( sprintf(fmt, lon2) + "  " + sprintf(fmt, lat2) )
  print( sprintf(fmt, lon3) + "  " + sprintf(fmt, lat3) )
  print( sprintf(fmt, lon4) + "  " + sprintf(fmt, lat4) )

  print( "nlat: " + sprintf("%4.0f",nlat) )
  print( "nlon: " + sprintf("%4.0f",nlon) )

end
