
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2014-10-24 20:10:38 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  nc = getenv("NCL_ARG_1")
  img = getenv("NCL_ARG_2")

  f = addfile( nc, "r" )
  y = f->y
  lat = f->lat
  delete(f)

  wks = gsn_open_wks ("eps", img)

  res = True
  ; resource {{{

;  res@vpHeightF = 0.56
;  res@vpWidthF = 0.72

  res@tiYAxisString = "latitude"
  res@tiXAxisString = "dyne/cm~S~2"

  res@gsnDraw = False
  res@gsnFrame = False
  res@gsnLeftString = ""
  res@gsnRightString = ""

  res@xyMonoLineColor = False
  res@xyDashPattern = 0 ; solid
  ;   res@xyMarkLineMode = "MarkLines"
  res@xyMarkLineMode = "Lines"
  ;   res@xyMarkers = (/6, 11, 16/)
  ;   res@xyMarkerColors = (/"blue", "red", "green"/)
;  res@xyLineColors = (/"black", "blue", "cyan", "red"/)
  res@xyLineColor = "red"
  res@xyLineThicknessF = 3
  res@xyDashPattern = 0

  ;   res@pmLegendDisplayMode = "Always"

  res@tmLabelAutoStride = True
  
  res@tmYROn = False
  res@tmXTOn = False
  res@tmYMajorGrid = True
  res@tmYMajorGridLineDashPattern = 2

;  res@tmXBMode = "Manual"
;  res@tmXBTickStartF   = 0
;  res@tmXBTickSpacingF = 50
;  res@tmXBTickEndF     = 500
  res@tmXMajorGrid = True
  res@tmXMajorGridLineDashPattern = 2

  ;   res@trXMaxF = 25
  ;   res@trYReverse               = True   ; reverses y-axis
  ;}}}

  plot = gsn_csm_xy(wks, y, lat, res)

  draw(plot)

  ; add legend
;  txres               = True
;  txres@txFontHeightF = 0.01
;  text = "PCOM, restored"
;  gsn_text_ndc(wks, text, 0.28, 0.65, txres)

end
