
; Description: zonal tropical current
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-03-17 07:47:59 BJT
; Last Change: 2014-03-18 22:10:04 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   ; dirs, files <<<1

   draw_dir = "/home/ou/archive/drawing/pcom/seminar_04/"
   data_dir = "/home/ou/archive/data/"

   f_s = addfile(data_dir + "soda/climate/climate_1981-2000.nc", "r")
   f_p_n = addfile(data_dir + "pcom/climate/fix_fkh/year_mean_081-100.nc", "r")
   f_p_r = addfile(data_dir + "pcom/climate/res_s/year_mean_081-100.nc", "r")
   f_l = addfile(data_dir + "licom/climate/unmodified/climate_081-100.nc", "r")

   ; data field <<<1

   lat_min = -20
   lat_max = 20
;   lon_min = 98
;   lon_max = 282

   u_s = f_s->u(0, :, :)
   u_l = f_l->us(0, 0, :, 0:360)
   u_p_n = f_p_n->u(0, 0, :, :)
   u_p_r = f_p_r->u(0, 0, :, :)
   
   ; workstation <<<1

   wtype = "eps"
   img = draw_dir + "u_tropical"
   wks = gsn_open_wks(wtype, img)
;   gsn_define_colormap(wks,"BlueYellowRed")  ; choose color map
;   gsn_define_colormap(wks,"BlGrYeOrReVi200")  ; choose color map
   gsn_define_colormap(wks,"BlueDarkRed18")  ; choose color map

   ; main res. <<<1

   res = True

   ; title  <<<2

   res@tiMainFontHeightF = 0.009

   ; gsn <<<2
   ;
   res@gsnDraw = False
   res@gsnFrame = False
;   res@gsnMaximize = True
   res@gsnSpreadColors      = True               ; use full color map
;   res@gsnSpreadColorStart  = 30
   res@gsnLeftString = ""
   res@gsnRightString = ""
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
   res@cnMaxLevelValF       = 0.5             ; set max contour level
   res@cnMinLevelValF       = -0.5               ; set min contour level
   res@cnLevelSpacingF = 0.05
   res@cnMissingValFillColor = "black"
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
   res@mpMinLatF = lat_min
   res@mpMaxLatF = lat_max
;   res@mpMinLonF = lon_min
;   res@mpMaxLonF = lon_max
   res@mpCenterLonF = 200

   ; tick mark  <<<2

   res@tmLabelAutoStride = True
   res@tmYROn = False
   res@tmXTOn = False
   res@tmXBLabelFontHeightF = 0.007
   res@tmYLLabelFontHeightF = 0.007
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

   plot = new(4, graphic)
   plot(0) = gsn_csm_contour_map_ce(wks, u_s, res_s)
   plot(1) = gsn_csm_contour_map_ce(wks, u_l, res_l)
   plot(2) = gsn_csm_contour_map_ce(wks, u_p_n, res_p_n)
   plot(3) = gsn_csm_contour_map_ce(wks, u_p_r, res_p_r)
   ; to fix the bug that the last plot will be wrong when using map
;   plot(4) = gsn_csm_contour(wks, u_s, res_s) 

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

   resP@pmLabelBarWidthF = 0.6
   resP@pmLabelBarHeightF = 0.05
   resP@pmLabelBarOrthogonalPosF = -0.01 ; let label bar a bit far

   resP@lbLabelFontHeightF = 0.009
   resP@lbLabelAutoStride = True
   resP@lbTitleString = "zonal currents (m/s)"
   resP@lbTitleFontHeightF = 0.012
;   resP@lbLabelFontHeightF = 0.007

   resP@txString = "Zonal currents"

   gsn_panel(wks, plot, (/4,1/), resP)

   ; figure text  <<<2

;   txres               = True
;   txres@txFontHeightF = 0.012
;   text = "Color is magnitude. Tropical: large bias, no west-boundary currents"
;   gsn_text_ndc(wks, text, 0.2, 0.15, txres)
   frame(wks)

   delete(wks)

   system("eps2png_trim " + img)
end
