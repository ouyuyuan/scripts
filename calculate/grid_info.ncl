
; Description: calc Ishii data grid information for integration and differentation, etc
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-12 07:08:41 BJT
; Last Change: 2014-12-11 20:29:49 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  datDir = getenv("NCL_ARG_1")
  outfile  = datDir + "post/grid_info.nc"

  f = addfile( datDir+"sample.nc", "r" )
  depth0   = f->depth
  lat0 = f->lat
  lon0 = f->lon
  temp = f->wtmp(0,:,:,:)
  delete(f)
  depth = doubletofloat(depth0)
  lat = doubletofloat(lat0)
  lon = doubletofloat(lon0)
  copy_VarAtts(depth0, depth)
  copy_VarAtts(lat0, lat)
  copy_VarAtts(lon0, lon)

  ; cal thickness of each layer
  ; the first layer depth is zero
  ;===============================
  nz = dimsizes(depth)

   dz = depth*0
   dz(0) = depth(1) * 0.5
   do i = 1, nz - 2
    dz(i) = (depth(i) - depth(i-1)) * 0.5 + (depth(i+1)-depth(i))*0.5
   end do
  dz(nz-1) = (depth(nz-1) - depth(nz-2))
;   print(dz+0)
  dz!0 = "depth"
  dz&depth = depth
  dz@long_name = "layer thicknesses"
  dz@units = depth@units

  pi  = 3.141592653589793
  torad = pi/180.0
  r = 6371e3 ; radius of the earth, meter

  ; cal. mask
  ;=========================================
  dims = dimsizes(temp)
  idx = new(dims, integer)
  idx = where(ismissing(temp), 0, 1)
  idx@long_name = "water grid, 1 is water"
  copy_VarCoords(temp, idx)

  ; cal. dx
  ;===================

  nlat = dimsizes(lat)
  nlon = dimsizes(lon)
  dx = new( (/nlat,nlon/), "float" )
  dx = r * ( lon(1) - lon(0) ) * torad
  dx = dx * conform( dx, cos(lat*torad), 0 )

  dx@units = "m"
  dx@long_name = "zonal grid length"
  dx!0 = "lat"
  dx!1 = "lon"
  dx&lat = lat
  dx&lon = lon

  ; cal. dy
  ;===================
  dy = dx
  dy = r * ( lat(1) - lat(0) ) * torad
  dy@long_name = "meridional grid length"

  ; grid area
  ;==============
  ds = dx
  ds = dx * dy
  ds@long_name = "grid box area"
  ds@units = "m^2"

  ; grid volume
  ;==============
  dv = new( (/nz,nlat,nlon/), "float" )
  dv = conform(dv, ds, (/1,2/)) * conform(dv, dz, 0)
  dv@long_name = "grid box volume"
  dv@units = "m^3"
  copy_VarCoords(idx, dv)
;  printVarSummary(dv)

  system("rm -f " + outfile)
  f = addfile(outfile, "c")
  f->idx = idx
  f->dx = dx
  f->dy = dy
  f->dz = dz
  f->ds = ds
  f->dv = dv

  f@data = "grid info. of Ishii, for integration and differentation, etc."
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")

end
