
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2014-11-27 09:43:15 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
  img = getenv("NCL_ARG_2")+getenv("NCL_ARG_0_base")

  ; max and min wind stress profile of the anomaly
  nc = getenv("NCL_ARG_1")+"ws_an_eof.nc"
  f = addfile( nc, "r" )
  eof = f->eof
  lat = f->lat
  ts = f->ts
  delete(f)
  pf_an = 0.3*cos(3.14159265/2.0 * (lat - 45)/15)
  pf_an = where(abs(lat-45) .lt. 15, pf_an, 0)

  plotTitle = "Meridional profile of anomaly wind stress"
  fontheight = 0.03
  yLabelSize = fontheight
  xLabelSize = fontheight

  wks = gsn_open_wks ("eps", img)

  res = True

  res@tiMainString =  plotTitle
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
;  res@xyLineColor = "red"
  res@xyLineThicknessF = 3
  res@xyDashPattern = 0
  res@xyLineColor = "red"
;  res@xyExplicitLegendLabels = (/" "+arg@exTitle, " control"/)

  res@tmLabelAutoStride = True
  
  res@tmYROn = False
  res@tmXTOn = False
  res@tmYMajorGrid = True
  res@tmYMajorGridLineDashPattern = 2
  res@tmYMajorGridThicknessF = 0.5
;  res@tmYLTickStartF   = -80
;  res@tmYLTickSpacingF = 20
;  res@tmYLTickEndF     = 80
  res@tmXMajorGridThicknessF = 0.5

  res@tmYLLabelFontHeightF = yLabelSize 
  res@tmXBLabelFontHeightF = xLabelSize
  res@tmYLMode = "Explicit"
  res@tmYLValues = (/0, 30, 60/)
  res@tmYLLabels = (/"EQ~S~o~N~", "30~S~o~N~N", "60~S~o~N~N"/)
  res@tmXBMode = "Explicit"
  res@tmXBValues = (/0., 0.1, 0.2, 0.3/)
  res@tmXBLabels = res@tmXBValues

;  res@tmXBMode = "Manual"
;  res@tmXBTickStartF   = 0
;  res@tmXBTickSpacingF = 50
;  res@tmXBTickEndF     = 500
  res@tmXMajorGrid = True
  res@tmXMajorGridLineDashPattern = 2

  res@trYMinF = 0
  ;   res@trXMaxF = 25
  ;   res@trYReverse               = True   ; reverses y-axis

  plot = gsn_csm_xy(wks, pf_an, lat, res)

  draw(plot)
  delete(wks)
  system("eps2png_trim "+img)

end
