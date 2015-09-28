
; Description: time-averaged free surface
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-12-28 19:24:25 BJT
; Last Change: 2013-12-29 19:26:35 BJT

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

   ; workstation <<<1

   wtype = "eps"
;   wtype = "png"
;   wtype = "ps"
;   wtype = "X11"
   img = draw_dir + "/zeta"
   wks = gsn_open_wks(wtype, img)
;   gsn_define_colormap(wks,"BlGrYeOrReVi200")  ; choose color map
;   gsn_define_colormap(wks,"BlueYellowRed")
;   gsn_define_colormap(wks,"GMT_drywet")
   gsn_define_colormap(wks,"cmp_b2r")
;   gsn_reverse_colormap(wks)

   ; main res. <<<1

   res = True

   ; titile <<<2

   res@tiMainFontHeightF = 0.04

   ; gsn <<<2
   ;
   res@gsnDraw = False
   res@gsnFrame = False
;   res@gsnMaximize = True
   res@gsnSpreadColors      = True               ; use full color map
;   res@gsnSpreadColorStart  = 20
;   res@gsnSpreadColorEnd    = 220

   ; contour <<<2
   ;
   res@cnFillOn             = True               ; turn on color for contours
;   res@cnLinesOn            = False              ; turn off contour lines
   res@cnLineLabelsOn       = False              ; turn off contour line labels
   res@cnInfoLabelOn        = False      ; turns off contour info label
   res@cnLevelSelectionMode = "ManualLevels"
   res@cnMaxLevelValF       = 8
   res@cnMinLevelValF       = -8
   res@cnLevelSpacingF = 1

   ; label bar <<<2

   res@lbLabelBarOn = False
;   res@lbOrientation            = "Vertical"     ; vertical label bar
   res@lbPerimOn                = False             ; no box around it
   ;    res@lbLabelStride            = 4

   ; plot manager <<<2

   ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
   ;    res@pmLabelBarWidthF         = 0.08              ; make it thinner
   res@pmLabelBarHeightF         = 0.08              ; make it thinner
   res@pmLabelBarOrthogonalPosF = 0.05          ; move label bar further

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

   ntimes = dimsizes(nc->zeta(:,0,0))
   nrows = 2
   ncols = 3
   nplots = nrows * ncols
   plots = new(nplots, graphic)
   recs = fspan(0, ntimes-1, nplots)

   do i = 0, nplots - 1
      rec = floattoint(recs(i))

      cn = nc->zeta(rec,:,:)
      cn = cn*100
      cn@units = "cm"
      cn@long_name = ""

      h = nc->ocean_time(rec)
      h = h/(24*3600.0)
      res@tiMainString = "after " + h + " days"

      plots(i) = gsn_csm_contour(wks, cn, res)
   end do

   ; panel <<<1
   
   resP = True
   a = nc->zeta(0,0,0)
   resP@txString = a@long_name + " (cm)"

;   resP@gsnFrame = False
;      resP@gsnPanelDebug = True
   resP@gsnPanelLabelBar = True
   resP@gsnPanelBottom = 0.06
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 5

   resP@pmLabelBarWidthF = 0.6
   resP@pmLabelBarHeightF = 0.06

   resP@lbLabelFontHeightF = 0.009
   resP@lbLabelAutoStride = True
   resP@lbLabelFontHeightF = 0.013

   gsn_panel(wks, plots, (/nrows,ncols/), resP)

   delete(wks)
;   system("convert " + img + "." + wtype + " -trim " + img + "_crop." + wtype)
   system("eps2png_trim " + img)

end
