
; Description: Meridional mean salinity
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-11-04 09:44:25 CST
; Last Change: 2013-11-18 09:47:11 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   ; directories <<<1

   draw_dir = "/home/ou/archive/drawing/pcom/assess/eps/t_res_monlong/s"
   data_dir = "/home/ou/archive/data"

   ; data files <<<1

   f_w = addfile(data_dir + "/woa09/salinity_annual_1deg.nc", "r")
   f_s = addfile(data_dir + "/climate/soda/climate_1981-2000_mermean.nc", "r")
   f_p = addfile(data_dir + \
   "/climate/pcom/t_res_monlong/climate_031-050_mermean.nc", "r")
   f_l = addfile(data_dir + "/climate/licom/unmodified/climate_081-100_mermean.nc", "r")

   ; workstation <<<1

   wtype = "eps"
   img = draw_dir + "/meridional_mean"
   wks = gsn_open_wks(wtype, img)
;   gsn_define_colormap(wks,"BlueYellowRed")  ; choose color map
   gsn_define_colormap(wks,"BlGrYeOrReVi200")  ; choose color map

   ; data field <<<1

   t_w = f_w->s_mn(0, :, :, :)
   cn_w = dim_avg_n_Wrap(t_w, 1)

   cn_s = f_s->salt(:, 0, :)
   cn_p = f_p->sa(0, :, 0, :)
   cn_l = f_l->ss(0, :, 0, {0:360})

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
   res@gsnSpreadColorEnd    = 180                ; end at color 200
   res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 
;   res@gsnCenterStringOrthogonalPosF = 0.05
   res@gsnLeftStringOrthogonalPosF = 0.03
   res@gsnRightStringOrthogonalPosF = 0.03

   ; contour <<<2
   ;
   res@cnFillOn             = True               ; turn on color for contours
   res@cnLinesOn            = False              ; turn off contour lines
   res@cnLineLabelsOn       = False              ; turn off contour line labels
   res@cnInfoLabelOn        = False      ; turns off contour info label
   res@cnLevelSelectionMode = "ManualLevels"
   res@cnMaxLevelValF       = 36.               ; set max contour level
   res@cnMinLevelValF       = 34.               ; set min contour level
   res@cnLevelSpacingF = 0.2

   ; label bar <<<2

   res@lbLabelBarOn = False
;   res@lbOrientation            = "Vertical"     ; vertical label bar
   res@lbPerimOn                = False             ; no box around it
   ;    res@lbLabelStride            = 4

   ; plot manager <<<2

   ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
   ;    res@pmLabelBarWidthF         = 0.08              ; make it thinner
   res@pmLabelBarOrthogonalPosF = -0.02          ; move label bar closer

   ; map  <<<2

;   res@mpLandFillColor          = "gray"            ; set land to be gray
;   res@mpMinLonF = 0
;   res@mpMaxLonF = 360
;   res@mpCenterLonF = 200

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

   res@trYMaxF = 5000.
;   res@trXMaxF = 25
;   res@trXMinF = -25
   res@trYReverse               = True   ; reverses y-axis

   ; individual res. <<<1

   res_w = res
   res_s = res
   res_p = res
   res_l = res

   res_w@tiMainString = "WOA09"

   res_s@tiMainString = "SODA"

   res_p@tiMainString = "PCOM"
;   res_p@cnLevelSelectionMode = "AutomaticLevels"
;   delete_VarAtts(res_p, (/"cnMaxLevelValF","cnMinLevelValF","cnLevelSpacingF"/))
;   res_p@cnMaxLevelValF = 35.4
;   res_p@cnMinLevelValF = 34.6
;   res_p@cnLevelSpacingF = 0.2

   res_l@tiMainString = "LICOM"
   res_l@gsnXAxisIrregular2Linear = True   ; converts irreg depth to linear 
   
   ; gsn plot <<<1

   plot = new(4, graphic)
   plot(0) = gsn_csm_contour(wks, cn_w, res_w)
   plot(1) = gsn_csm_contour(wks, cn_s, res_s)
   plot(2) = gsn_csm_contour(wks, cn_p, res_p)
   plot(3) = gsn_csm_contour(wks, cn_l, res_l)

;   printVarSummary(cn_p)
;   printVarSummary(cn_l)
;   printVarSummary(temp)

   ; gsn panel <<<1

   ; panel <<<2
   
   resP = True
   resP@gsnFrame = False
;      resP@gsnPanelDebug = True
   resP@gsnPanelLabelBar = True
   resP@gsnPanelBottom = 0.05
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 3

   resP@pmLabelBarWidthF = 0.6
   resP@pmLabelBarHeightF = 0.05
   resP@pmLabelBarOrthogonalPosF = -0.03 ; let label bar a bit far

   resP@lbLabelFontHeightF = 0.009
   resP@lbLabelAutoStride = True
;   resP@lbLabelFontHeightF = 0.007

   resP@txString = "Meridional mean salinity"

   gsn_panel(wks, plot, (/2,2/), resP)

   ; figure text  <<<2

   txres               = True
   txres@txFontHeightF = 0.01
   text = "High-bias in deep ocean"
   gsn_text_ndc(wks, text, 0.5, 0.02, txres)
   frame(wks)

end
