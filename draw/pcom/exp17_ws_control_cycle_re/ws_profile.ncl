
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2014-11-23 16:50:08 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
  img = getenv("NCL_ARG_2")+getenv("NCL_ARG_0_base")

  ; wind stress profile in control run
  indir = "/home/ou/archive/data/pcom/input/"
  f = addfile(indir+"pcom_bcf_mn_re_cycle.nc", "r")
  bcu_ctr = f->bcu(0:11,:,:)
  lat = f->lat
  delete(f)
  pf_ctr = bcu_ctr(0,:,0)
  pf_ctr = dim_avg_n( dim_avg_n(bcu_ctr,0), 1 )
  yValues = pf_ctr

  plotTitle = "Profile of Zonal wind stress"
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
;  res@xyLineColors = pfColors
;  res@xyLineColor = "red"
  res@xyLineThicknessF = 3
  res@xyDashPattern = 0
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
  res@tmYLValues = (/-60, -30, 0, 30, 60/)
  res@tmYLLabels = (/"60S", "30S", "EQ", "30N", "60N"/)
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

  plot = gsn_csm_xy(wks, yValues, lat, res)

  draw(plot)
  delete(wks)
  system("eps2png_trim "+img)

end
