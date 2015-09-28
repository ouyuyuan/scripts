
; Description: upper ocean temperature on the equator in the Pacific, 
;              expriment result
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-27 13:28:56 BJT
; Last Change: 2014-10-27 13:38:31 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  nc = getenv("NCL_ARG_1")
  img = getenv("NCL_ARG_2")

;  cmap = "BlGrYeOrReVi200"
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
  control = f->control(z|:,lon|130:290) ; Pacific
  sh = f->exp_sh(z|:,lon|130:290) ; Pacific
  sm = f->exp_sm(z|:,lon|130:290) ; Pacific
  eq = f->exp_eq(z|:,lon|130:290) ; Pacific
  nm = f->exp_nm(z|:,lon|130:290) ; Pacific
  nh = f->exp_nh(z|:,lon|130:290) ; Pacific

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
  res@gsnSpreadColorEnd    = 250
  if (cmap.eq."BlGrYeOrReVi200") then
    res@gsnSpreadColorEnd    = 180
  end if
  res@gsnLeftString = ""
  res@gsnRightString = ""
  res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 
  res@gsnLeftStringOrthogonalPosF = 0.03
  res@gsnRightStringOrthogonalPosF = 0.03

  ; contour <<<2
  ;
  res@cnFillOn             = True               ; turn on color for contours
;  res@cnLinesOn            = False              ; turn off contour lines
  ;   res@cnLineThicknessF = 0.5
  res@cnLineLabelsOn       = True ; turn off contour line labels
  res@cnInfoLabelOn        = False      ; turns off contour info label
;  symMinMaxPlt(cn, 50, False, res)
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMaxLevelValF       = 28.               ; set max contour level
  res@cnMinLevelValF       = 11.               ; set min contour level
  res@cnLevelSpacingF = 1
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

  res@tmYLMode = "Explicit"
  res@tmYLValues = (/0, 100, 200, 300/)
  res@tmYLMinorValues =  ispan(0,350,50)
  res@tmYLLabels = res@tmYLValues

  ; transformation <<<2

  res@trYMaxF = 350.
  res@trYMinF = 0.
  res@trYReverse               = True   ; reverses y-axis
  ; }}}

  res_control = res
  res_sh = res
  res_sm = res
  res_eq = res
  res_nm = res
  res_nh = res
  res_control@tiMainString = "Control Run"
  res_sh@tiMainString = "exp_sh"
  res_sm@tiMainString = "exp_sm"
  res_eq@tiMainString = "exp_eq"
  res_nm@tiMainString = "exp_nm"
  res_nh@tiMainString = "exp_nh"

   plot = new(6, graphic)
   plot(0) = gsn_csm_contour(wks, control, res_control)
   plot(1) = gsn_csm_contour(wks, sh, res_sh)
   plot(2) = gsn_csm_contour(wks, sm, res_sm)
   plot(3) = gsn_csm_contour(wks, eq, res_eq)
   plot(4) = gsn_csm_contour(wks, nm, res_nm)
   plot(5) = gsn_csm_contour(wks, nh, res_nh)

   resP = True
   resP@gsnFrame = False
   resP@gsnPanelLabelBar = True
;      resP@gsnPanelBottom = 0.05
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 8
   resP@gsnPanelRowSpec = True

   resP@pmLabelBarWidthF = 0.7
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
  txres@txFontHeightF = 0.012
  text = "(~S~o~N~C)"
  gsn_text_ndc(wks, text, 0.88, 0.25, txres)

end
