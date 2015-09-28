
; Description: exract wrf 2d grid, save it to file
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-08-19 10:36:29 BJT
; Last Change: 2014-09-24 10:06:00 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
  in = "/media/SAMSUNG/WRF_601x361/output/wrfout_d01_2014-07-17_00:00:00"
  out = "/home/ou/archive/data/roms/hyzx/wrf_grid.nc"

  f = addfile( in, "r" )
  lat = f->XLAT(0,:,:)
  lon = f->XLONG(0,:,:)
  landmask = f->LANDMASK(0,:,:)
  delete(f)

  system("rm -f " + out)
  f = addfile( out, "c" )
  f->XLAT=lat
  f->XLONG=lon
  f->LANDMASK=landmask

end
