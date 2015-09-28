
; Description: Meridional slice of u
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-12-27 21:54:41 BJT
; Last Change: 2013-12-27 22:12:51 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   ; data file <<<1

   draw_dir = "/home/ou/archive/drawing/pcom/assess/exp_05"
   data_dir = "/home/ou/archive/data/pcom/climate/exp_05"

   f = addfile(data_dir + "/year_mean_351-380.nc", "r")

   ; regions <<<1

   lon = 220.5
;   dep_min = 0.
;   dep_max = 700.
   img_reg = flt2string(lon)

   ; workstation <<<1

;   wtype = "eps"
   wtype = "png"
   img = draw_dir + "/u_slice_lon" + "_" + img_reg
   wks = gsn_open_wks(wtype, img)
;   gsn_define_colormap(wks,"BlueYellowRed")  ; choose color map
;   gsn_define_colormap(wks,"BlGrYeOrReVi200")  ; choose color map
;   gsn_define_colormap(wks,"cmp_b2r")  ; choose color map
   gsn_define_colormap(wks,"ncl_default")  ; choose color map

   ; data field <<<1

   cn = f->u(0, :, :, {lon})

   ; main res. <<<1

   res = True
   res@tiMainString = "PCOM"

   ; gsn <<<2
   ;
;   res@gsnDraw = False
;   res@gsnFrame = False
;   res@gsnMaximize = True
   res@gsnSpreadColors      = True               ; use full color map
;   res@gsnSpreadColorStart  = 30                 ; start at color 17
;   res@gsnSpreadColorEnd    = 240                ; end at color 200
;   res@gsnSpreadColorEnd    = 180                ; end at color 200
;   res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 
   res@gsnYAxisIrregular2Log = True   ; converts irreg depth to linear 
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

;   res@trYMaxF = 5000.
;   res@trYMinF = 7.5
;   res@trYMaxF = 500.
;   res@trXMaxF = 25
;   res@trXMinF = -25
   res@trYReverse               = True   ; reverses y-axis


   ; gsn plot <<<1

   plot = gsn_csm_contour(wks, cn, res)

;   frame(wks)

end
