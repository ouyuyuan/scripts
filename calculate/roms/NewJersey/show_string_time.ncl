
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-12-28 09:29:26 BJT
; Last Change: 2014-08-08 11:09:41 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"

begin
;  nc = "/home/ou/archive/data/roms/latte/cfsr/sea_2006_01hr_TaqaQrQp.nc"
  nc = "/home/ou/archive/data/roms/latte/in/frc_latte_wrf_Tair.nc"

;  timename = "time"
  timename = "ncep_time"

  f = addfile(nc, "r")
  t = f->$timename$
  delete(f)

  t@units = "days since 2006-01-01 00:00:00"

  format = "%Y-%N-%D %H:%M:%S"
  st = cd_string( t, format )
  print(st)

end
