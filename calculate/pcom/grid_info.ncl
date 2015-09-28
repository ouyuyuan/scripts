
; Description: calc PCOM grid information for integration and differentation, etc
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-12 07:08:41 BJT
; Last Change: 2015-03-22 09:18:20 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir  = "/home/ou/archive/data/pcom/"
fileOut = datDir + "grid_info.nc"

f = addfile( datDir+"input/pcom_ini.nc", "r" )
idx = f->idx
z   = f->z
lat = f->lat
lon = f->lon
delete(f)
delete(idx@missing_value)

; cal thickness of each layer
; assume z is at the middle of the level
;========================================
nz = dimsizes(z)
if (z(0)-0 .lt. 10e-6) then
  print("the first layer is zero, stop.")
  return
end if

dz = z*0
dz(0) = z(0) * 2
do i = 1, nz - 1
  dz(i) = (z(i) - sum(dz)) * 2
  if (dz(i) .lt. 0) then
     print("thickness of layer is not positive! stop.")
     return
  end if
end do
;   print(dz+0)
dz!0 = "z"
dz&z = z
dz@long_name = "layer thicknesses"
dz@units = z@units

zb = dz
zb@long_name = "bottom depth of each layer"
zb = dim_cumsum(dz, 2)

pi  = 3.141592653589793
torad = pi/180.0
;r = 6371220.0 ; radius of the earth, meter
r = 6371e3 ; radius of the earth, meter

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

system("rm -f " + fileOut)
f = addfile(fileOut, "c")
f->idx = idx
f->dx = dx
f->dy = dy
f->dz = dz
f->zb = zb
f->ds = ds
f->dv = dv

f@data = "grid info. of PCOM, for integration and differentation, etc."
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
