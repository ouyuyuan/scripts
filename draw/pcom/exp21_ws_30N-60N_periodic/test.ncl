
; Description: depth of thermocline
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-10 10:19:03 BJT
; Last Change: 2014-11-30 09:25:41 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  img = getenv("NCL_ARG_2")+getenv("NCL_ARG_0_base")

  fontSize = 0.03
  cmap = "NCV_blu_red"
  wks = gsn_open_wks("eps", img)
  gsn_define_colormap(wks,cmap)

  latVal = -0.5
  lonW = 110.5
  lonE = 290.5
  temp = 20

  nc = "/home/ou/archive/data/pcom/exp17_ws_control_cycle_re/post/isothermal_line_depth.nc"
  f = addfile(nc, "r")
  isot = f->isot(60:,{temp},:,{lonW:lonE})
  delete(f)
  cn_ctr = dim_avg_n_Wrap(isot, 0)
  cn_ctr = smth9(cn_ctr, 0.5, 0.25, False)
  delete(isot)

  nc = getenv("NCL_ARG_1")+"isothermal_line_depth.nc"
  f = addfile(nc, "r")
  isot = f->isot(60:,{temp},:,{lonW:lonE})
  delete(f)
  cn = dim_avg_n_Wrap(isot, 0)
  cn = smth9(cn, 0.5, 0.25, False)
  delete(isot)

  cn_diff = cn
  cn_diff = cn - cn_ctr

  plotWid = 0.9
  plotHei = 0.2
  cbWid = 0.8
  cbHei = 0.05
  cbUnits = "m"
  cbMinMaxInc = (/0.,400.,10./)
  cbMinMaxInc_diff = (/-10.,10.,0.5/)
  yAxisTitle = "~S~o~N~C"
;  lbPosUp = 0.09
;  lbPosRight = 0.2
;  lbUnitPosX = 0.9
;  lbUnitPosY = 0.38

   res = True
  ; {{{ 
  res@vpHeightF = plotHei
  res@vpWidthF = plotWid

  res@tiYAxisString = yAxisTitle
   res@gsnDraw = False
   res@gsnFrame = False
   res@gsnSpreadColors      = True               ; use full color map
;   res@gsnSpreadColorStart  = 30                 ; start at color 17
;   res@gsnSpreadColorEnd    = 180
   res@gsnLeftString = ""
   res@gsnRightString = ""

   res@cnFillOn             = True               ; turn on color for contours
   res@cnLinesOn            = False              ; turn off contour lines
;   res@cnLineThicknessF = 0.5
   res@cnLineLabelsOn       = False              ; turn off contour line labels
   res@cnInfoLabelOn        = False      ; turns off contour info label
   res@cnLevelSelectionMode = "ManualLevels"
   res@cnMinLevelValF       = cbMinMaxInc(0)
   res@cnMaxLevelValF       = cbMinMaxInc(1)
   res@cnLevelSpacingF      = cbMinMaxInc(2)
  res@cnMissingValFillColor = "gray60"
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
;   res@tmXBOn = False
   res@tmYLLabelFontHeightF = fontSize
   res@tmXBLabelFontHeightF = fontSize
  res@tmYLMode = "Explicit"
  res@tmYLValues = (/-20, 0, 20/)
  res@tmYLLabels = (/"20~S~o~N~S","EQ","20~S~o~N~N"/)

   res@mpShapeMode = "FreeAspect"
   res@mpMinLatF = -20
   res@mpMaxLatF = 20
   res@mpMinLonF = 120
   res@mpMaxLonF = 290
   res@mpCenterLonF = 200

   res@pmLabelBarWidthF = cbWid
   res@pmLabelBarOrthogonalPosF = 0.2
;   res@pmLabelBarParallelPosF = lbPosRight
  ; }}}

   plot = new(3, graphic)
   plot(0) = gsn_csm_contour_map(wks, cn_ctr, res)
   res@lbLabelBarOn = False
   plot(1) = gsn_csm_contour(wks, cn, res)
   res@lbLabelBarOn = True
   res@cnMinLevelValF       = cbMinMaxInc_diff(0)
   res@cnMaxLevelValF       = cbMinMaxInc_diff(1)
   res@cnLevelSpacingF      = cbMinMaxInc_diff(2)
   plot(2) = gsn_csm_contour(wks, cn_diff, res)

   resP = True
   ; {{{
   resP@gsnFrame = False
;   resP@gsnPanelLabelBar = True
;      resP@gsnPanelBottom = 0.05
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 5
   resP@gsnPanelRowSpec = True

   resP@pmLabelBarWidthF = cbWid
   resP@pmLabelBarHeightF = cbHei
;   resP@pmLabelBarOrthogonalPosF = lbPosUp
;   resP@pmLabelBarParallelPosF = lbPosRight

;   resP@lbAutoManage = False
   resP@lbLabelFontHeightF = fontSize*0.8
;   resP@lbPerimOn   = True
;   resP@lbLabelAutoStride = True
   resP@lbLabelStride            = 5
;   resP@lbTitleString = "Verical mean sea salinity (psu)"
   resP@lbTitleFontHeightF = 0.013
   resP@lbBoxLinesOn = False
;   resP@lbLabelFontHeightF = 0.007
  resP@lbLabelPosition = "Top"
  ; }}}

;   resP@txString = "Sea surface salinity"

   gsn_panel(wks, plot, (/1,1,1/), resP)

  txres               = True
  txres@txFontHeightF = fontSize
;  text = "m"
;  gsn_text_ndc(wks, text, lbUnitPosX, lbUnitPosY, txres)

  delete(wks)
  system("eps2png_trim "+img)

end
