
; Description: Surface currents, vector over direction
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-11-04 09:44:25 CST
; Last Change: 2013-11-17 09:35:27 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   ; directories <<<1

   draw_dir = "/home/ou/archive/drawing/pcom/assess/eps/t_res_monlong/uvw"
   data_dir = "/home/ou/archive/data/climate"

   ; data files <<<1

   f_s = addfile(data_dir + "/soda/climate_1981-2000.nc", "r")
   f_p = addfile(data_dir + "/pcom/t_res_monlong/climate_031-050.nc", "r")
   f_l = addfile(data_dir + "/licom/unmodified/climate_081-100.nc", "r")

   ; regions <<<1

   img_reg = "global"

   ; workstation <<<1

   wtype = "eps"
   img = draw_dir + "/surface_direction" + "_" + img_reg
   wks = gsn_open_wks(wtype, img)
;   gsn_define_colormap(wks,"BlueYellowRed")  ; choose color map
;   gsn_define_colormap(wks,"BlGrYeOrReVi200")  ; choose color map
   gsn_define_colormap(wks,"cmp_b2r")  ; choose color map
;   gsn_define_colormap(wks,"WhBlReWh")  ; choose color map

   ; data field <<<1

   u_s = f_s->u(0, :, :)
   v_s = f_s->v(0, :, :)

   u_p = f_p->u(0, 0, :, :)
   v_p = f_p->v(0, 0, :, :)
   
   u_l = f_l->us(0, 0, :, 0:360)
   v_l = f_l->vs(0, 0, :, 0:360)

   ; cal. direction
   ;
   r2d = 180/3.14159265
   di_s = atan2(v_s, u_s)*r2d
   di_p = atan2(v_p, u_p)*r2d
   di_l = atan2(v_l, u_l)*r2d
   copy_VarCoords(v_s, di_s)
   copy_VarCoords(v_p, di_p)
   copy_VarCoords(v_l, di_l)

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
;   res@cnMaxLevelValF       = 0.5               ; set max contour level
;   res@cnMinLevelValF       = 0.05               ; set min contour level
;   res@cnLevelSpacingF = 0.1

   ; vector <<<2
   ;
   res@vcLevelSelectionMode = "ManualLevels"
   res@vcRefMagnitudeF       = 1.0                  ; add a reference vector
   res@vcRefLengthF          = 0.045                ; what the ref length is
   res@vcMinDistanceF          = 0.017            ; thin out vectors
   res@vcRefAnnoOrthogonalPosF   = -1.0            ; move ref vector
;   res@vcMonoLineArrowColor  = False                ; vec's colored by their mag_p
   res@vcRefAnnoArrowLineColor   = "black"         ; change ref vector color
   res@vcRefAnnoArrowUseVecColor = False           ; don't use vec color for ref
   res@vcGlyphStyle          = "CurlyVector"        ; turn on curly vectors
   res@vcLineArrowThicknessF   = 0.5               ; change vector thickness
   res@vcVectorDrawOrder       = "PostDraw"        ; draw vectors last
   res@vcLineArrowColor        = "black"           ; change vector color

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
   res_l@gsnAddCyclic = False
;   res_l@gsnXAxisIrregular2Linear = True   ; converts irreg latitude to linear 
   
   ; gsn plot <<<1

   plot = new(3, graphic)
   plot(0) = gsn_csm_vector_scalar_map_ce(wks, u_s, v_s, di_s, res_s)
   plot(1) = gsn_csm_vector_scalar_map_ce(wks, u_p, v_p, di_p, res_p)
   plot(2) = gsn_csm_vector_scalar_map_ce(wks, u_l, v_l, di_l, res_l)
   ; to fix the bug that the last plot will be wrong when using map
;   plot(4) = gsn_csm_contour(wks, cn_w, res_w) 

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
   resP@gsnPanelYWhiteSpacePercent = 10
   resP@gsnPanelRowSpec = True
;      resP@gsnPanelBottom = 0.05

   resP@pmLabelBarWidthF = 0.7
   resP@pmLabelBarHeightF = 0.05

   resP@lbLabelFontHeightF = 0.009
   resP@lbLabelAutoStride = True
;   resP@lbLabelFontHeightF = 0.007

   resP@txString = "Sea surface horizontal currents and its direction"

   gsn_panel(wks, plot, (/1,2/), resP)

   ; figure text  <<<2

   txres               = True
   txres@txFontHeightF = 0.01
   text = "+-30, subduction, AAC"
   gsn_text_ndc(wks, text, 0.5, 0.04, txres)
   frame(wks)

end
