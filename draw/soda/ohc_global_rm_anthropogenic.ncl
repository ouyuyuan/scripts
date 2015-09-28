
; Description: remove anthropogenic trend 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2014-12-05 20:22:47 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
  nc = getenv("NCL_ARG_1")+"ohc.nc"
  img = getenv("NCL_ARG_2")+getenv("NCL_ARG_0_base")
;  cmap = "NCL_default"
;  cmap = "GMT_jet"
  cmap = "WhiteBlueGreenYellowRed"

  f = addfile( nc, "r" )
  y_ori = f->ohc_glo
  time = f->time
  delete(f)

  y = y_ori
  y = y*1.0e-26
  y@units = "10~S~26~N~J"
  y_mean = dim_avg_n(y,0)

  ; linear trend, two parts
  cy = 1960 ; acceleration begins
  y_a = y({:cy})
  y_b = y({cy+1:})
  t_a = time({:cy})
  t_b = time({cy+1:})

  rc_a = regline(t_a, y_a)
  rc_b = regline(t_b, y_b)
  y_a_trend = y
  y_a_trend = y@_FillValue
  y_a_trend({:cy}) = rc_a * (t_a - rc_a@xave) + rc_a@yave
  y_b_trend = y
  y_b_trend = y@_FillValue
  y_b_trend({cy+1:}) = rc_b * (t_b - rc_b@xave) + rc_b@yave

  y_d = y
  y_d({:cy}) = y_a - y_a_trend({:cy})
  y_d({cy+1:}) = y_b - y_b_trend({cy+1:})
  y_d@long_name = "detrended OHC"
  y_d = y_d *1.0e4
  y_d@units = "10~S~22~N~J"

  N     = dimsizes(time)

  y_trend = new((/2,N/), typeof(y))
  y_trend(0,:) = y_a_trend
  y_trend(1,:) = y_b_trend

;************************************
; compute wavelet
;************************************
;{{{
  mother  = 0
  param   = 6.0
  dt      = 0.25    ;timesteps in units of years
  s0      = dt
  dj      = 0.25
  jtot    = 1+floattointeger(((log10(N*dt/s0))/dj)/log10(2.))
  npad    = N
  nadof   = 0
  noise   = 1
  siglvl  = .05
  isigtest= 0

  w = wavelet(y_d,mother,dt,param,s0,dj,jtot,npad,noise,isigtest,siglvl,nadof)
;************************************
; create coodinate arrays for plot
;************************************
  power            = onedtond(w@power,(/jtot,N/))
  power!0          = "period"                        ; Y axis
  power&period     = w@period                      ; convert period to units of years

  power!1          = "time"                          ; X axis
  power&time       = time

  power@long_name  = "Power Spectrum"
  power@units      = "1/unit-freq"

; compute significance ( >= 1 is significant)
  sig              = power                            ; transfer meta data
  sig              = power/conform (power,w@signif,0)
  sig@long_name    = "Significance"
  sig@units        = " "
  ;}}}

;  plotTitle = "Time series of anomaly wind stress"
  fontSize = 0.03
  yLabelSize = fontSize
  xLabelSize = fontSize
  plotWid = 0.9
  plotHei = 0.15
  xTitle = "year"
