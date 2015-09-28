
; Description: EOF pattern of isothermal line depth
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-10 10:19:03 BJT
; Last Change: 2014-11-29 18:38:47 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  nc = getenv("NCL_ARG_1")+"dtc_diff_eof.nc"
  img = getenv("NCL_ARG_2")+getenv("NCL_ARG_0_base")

  fontSize = 0.03
  cmap = "NCV_blu_red"
  wks = gsn_open_wks("eps", img)
  gsn_define_colormap(wks,cmap)

  f = addfile(nc, "r")
  eof = f->eof_Atl_S
  ts = f->ts_Atl_S
  t = f->time
  delete(f)
  year = t
  eof = lonFlip(eof)

  cn1 = eof(0,:,:)
  cn2 = eof(1,:,:)
  plotWid = 0.8
  plotHei = 0.3

  cbWid = 0.4
  cbHei = 0.05
  cbPosUp = 0.3
  cbPosRight = -0.17
  cbMinMaxInc = (/-5,5,0.1/)
  cbUnits = "m"
  cbUnitPosX = 0.75
  cbUnitPosY = 0.545

  texta = sprintf("EOF1: %4.1f",eof@pcvar(0))+"%"
  textb = sprintf("EOF2: %4.1f",eof@pcvar(1))+"%"

  tsPlotWid = plotWid
  tsPlotHei = 0.2
  tsTitle = "Time series of EOF1"
  tsTitleUp = 0.1
  yLabelSize = fontSize*1.2
  xLabelSize = fontSize*1.2
  xValues = t
  yValues = ts(0,:)
;  yValues = ts
  yTitle = ""
  xTitle = "model year"
  lineColors = (/"red", "blue"/)
  lgLabels = (/"PC1", "PC2"/)
  lgPosRight = -0.45
  lgPosUp = 0.2
  lgWid = 0.1
  lgHei = 0.1
