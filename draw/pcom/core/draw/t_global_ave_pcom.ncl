
; Description: global average potential temperature
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-04-10 16:41:49 BJT
; Last Change: 2014-10-07 08:34:00 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  img = getenv("NCL_ENV_image_name")
  fname = getenv("NCL_ENV_datafile_name")

  wks = gsn_open_wks ("eps", img)
  wks2 = gsn_open_wks ("eps", img + "_core_axis")

  f = addfile( fname, "r" )
  pt = f->y
  year = f->x
  delete(f)

  res = True
  res@tiYAxisString = "~S~o~N~C"
  res@tiXAxisString = "year"
  res@xyLineColor = "red"

  plot = gsn_csm_xy(wks, year, pt, res)

;;   core axis draw

  res2 = res

  res2@tmYLMode = "Explicit"
  res2@tmYLValues = (/ 1 ,  1.5 ,  2 ,  2.5 ,  3 ,  3.5 ,  4 ,  4.5 /)
  res2@tmYLLabels = (/"1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5"/)
  res2@trYMaxF = 4.5
  res2@trYMinF = 1.0

  plot2 = gsn_csm_xy(wks2, year, pt, res2)

end
