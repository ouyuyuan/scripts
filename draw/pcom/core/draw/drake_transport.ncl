
; Description: drake transport trend
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-09 18:54:19 BJT
; Last Change: 2014-10-09 18:54:19 BJT

; Description: global average potential temperature
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-04-10 16:41:49 BJT
; Last Change: 2014-10-09 19:29:09 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  img = getenv("NCL_ENV_image_name")
  fname = getenv("NCL_ENV_datafile_name")

  wks = gsn_open_wks ("eps", img)
  wks2 = gsn_open_wks ("eps", img + "_core_axis")

  f = addfile( fname, "r" )
  y = f->y
  year = f->x
  delete(f)
  y(0) = y(1) ; initial is zero, occupy space of the plot

  res = True

  res@vpHeightF = 0.56
  res@vpWidthF = 0.72

  res@gsnDraw = False
  res@gsnFrame = False
  res@gsnLeftString = ""
  res@gsnRightString = ""

  res@tiYAxisString = "Sv"
  res@tiXAxisString = "Year"

  res@xyMonoLineColor = False
  ;   res@xyMarkLineMode = "MarkLines"
  res@xyMarkLineMode = "Lines"
  res@xyLineColor = "red"
  res@xyLineThicknessF = 3
  res@xyDashPattern = 0

  res@tmYROn = False
  res@tmXTOn = False
  res@tmYMajorGrid = True
  res@tmYMajorGridLineDashPattern = 2

  res@tmXBMode = "Manual"
  res@tmXBTickStartF   = 0
  res@tmXBTickSpacingF = 50
  res@tmXBTickEndF     = 500

  res@tmXMajorGrid = True
  res@tmXMajorGridLineDashPattern = 2

  plot = gsn_csm_xy(wks, year, y, res)
  draw(plot)

  txres               = True
  txres@txFontHeightF = 0.025
  text = "Drake Passage transport"
  gsn_text_ndc(wks, text, 0.5, 0.85, txres)

;;   core axis draw

  res2 = res

  res2@tmYLMode = "Manual"
  res2@tmYLTickStartF   = 0
  res2@tmYLTickSpacingF = 20
  res2@tmYLTickEndF     = 200
;  res2@tmYRMode = "Explicit"
;  res2@tmYLValues = (/0,20,40,60,80,100,120,140,150,180,200/)
;  res2@tmYLLabels = res2@tmYLValues

  res2@trYMaxF = 200
  res2@trYMinF = 0

  plot2 = gsn_csm_xy(wks2, year, y, res2)
  draw(plot2)


end
