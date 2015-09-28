
; Description: x location of rho-points
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-12-28 09:29:26 BJT
; Last Change: 2013-12-28 10:26:06 BJT

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

   cn = nc->x_rho
   cn = cn*0.001
   cn@units = "km"

   ; workstation <<<1

;   wtype = "eps"
   wtype = "png"
;   wtype = "X11"
   img = draw_dir + "/x_rho"
   wks = gsn_open_wks(wtype, img)
;   gsn_define_colormap(wks,"BlGrYeOrReVi200")  ; choose color map
;   gsn_define_colormap(wks,"BlueYellowRed")
;   gsn_define_colormap(wks,"GMT_drywet")
;   gsn_reverse_colormap(wks)

   ; main res. <<<1

   res = True
;   res@tiMainString = "Coriolis parameter"

   ; gsn <<<2
   ;
;   res@gsnDraw = False
;   res@gsnFrame = False
;   res@gsnMaximize = True
   res@gsnSpreadColors      = True               ; use full color map
   res@gsnSpreadColorStart  = 140
   res@gsnSpreadColorEnd    = 230

   ; contour <<<2
   ;
   res@cnFillOn             = True               ; turn on color for contours
;   res@cnLinesOn            = False              ; turn off contour lines
   res@cnLineLabelsOn       = False              ; turn off contour line labels
   res@cnInfoLabelOn        = False      ; turns off contour info label
;   res@cnLevelSelectionMode = "ManualLevels"
;   res@cnMaxLevelValF       = 5500.               ; set max contour level
;   res@cnMinLevelValF       = 500.               ; set min contour level
;   res@cnLevelSpacingF = 30.

   ; label bar <<<2

;   res@lbLabelBarOn = False
;   res@lbOrientation            = "Vertical"     ; vertical label bar
   res@lbPerimOn                = False             ; no box around it
   ;    res@lbLabelStride            = 4

   ; plot manager <<<2

   ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.

;       res@pmLabelBarWidthF         = 0.08              ; make it thinner
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

   plot = gsn_csm_contour(wks, cn, res)

   delete(wks)
   system("convert " + img + "." + wtype + " -trim " + img + "_crop." + wtype)

end
