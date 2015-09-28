
; Description: Vertical mean temperature anormaly to WOA09
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-11-05 10:52:05 CST
; Last Change: 2013-11-18 09:27:40 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   ; directories <<<1

   draw_dir = "/home/ou/archive/drawing/pcom/assess/eps/t_res_monlong/t"
   data_dir = "/home/ou/archive/data"

   ; data files <<<1

   f_w = addfile(data_dir + "/woa09/t_level_mean.nc", "r")
   f_s = addfile(data_dir + "/climate/soda/level_mean_1981-2000_woa_grid.nc", "r")
   f_p = addfile(data_dir + \
   "/climate/pcom/t_res_monlong/level_mean_031-050_woa_grid.nc", "r")
   f_l = addfile(data_dir + \
   "/climate/licom/unmodified/level_mean_081-100_woa_grid.nc", "r")

   ; regions <<<1

   img_reg = "global"

   ; workstation <<<1

   wtype = "eps"
   img = draw_dir + "/level_mean_anormaly" + "_" + img_reg
   wks = gsn_open_wks(wtype, img)
   gsn_define_colormap(wks,"BlueYellowRed")  ; choose color map
;   gsn_define_colormap(wks,"BlGrYeOrReVi200")  ; choose color map
;   gsn_define_colormap(wks,"BlueRed")  ; choose color map

   ; data field <<<1

   t_w = f_w->t_mn(0, :, :)
   t_s = f_s->temp(:, :)
   t_p = f_p->pt(0, :, :)
   t_l = f_l->ts(0, :, :)

   ; cal. anormaly with WOA09

   cn_s = t_s - t_w
   cn_p = t_p - t_w
   cn_l = t_l - t_w
   copy_VarCoords(t_s, cn_s)
   copy_VarAtts(t_s, cn_s)
   copy_VarCoords(t_p, cn_p)
   copy_VarAtts(t_p, cn_p)
   copy_VarCoords(t_l, cn_l)
   copy_VarAtts(t_l, cn_l)

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
   res@cnMaxLevelValF       = 7.               ; set max contour level
   res@cnMinLevelValF       = -7.               ; set min contour level
;   res@cnLevelSpacingF = 0.5
   res@cnLevelSpacingF = 1.0

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

   res_s = res
   res_p = res
   res_l = res

   res_s@tiMainString = "SODA"

   res_p@tiMainString = "PCOM"

   res_l@tiMainString = "LICOM"
;   res_l@gsnAddCyclic = False
;   res_l@gsnYAxisIrregular2Linear = True   ; converts irreg latitude to linear 
   
   ; gsn plot <<<1

   plot = new(3, graphic)
   plot(0) = gsn_csm_contour_map_ce(wks, cn_s, res_s)
   plot(1) = gsn_csm_contour_map_ce(wks, cn_p, res_p)
   plot(2) = gsn_csm_contour_map_ce(wks, cn_l, res_l)

;   printVarSummary(cn_p)
;   printVarSummary(cn_l)
;   printVarSummary(temp)

   ; gsn panel <<<1

   ; panel <<<2
   
   resP = True
   resP@gsnFrame = False
;      resP@gsnPanelDebug = True
   resP@gsnPanelLabelBar = True
   resP@pmLabelBarWidthF = 0.5
   resP@pmLabelBarHeightF = 0.05
   resP@lbLabelFontHeightF = 0.009
   resP@lbLabelAutoStride = True
;   resP@lbLabelFont = 15
;   resP@lbLabelFontHeightF = 0.007
;      resP@gsnPanelBottom = 0.05
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 10
   resP@gsnPanelRowSpec = True
   resP@txString = "Vertical mean temperature anormaly to WOA09"

   gsn_panel(wks, plot, (/1,2/), resP)

   ; figure text  <<<2

   txres               = True
   txres@txFontHeightF = 0.01
   text = "'grid' produced by sub WOA, cold in M&L"
   gsn_text_ndc(wks, text, 0.5, 0.05, txres)
   frame(wks)

end
