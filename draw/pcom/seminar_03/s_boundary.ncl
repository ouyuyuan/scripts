
; Description: Salt flux boundary
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-03-16 06:33:57 BJT
; Last Change: 2014-03-29 20:44:17 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   ; directories <<<1

   data_dir = "/home/ou/archive/data/pcom/"
   draw_dir = "/home/ou/archive/drawing/pcom/seminar_03/"

   ; data files <<<1

   f_b = addfile(data_dir + "/input/pcom_bcf_mn.nc", "r")
   f_n = addfile(data_dir + "/climate/fix_fkh/year_mean_081-100.nc", "r")
;   f_n = addfile(data_dir + "/climate/modify_mixing/year_mean_081-100.nc", "r")
   f_r = addfile(data_dir + "/climate/res_s/year_mean_081-100.nc", "r")

   ; workstation <<<1

   wtype = "eps"
   img = draw_dir + "s_boundary"
   wks = gsn_open_wks(wtype, img)
;   gsn_define_colormap(wks,"BlueYellowRed")  ; choose color map
   gsn_define_colormap(wks,"BlGrYeOrReVi200")  ; choose color map

   ; data field <<<1

   bcs = f_b->bcs(:,:,:)
   cn_bcs = dim_avg_n_Wrap(bcs, 0)
   emp = f_b->emp(:,:,:)
   cn_emp = dim_avg_n_Wrap(emp, 0)
   cn_emp = cn_emp*24*3600*10 ; change cm/s to mm/day

   cn_n = f_n->sa(0, 0, :, :)
   cn_r = f_r->sa(0, 0, :, :)

   ; main res. <<<1

   res = True

   ; gsn <<<2
   ;
   res@gsnDraw = False
   res@gsnFrame = False
;   res@gsnMaximize = True
   res@gsnSpreadColors      = True               ; use full color map
   res@gsnLeftString = ""
   res@gsnRightString = ""
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

   ; label bar <<<2

;   res@lbLabelBarOn = False
;   res@lbOrientation            = "Vertical"     ; vertical label bar
   res@lbTitleFontHeightF = 0.02
   res@lbTitleOffsetF = -0.1
   res@lbPerimOn                = False             ; no box around it
   ;    res@lbLabelStride            = 4

   ; plot manager <<<2

   ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
   ;    res@pmLabelBarWidthF         = 0.08              ; make it thinner
   res@pmLabelBarOrthogonalPosF = 0.15          ; move label bar further

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

   res_n = res
   res_n@tiMainString = "simulated surface salinity (natural boundary)"
   res_n@lbTitleString = "absolute salinity (g/kg)"
   res_n@cnLevelSelectionMode = "ManualLevels"
   res_n@cnMaxLevelValF       = 35.2               ; set max contour level
   res_n@cnMinLevelValF       = 34.4               ; set min contour level
   res_n@cnLevelSpacingF = 0.05

   res_r = res
   res_r@tiMainString = "simulated surface salinity (relaxation boundary)"
   res_r@lbTitleString = "absolute salinity (g/kg)"
   res_r@cnLevelSelectionMode = "ManualLevels"
   res_r@cnMaxLevelValF       = 37.               ; set max contour level
   res_r@cnMinLevelValF       = 30.               ; set min contour level
   res_r@cnLevelSpacingF = 0.5

   res_emp = res
   res_emp@tiMainString = "evaporation minus precipitation, forcing field"
   res_emp@lbTitleString = "rate of evaporation minus precipitation (mm/day)"
   res_emp@cnLevelSelectionMode = "ManualLevels"
   res_emp@cnMaxLevelValF       = 5               ; set max contour level
   res_emp@cnMinLevelValF       = -7              ; set min contour level
   res_emp@cnLevelSpacingF = 1

   res_bcs = res
   res_bcs@tiMainString = "surface salinity, forcing field"
   res_bcs@lbTitleString = "absolute salinity (g/kg)"
   res_bcs@cnLevelSelectionMode = "ManualLevels"
   res_bcs@cnMaxLevelValF       = 37.               ; set max contour level
   res_bcs@cnMinLevelValF       = 30.               ; set min contour level
   res_bcs@cnLevelSpacingF = 0.5

;   res_n@cnLevelSelectionMode = "AutomaticLevels"
;   delete_VarAtts(res_n, (/"cnMaxLevelValF","cnMinLevelValF","cnLevelSpacingF"/))
;   res_n@cnMaxLevelValF = 35.6
;   res_n@cnMinLevelValF = 34.2
;   res_n@cnLevelSpacingF = 0.1

   ; gsn plot <<<1

   plot = new(5, graphic)
   plot(0) = gsn_csm_contour_map_ce(wks, cn_n, res_n)
   plot(1) = gsn_csm_contour_map_ce(wks, cn_emp, res_emp)
   plot(2) = gsn_csm_contour_map_ce(wks, cn_r, res_r)
   plot(3) = gsn_csm_contour_map_ce(wks, cn_bcs, res_bcs)
   ; to fix the bug that the last plot will be wrong when using map
   plot(4) = gsn_csm_contour(wks, cn_r, res_r) 

;   printVarSummary(cn_n)
;   printVarSummary(cn_l)
;   printVarSummary(temp)

   ; gsn panel <<<1

   ; panel <<<2
   
   resP = True
   resP@gsnFrame = False
;      resP@gsnPanelDebug = True
;   resP@gsnPanelLabelBar = True
   resP@pmLabelBarWidthF = 0.7
   resP@pmLabelBarHeightF = 0.05
   resP@lbLabelFontHeightF = 0.009
   resP@lbLabelAutoStride = True
;   resP@lbLabelFontHeightF = 0.007
;      resP@gsnPanelBottom = 0.05
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 5
;   resP@gsnPanelRowSpec = True
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
