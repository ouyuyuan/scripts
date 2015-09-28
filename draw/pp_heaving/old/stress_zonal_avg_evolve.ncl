
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 21:12:48 BJT
; Last Change: 2014-10-25 15:30:55 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  nc = getenv("NCL_ARG_1")
  img = getenv("NCL_ARG_2")
  fontheight = 0.012

  cmap = "BlGrYeOrReVi200"
;  cmap = "testcmap"
;  cmap = "NCV_blue_red"
  cmap = "NCl_default"
  wks = gsn_open_wks("eps", img)
  gsn_define_colormap(wks,cmap)

  f = addfile(nc, "r")
  cn1 = f->cn
  delete(f)

  mean = dim_avg_n_Wrap(cn1, 1)
  cn2 = cn1
  cn2 = cn2 - conform(cn2, mean, 0)

  res = True

;  res@vpHeightF = 0.45
;  res@vpWidthF = 0.73

   res@gsnDraw = False
   res@gsnFrame = False
;   res@gsnSpreadColors      = False
;   res@gsnSpreadColorStart  = 30                 ; start at color 17
;   res@gsnSpreadColorEnd    = 180
   res@gsnLeftString = ""
   res@gsnRightString = ""

   res@cnFillOn             = True               ; turn on color for contours
   res@cnLinesOn            = False              ; turn off contour lines
;   res@cnLineThicknessF = 0.5
   res@cnLineLabelsOn       = False              ; turn off contour line labels
   res@cnInfoLabelOn        = False      ; turns off contour info label
;   res@cnLevelSelectionMode = "ExplicitLevels"
;   res@cnLevels = (/-0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6, 0.8, 1.0, 1.2, 1.4, \
;   1.6, 1.8, 2.0/)
;   res@cnFillColors = (/2,  8,14, 20, 30, 45,  60,  75,  90, 105, 120, 135, \
;   150, 165, 180/)          
;   res@cnFillMode = "RasterFill"

;   res@lbLabelBarOn = False
;   res@lbBoxLinesOn = False
   res@lbOrientation = "vertical"

;   res@pmLabelBarHeightF = 0.08
   res@pmLabelBarOrthogonalPosF = 0.02

   res@tmLabelAutoStride = False
   res@tmYROn = False
   res@tmXTOn = False

   res1 = res
   res1@cnLevelSelectionMode = "ManualLevels"
   res1@cnMinLevelValF = -0.6
   res1@cnMaxLevelValF = 2
   res1@cnLevelSpacingF = 0.2
;   res1@cnFillPalette = "ncl_default"
;   res1@cnFillPalette = "BlGrYeOrReVi200"
;   res1@cnSpanFillPalette = False
   res1@gsnSpreadColorStart = 80
;   res1@gsnSpreadColorEnd    = 255

   res2 = res
   res2@cnLevelSelectionMode = "ManualLevels"
   res2@cnMinLevelValF = -0.3
   res2@cnMaxLevelValF = 0.3
   res2@cnLevelSpacingF = 0.05
;   res2@cnSpanFillPalette = True
;   res2@cnFillPalette = "ncl_default"

   plot = new(2, graphic)
   plot(0) = gsn_csm_contour(wks, cn1, res1)
   plot(1) = gsn_csm_contour(wks, cn2, res2)

   resP = True
   resP@gsnFrame = False
;   resP@gsnPanelLabelBar = True
;      resP@gsnPanelBottom = 0.05
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 10
   resP@gsnPanelRowSpec = True

   resP@pmLabelBarWidthF = 0.5
   resP@pmLabelBarHeightF = 0.06
   resP@pmLabelBarOrthogonalPosF = -0.01

   gsn_panel(wks, plot, (/2/), resP)

  txres               = True
  txres@txFontHeightF = fontheight
  text = "Zonal Mean Wind Stress Evolved with Time"
  gsn_text_ndc(wks, text, 0.24, 0.7, txres)
  text = "dyne/cm~S~2"
  gsn_text_ndc(wks, text, 0.48, 0.68, txres)
  text = "year"
  gsn_text_ndc(wks, text, 0.24, 0.3, txres)

  text = "Zonal Mean Wind Stress Anormaly"
  gsn_text_ndc(wks, text, 0.75, 0.7, txres)
  text = "dyne/cm~S~2"
  gsn_text_ndc(wks, text, 0.95, 0.69, txres)
  text = "year"
  gsn_text_ndc(wks, text, 0.75, 0.3, txres)

end
