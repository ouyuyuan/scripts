
; Description: Surface currents, vector over magnitude, independent bar
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-03-16 10:40:40 BJT
; Last Change: 2014-03-17 06:58:43 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   ; dirs, files <<<1

   draw_dir = "/home/ou/archive/drawing/pcom/seminar_03/"
   data_dir = "/home/ou/archive/data/"

   f_s = addfile(data_dir + "soda/climate/climate_1981-2000.nc", "r")
   f_p_n = addfile(data_dir + "pcom/climate/fix_fkh/year_mean_081-100.nc", "r")
   f_p_r = addfile(data_dir + "pcom/climate/res_s/year_mean_081-100.nc", "r")
   f_l = addfile(data_dir + "licom/climate/unmodified/climate_081-100.nc", "r")

   ; workstation <<<1

   wtype = "eps"
   img = draw_dir + "current_surface_bar"
   wks = gsn_open_wks(wtype, img)
;   gsn_define_colormap(wks,"BlueYellowRed")  ; choose color map
   gsn_define_colormap(wks,"BlGrYeOrReVi200")  ; choose color map

   ; data field <<<1

   u_s = f_s->u(0, :, :)
   v_s = f_s->v(0, :, :)

   u_l = f_l->us(0, 0, :, 0:360)
   v_l = f_l->vs(0, 0, :, 0:360)

   u_p_n = f_p_n->u(0, 0, :, :)
   v_p_n = f_p_n->v(0, 0, :, :)
   u_p_r = f_p_r->u(0, 0, :, :)
   v_p_r = f_p_r->v(0, 0, :, :)
   
   ; cal. magnitude
   ;
   mag_s = sqrt(u_s^2 + v_s^2)   
;   mag_s = mag_s*100
   copy_VarCoords(v_s, mag_s)

   mag_l = sqrt(u_l^2 + v_l^2)   
;   mag_l = mag_l*100
   copy_VarCoords(v_l, mag_l)

   mag_p_n = sqrt(u_p_n^2 + v_p_n^2)   
;   mag_p_n = mag_p_n*100
   copy_VarCoords(v_p_n, mag_p_n)

   mag_p_r = sqrt(u_p_r^2 + v_p_r^2)   
;   mag_p_r = mag_p_r*100
   copy_VarCoords(v_p_r, mag_p_r)

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

   ; vector <<<2
   ;
   res@vcLevelSelectionMode = "ManualLevels"
   res@vcRefMagnitudeF       = 1.0                  ; add a reference vector
   res@vcRefLengthF          = 0.045                ; what the ref length is
   res@vcMinDistanceF          = 0.017            ; thin out vectors
   res@vcRefAnnoOrthogonalPosF   = -1.0            ; move ref vector
;   res@vcMonoLineArrowColor  = False                ; vec's colored by their mag_p_n
   res@vcRefAnnoArrowLineColor   = "black"         ; change ref vector color
   res@vcRefAnnoArrowUseVecColor = False           ; don't use vec color for ref
   res@vcGlyphStyle          = "CurlyVector"        ; turn on curly vectors
   res@vcLineArrowThicknessF   = 0.5               ; change vector thickness
   res@vcVectorDrawOrder       = "PostDraw"        ; draw vectors last
   res@vcLineArrowColor        = "black"           ; change vector color

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
   res_s@tiMainString = "SODA"
   res_s@cnLevelSelectionMode = "ManualLevels"
   res_s@cnMaxLevelValF       = 0.5              ; set max contour level
   res_s@cnMinLevelValF       = 0.0               ; set min contour level
   res_s@cnLevelSpacingF = 0.1

   res_l = res
   res_l@tiMainString = "LICOM"
   res_l@gsnAddCyclic = False
   res_l@cnLevelSelectionMode = "ManualLevels"
   res_l@cnMaxLevelValF       = 0.5              ; set max contour level
   res_l@cnMinLevelValF       = 0.0               ; set min contour level
   res_l@cnLevelSpacingF = 0.1
;   res_l@gsnXAxisIrregular2Linear = True   ; converts irreg latitude to linear 
   
   res_p_n = res
   res_p_n@tiMainString = "PCOM, natural saltinity bounday"
   res_p_n@cnLevelSelectionMode = "ManualLevels"
   res_p_n@cnMaxLevelValF       = 1              ; set max contour level
   res_p_n@cnMinLevelValF       = 0.0               ; set min contour level
   res_p_n@cnLevelSpacingF = 0.1

   res_p_r = res
   res_p_r@tiMainString = "PCOM, relaxation salinity bounday"
   res_p_r@cnLevelSelectionMode = "ManualLevels"
   res_p_r@cnMaxLevelValF       = 1              ; set max contour level
   res_p_r@cnMinLevelValF       = 0.0               ; set min contour level
   res_p_r@cnLevelSpacingF = 0.1

   ; gsn plot <<<1

   plot_u = new(2, graphic)
   plot_u(0) = gsn_csm_vector_scalar_map_ce(wks, u_s, v_s, mag_s, res_s)
   plot_u(1) = gsn_csm_vector_scalar_map_ce(wks, u_l, v_l, mag_l, res_l)

   plot_l = new(2, graphic)
   plot_l(0) = gsn_csm_vector_scalar_map_ce(wks, u_p_n, v_p_n, mag_p_n, res_p_n)
   plot_l(1) = gsn_csm_vector_scalar_map_ce(wks, u_p_r, v_p_r, mag_p_r, res_p_r)
   ; to fix the bug that the last plot will be wrong when using map
;   plot(4) = gsn_csm_contour(wks, cn_w, res_w) 

;   printVarSummary(cn_p)
;   printVarSummary(cn_l)
;   printVarSummary(temp)

   ; gsn panel <<<1

   ; main <<<2
   
   resP = True
   resP@gsnFrame = False
;      resP@gsnPanelDebug = True
   resP@gsnPanelLabelBar = True
   resP@gsnPanelXWhiteSpacePercent = 5
;   resP@gsnPanelYWhiteSpacePercent = 7
;   resP@gsnPanelRowSpec = True
;   resP@gsnPanelBottom = 0.45

   resP@pmLabelBarWidthF = 0.3
   resP@pmLabelBarHeightF = 0.05
   resP@pmLabelBarOrthogonalPosF = -0.02 ; let label bar a bit far

   resP@lbLabelFontHeightF = 0.009
   resP@lbLabelAutoStride = True
   resP@lbTitleString = "surface horizontal current (m/s)"
   resP@lbTitleFontHeightF = 0.012

   ; up  <<<2
      
   resP_u = resP
   resP_u@txString = "Sea surface horizontal currents"
   resP_u@gsnPanelBottom = 0.45
   gsn_panel(wks, plot_u, (/1,2/), resP_u)

   ; bottom  <<<2

   resP_l = resP
   resP_l@gsnPanelTop = 0.45
   gsn_panel(wks, plot_l, (/1,2/), resP_l)

   ; figure text  <<<2

;   txres               = True
;   txres@txFontHeightF = 0.012
;   text = "Color is magnitude"
;   gsn_text_ndc(wks, text, 0.2, 0.15, txres)
   frame(wks)

   delete(wks)

   system("eps2png_trim " + img)
end
