
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2014-10-29 08:46:54 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure draw_profile(img, inres, arg)
local res, f
begin
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
  res@xyExplicitLegendLabels = (/" "+arg@exTitle, " control run"/)

  res@lgPerimOn = False
  res@lgLabelFontHeightF = 0.02
  res@lgPerimFill = "SolidFill"
  res@lgPerimFillColor = "White"

  res@pmLegendDisplayMode = "Always"
  res@pmLegendSide = "Right"
  res@pmLegendOrthogonalPosF = -0.5
  res@pmLegendWidthF = 0.1
  res@pmLegendHeightF = 0.1

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
arg@exTitle = "exp_an_15S-15N"
;draw_profile(img+"___15S-15N", res, arg)

; anomaly at 60S~60N
;====================
arg@ctrVarName = "control"
arg@exVarName = "an_60S60N"
arg@exTitle = "exp_an_60S-60N"
;draw_profile(img+"___60S-60N", res, arg)

; anomaly at 70S~30S
;====================
arg@ctrVarName = "control"
arg@exVarName = "an_70S30S"
arg@exTitle = "exp_an_70S-30S"
;draw_profile(img+"___70S-30S", res, arg)

; anomaly at 40S~10S
;====================
arg@ctrVarName = "control"
arg@exVarName = "an_40S10S"
arg@exTitle = "exp_an_40S-10S"
;draw_profile(img+"___40S-10S", res, arg)

; anomaly at 10S~20N
;====================
arg@ctrVarName = "control"
arg@exVarName = "an_10S20N"
arg@exTitle = "exp_an_10S-20N"
;draw_profile(img+"___10S-20N", res, arg)

; anomaly at EQ~30N
;====================
arg@ctrVarName = "control"
arg@exVarName = "an_EQ30N"
arg@exTitle = "exp_an_EQ-30N"
;draw_profile(img+"___EQ-30N", res, arg)

; anomaly at 30N~60N
;====================
arg@ctrVarName = "control"
arg@exVarName = "an_30N60N"
arg@exTitle = "exp_an_30N-60N"
;draw_profile(img+"___30N-60N", res, arg)

