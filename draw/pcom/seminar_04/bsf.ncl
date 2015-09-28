
; Description: barotropic stream function
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-03-17 14:18:20 BJT
; Last Change: 2014-03-20 16:56:05 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   ; dirs, files <<<1

   draw_dir = "/home/ou/archive/drawing/pcom/seminar_04/"
   data_dir = "/home/ou/archive/data/"

   f_s = addfile(data_dir + "soda/climate/calculated/bsf.nc", "r")
   f_p_n = addfile(data_dir + "pcom/climate/fix_fkh/calculated/bsf.nc", "r")
   f_p_r = addfile(data_dir + "pcom/climate/res_s/calculated/bsf.nc", "r")
   f_l = addfile(data_dir + "licom/climate/unmodified/calculated/bsf.nc", "r")

   ; data field <<<1

   cn_s = f_s->bsf(0,:,:)
   cn_l = f_l->bsf(0,:,:)
   cn_p_n = f_p_n->bsf(0,:,:)
   cn_p_r = f_p_r->bsf(0,:,:)

   ; workstation <<<1

   wtype = "eps"
   img = draw_dir + "bsf"
   wks = gsn_open_wks(wtype, img)
;   gsn_define_colormap(wks,"BlueYellowRed")  ; choose color map
   gsn_define_colormap(wks,"BlGrYeOrReVi200")  ; choose color map

   ; main res. <<<1

   res = True

   ; gsn <<<2
   ;
   res@gsnDraw = False
   res@gsnFrame = False
   res@gsnScalarContour     = True               ; contours desired
;   res@gsnMaximize = True
   res@gsnSpreadColors      = True               ; use full color map
;   res@gsnSpreadColorStart  = 110                 ; start at color 17
;   res@gsnSpreadColorEnd    = 240                ; end at color 200
;   res@gsnSpreadColorEnd    = 180                ; end at color 200
;   res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 

   ; contour <<<2
   ;
   res@cnFillOn             = True               ; turn on color for contours
   res@cnLinesOn            = False              ; turn off contour lines
   res@cnLineLabelsOn       = False              ; turn off contour line labels
   res@cnInfoLabelOn        = False      ; turns off contour info label
;   res@cnLevelSelectionMode = "ManualLevels"
;   res@cnMaxLevelValF       = 0.5              ; set max contour level
;   res@cnMinLevelValF       = 0.0               ; set min contour level
;   res@cnLevelSpacingF = 0.1

   ; label bar <<<2

   res@lbLabelBarOn = False
;   res@lbOrientation            = "Vertical"     ; vertical label bar
   res@lbTitleFontHeightF = 0.02
   res@lbTitleOffsetF = -0.1
   res@lbPerimOn                = False             ; no box around it
   ;    res@lbLabelStride            = 4

   ; plot manager <<<2

   ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
   ;    res@pmLabelBarWidthF         = 0.08              ; make it thinner
   res@pmLabelBarOrthogonalPosF = 0.08          ; move label bar further

   ; map  <<<2

;   res@mpLandFillColor          = "gray"            ; set land to be gray
;   res@mpMinLonF = 0
;   res@mpMaxLonF = 360
   res@mpCenterLonF = 200

   ; tick mark  <<<2

   res@tmLabelAutoStride = True
   res@tmYROn = False
   res@tmXTOn = False
;   res@tmYLMode = "Manual"
;   res@tmYLTickStartF    = 100.
;   res@tmYLTickSpacingF  = 100.
;   res@tmXBMode = "Manual"
;   res@tmXBTickSpacingF = 5
;   res@tmXBTickStartF    = -25
;   res@tmXBTickEndF      = 25
;   res@tmYLTickEndF      = 300.

   ; transformation <<<2

;   res@trYMaxF = 500.
;   res@trXMaxF = 25
;   res@trXMinF = -25
;   res@trYReverse               = True   ; reverses y-axis

   ; individual res. <<<1

   res_s = res
   res_p_n = res
   res_p_r = res
   res_l = res

   res_s@tiMainString = "SODA"

   res_l@tiMainString = "LICOM"
   res_l@gsnAddCyclic = False
;   res_l@gsnXAxisIrregular2Linear = True   ; converts irreg latitude to linear 
   
   res_p_n@tiMainString = "PCOM, natural saltinity bounday"
   res_p_r@tiMainString = "PCOM, relaxation salinity bounday"

   ; gsn plot <<<1

   plot = new(5, graphic)
   plot(0) = gsn_csm_contour_map_ce(wks, cn_s, res_s)
   plot(1) = gsn_csm_contour_map_ce(wks, cn_l, res_s)
   plot(2) = gsn_csm_contour_map_ce(wks, cn_p_n, res_s)
   plot(3) = gsn_csm_contour_map_ce(wks, cn_p_r, res_s)
   ; to fix the bug that the last plot will be wrong when using map
   plot(4) = gsn_csm_contour(wks, cn_s, res_s)

;   printVarSummary(cn_p)
;   printVarSummary(cn_l)
;   printVarSummary(temp)

   ; gsn panel <<<1

   ; panel <<<2
   
   resP = True
   resP@gsnFrame = False
;      resP@gsnPanelDebug = True
   resP@gsnPanelLabelBar = True
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 7
;   resP@gsnPanelRowSpec = True
;      resP@gsnPanelBottom = 0.05

   resP@pmLabelBarWidthF = 0.3
   resP@pmLabelBarHeightF = 0.05
   resP@pmLabelBarOrthogonalPosF = -0.01 ; let label bar a bit far

   resP@lbLabelFontHeightF = 0.009
   resP@lbLabelAutoStride = True
   resP@lbTitleString = "Barotropic stream fuction (Sv)"
   resP@lbTitleFontHeightF = 0.012
;   resP@lbLabelFontHeightF = 0.007

   resP@txString = "Barotropic stream function"

   gsn_panel(wks, plot, (/2,2/), resP)

   ; figure text  <<<2

;   txres               = True
;   txres@txFontHeightF = 0.012
;   text = "Color is magnitude. Tropical: large bias, no west-boundary currents"
;   gsn_text_ndc(wks, text, 0.2, 0.15, txres)
   frame(wks)

   delete(wks)

   system("eps2png_trim " + img)
end
