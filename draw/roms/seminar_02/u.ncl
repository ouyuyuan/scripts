
; Description: time-averaged u-momentum component
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-12-29 21:06:38 BJT
; Last Change: 2013-12-30 14:15:04 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
 
   ; directories <<<1

   draw_dir = "/home/ou/archive/drawing/roms/upwelling"
   data_dir = "/home/ou/archive/data/roms/upwelling"

   ; data files <<<1

;   setfileoption("nc","MissingToFillValue",False)
   nc = addfile(data_dir + "/ocean_avg.nc", "r")

   ; data fields  <<<1

   us = nc->u(19,0,:,:)
   us = us*100
;   us@long_name = "u"
;   us@units = "cm/s"

   uxi = nc->u(19,:,40,:)
   uxi = uxi*100
;   uxi@long_name = "u"
;   uxi@units = "cm/s"

   ueta = nc->u(19,:,:,20)
   ueta = ueta*100
;   ueta@long_name = "u"
;   ueta@units = "cm/s"

   ; workstation <<<1

   wtype = "eps"
;   wtype = "png"
;   wtype = "X11"
   img = draw_dir + "/u"
   wks = gsn_open_wks(wtype, img)
;   gsn_define_colormap(wks,"BlGrYeOrReVi200")  ; choose color map
;   gsn_define_colormap(wks,"BlueYellowRed")
;   gsn_define_colormap(wks,"GMT_drywet")
   gsn_define_colormap(wks,"ncl_default")
   gsn_reverse_colormap(wks)

   ; main res. <<<1

   res = True
;   res@tiMainString = "Application bathymetry"

   ; title <<<2

;   res@tiLeftString
   res@tiYAxisString = ""
   res@tiMainFontHeightF = 0.04

   ; gsn <<<2
   ;
   res@gsnLeftString = "u"
   res@gsnRightString = "cm/s"
   res@gsnLeftStringOrthogonalPosF = 0.03
   res@gsnRightStringOrthogonalPosF = 0.03
   res@gsnDraw = False
   res@gsnFrame = False
;   res@gsnMaximize = True
   res@gsnSpreadColors      = True               ; use full color map
;   res@gsnSpreadColorStart  = 130
   res@gsnSpreadColorEnd    = 130

   ; contour <<<2
   ;
   res@cnFillOn             = True               ; turn on color for contours
   res@cnLineLabelsOn       = False              ; turn off contour line labels
   res@cnInfoLabelOn        = False      ; turns off contour info label
   res@cnLevelSelectionMode = "ManualLevels"

   ; label bar <<<2

;   res@lbLabelBarOn = False
;   res@lbOrientation            = "Vertical"     ; vertical label bar
   res@lbPerimOn                = False             ; no box around it
   ;    res@lbLabelStride            = 4

   ; plot manager <<<2

   ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
;       res@pmLabelBarWidthF         = 0.08              ; make it thinner
   res@pmLabelBarHeightF         = 0.08              ; make it thinner
   res@pmLabelBarOrthogonalPosF = 0.05          ; move label bar closer

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

;   res@trYMaxF = 500.
;   res@trXMaxF = 25
;   res@trXMinF = -25
;   res@trYReverse               = True   ; reverses y-axis

   ; gsn plot <<<1

   plots = new(3, graphic)
   res@tiMainString = "surface"
   res@cnLinesOn            = False              ; turn off contour lines
   res@cnMaxLevelValF       = -15.               ; set max contour level
   res@cnMinLevelValF       = -35               ; set min contour level
   res@cnLevelSpacingF = 5
   plots(0) = gsn_csm_contour(wks, us, res)

   res@tiMainString = "slice along x-direction"
   res@cnLinesOn            = True
   res@cnMaxLevelValF       = -16.               ; set max contour level
   res@cnMinLevelValF       = -25               ; set min contour level
   res@cnLevelSpacingF = 2
   plots(1) = gsn_csm_contour(wks, uxi, res)

   res@tiMainString = "slice along y-direction"
   res@cnLinesOn            = True
   res@cnMaxLevelValF       = -15.               ; set max contour level
   res@cnMinLevelValF       = -60               ; set min contour level
   res@cnLevelSpacingF = 10
   plots(2) = gsn_csm_contour(wks, ueta, res)

   ; panel <<<1
   
   resP = True
   resP@txString = "u after 4.875 days"

;   resP@gsnFrame = False
;      resP@gsnPanelDebug = True
;   resP@gsnPanelLabelBar = True
   resP@gsnPanelBottom = 0.06
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 5

   resP@pmLabelBarWidthF = 0.6
   resP@pmLabelBarHeightF = 0.06

   resP@lbLabelFontHeightF = 0.009
   resP@lbLabelAutoStride = True
   resP@lbLabelFontHeightF = 0.014

   gsn_panel(wks, plots, (/1,3/), resP)

   delete(wks)
;   system("convert " + img + "." + wtype + " -trim " + img + "_crop." + wtype)
   system("eps2png_trim " + img)

end
