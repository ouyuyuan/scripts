
; Description: Wind stress forcing, control run
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-11 19:31:11 BJT
; Last Change: 2015-04-15 19:21:38 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  nc = getenv("NCL_ARG_1")
  img = getenv("NCL_ARG_2")
  fontheight = 0.015

  cmap = "BlGrYeOrReVi200"
;  cmap = "testcmap"
;  cmap = "NCV_blue_red"
  wks = gsn_open_wks("eps", img)
  gsn_define_colormap(wks,cmap)

  f = addfile(nc, "r")
  vx = f->taux
  vy = f->tauy
  sc = f->mag
  delete(f)

 res = True

  res@vpHeightF = 0.45
  res@vpWidthF = 0.73

   res@gsnDraw = False
   res@gsnFrame = False
   res@gsnLeftString = ""
   res@gsnRightString = ""
   res@gsnScalarContour     = True               ; contours desired
   res@gsnSpreadColors      = True               ; use full color map
   res@gsnSpreadColorStart  = 35                 ; start at color 17
;   res@gsnSpreadColorEnd    = 240                ; end at color 200
   res@gsnSpreadColorEnd    = 180                ; end at color 200

   res@cnFillOn             = True               ; turn on color for contours
   res@cnLinesOn            = False              ; turn off contour lines
   res@cnLineLabelsOn       = False              ; turn off contour line labels
   res@cnInfoLabelOn        = False      ; turns off contour info label
;  res@cnMissingValFillColor = "gray60"
;   res@cnLevelSelectionMode = "ManualLevels"
;   res@cnMaxLevelValF       = 0.5              ; set max contour level
;   res@cnMinLevelValF       = 0.0               ; set min contour level
;   res@cnLevelSpacingF = 0.05

;   res@vcLevelSelectionMode = "ManualLevels"
   res@vcRefMagnitudeF       = 0.25                  ; add a reference vector
   res@vcRefLengthF          = 0.05                ; what the ref length is
   res@vcMinDistanceF          = 0.01            ; thin out vectors
   res@vcRefAnnoOrthogonalPosF   = -0.9            ; move ref vector
   res@vcRefAnnoParallelPosF   = 0.3            ; move ref vector
;   res@vcMonoLineArrowColor  = False                ; vec's colored by their mag_p_n
  res@vcRefAnnoPerimOn = False
  res@vcRefAnnoString1 = res@vcRefMagnitudeF + " m/s"
   res@vcRefAnnoArrowLineColor   = "black"         ; change ref vector color
   res@vcRefAnnoArrowUseVecColor = False           ; don't use vec color for ref
   res@vcGlyphStyle          = "CurlyVector"        ; turn on curly vectors
;   res@vcLineArrowThicknessF   = 0.5               ; change vector thickness
  res@vcLineArrowHeadMaxSizeF = 0.015
  res@vcLineArrowHeadMinSizeF = 0.005  
   res@vcVectorDrawOrder       = "PostDraw"        ; draw vectors last
   res@vcLineArrowColor        = "black"           ; change vector color

;   res@lbLabelBarOn = False
;   res@lbOrientation            = "Vertical"     ; vertical label bar
;   res@lbPerimOn                = False             ; no box around it
   ;    res@lbLabelStride            = 4

   ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
   res@pmLabelBarWidthF  = 0.4
   res@pmLabelBarHeightF = 0.05
   res@pmLabelBarOrthogonalPosF = 0.1         ; move label bar further

;   res@mpLandFillColor          = "gray"            ; set land to be gray
;   res@mpMinLonF = 0
;   res@mpMaxLonF = 360
;   res@mpCenterLonF = 180

   ; tick mark  <<<2

   res@tmLabelAutoStride = True
   res@tmYROn = False
   res@tmXTOn = False
   res@tmYLLabelFontHeightF = fontheight
   res@tmXBLabelFontHeightF = fontheight
;   res@tmYLMode = "Manual"
;   res@tmYLTickStartF    = 100.
;   res@tmYLTickSpacingF  = 100.
;   res@tmXBMode = "Manual"
;   res@tmXBTickSpacingF = 5
;   res@tmXBTickStartF    = -25
;   res@tmXBTickEndF      = 25
;   res@tmYLTickEndF      = 300.

   plot = gsn_csm_vector_scalar(wks, vx, vy, sc, res)

   draw(plot)

  txres               = True
  txres@txFontHeightF = fontheight
  text = "Climatory Zonal Wind Stress Forcing in PCOM"
  gsn_text_ndc(wks, text, 0.5, 0.83, txres)
  text = "magnitude (N/m~S~2~N~)"
  gsn_text_ndc(wks, text, 0.57, 0.27, txres)

end
