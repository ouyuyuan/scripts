
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2015-01-11 14:45:19 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
  img = getenv("NCL_ARG_2")+getenv("NCL_ARG_0_base")

  nc = getenv("NCL_ARG_1")+"ws_an_eof.nc"
  f = addfile( nc, "r" )
  ts = f->ts(:239)
  t = f->t(:239)
  delete(f)
  year = t/12.0

  tsmax = max(ts)
  ts = ts/tsmax

  plotTitle = "Time series of anomaly wind stress"
  fontheight = 0.03
  yLabelSize = fontheight
  xLabelSize = fontheight
  xAxis = year
  yAxis = ts
  plotWid = 0.8
  plotHei = 0.4
  yTitle = ""
  xTitle = "model year"

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
  res@gsnAboveYRefLineColor = "IndianRed2"
  res@gsnBelowYRefLineColor = "SteelBlue2"

  res@xyMonoLineColor = False
  res@xyDashPattern = 0 ; solid
  ;   res@xyMarkLineMode = "MarkLines"
  res@xyMarkLineMode = "Lines"
  ;   res@xyMarkers = (/6, 11, 16/)
  ;   res@xyMarkerColors = (/"blue", "red", "green"/)
;  res@xyLineColors = (/"magenta1", "cyan", "red", "blue", "forestgreen"/)
;  res@xyLineColor = "red"
  res@xyLineThicknessF = 3
  res@xyDashPattern = 0
;  res@xyLineColor = "red"
;  res@xyExplicitLegendLabels = (/" "+arg@exTitle, " control"/)

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

  res@tmYLLabelFontHeightF = yLabelSize 
  res@tmXBLabelFontHeightF = xLabelSize
  res@tmYLMode = "Explicit"
  res@tmYLValues = (/-1, 0, 1/)
  res@tmYLLabels = res@tmYLValues
;  res@tmYLLabels = (/"60S", "30S", "EQ", "30N", "60N"/)
  res@tmXBMode = "Explicit"
  res@tmXBValues = (/0., 10, 20, 30, 40, 50, 60/)
  res@tmXBLabels = res@tmXBValues

;  res@tmXBMode = "Manual"
;  res@tmXBTickStartF   = 0
;  res@tmXBTickSpacingF = 50
;  res@tmXBTickEndF     = 500
  res@tmXMajorGrid = True
  res@tmXMajorGridLineDashPattern = 2

  ;   res@trXMaxF = 25
  ;   res@trYReverse               = True   ; reverses y-axis

  plot = gsn_csm_xy(wks, xAxis, yAxis, res)

  draw(plot)
  delete(wks)
  system("eps2png_trim "+img)

end
