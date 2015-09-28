
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2014-10-27 20:03:35 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  nc = getenv("NCL_ARG_1")
  img = getenv("NCL_ARG_2")

  f = addfile( nc, "r" )
  control = f->control
  sh = f->sh
  sm = f->sm
  eq = f->eq
  nm = f->nm
  nh = f->nh
  lat = f->lat
  delete(f)

  profile = new( (/6, dimsizes(lat)/), float )
  profile(0,:) = sh
  profile(1,:) = sm
  profile(2,:) = eq
  profile(3,:) = nm
  profile(4,:) = nh
  profile(5,:) = control

  wks = gsn_open_wks ("eps", img)

  res = True
  ; resource {{{

;  res@vpHeightF = 0.56
;  res@vpWidthF = 0.72

  res@tiMainString = "a) Profile of Wind Stress in 6 Experiments"
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
  res@xyLineColors = (/"magenta1", "cyan", "red", "blue", "forestgreen", "black"/)
;  res@xyLineColor = "red"
  res@xyLineThicknessF = 3
  res@xyDashPattern = 0
  res@xyExplicitLegendLabels = (/"an_70S-30S", "an_40S-10S", "an_10S-20N", \
  "an_EQ-30N", "an_30N-60N", "control run"/)

  res@lgPerimOn = False
  res@lgLabelFontHeightF = 0.02
  res@lgPerimFill = "SolidFill"
  res@lgPerimFillColor = "White"

  res@pmLegendDisplayMode = "Always"
  res@pmLegendSide = "Right"
  res@pmLegendOrthogonalPosF = -0.5
  res@pmLegendWidthF = 0.1
  res@pmLegendHeightF = 0.3

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

  res@trYMaxF = 80
  res@trYMinF = -80
  ;   res@trYReverse               = True   ; reverses y-axis
  ;}}}

  plot = gsn_csm_xy(wks, profile, lat, res)

  draw(plot)

  ; add legend
;  txres               = True
;  txres@txFontHeightF = 0.01
;  text = "PCOM, restored"
;  gsn_text_ndc(wks, text, 0.28, 0.65, txres)

end
