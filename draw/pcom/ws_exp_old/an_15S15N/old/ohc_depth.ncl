
; Description: for comparison with NOAA result
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-11 10:54:25 BJT
; Last Change: 2014-11-11 16:34:35 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  nc = getenv("NCL_ARG_1")
  img = getenv("NCL_ARG_2")

  f = addfile( nc, "r" )
  ohc_all = f->control_all
  ohc_700 = f->control_700
  ohc_2000 = f->control_2000
  year = f->time
  delete(f)
  year = year - 500

  ohc= new( (/3, dimsizes(year)/), typeof(ohc_all) )
  ohc(0,:) = ohc_700
  ohc(1,:) = ohc_2000
  ohc(2,:) = ohc_all

  wks = gsn_open_wks ("eps", img)

  ohc = ohc * 1.0e-25

  res = True

;  res@vpHeightF = 0.56
;  res@vpWidthF = 0.72

  res@tiMainString = "Ocean Heat Content, control run"
  res@tiYAxisString = "10~S~25~N~J"
  res@tiXAxisString = "year"

  res@gsnDraw = False
  res@gsnFrame = False
  res@gsnLeftString = ""
  res@gsnRightString = ""

  res@xyMonoLineColor = False
  res@xyDashPattern = 0 ; solid
  ;   res@xyMarkLineMode = "MarkLines"
  res@xyMarkLineMode = "Lines"
  ;   res@xyMarkers = (/6, 11, 16/)
;     res@xyMarkerColors = (/"blue", "red", "forestgreen"/)
;  res@xyMarkerColors = (/"black", "blue", "red"/)
;  res@xyLineColors = (/"magenta1", "cyan", "red", "blue", "forestgreen"/)
  res@xyLineColors = (/"blue", "red", "black"/)
  res@xyLineThicknessF = 3
  res@xyDashPattern = 0
  res@xyExplicitLegendLabels = (/"0-700m", "0-2000m", "all depth"/)

  res@lgPerimOn = False
  res@lgLabelFontHeightF = 0.02
  res@lgPerimFill = "SolidFill"
  res@lgPerimFillColor = "White"

  res@pmLegendDisplayMode = "Always"
  res@pmLegendSide = "Right"
  res@pmLegendOrthogonalPosF = -0.45
  res@pmLegendWidthF = 0.1
  res@pmLegendHeightF = 0.5

  res@tmLabelAutoStride = True
  
;  res@tmYROn = False
;  res@tmXTOn = False
  res@tmYMajorGrid = True
  res@tmYMajorGridLineDashPattern = 2
  res@tmYMajorGridThicknessF = 0.5
;  res@tmYLTickStartF   = -80
;  res@tmYLTickSpacingF = 20
;  res@tmYLTickEndF     = 80
  res@tmXMajorGridThicknessF = 0.5

;  res@tmXBMode = "Manual"
;  res@tmXBTickStartF   = 0
;  res@tmXBTickSpacingF = 50
;  res@tmXBTickEndF     = 500
  res@tmXMajorGrid = True
  res@tmXMajorGridLineDashPattern = 2

  ;   res@trXMaxF = 25
  ;   res@trYReverse               = True   ; reverses y-axis

  plot = gsn_csm_xy(wks, year, ohc, res)

  draw(plot)
  frame(wks)

  ; add legend
;  txres               = True
;  txres@txFontHeightF = 0.01
;  text = "PCOM, restored"
;  gsn_text_ndc(wks, text, 0.28, 0.65, txres)

end
