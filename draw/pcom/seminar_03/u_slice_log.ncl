
; Description: slice of u after fixing vertical mixing parameter fkh
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-03-11 08:56:41 BJT
; Last Change: 2014-03-15 09:38:02 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
   
   ; dirs, files <<<1

   data_dir = "/home/ou/archive/data/"
   draw_dir = "/home/ou/archive/drawing/pcom/seminar_03/"

   f_s = addfile(data_dir + "soda/climate/climate_1981-2000.nc", "r")
   f_p = addfile(data_dir + "pcom/climate/t_res_monlong/climate_031-050.nc", "r")
   f_p_new = addfile(data_dir + "pcom/climate/fix_fkh/year_mean_081-100.nc", "r")
   f_l = addfile(data_dir + \ 
   "licom/climate/unmodified/climate_081-100_woa_grid_hori_positive_level.nc", "r")

   ; data field <<<1

   lon = 220.5
   cn_s = f_s->u(:, :, {lon})
   cn_p = f_p->u(0, :, :, {lon})
   cn_p_new = f_p_new->u(0,:,:,{lon})
   cn_l = f_l->us(0, :, :, {lon})

   ; workstation <<<1

   wtype = "eps"
   img = draw_dir + "u_slice_log"
   wks = gsn_open_wks(wtype, img)
;   gsn_define_colormap(wks,"BlueYellowRed")  ; choose color map
   gsn_define_colormap(wks,"BlGrYeOrReVi200")  ; choose color map
;   gsn_define_colormap(wks,"cmp_b2r")  ; choose color map
;   gsn_define_colormap(wks,"ncl_default")  ; choose color map

   ; main res. <<<1

   res = True

   ; title  <<<2

   res@tiXAxisString = "latitude"
   res@tiYAxisString = "depth (m)"

   ; gsn <<<2
   ;
   res@gsnDraw = False
   res@gsnFrame = False
;   res@gsnMaximize = True
   res@gsnSpreadColors      = True               ; use full color map
;   res@gsnSpreadColorStart  = 30                 ; start at color 17
;   res@gsnSpreadColorEnd    = 240                ; end at color 200
   res@gsnSpreadColorEnd    = 180                ; end at color 200
;   res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 
   res@gsnYAxisIrregular2Log = True   ; converts irreg depth to linear 
   res@gsnLeftString = ""
   res@gsnRightString = ""
   res@gsnLeftStringOrthogonalPosF = 0.03
   res@gsnRightStringOrthogonalPosF = 0.03

   ; contour <<<2
   ;
   res@cnFillOn             = True               ; turn on color for contours
   res@cnLinesOn            = False              ; turn off contour lines
   res@cnLineLabelsOn       = False              ; turn off contour line labels
   res@cnInfoLabelOn        = False      ; turns off contour info label
   res@cnLevelSelectionMode = "ManualLevels"
   res@cnMaxLevelValF       = 0.5               ; set max contour level
   res@cnMinLevelValF       = -0.5               ; set min contour level
;   res@cnLevelSpacingF = 0.05
   res@cnLevelSpacingF = 0.1
   res@cnMissingValFillColor = "black"

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
   res@trYMinF = 7.5
;   res@trYMaxF = 500.
;   res@trXMaxF = 25
;   res@trXMinF = -25
   res@trYReverse               = True   ; reverses y-axis

   ; individual res. <<<1

   res_s = res
   res_p = res
   res_p_new = res
   res_l = res

   res_s@tiMainString = "SODA"
   res_p@tiMainString = "PCOM (constant diffusity)"
   res_p_new@tiMainString = "PCOM (depth-vary diffusity)"
   res_l@tiMainString = "LICOM"
;   res_l@gsnAddCyclic = False
;   res_l@gsnYAxisIrregular2Linear = True   ; converts irreg latitude to linear 

   ; gsn plot <<<1

   plot = new(4, graphic)
   plot(0) = gsn_csm_contour(wks, cn_s, res_s)
   plot(1) = gsn_csm_contour(wks, cn_l, res_l)
   plot(2) = gsn_csm_contour(wks, cn_p, res_p)
   plot(3) = gsn_csm_contour(wks, cn_p_new, res_p_new)

   ; gsn panel <<<1

   resP = True
   resP@gsnFrame = False
;      resP@gsnPanelDebug = True
   resP@gsnPanelLabelBar = True
;      resP@gsnPanelBottom = 0.05
;   resP@gsnPanelRowSpec = True
   resP@gsnPanelXWhiteSpacePercent = 10
   resP@gsnPanelYWhiteSpacePercent = 5

   resP@pmLabelBarWidthF = 0.6
   resP@pmLabelBarHeightF = 0.05
   resP@pmLabelBarOrthogonalPosF = -0.025 ; let label bar a bit far

   resP@lbLabelFontHeightF = 0.009
   resP@lbLabelAutoStride = True
;   resP@lbLabelFontHeightF = 0.007

   resP@txString = "Zonal current at "  + flt2string(lon) + "E"

   gsn_panel(wks, plot, (/2,2/), resP)

   ; label bar text  <<<1

   txres               = True
   txres@txFontHeightF = 0.015
   text = "zonal current (m/s)"
   gsn_text_ndc(wks, text, 0.5, 0.11, txres)
   
   text = "climate mean"
   gsn_text_ndc(wks, text, 0.2, 0.05, txres)
   frame(wks)

   delete(wks)

   system("eps2png_trim " + img)

end
