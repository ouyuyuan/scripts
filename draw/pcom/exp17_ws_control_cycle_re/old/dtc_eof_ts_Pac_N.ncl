
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2014-11-28 21:49:33 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
  img = getenv("NCL_ARG_2")+getenv("NCL_ARG_0_base")

  nc = getenv("NCL_ARG_1")+"dtc_eof.nc"
  f = addfile( nc, "r" )
  ts = f->ts_Pac_N
  t = f->time
  delete(f)
  year = t

  plotTitle = ""
  fontheight = 0.03
  yLabelSize = fontheight
  xLabelSize = fontheight
  xValues = t
  yValues = ts(0,:)
;  yValues = ts
  plotWid = 0.8
  plotHei = 0.4
  yTitle = ""
  xTitle = "model year"
  lineColors = (/"red"/)
  lgLabels = (/"PC1"/)
  lgPosRight = -0.3
  lgPosUp = 0.9
;  lgOrder = (/1,0/)

  wks = gsn_open_wks ("eps", img)

  res = True

  res@tiMainString =  plotTitle
  res@vpWidthF = plotWid
  res@vpHeightF = plotHei
  res@vpXF = 0.1

  res@tiYAxisString = yTitle
  res@tiXAxisString = xTitle

  res@gsnDraw = False
  res@gsnFrame = False
  res@gsnLeftString = ""
  res@gsnRightString = ""
  res@gsnYRefLine = 0.
;  res@gsnAboveYRefLineColor = "IndianRed2"
;  res@gsnBelowYRefLineColor = "SteelBlue2"

  res@xyMonoLineColor = False
  res@xyDashPattern = 0 ; solid
  ;   res@xyMarkLineMode = "MarkLines"
  res@xyMarkLineMode = "Lines"
  ;   res@xyMarkers = (/6, 11, 16/)
;  res@xyMarkerColors = (/"blue", "red"/)
;  res@xyLineColors = (/"magenta1", "cyan", "red", "blue", "forestgreen"/)
  res@xyLineColors = lineColors
;  res@xyLineColor = "red"
  res@xyLineThicknessF = 3
  res@xyDashPattern = 0
;  res@xyLineColor = "red"
  res@xyExplicitLegendLabels = lgLabels

  res@tmLabelAutoStride = True
  
  res@tmYROn = False
  res@tmXTOn = False
;  res@tmYMajorGrid = True
  res@tmYMajorGridLineDashPattern = 2
  res@tmYMajorGridThicknessF = 0.5
  res@tmYLTickStartF   = -80
  res@tmYLTickSpacingF = 20
  res@tmYLTickEndF     = 80
  res@tmXMajorGridThicknessF = 0.5

  res@tmYLLabelFontHeightF = yLabelSize 
  res@tmXBLabelFontHeightF = xLabelSize
  res@tmYLMode = "Explicit"
  res@tmYLValues = (/-2,-1,0,1,2,3,4/)
  res@tmYLLabels = res@tmYLValues
;  res@tmXBMode = "Explicit"
;  res@tmXBValues = (/0., 10, 20, 30, 40, 50, 60/)
;  res@tmXBLabels = res@tmXBValues

;  res@tmXBMode = "Manual"
;  res@tmXBTickStartF   = 0
;  res@tmXBTickSpacingF = 50
;  res@tmXBTickEndF     = 500
;  res@tmXMajorGrid = True
  res@tmXMajorGridLineDashPattern = 2

  res@lgPerimOn = False
  res@lgLabelFontHeightF = fontheight
  res@lgPerimFill = "SolidFill"
  res@lgPerimFillColor = "White"
;  res@lgItemOrder = lgOrder

  res@pmLegendDisplayMode = "Always"
  res@pmLegendSide = "Right"
  res@pmLegendOrthogonalPosF = lgPosRight
  res@pmLegendParallelPosF = lgPosUp
  res@pmLegendWidthF = 0.1
;  res@pmLegendHeightF = 0.5

  ;   res@trXMaxF = 25
  ;   res@trYReverse               = True   ; reverses y-axis

  plot = gsn_csm_xy(wks, xValues, yValues, res)

  draw(plot)
  delete(wks)
  system("eps2png_trim "+img)

end
