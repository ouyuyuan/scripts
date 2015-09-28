
; Description: vertical mean temperature by CDO
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-11-04 09:44:25 CST
; Last Change: 2013-11-20 19:13:47 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   ; directories <<<1

   draw_dir = "/home/ou/archive/drawing/pcom/assess/eps/t_res_monlong/t"
   data_dir = "/home/ou/archive/data"

   ; data files <<<1

   f_w = addfile(data_dir + "/woa09/t_level_mean.nc", "r")
   f_s = addfile(data_dir + "/climate/soda/level_mean_1981-2000.nc", "r")
   f_p = addfile(data_dir + "/climate/pcom/t_res_monlong/level_mean_031-050.nc", "r")
   f_l = addfile(data_dir + "/climate/licom/unmodified/level_mean_081-100.nc", "r")

   ; regions <<<1

   img_reg = "global"

   ; workstation <<<1

   wtype = "eps"
   img = draw_dir + "/level_mean" + "_" + img_reg
   wks = gsn_open_wks(wtype, img)
;   gsn_define_colormap(wks,"BlueYellowRed")  ; choose color map
;   gsn_define_colormap(wks,"BlGrYeOrReVi200")  ; choose color map
   gsn_define_colormap(wks,"ncl_default")  ; choose color map

   ; data field <<<1

   cn_w = f_w->t_mn(0, :, :)
   cn_s = f_s->temp(:, :)
   cn_p = f_p->pt(0, :, :)
   cn_l = f_l->ts(0, :, :)

   ; main res. <<<1

   res = True

   ; gsn <<<2
   ;
   res@gsnDraw = False
   res@gsnFrame = False
;   res@gsnMaximize = True
   res@gsnSpreadColors      = True               ; use full color map
;   res@gsnSpreadColorStart  = 30                 ; start at color 17
;   res@gsnSpreadColorEnd    = 240                ; end at color 200
;   res@gsnSpreadColorEnd    = 180                ; end at color 200
;   res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 

   ; contour <<<2
   ;
   res@cnFillOn             = True               ; turn on color for contours
   res@cnLinesOn            = False              ; turn off contour lines
   res@cnLineLabelsOn       = False              ; turn off contour line labels
   res@cnInfoLabelOn        = False      ; turns off contour info label
   res@cnLevelSelectionMode = "ManualLevels"
   res@cnMaxLevelValF       = 8.               ; set max contour level
   res@cnMinLevelValF       = 2.               ; set min contour level
   res@cnLevelSpacingF = 2.

   ; label bar <<<2

   res@lbLabelBarOn = False
;   res@lbOrientation            = "Vertical"     ; vertical label bar
   res@lbPerimOn                = False             ; no box around it
   ;    res@lbLabelStride            = 4

   ; plot manager <<<2

   ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
   ;    res@pmLabelBarWidthF         = 0.08              ; make it thinner
   res@pmLabelBarOrthogonalPosF = -0.04          ; move label bar closer

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

   res_w = res
   res_s = res
   res_p = res
   res_l = res

   res_w@tiMainString = "WOA09"

   res_s@tiMainString = "SODA"

   res_p@tiMainString = "PCOM"

   res_l@tiMainString = "LICOM"
   res_l@gsnAddCyclic = False
   
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
   resP@pmLabelBarWidthF = 0.3
   resP@pmLabelBarHeightF = 0.05
   resP@lbLabelFontHeightF = 0.009
   resP@lbLabelAutoStride = True
;   resP@lbLabelFontHeightF = 0.007
;      resP@gsnPanelBottom = 0.05
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 10
   resP@txString = "Vertical mean temperature"

   gsn_panel(wks, plot, (/2,2/), resP)

   ; figure text  <<<2

   txres               = True
   txres@txFontHeightF = 0.01
   text = "'grid' field in WOA"
   gsn_text_ndc(wks, text, 0.5, 0.05, txres)
   frame(wks)

end
