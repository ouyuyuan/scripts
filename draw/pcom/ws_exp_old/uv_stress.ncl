
; Description: Wind stress forcing, alike Large2008 Fig.6
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-10 10:19:03 BJT
; Last Change: 2014-10-24 21:25:10 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  nc = getenv("NCL_ARG_1")
  img = getenv("NCL_ARG_2")

  fontheight = 0.015
;  cmap = "BlGrYeOrReVi200"
;  cmap = "testcmap"
  cmap = "NCV_blue_red"
  wks = gsn_open_wks("eps", img)
  gsn_define_colormap(wks,cmap)

  f = addfile(nc, "r")
  cn1 = f->taux
  cn2 = f->tauy
  delete(f)

   res = True

  res@vpHeightF = 0.45
  res@vpWidthF = 0.73

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
   res@cnMaxLevelValF       =  0.2              ; set max contour level
   res@cnMinLevelValF       = -0.2
   res@cnLevelSpacingF = 0.02
  res@cnMissingValFillColor = "gray60"
;   res@cnFillMode = "RasterFill"

   res@lbLabelBarOn = False

   res@tmLabelAutoStride = False
   res@tmYROn = False
   res@tmXTOn = False
   res@tmYLLabelFontHeightF = fontheight
   res@tmXBLabelFontHeightF = fontheight
  res@tmYLMode = "Explicit"
  res@tmYLValues = (/-50, 0, 50/)
  res@tmYLLabels = (/"50~S~o~N~S","EQ","50~S~o~N~S"/)
  res@tmXBMode = "Explicit"
  res@tmXBValues = (/0,100,200,300/)
  res@tmXBLabels = (/"0~S~o~N~E", "100~S~o~N~E", "160~S~o~N~W", "60~S~o~N~W"/)


   res1 = res

   res2 = res

   plot = new(2, graphic)
;   plot(0) = gsn_csm_contour_map(wks, cn1, res1)
;   plot(1) = gsn_csm_contour_map(wks, cn2, res2)
   plot(0) = gsn_csm_contour(wks, cn1, res1)
   plot(1) = gsn_csm_contour(wks, cn2, res2)

   resP = True
   resP@gsnFrame = False
   resP@gsnPanelLabelBar = True
;      resP@gsnPanelBottom = 0.05
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 10
   resP@gsnPanelRowSpec = True

   resP@pmLabelBarWidthF = 0.5
   resP@pmLabelBarHeightF = 0.06
   resP@pmLabelBarOrthogonalPosF = -0.01

;   resP@lbAutoManage = False
   resP@lbLabelFontHeightF = 0.013
   resP@lbPerimOn                = False             ; no box around it
;   resP@lbLabelAutoStride = True
   resP@lbLabelStride            = 5
;   resP@lbTitleString = "Verical mean sea salinity (psu)"
   resP@lbTitleFontHeightF = 0.013
;   resP@lbBoxLinesOn = False
;   resP@lbLabelFontHeightF = 0.007

;   resP@txString = "Sea surface salinity"

   gsn_panel(wks, plot, (/1,1/), resP)

  txres               = True
  txres@txFontHeightF = fontheight
  text = "Climatory Zonal Wind Stress Forcing in PCOM"
  gsn_text_ndc(wks, text, 0.5, 0.98, txres)
  text = "a)"
  gsn_text_ndc(wks, text, 0.25, 0.98, txres)
  text = "Climatory Meridional Wind Stress Forcing in PCOM"
  gsn_text_ndc(wks, text, 0.52, 0.56, txres)
  text = "b)"
  gsn_text_ndc(wks, text, 0.25, 0.56, txres)
  text = "N/m~S~2"
  gsn_text_ndc(wks, text, 0.81, 0.15, txres)

end
