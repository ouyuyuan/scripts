
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-12-28 09:29:26 BJT
; Last Change: 2014-08-08 08:53:11 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"
load "/home/ou/archive/scripts/draw/utils/ncl.ncl"

begin
  data_dir = "/home/ou/archive/data/roms/latte/cfsr/"
  nc = data_dir + "sea_2006_01hr_TaqaQrQp_box.nc"

  timename = "time"

  f = addfile(nc, "r")
  t = f->$timename$
  delete(f)

  dates = (/"2006-04-05 00:00:00",\
            "2006-04-07 00:00:00",\
            "2006-04-10 00:00:00"/)

  do i = 0, 2
    ti = ou_timestring2i( dates(i), t )
    print(ti+0)
  end do

end
