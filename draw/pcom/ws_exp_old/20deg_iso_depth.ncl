
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-26 09:22:54 BJT
; Last Change: 2014-10-27 16:16:56 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  nc = getenv("NCL_ARG_1")
  img = getenv("NCL_ARG_2")

  fontheight = 0.03
;  cmap = "BlGrYeOrReVi200"
;  cmap = "testcmap"
;  cmap = "NCV_blue_red"
  cmap = "NCL_default"
  wks = gsn_open_wks("eps", img)
  gsn_define_colormap(wks,cmap)

  f = addfile(nc, "r")
  ini = f->ini
  zy = f->zy
  spinup = f->spinup
  fkh0 = f->fkh0
  fkh1 = f->fkh1
  fkh2 = f->fkh2
  delete(f)

   res = True

  res@vpHeightF = 0.4
  res@vpWidthF = 0.8

   res@tiMainFontHeightF = fontheight*1.2

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
   res@cnMaxLevelValF       =  400              ; set max contour level
   res@cnMinLevelValF       = 40
   res@cnLevelSpacingF = 20
;  res@cnMissingValFillColor = "gray60"
;   res@cnFillMode = "RasterFill"

   res@tmYLLabelFontHeightF = fontheight
   res@tmXBLabelFontHeightF = fontheight
   res@tmXBLabelStride  = 2

   res@lbLabelBarOn = False

;   res@mpLandFillColor          = "gray"            ; set land to be gray
;   res@mpMinLonF = 0
;   res@mpMaxLonF = 360
   res@mpShapeMode = "FreeAspect"
   res@mpMinLatF = -40
   res@mpMaxLatF = 40
   res@mpCenterLonF = 180

   res_ini    = res
   res_spinup = res
   res_zy     = res
   res_fkh0   = res
   res_fkh1   = res
   res_fkh2   = res
  res_ini@tiMainString = "Obs. (WOA09)"
  res_zy@tiMainString = "result from ZY"
  res_spinup@tiMainString = "spinup field"
  res_fkh0@tiMainString = "constant kappa"
  res_fkh1@tiMainString = "datasets of Zhang(2014)"
  res_fkh2@tiMainString = "vertical profile kappa"

   plot = new(6, graphic)
   plot(0) = gsn_csm_contour_map(wks, ini, res_ini)
   plot(1) = gsn_csm_contour_map(wks, zy, res_zy)
   plot(2) = gsn_csm_contour_map(wks, spinup, res_spinup)
   plot(3) = gsn_csm_contour_map(wks, fkh0, res_fkh0)
   plot(4) = gsn_csm_contour_map(wks, fkh1, res_fkh1)
   plot(5) = gsn_csm_contour_map(wks, fkh2, res_fkh2)

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
   resP@lbLabelFontHeightF = fontheight * 0.5
   resP@lbPerimOn                = False             ; no box around it
;   resP@lbLabelAutoStride = True
;   resP@lbLabelStride            = 5
;   resP@lbTitleString = "Verical mean sea salinity (psu)"
   resP@lbTitleFontHeightF = fontheight
   resP@lbOrientation = "vertical"
;   resP@lbBoxLinesOn = False

;   resP@txString = "Sea surface salinity"

   gsn_panel(wks, plot, (/2,2,2/), resP)

  txres               = True
  txres@txFontHeightF = 0.017
;  text = "a)"
;  gsn_text_ndc(wks, text, 0.25, 0.98, txres)
;  text = "b)"
;  gsn_text_ndc(wks, text, 0.25, 0.56, txres)
  text = "(m)"
  gsn_text_ndc(wks, text, 0.91, 0.84, txres)

end