;  xTicks = (/450, 475, 500, 525, 550, 575, 600, 625, 650/)
  xTicks = ispan(1870, 2010, 10)

  wks = gsn_open_wks ("eps", img)
  gsn_define_colormap(wks,cmap)

   res = True
  ; {{{

  res@vpWidthF = plotWid
  res@vpHeightF = plotHei
;  res@vpXF = 0.1
;  res@vpYF = 0.9

  res@tiYAxisString = y@units
  res@tiXAxisString = xTitle
  res@tiXAxisFontHeightF = fontSize

  res@gsnDraw = False
  res@gsnFrame = False
  res@gsnLeftString = ""
  res@gsnRightString = ""
  res@gsnYRefLine = y_mean
  res@gsnAboveYRefLineColor = "IndianRed2"
  res@gsnBelowYRefLineColor = "SteelBlue2"

  res@xyMonoLineColor = False
  res@xyDashPattern = 0 ; solid
  ;   res@xyMarkLineMode = "MarkLines"
  res@xyMarkLineMode = "Lines"
  ;   res@xyMarkers = (/6, 11, 16/)
;  res@xyMarkerColors = (/"blue", "red"/)
;  res@xyLineColors = (/"magenta1", "cyan", "red", "blue", "forestgreen"/)
;  res@xyLineColors = lineColors
  res@xyLineColor = "blue3"
  res@xyLineThicknessF = 3
  res@xyDashPattern = 0

  res@tmLabelAutoStride = True
  
  res@tmXTOn = False
;  res@tmYMajorGrid = True
  res@tmYMajorGridLineDashPattern = 2
  res@tmYMajorGridThicknessF = 0.5
;  res@tmYLTickStartF   = -80
;  res@tmYLTickSpacingF = 20
;  res@tmYLTickEndF     = 80
  res@tmXMajorGridThicknessF = 0.5

  res@tmYLLabelFontHeightF = yLabelSize 
  res@tmYLMode = "Explicit"
  res@tmYLValues = (/13.740, 13.741, 13.742/)
  res@tmYLLabels = (/"13.740", "13.741", "13.742"/)

  res@tmYUseLeft = False
  res@tmYRLabelsOn = True
  res@tmYRLabelFontHeightF = yLabelSize 
  res@tmYROn = True
  rticks = (/-0.00008, 0, 0.00008/)
  res@tmYRMode = "Explicit"
  res@tmYRValues = rticks*y_mean + y_mean
  res@tmYRLabels = (/"- 0.00008", "0", "0.00008"/)

  res@tmXBLabelFontHeightF = xLabelSize
  res@tmXBMode = "Explicit"
  res@tmXBValues = xTicks
  res@tmXBLabels = xTicks

  ; }}}

   res_trend = True
  ; {{{

  res_trend@vpWidthF = plotWid
  res_trend@vpHeightF = plotHei
;  res_trend@vpXF = 0.1
;  res_trend@vpYF = 0.9

  res_trend@tiYAxisString = ""
  res_trend@tiXAxisString = ""
  res_trend@tiXAxisFontHeightF = fontSize

  res_trend@gsnDraw = False
  res_trend@gsnFrame = False
  res_trend@gsnLeftString = ""
  res_trend@gsnRightString = ""

  res_trend@xyMonoLineColor = False
  res_trend@xyDashPattern = 0 ; solid
  res_trend@xyMarkLineMode = "Lines"
  res_trend@xyLineColors = (/"black","chartreuse3"/)
  res_trend@xyLineThicknessF = 3
  res_trend@xyDashPattern = 0

  res_trend@tmLabelAutoStride = True
  
  res_trend@tmXTOn = False
  res_trend@tmYMajorGridLineDashPattern = 2
  res_trend@tmYMajorGridThicknessF = 0.5
  res_trend@tmXMajorGridThicknessF = 0.5

  res_trend@tmYLLabelFontHeightF = yLabelSize 
;  res_trend@tmYLMode = "Explicit"
;  res_trend@tmYLValues = (/13.740, 13.741, 13.742/)
;  res_trend@tmYLLabels = (/"13.740", "13.741", "13.742"/)

  res_trend@tmXBLabelFontHeightF = xLabelSize
  res_trend@tmXBMode = "Explicit"
  res_trend@tmXBValues = xTicks
  res_trend@tmXBLabels = xTicks

  ; }}}

  res_d = True
  ; {{{

  res_d@vpWidthF = plotWid
  res_d@vpHeightF = plotHei
;  res_d@vpXF = 0.1
;  res_d@vpYF = 0.9

  res_d@tiYAxisString = y_d@units
  res_d@tiXAxisString = xTitle
  res_d@tiXAxisFontHeightF = fontSize

  res_d@gsnDraw = False
  res_d@gsnFrame = False
  res_d@gsnLeftString = ""
  res_d@gsnRightString = ""
  res_d@gsnYRefLine = 0.
  res_d@gsnAboveYRefLineColor = "IndianRed2"
  res_d@gsnBelowYRefLineColor = "SteelBlue2"

  res_d@xyMonoLineColor = False
  res_d@xyDashPattern = 0 ; solid
  ;   res_d@xyMarkLineMode = "MarkLines"
  res_d@xyMarkLineMode = "Lines"
  ;   res_d@xyMarkers = (/6, 11, 16/)
;  res_d@xyMarkerColors = (/"blue", "red"/)
;  res_d@xyLineColors = (/"magenta1", "cyan", "red", "blue", "forestgreen"/)
;  res_d@xyLineColors = lineColors
  res_d@xyLineColor = "blue3"
  res_d@xyLineThicknessF = 3
  res_d@xyDashPattern = 0

  res_d@tmLabelAutoStride = True
  
  res_d@tmXTOn = False
  res_d@tmYROn = False
;  res_d@tmYMajorGrid = True
  res_d@tmYMajorGridLineDashPattern = 2
  res_d@tmYMajorGridThicknessF = 0.5
;  res_d@tmYLTickStartF   = -80
;  res_d@tmYLTickSpacingF = 20
;  res_d@tmYLTickEndF     = 80
  res_d@tmXMajorGridThicknessF = 0.5

  res_d@tmYLMode = "Explicit"
  res_d@tmYLValues = (/-6, 0, 6/)
  res_d@tmYLLabels = res_d@tmYLValues

  res_d@tmYLLabelFontHeightF = yLabelSize 
  res_d@tmXBLabelFontHeightF = xLabelSize
  res_d@tmXBMode = "Explicit"
  res_d@tmXBValues = xTicks
  res_d@tmXBLabels = xTicks

  ; }}}

  res_w = True
  ;{{{

  res_w@vpWidthF = plotWid
  res_w@vpHeightF = plotHei*2

  res_w@tiYAxisString = "period (year)"
  res_w@tiXAxisString = xTitle

   res_w@gsnDraw = False
   res_w@gsnFrame = False
   res_w@gsnSpreadColors      = True               ; use full color map
   if (cmap.eq."WhiteBlueGreenYellowRed") then
     res_w@gsnSpreadColorStart  = 20
   end if
;   res_w@gsnSpreadColorEnd    = 180
   res_w@gsnLeftString = ""
   res_w@gsnRightString = ""
   res_w@gsnYAxisIrregular2Linear = True

   res_w@cnFillOn             = True               ; turn on color for contours
   res_w@cnLinesOn            = False              ; turn off contour lines
;   res_w@cnLineThicknessF = 0.5
   res_w@cnLineLabelsOn       = False              ; turn off contour line labels
   res_w@cnInfoLabelOn        = False      ; turns off contour info label
;   res_w@cnLevelSelectionMode = "ManualLevels"
;   res_w@cnMinLevelValF       = 1
;   res_w@cnMaxLevelValF       = 7
;   res_w@cnLevelSpacingF      = 0.1
;   res_w@cnLevelSelectionMode = "ExplicitLevels"
;   res_w@cnLevels = \
;   (/1, 2, 3,\
;   4, \
;   5, 6, 7/)
;   res_w@cnFillColors = \
;    (/"magenta4", "blue2", "cyan3", \
;    "LightSteelBlue1",  "RosyBrown1", \
;    "yellow2", "orange1", "red3"/)
;  res_w@cnMissingValFillColor = "gray60"
;   res_w@cnFillMode = "RasterFill"

;   res_w@lbLabelBarOn = False
  res_w@lbOrientation = "vertical"
;   res_w@lbPerimOn                = False             ; no box around it
   res_w@lbLabelFontHeightF = fontSize
;   res_w@lbLabelStride            = 5
;   res_w@lbLabelPosition = "Top"
   res_w@lbTitleString = "unit^2"
;   res_w@lbTitlePosition = "Right"
   res_w@lbTitleFontHeightF = fontSize
   res_w@lbTitleOffsetF = 0.1
   res_w@lbBoxLinesOn = False

   res_w@tmLabelAutoStride   = True
;   res_w@tmYROn = False
;   res_w@tmXTOn = False
;   res_w@tmXBOn = False

  res_w@tmYLLabelFontHeightF = fontSize
  res_w@tmYLMode = "Explicit"
  res_w@tmYLValues = (/0, 10, 20, 30, 40/)
  res_w@tmYLLabels = res_w@tmYLValues

  res_w@tmXBLabelFontHeightF = fontSize
  res_w@tmXBMode = "Explicit"
  res_w@tmXBValues = xTicks
  res_w@tmXBLabels = xTicks

   res_w@pmLabelBarHeightF = 0.4
   res_w@pmLabelBarWidthF = 0.05
;   res_w@pmLabelBarOrthogonalPosF = 0.2
   res_w@pmLabelBarParallelPosF = 0.65

;   res_w@trYMaxF = 64
  res_w@trYReverse          = True                  ; reverse y-axis
  ;}}}

  res_sig = True                            ; res_sig probability plots
  ;{{{
  res_sig@vpWidthF = res_w@vpWidthF
  res_sig@vpHeightF = res_w@vpHeightF

  res_sig@gsnDraw             = False       ; Do not draw plot
  res_sig@gsnFrame            = False       ; Do not advance frome
  res_sig@gsnLeftString = ""
  res_sig@gsnRightString = ""
  res_sig@gsnYAxisIrregular2Linear = True

  res_sig@tmYLMode = "Explicit"
  res_sig@tmYLValues = res_w@tmYLValues
  res_sig@tmYLLabels = res_w@tmYLLabels

  res_sig@cnLevelSelectionMode = "ManualLevels" ; set manual contour levels
  res_sig@cnMinLevelValF      = 0.00        ; set min contour level
  res_sig@cnMaxLevelValF      = 2.00        ; set max contour level
  res_sig@cnLevelSpacingF     = 1.00        ; set contour spacing
  res_sig@cnInfoLabelOn       = False
  res_sig@cnLinesOn           = False       ; do not draw contour lines
  res_sig@cnLineLabelsOn      = False       ; do not draw contour labels
  res_sig@cnFillScaleF        = 0.8          ; add extra density

  res_sig@trYReverse          = True
  ;}}}

  plot = new(3, graphic)
  plot(0) = gsn_csm_xy(wks, time, y, res)
  plot_trend = gsn_csm_xy(wks, time, y_trend, res_trend)
