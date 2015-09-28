
; Description: latitude section of experiments compare to control run
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-28 09:18:37 BJT
; Last Change: 2014-10-28 10:49:06 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  nc = getenv("NCL_ARG_1")
  img = getenv("NCL_ARG_2")

;  cmap = "BlGrYeOrReVi200"
  cmap = "NCL_default"
;  cmap = "BlRe"
;  cmap = "hotres"

  wks = gsn_open_wks ("eps", img)
  gsn_define_colormap(wks, cmap)

  f = addfile( nc, "r" )
  ctr_sh = f->control_50S
  ctr_sm = f->control_25S
  ctr_eq = f->control_5N
  ctr_nm = f->control_15N
  ctr_nh = f->control_45N

  sh = f->an_70S30S_50S
  sm = f->an_40S10S_25S
  eq = f->an_10S20N_5N
  nm = f->an_EQ30N_15N
  nh = f->an_30N60N_45N

  sh_d = sh
  sh_d = sh  - ctr_sh
  sm_d = sm - ctr_sm
  eq_d = eq - ctr_eq
  nm_d = nm - ctr_nm
  nh_d = nh - ctr_nh

  res = True
  ; resource{{

  res@vpWidthF = 0.9
  res@vpHeightF = 0.1
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
  res@cnLinesOn            = False              ; turn off contour lines
  ;   res@cnLineThicknessF = 0.5
  res@cnLineLabelsOn       = False; turn off contour line labels
  res@cnInfoLabelOn        = False      ; turns off contour info label
;  symMinMaxPlt(cn, 50, False, res)
;  res@cnLevelSelectionMode = "ManualLevels"
;  res@cnMaxLevelValF       = 1.5               ; set max contour level
;  res@cnMinLevelValF       = -1.5               ; set min contour level
;  res@cnLevelSpacingF = 0.25
;  res@cnFillMode = "RasterFill"

  ; label bar <<<2

;  res@lbLabelBarOn = False
;  res@lbOrientation            = "Vertical"     ; vertical label bar
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
;  res@tmXBMode = "Explicit"
;  res@tmXBValues = (/140, 180, 220, 260/)
;  res@tmXBMinorValues =  ispan(140,280,20)
;  res@tmXBLabels = (/"140~S~o~N~E", "180~S~o", "140~S~o~N~W", "100~S~o~N~W"/)

;  res@tmYLMode = "Explicit"
;  res@tmYLValues = (/0, 100, 200, 300/)
;  res@tmYLMinorValues =  ispan(0,350,50)
;  res@tmYLLabels = res@tmYLValues

  ; transformation <<<2

  res@trYMaxF = 800.
  res@trYMinF = 0.
  res@trYReverse               = True   ; reverses y-axis
  ; }}}

   plot = new(3, graphic)

   res@tiMainString = "Control Run"
   plot(0) = gsn_csm_contour(wks, ctr_sh, res)

  res@tiMainString = "an_70S-30S"
   plot(1) = gsn_csm_contour(wks, sh, res)

  res@tiMainString = "(an_70S-30S) - (control run)"
   plot(2) = gsn_csm_contour(wks, sh_d, res)

;  res@cnLevelSelectionMode = "ManualLevels"
;  res@cnMaxLevelValF       = 28.               ; set max contour level
;  res@cnMinLevelValF       = 2.               ; set min contour level
;  res@cnLevelSpacingF = 2

  res@tiMainString = "exp_sm - control run"
  res@tiMainString = "exp_eq - control run"
  res@tiMainString = "exp_nm - control run"
  res@tiMainString = "exp_nh - control run"

;   plot(3) = gsn_csm_contour(wks, ctr_sm, res)
;   plot(4) = gsn_csm_contour(wks, sm, res)
;   plot(5) = gsn_csm_contour(wks, sm_d, res)

;   plot(6) = gsn_csm_contour(wks, ctr_eq, res)
;   plot(7) = gsn_csm_contour(wks, eq, res)
;   plot(8) = gsn_csm_contour(wks, eq_d, res)

;   plot(9) = gsn_csm_contour(wks, ctr_nm, res)
;   plot(10) = gsn_csm_contour(wks, nm, res)
;   plot(11) = gsn_csm_contour(wks, nm_d, res)

;   plot(12) = gsn_csm_contour(wks, ctr_nh, res)
;   plot(13) = gsn_csm_contour(wks, nh, res)
;   plot(14) = gsn_csm_contour(wks, nh_d, res)

   resP = True
   resP@gsnFrame = False
;   resP@gsnPanelLabelBar = True
;      resP@gsnPanelBottom = 0.05
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 5
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

   resP@txString = "Potential Temperature at 50S"

   gsn_panel(wks, plot, (/1,1,1/), resP)

  txres               = True
  txres@txFontHeightF = 0.012
  text = "(~S~o~N~C)"
;  gsn_text_ndc(wks, text, 0.88, 0.25, txres)

end
