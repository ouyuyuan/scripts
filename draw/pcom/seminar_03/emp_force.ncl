
; Description: evaporation minus precipitation, fresh water flux
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-03-14 06:47:51 BJT
; Last Change: 2014-03-15 10:49:28 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
   
   ; dirs, files <<<1

;   data_dir = "/media/scidata/pcom/"
   data_dir = "/home/ou/archive/data/pcom/input/"
   draw_dir = "/home/ou/archive/drawing/pcom/seminar_03/"

   f_bcf = addfile(data_dir + "pcom_bcf_mn.nc", "r")

   ; data field <<<1

   emp = f_bcf->emp
   emp = emp*24*3600*10 ; change cm/s to mm/day

   ; workstation <<<1

   wtype = "eps"
   img = draw_dir + "emp_force"
   wks = gsn_open_wks(wtype, img)
;   gsn_define_colormap(wks,"BlueYellowRed")  ; choose color map
   gsn_define_colormap(wks,"BlGrYeOrReVi200")  ; choose color map
;   gsn_define_colormap(wks,"cmp_b2r")  ; choose color map
;   gsn_define_colormap(wks,"ncl_default")  ; choose color map

   ; main res. <<<1

   res = True

   ; title  <<<2

;   res@tiXAxisString = "latitude"
;   res@tiYAxisString = "longitude"

   ; gsn <<<2
   ;
   res@gsnDraw = False
   res@gsnFrame = False
;   res@gsnMaximize = True
   res@gsnSpreadColors      = True               ; use full color map
;   res@gsnSpreadColorStart  = 30                 ; start at color 17
;   res@gsnSpreadColorEnd    = 240                ; end at color 200
;   res@gsnSpreadColorEnd    = 180                ; end at color 200
   res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 
;   res@gsnYAxisIrregular2Log = True   ; converts irreg depth to linear 
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
;   res@cnMissingValFillColor = "black"
   res@cnLevelSelectionMode = "ManualLevels"
   res@cnMaxLevelValF       = 6               ; set max contour level
   res@cnMinLevelValF       = -10              ; set min contour level
   res@cnLevelSpacingF = 1
;   res@cnLevelSpacingF = 0.1

   ; label bar <<<2

;   res@lbLabelBarOn = False
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

;   res@trYMaxF = 5000.
;   res@trYMinF = 7.5
;   res@trYMaxF = 500.
;   res@trXMaxF = 25
;   res@trXMinF = -25
;   res@trYReverse               = True   ; reverses y-axis

   ; gsn plot <<<1

   plot = new(13, graphic)
   res@tiMainString = "January"
   plot(0) = gsn_csm_contour_map(wks, emp(0,:,:), res)
   res@tiMainString = "February"
   plot(1) = gsn_csm_contour_map(wks, emp(1,:,:), res)
   res@tiMainString = "March"
   plot(2) = gsn_csm_contour_map(wks, emp(2,:,:), res)
   res@tiMainString = "April"
   plot(3) = gsn_csm_contour_map(wks, emp(3,:,:), res)
   res@tiMainString = "May"
   plot(4) = gsn_csm_contour_map(wks, emp(4,:,:), res)
   res@tiMainString = "June"
   plot(5) = gsn_csm_contour_map(wks, emp(5,:,:), res)
   res@tiMainString = "July"
   plot(6) = gsn_csm_contour_map(wks, emp(6,:,:), res)
   res@tiMainString = "August"
   plot(7) = gsn_csm_contour_map(wks, emp(7,:,:), res)
   res@tiMainString = "Septempber"
   plot(8) = gsn_csm_contour_map(wks, emp(8,:,:), res)
   res@tiMainString = "October"
   plot(9) = gsn_csm_contour_map(wks, emp(9,:,:), res)
   res@tiMainString = "November"
   plot(10) = gsn_csm_contour_map(wks, emp(10,:,:), res)
   res@tiMainString = "December"
   plot(11) = gsn_csm_contour_map(wks, emp(11,:,:), res)
   plot(12) = gsn_csm_contour(wks, emp(11,:,:), res)

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
   resP@pmLabelBarOrthogonalPosF = -0.02 ; let label bar a bit far

   resP@lbLabelFontHeightF = 0.009
   resP@lbLabelAutoStride = True
;   resP@lbLabelFontHeightF = 0.007

   resP@txString = "Evaporation minus precipitation"

   gsn_panel(wks, plot, (/4,3/), resP)

   ; label bar text  <<<1

   txres               = True
   txres@txFontHeightF = 0.012
   text = "rate of evaporation minus precipitation (mm/day)"
   gsn_text_ndc(wks, text, 0.5, 0.134, txres)
   text = "From OAFLUX of Woods Hole objective analysis and CPC Merge Analysis of Precipitation of NOAA"
   gsn_text_ndc(wks, text, 0.3, 0.06, txres)
   
   frame(wks)

   delete(wks)

   system("eps2png_trim " + img)

end
