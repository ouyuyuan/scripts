
; Description: Sea Surface salinity
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-03-14 18:25:34 BJT
; Last Change: 2014-04-10 09:33:04 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   ; directories <<<1

   data_dir = "/home/ou/archive/data/"
   draw_dir = "/home/ou/archive/drawing/pcom/phd_open/"

   ; data files <<<1

   f_w = addfile(data_dir + "woa09/salinity_annual_1deg.nc", "r")
   f_s = addfile(data_dir + "soda/climate/climate_1981-2000.nc", "r")
   f_p = addfile(data_dir + "pcom/climate/res_s/year_mean_081-100.nc", "r")
   f_l = addfile(data_dir + "licom/climate/unmodified/climate_081-100.nc", "r")

   ; workstation <<<1

   wtype = "eps"
   img = draw_dir + "sss"
   wks = gsn_open_wks(wtype, img)
;   gsn_define_colormap(wks,"BlueYellowRed")  ; choose color map
   gsn_define_colormap(wks,"BlGrYeOrReVi200")  ; choose color map
;   gsn_define_colormap(wks,"NCL_default")

   ; data field <<<1

   cn_w = f_w->s_mn(0, 0, :, :)
   cn_s = f_s->salt(0, :, :)
   cn_p = f_p->sa(0, 0, :, :)
   cn_l = f_l->ss(0, 0, ::-1, 0:359)

   ; main res. <<<1

   res = True

   ; gsn <<<2
   ;
   res@gsnDraw = False
   res@gsnFrame = False
;   res@gsnMaximize = True
   res@gsnSpreadColors      = True               ; use full color map
;   res@gsnSpreadColorStart  = 30                 ; start at color 17
   res@gsnSpreadColorEnd    = 180                ; end at color 200
   res@gsnLeftString = ""
   res@gsnRightString = ""
;   res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 

   ; contour <<<2
   ;
   res@cnFillOn             = True               ; turn on color for contours
   res@cnLinesOn            = False              ; turn off contour lines
;   res@cnLineThicknessF = 0.5
   res@cnLineLabelsOn       = False              ; turn off contour line labels
   res@cnInfoLabelOn        = False      ; turns off contour info label
   res@cnLevelSelectionMode = "ManualLevels"
   res@cnMaxLevelValF       = 37.               ; set max contour level
   res@cnMinLevelValF       = 30.               ; set min contour level
   res@cnLevelSpacingF = 0.5

   ; label bar <<<2

   res@lbLabelBarOn = False
;   res@lbOrientation            = "Vertical"     ; vertical label bar
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
   res@mpCenterLonF = 180

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

   res_w = res
   res_s = res
   res_p = res
   res_l = res

   res_w@tiMainString = "Observation (WOA09)"

   res_s@tiMainString = "Re-analysis (SODA)"

;   res_p@cnLevelSelectionMode = "AutomaticLevels"
;   delete_VarAtts(res_p, (/"cnMaxLevelValF","cnMinLevelValF","cnLevelSpacingF"/))
;   res_p@cnMaxLevelValF = 35.6
;   res_p@cnMinLevelValF = 34.2
;   res_p@cnLevelSpacingF = 0.1

   res_l@tiMainString = "LICOM"
   res_l@gsnAddCyclic = False
;   res_l@gsnYAxisIrregular2Linear = True   ; converts irreg latitude to linear 

   res_p@tiMainString = "PCOM"
   
   ; gsn plot <<<1

   plot = new(5, graphic)
   plot(0) = gsn_csm_contour_map_ce(wks, cn_w, res_w)
   plot(1) = gsn_csm_contour_map_ce(wks, cn_s, res_s)
   plot(2) = gsn_csm_contour_map_ce(wks, cn_p, res_p)
   plot(3) = gsn_csm_contour_map_ce(wks, cn_l, res_l)
   ; to fix the bug that the last plot will be wrong when using map
   plot(4) = gsn_csm_contour(wks, cn_w, res_w) 

;   printVarSummary(cn_p)
;   printVarSummary(cn_l)
;   printVarSummary(temp)

   ; gsn panel <<<1

   ; panel <<<2
   
   resP = True
   resP@gsnFrame = False
;      resP@gsnPanelDebug = True
   resP@gsnPanelLabelBar = True
;      resP@gsnPanelBottom = 0.05
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 10
;   resP@gsnPanelRowSpec = True

   resP@pmLabelBarWidthF = 0.7
   resP@pmLabelBarHeightF = 0.05

   resP@lbLabelFontHeightF = 0.013
   resP@lbLabelAutoStride = True
   resP@lbTitleString = "sea surface salinity (psu)"
   resP@lbTitleFontHeightF = 0.013
;   resP@lbLabelFontHeightF = 0.007

;   resP@txString = "Sea surface salinity"

   gsn_panel(wks, plot, (/2,2/), resP)

   ; figure text  <<<2

;   txres               = True
;   txres@txFontHeightF = 0.01
;   text = "Small range and gradient"
;   gsn_text_ndc(wks, text, 0.5, 0.04, txres)

   frame(wks)

   delete(wks)

   system("eps2png_trim " + img)
end