;  lgOrder = (/1,0/)
  lgOrder = (/0/)

  res = True
  ;{{{

  res@vpHeightF = plotHei
  res@vpWidthF = plotWid

   res@gsnDraw = False
   res@gsnFrame = False
   res@gsnSpreadColors      = True               ; use full color map
;   res@gsnSpreadColorStart  = 30                 ; start at color 17
;   res@gsnSpreadColorEnd    = 180
   res@gsnLeftString = ""
   res@gsnRightString = texta

   res@cnFillOn             = True               ; turn on color for contours
   res@cnLinesOn            = False              ; turn off contour lines
;   res@cnLineThicknessF = 0.5
   res@cnLineLabelsOn       = False              ; turn off contour line labels
   res@cnInfoLabelOn        = False      ; turns off contour info label
   res@cnLevelSelectionMode = "ManualLevels"
   res@cnMinLevelValF       = cbMinMaxInc(0)
   res@cnMaxLevelValF       = cbMinMaxInc(1)
   res@cnLevelSpacingF      = cbMinMaxInc(2)
;  res@cnMissingValFillColor = "gray60"
;   res@cnFillMode = "RasterFill"

;   res@lbLabelBarOn = False
;   res@lbPerimOn                = False             ; no box around it
   res@lbLabelFontHeightF = fontSize
;   res@lbLabelStride            = 5
   res@lbLabelPosition = "Top"
   res@lbTitleString = cbUnits
   res@lbTitlePosition = "Right"
   res@lbTitleFontHeightF = fontSize
   res@lbBoxLinesOn = False

   res@tmLabelAutoStride = False
   res@tmYROn = False
   res@tmXTOn = False
   res@tmXBOn = False
   res@tmYLLabelFontHeightF = fontSize
   res@tmXBLabelFontHeightF = fontSize
  res@tmYLMode = "Explicit"
  res@tmYLValues = (/-20, -10, 0/)
  res@tmYLLabels = (/"20~S~o~N~S", "10~S~o~N~S", "EQ"/)

   res@mpShapeMode = "FreeAspect"
   res@mpMinLatF = -20
   res@mpMaxLatF = 0
   res@mpMinLonF = -105
   res@mpMaxLonF = 15
   res@mpCenterLonF = 200
   ;}}}

   resTs = True
  ; {{{

  resTs@vpWidthF = tsPlotWid
  resTs@vpHeightF = tsPlotHei
  resTs@vpXF = 0.1
  resTs@vpYF = 0.9

  resTs@tiYAxisString = yTitle
  resTs@tiXAxisString = xTitle
  resTs@tiXAxisFontHeightF = fontSize

  resTs@gsnDraw = False
  resTs@gsnFrame = False
  resTs@gsnLeftString = ""
  resTs@gsnRightString = ""
  resTs@gsnCenterString =  tsTitle
  resTs@gsnCenterStringOrthogonalPosF = tsTitleUp
  resTs@gsnCenterStringFontHeightF =  fontSize*1.2
  resTs@gsnYRefLine = 0.
;  resTs@gsnAboveYRefLineColor = "IndianRed2"
;  resTs@gsnBelowYRefLineColor = "SteelBlue2"

  resTs@xyMonoLineColor = False
  resTs@xyDashPattern = 0 ; solid
  ;   resTs@xyMarkLineMode = "MarkLines"
  resTs@xyMarkLineMode = "Lines"
  ;   resTs@xyMarkers = (/6, 11, 16/)
;  resTs@xyMarkerColors = (/"blue", "red"/)
;  resTs@xyLineColors = (/"magenta1", "cyan", "red", "blue", "forestgreen"/)
  resTs@xyLineColors = lineColors
;  resTs@xyLineColor = "red"
  resTs@xyLineThicknessF = 3
  resTs@xyDashPattern = 0
;  resTs@xyLineColor = "red"
  resTs@xyExplicitLegendLabels = lgLabels

  resTs@tmLabelAutoStride = True
  
  resTs@tmYROn = False
  resTs@tmXTOn = False
;  resTs@tmYMajorGrid = True
  resTs@tmYMajorGridLineDashPattern = 2
  resTs@tmYMajorGridThicknessF = 0.5
  resTs@tmYLTickStartF   = -80
  resTs@tmYLTickSpacingF = 20
  resTs@tmYLTickEndF     = 80
  resTs@tmXMajorGridThicknessF = 0.5

  resTs@tmYLLabelFontHeightF = yLabelSize 
  resTs@tmXBLabelFontHeightF = xLabelSize
  resTs@tmYLMode = "Explicit"
  resTs@tmYLValues = (/-2,0,2/)
  resTs@tmYLLabels = resTs@tmYLValues
;  resTs@tmXBMode = "Explicit"
;  resTs@tmXBValues = (/0., 10, 20, 30, 40, 50, 60/)
;  resTs@tmXBLabels = resTs@tmXBValues

;  resTs@tmXBMode = "Manual"
;  resTs@tmXBTickStartF   = 0
;  resTs@tmXBTickSpacingF = 50
;  resTs@tmXBTickEndF     = 500
;  resTs@tmXMajorGrid = True
  resTs@tmXMajorGridLineDashPattern = 2

  resTs@lgPerimOn = False
  resTs@lgLabelFontHeightF = fontSize
  resTs@lgPerimFill = "SolidFill"
  resTs@lgPerimFillColor = "White"
  resTs@lgItemOrder = lgOrder

;  resTs@pmLegendDisplayMode = "Always"
  resTs@pmLegendSide = "Right"
  resTs@pmLegendOrthogonalPosF = lgPosRight
  resTs@pmLegendParallelPosF = lgPosUp
  resTs@pmLegendWidthF = lgWid
  resTs@pmLegendHeightF = lgHei

  ;   resTs@trXMaxF = 25
  ;   resTs@trYReverse               = True   ; reverses y-axis
  ; }}}

   res1 = res
   res2 = res

   plot = new(2, graphic)
   plot(0) = gsn_csm_contour_map(wks, cn1, res1)
   res2@gsnRightString = textb
   res2@lbLabelBarOn = False
;   plot(1) = gsn_csm_contour_map(wks, cn2, res2)
   plot(1) = gsn_csm_xy(wks, xValues, yValues, resTs)

   resP = True
   ;{{{
   resP@gsnFrame = False
;   resP@gsnPanelLabelBar = True
;      resP@gsnPanelBottom = 0.05
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 5
   resP@gsnPanelRowSpec = True

   resP@pmLabelBarWidthF = cbWid
   resP@pmLabelBarHeightF = cbHei
   resP@pmLabelBarOrthogonalPosF = cbPosUp
   resP@pmLabelBarParallelPosF = cbPosRight

;   resP@lbAutoManage = False
;   resP@lbLabelAutoStride = True
   resP@lbPerimOn                = False             ; no box around it
   resP@lbLabelFontHeightF = fontSize*0.8
   resP@lbLabelStride            = 5
   resP@lbLabelPosition = "Top"

   resP@lbTitleString = cbUnits
   resP@lbTitlePosition = "Right"
   resP@lbTitleFontHeightF = fontSize*0.8
   resP@lbBoxLinesOn = False

;   resP@txString = "Sea surface salinity"
  ;}}}

  gsn_panel(wks, plot, (/1,1/), resP)

  txres               = True
  txres@txFontHeightF = fontSize
  text = "m"
;  gsn_text_ndc(wks, text, 0.75, 0.545, txres)

  delete(wks)
  system("eps2png_trim "+img)

end
