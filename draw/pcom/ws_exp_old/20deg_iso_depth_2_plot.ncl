
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-26 09:22:54 BJT
; Last Change: 2014-10-26 19:05:41 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  nc = getenv("NCL_ARG_1")
  img = getenv("NCL_ARG_2")

  fontheight = 0.015
;  cmap = "BlGrYeOrReVi200"
;  cmap = "testcmap"
;  cmap = "NCV_blue_red"
  cmap = "NCL_default"
  wks = gsn_open_wks("eps", img)
  gsn_define_colormap(wks,cmap)

  f = addfile(nc, "r")
  ini = f->ini
  control = f->fkh1
  delete(f)

   res = True

  res@vpHeightF = 0.4
  res@vpWidthF = 0.8

   res@gsnDraw = False
   res@gsnFrame = False
   res@gsnSpreadColors      = True               ; use full color map
;   res@gsnSpreadColorStart  = 30                 ; start at color 17
;   res@gsnSpreadColorEnd    = 180
   res@gsnStringFontHeightF = fontheight
   res@gsnLeftString = ""
   res@gsnRightString = ""

   res@cnFillOn             = True               ; turn on color for contours
   res@cnLinesOn            = False              ; turn off contour lines
;   res@cnLineThicknessF = 0.5
   res@cnLineLabelsOn       = False              ; turn off contour line labels
   res@cnInfoLabelOn        = False      ; turns off contour info label
   res@cnLevelSelectionMode = "ManualLevels"
   res@cnMaxLevelValF       =  400              ; set max contour level
   res@cnMinLevelValF       = 40
   res@cnLevelSpacingF = 20
;  res@cnMissingValFillColor = "gray60"
;   res@cnFillMode = "RasterFill"

   res@tmYLLabelFontHeightF = fontheight
   res@tmXBLabelFontHeightF = fontheight

   res@lbLabelBarOn = False

;   res@mpLandFillColor          = "gray"            ; set land to be gray
;   res@mpMinLonF = 0
;   res@mpMaxLonF = 360
   res@mpShapeMode = "FreeAspect"
   res@mpMinLatF = -40
   res@mpMaxLatF = 40
   res@mpCenterLonF = 180

   res_ini = res
   res_control = res

   plot = new(2, graphic)
   plot(0) = gsn_csm_contour_map(wks, ini, res_ini)
   plot(1) = gsn_csm_contour_map(wks, control, res_control)

   resP = True
   resP@gsnFrame = False
   resP@gsnPanelLabelBar = True
;      resP@gsnPanelBottom = 0.05
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 10
   resP@gsnPanelRowSpec = True

   resP@pmLabelBarWidthF = 0.05
   resP@pmLabelBarHeightF = 0.7
   resP@pmLabelBarOrthogonalPosF = 0.01

;   resP@lbAutoManage = False
   resP@lbLabelFontHeightF = fontheight * 0.8
   resP@lbPerimOn                = False             ; no box around it
;   resP@lbLabelAutoStride = True
;   resP@lbLabelStride            = 5
;   resP@lbTitleString = "Verical mean sea salinity (psu)"
   resP@lbTitleFontHeightF = fontheight
   resP@lbOrientation = "vertical"
;   resP@lbBoxLinesOn = False

;   resP@txString = "Sea surface salinity"

   gsn_panel(wks, plot, (/1,1/), resP)

  txres               = True
  txres@txFontHeightF = fontheight
  text = "Obs. (WOA09)"
  gsn_text_ndc(wks, text, 0.4, 0.92, txres)
;  text = "a)"
;  gsn_text_ndc(wks, text, 0.25, 0.98, txres)
  text = "Control run"
  gsn_text_ndc(wks, text, 0.4, 0.48, txres)
;  text = "b)"
;  gsn_text_ndc(wks, text, 0.25, 0.56, txres)
  text = "m"
  gsn_text_ndc(wks, text, 0.79, 0.85, txres)

end
