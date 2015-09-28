
; Description: upper ocean dtdz on the equator in the Pacific
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-26 20:37:16 BJT
; Last Change: 2014-10-26 21:37:02 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  nc = getenv("NCL_ARG_1")
  img = getenv("NCL_ARG_2")

;  cmap = "BlGrYeOrReVi200"
;  cmap = "GMT_globe"
;  cmap = "amwg_blueyellowred"
;  cmap = "NCV_blue_red"
;  cmap = "testcmap"
;  cmap = "NCV_jaisnd"
;  cmap = "BlueWhiteOrangeRed"
;  cmap = "BlWhRe"
  cmap = "NCL_default"
;  cmap = "BlRe"
;  cmap = "hotres"
;  cmap = "precip_11lev"

  wks = gsn_open_wks ("eps", img)
  gsn_define_colormap(wks, cmap)

  f = addfile( nc, "r" )
  ini = f->ini(z|:,lon|130:290) ; Pacific
  spinup = f->spinup(z|:,lon|130:290) ; Pacific
  zy = f->zy(z|:,lon|130:290) ; Pacific
  fkh0 = f->fkh0(z|:,lon|130:290) ; Pacific
  fkh1 = f->fkh1(z|:,lon|130:290) ; Pacific
  fkh2 = f->fkh2(z|:,lon|130:290) ; Pacific

; change degC/m to degC/10m
  ini = ini*10
  spinup = spinup*10
  zy = zy*10
  fkh0 = fkh0*10
  fkh1 = fkh1*10
  fkh2 = fkh2*10

  res = True
  ; resource{{

  res@vpWidthF = 0.7
  res@vpHeightF = res@vpWidthF * (3.6/4.5)
  res@vpXF = 0.1

;  res@tiYAxisString = "m"
;  res@tiXAxisString = "year"
  ; gsn <<<2
  ;
  res@gsnDraw = False
  res@gsnFrame = False
  ;   res@gsnMaximize = True
  res@gsnSpreadColors      = True               ; use full color map
  res@gsnSpreadColorEnd    = 130
  res@gsnLeftString = ""
  res@gsnRightString = ""
  res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 
  res@gsnLeftStringOrthogonalPosF = 0.03
  res@gsnRightStringOrthogonalPosF = 0.03

  ; contour <<<2
  ;
  res@cnFillOn             = True               ; turn on color for contours
  res@cnLinesOn            = False              ; turn off contour lines
  ;   res@cnLineThicknessF = 0.5
  res@cnLineLabelsOn       = False; turn off contour line labels
  res@cnInfoLabelOn        = False      ; turns off contour info label
;  symMinMaxPlt(cn, 50, False, res)
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMaxLevelValF       = 0.               ; set max contour level
  res@cnMinLevelValF       = -1.6               ; set min contour level
  res@cnLevelSpacingF = 0.2
;  res@cnFillMode = "RasterFill"

  ; label bar <<<2

  res@lbLabelBarOn = False
  res@lbOrientation            = "Vertical"     ; vertical label bar
  res@lbPerimOn                = False             ; no box around it
;  res@lbBoxLinesOn = False

  ;   res@lbBoxLinesOn = False
  ;    res@lbLabelStride            = 4

  ; plot manager <<<2

  ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
  ;   res@pmLabelBarWidthF = 0.5
  ;   res@pmLabelBarHeightF = 0.05
  ;   res@pmLabelBarOrthogonalPosF = 0.2

  ; map  <<<2

  ;   res@mpLandFillColor          = "gray"            ; set land to be gray
  ;   res@mpMinLonF = 0
  ;   res@mpMaxLonF = 360
;  res@mpCenterLonF = 180

  ; tick mark  <<<2

  res@tmLabelAutoStride = True
;  res@tmYROn = False
;  res@tmXTOn = False
  ;   res@tmYLMode = "Manual"
  ;   res@tmYLTickStartF    = 100.
  ;   res@tmYLTickSpacingF  = 100.
  res@tmXBMode = "Explicit"
  res@tmXBValues = (/140, 180, 220, 260/)
  res@tmXBMinorValues =  ispan(140,280,20)
  res@tmXBLabels = (/"140~S~o~N~E", "180~S~o", "140~S~o~N~W", "100~S~o~N~W"/)

;  res@tmYLMode = "Explicit"
;  res@tmYLValues = (/0, 100, 200, 300/)
;  res@tmYLMinorValues =  ispan(0,350,50)
;  res@tmYLLabels = res@tmYLValues

  ; transformation <<<2

  res@trYMaxF = 800.
  res@trYMinF = 0.
  res@trYReverse               = True   ; reverses y-axis
  ; }}}

  res_ini = res
  res_zy = res
  res_spinup = res
  res_fkh0 = res
  res_fkh1 = res
  res_fkh2 = res
  res_ini@tiMainString = "pt/pz obs. (WOA09)"
  res_zy@tiMainString = "result from ZY"
  res_spinup@tiMainString = "spinup field"
  res_fkh0@tiMainString = "constant kappa"
  res_fkh1@tiMainString = "datasets of Zhang(2014)"
  res_fkh2@tiMainString = "vertical profile kappa"

   plot = new(6, graphic)
   plot(0) = gsn_csm_contour(wks, ini, res_ini)
   plot(1) = gsn_csm_contour(wks, zy, res_zy)
   plot(2) = gsn_csm_contour(wks, spinup, res_spinup)
   plot(3) = gsn_csm_contour(wks, fkh0, res_fkh0)
   plot(4) = gsn_csm_contour(wks, fkh1, res_fkh1)
   plot(5) = gsn_csm_contour(wks, fkh2, res_fkh2)

   resP = True
   resP@gsnFrame = False
   resP@gsnPanelLabelBar = True
;      resP@gsnPanelBottom = 0.05
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 10
   resP@gsnPanelRowSpec = True

   resP@pmLabelBarWidthF = 0.4
   resP@pmLabelBarHeightF = 0.06
   resP@pmLabelBarOrthogonalPosF = 0.02

;   resP@lbAutoManage = False
;   resP@lbLabelFontHeightF = 0.013
   resP@lbPerimOn                = False             ; no box around it
;   resP@lbLabelAutoStride = True
;   resP@lbLabelStride            = 5
;   resP@lbTitleString = "Verical mean sea salinity (psu)"
;   resP@lbTitleFontHeightF = 0.013
;   resP@lbBoxLinesOn = False
   resP@lbLabelFontHeightF = 0.01

;   resP@txString = "Sea surface salinity"

   gsn_panel(wks, plot, (/3,3/), resP)

  txres               = True
  txres@txFontHeightF = 0.01
  text = "~S~o~N~C/10m"
  gsn_text_ndc(wks, text, 0.73, 0.25, txres)

end