;  plot(0) = plot_trend
  overlay(plot(0),plot_trend)				; overlay probability plot onto power plot

  y_title = y_d@units
  plot(1) = gsn_csm_xy(wks, time, y_d, res_d)
  plot(2) = gsn_csm_contour(wks,power,res_w)
  plot_sig = gsn_csm_contour(wks,sig,res_sig)
  plot_sig = ShadeGtContour(plot_sig,1.,17)
;  plot(2) = plot_sig
  overlay(plot(2),plot_sig)				; overlay probability plot onto power plot

   resP = True
   ;{{{
   resP@gsnFrame = False
;   resP@gsnPanelLabelBar = True
;      resP@gsnPanelBottom = 0.05
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 15
   resP@gsnPanelRowSpec = True

;   resP@pmLabelBarWidthF = cbWid
;   resP@pmLabelBarHeightF = cbHei
;   resP@pmLabelBarOrthogonalPosF = cbPosUp
;   resP@pmLabelBarParallelPosF = cbPosRight

;   resP@lbAutoManage = False
;   resP@lbLabelAutoStride = True
   resP@lbPerimOn                = False             ; no box around it
   resP@lbLabelFontHeightF = fontSize*0.8
   resP@lbLabelStride            = 5
   resP@lbLabelPosition = "Top"

;   resP@lbTitleString = cbUnits
   resP@lbTitlePosition = "Right"
   resP@lbTitleFontHeightF = fontSize*0.8
   resP@lbBoxLinesOn = False

;   resP@txString = "Sea surface salinity"
  ;}}}

  gsn_panel(wks, plot, (/1,1,1/), resP)

  frame(wks)
  delete(wks)
  system("eps2png_trim "+img)

end
