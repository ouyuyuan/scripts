
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2014-11-18 08:51:55 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure draw_profile(img, inres, arg)
local res, f
begin
  fontheight = 0.03
  nc = getenv("NCL_ARG_1")
  f = addfile( nc, "r" )
  ctr = f->$arg@ctrVarName$
  ex  = f->$arg@exVarName$
  lat = f->lat
  delete(f)

  profile = new( (/2, dimsizes(lat)/), float )
  profile(0,:) = ex
  profile(1,:) = ctr

  wks = gsn_open_wks ("eps", img)

  res = True

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
;  res@xyLineColors = (/"magenta1", "cyan", "red", "blue", "forestgreen"/)
  res@xyLineColors = (/"red", "black"/)
;  res@xyLineColor = "red"
  res@xyLineThicknessF = 3
  res@xyDashPattern = 0
  res@xyExplicitLegendLabels = (/" "+arg@exTitle, " control"/)

  res@lgPerimOn = False
  res@lgLabelFontHeightF = 0.04
  res@lgPerimFill = "SolidFill"
  res@lgPerimFillColor = "White"

  res@pmLegendDisplayMode = "Always"
  res@pmLegendSide = "Right"
  res@pmLegendOrthogonalPosF = -0.5
  res@pmLegendWidthF = 0.1
  res@pmLegendHeightF = 0.15

  res@tmLabelAutoStride = True
  
  res@tmYROn = False
  res@tmXTOn = False
  res@tmYMajorGrid = True
  res@tmYMajorGridLineDashPattern = 2
  res@tmYMajorGridThicknessF = 0.5
  res@tmYLTickStartF   = -80
  res@tmYLTickSpacingF = 20
  res@tmYLTickEndF     = 80
  res@tmXMajorGridThicknessF = 0.5

  res@tmYLLabelFontHeightF = fontheight
  res@tmXBLabelFontHeightF = fontheight
  res@tmYLMode = "Explicit"
  res@tmYLValues = (/-60, -15, 15, 60/)
  res@tmYLLabels = (/"60S", "15S", "15N", "60N"/)
;  res@tmXBMode = "Explicit"
;  res@tmXBValues = (/0,100,200,300/)
;  res@tmXBLabels = (/"0~S~o~N~E", "100~S~o~N~E", "160~S~o~N~W", "60~S~o~N~W"/)

;  res@tmXBMode = "Manual"
;  res@tmXBTickStartF   = 0
;  res@tmXBTickSpacingF = 50
;  res@tmXBTickEndF     = 500
  res@tmXMajorGrid = True
  res@tmXMajorGridLineDashPattern = 2

  ;   res@trXMaxF = 25
  ;   res@trYReverse               = True   ; reverses y-axis

  copy_VarAtts(inres, res)
  plot = new(2, graphic)
  res@tiMainString =  "a) wind stress profile"
  plot(0) = gsn_csm_xy(wks, profile, lat, res)
  res@tiMainString =  "b) anomaly to control run"
  res@pmLegendDisplayMode = "Never"
  res@tmXBMode = "Explicit"
  res@tmXBValues = (/-0.1, -0.05, 0.0/)
;  res@tmXBLabels = (/"0~S~o~N~E", "100~S~o~N~E", "160~S~o~N~W", "60~S~o~N~W"/)
  res@tmXBLabels = res@tmXBValues
  plot(1) = gsn_csm_xy(wks, ex - ctr, lat, res)

  resP = True
  resP@txString = "Zonal Profile of Wind Stress of "+arg@exTitle
  resP@gsnFrame = False
  resP@gsnPanelRowSpec = True
   resP@gsnPanelXWhiteSpacePercent = 5
;   resP@gsnPanelYWhiteSpacePercent = 5
  gsn_panel(wks, plot, (/2/), resP)

;  draw(plot)
  delete(wks)
  system("eps2png_trim "+img)

end

img = getenv("NCL_ARG_2")
res = True
arg = True

; anomaly at 15S~15N
;====================
arg@ctrVarName = "control"
arg@exVarName = "an_15S15N"
;arg@exTitle = "exp_15S-15N"
arg@exTitle = "exp"
draw_profile(img, res, arg)
