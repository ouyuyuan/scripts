
; Description: EOF pattern of isothermal line depth
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-10 10:19:03 BJT
; Last Change: 2014-11-27 20:13:32 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  nc = getenv("NCL_ARG_1")+"dtc_eof.nc"
  img = getenv("NCL_ARG_2")+getenv("NCL_ARG_0_base")

  fontheight = 0.03
;  cmap = "BlGrYeOrReVi200"
;  cmap = "testcmap"
;  cmap = "NCV_blue_red"
  cmap = "NCV_blu_red"
;  cmap = "BlueWhiteOrangeRed"
;  cmap = "NCV_jaisnd"
  wks = gsn_open_wks("eps", img)
  gsn_define_colormap(wks,cmap)

  f = addfile(nc, "r")
  eof = f->eof
  delete(f)

  cn1 = eof(0,:,:)
  cn2 = eof(1,:,:)
  plotWid = 0.8
  plotHei = 0.3
  colorbarWid = 0.3
  colorbarHei = 0.05
  texta = sprintf("%4.1f",eof@pcvar(0))+"%"
  textb = sprintf("%4.1f",eof@pcvar(1))+"%"
  lbPosUp = 0.08
  lbPosRight = 0.17
  lbMinMaxInc = (/-40,40,1/)

   res = True

  res@vpHeightF = plotHei
  res@vpWidthF = plotWid

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
   res@cnMinLevelValF       = lbMinMaxInc(0)
   res@cnMaxLevelValF       = lbMinMaxInc(1)
   res@cnLevelSpacingF      = lbMinMaxInc(2)
;  res@cnMissingValFillColor = "gray60"
;   res@cnFillMode = "RasterFill"

   res@lbLabelBarOn = False

   res@tmLabelAutoStride = False
   res@tmYROn = False
   res@tmXTOn = False
   res@tmXBOn = False
   res@tmYLLabelFontHeightF = fontheight
   res@tmXBLabelFontHeightF = fontheight
  res@tmYLMode = "Explicit"
  res@tmYLValues = (/-30, 0, 30/)
  res@tmYLLabels = (/"30~S~o~N~S","EQ","30~S~o~N~S"/)

   res@mpShapeMode = "FreeAspect"
   res@mpMinLatF = -40
   res@mpMaxLatF = 40
   res@mpCenterLonF = 200

   res1 = res
   res2 = res

   plot = new(2, graphic)
   plot(0) = gsn_csm_contour_map(wks, cn1, res1)
   plot(1) = gsn_csm_contour_map(wks, cn2, res2)

   resP = True
   resP@gsnFrame = False
   resP@gsnPanelLabelBar = True
;      resP@gsnPanelBottom = 0.05
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 10
   resP@gsnPanelRowSpec = True

   resP@pmLabelBarWidthF = colorbarWid
   resP@pmLabelBarHeightF = colorbarHei
   resP@pmLabelBarOrthogonalPosF = lbPosUp
   resP@pmLabelBarParallelPosF = lbPosRight

;   resP@lbAutoManage = False
   resP@lbLabelFontHeightF = fontheight*0.8
   resP@lbPerimOn                = False             ; no box around it
;   resP@lbLabelAutoStride = True
   resP@lbLabelStride            = 5
;   resP@lbTitleString = "Verical mean sea salinity (psu)"
   resP@lbTitleFontHeightF = 0.013
   resP@lbBoxLinesOn = False
;   resP@lbLabelFontHeightF = 0.007
  resP@lbLabelPosition = "Top"

;   resP@txString = "Sea surface salinity"

   gsn_panel(wks, plot, (/1,1/), resP)

  txres               = True
  txres@txFontHeightF = fontheight
  text = texta
  gsn_text_ndc(wks, text, 0.3, 0.86, txres)
  text = textb
  gsn_text_ndc(wks, text, 0.3, 0.51, txres)
  text = "m"
  gsn_text_ndc(wks, text, 0.94, 0.27, txres)

  delete(wks)
  system("eps2png_trim "+img)

end
