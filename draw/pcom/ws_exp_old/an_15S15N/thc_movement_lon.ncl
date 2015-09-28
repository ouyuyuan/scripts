
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-28 09:18:37 BJT
; Last Change: 2014-11-09 21:00:44 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure draw_sec(img, inres, arg)
local res, nc, wks
begin
  cmap = "NCL_default"
  fontheight = 0.03

  nc = getenv("NCL_ARG_1")
  f = addfile(nc, "r")
  cnc_p = f->$arg@ctrNames(0)$
  cnc_a = f->$arg@ctrNames(1)$
  cnc_i = f->$arg@ctrNames(2)$
  cnc_p = smth9( cnc_p, 0.5, 0.25, False )
  cnc_a = smth9( cnc_a, 0.5, 0.25, False )
  cnc_i = smth9( cnc_i, 0.5, 0.25, False )

  cne_p = f->$arg@exNames(0)$
  cne_a = f->$arg@exNames(1)$
  cne_i = f->$arg@exNames(2)$
  cne_p = smth9( cne_p, 0.5, 0.25, False )
  cne_a = smth9( cne_a, 0.5, 0.25, False )
  cne_i = smth9( cne_i, 0.5, 0.25, False )

  wks = gsn_open_wks ("eps", img)
  gsn_define_colormap(wks, cmap)

  res = True

  res@tiYAxisString = "depth (m)"
  res@tiXAxisString = "longitude"
  res@tiYAxisFontHeightF = fontheight*1.3
  res@tiMainFontHeightF = fontheight * 1.5

;  res@vpWidthF = 0.9
;  res@vpHeightF = 0.5
;  res@vpXF = 0.1

  res@gsnDraw = False
  res@gsnFrame = False
;  res@gsnScale = True
;  res@gsnSpreadColors      = True               ; use full color map
;  res@gsnSpreadColorEnd    = 250
  if (cmap.eq."BlGrYeOrReVi200") then
    res@gsnSpreadColorEnd    = 180
  end if
  res@gsnLeftString = ""
  res@gsnRightString = ""
  res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 
  res@gsnLeftStringOrthogonalPosF = 0.03
  res@gsnRightStringOrthogonalPosF = 0.03

  res@cnFillOn             = True
  res@cnLinesOn            = True
  res@cnLineThicknessF = 0.5
  res@cnLineLabelsOn       = False
  res@cnInfoLabelOn        = False      ; turns off contour info label
  res@cnLevelSelectionMode = "ExplicitLevels"
  res@cnLevels = (/20/)
  res@cnLineThicknessF = 2.0
  res@cnLineColor = "black"
  res@cnFillColors = (/"transparent","transparent"/)
  res@cnMissingValFillColor = "gray60"

  res@lbLabelBarOn = False
;  res@lbOrientation            = "Vertical"     ; vertical label bar
  res@lbPerimOn                = False             ; no box around it
;  res@lbBoxLinesOn = False
  ;   res@lbBoxLinesOn = False
  ;    res@lbLabelStride            = 4
  res@lbLabelFontHeightF = fontheight
  res@lbTitleString = "(~S~o~N~C)"
  res@lbTitlePosition = "top"
  res@lbTitleFontHeightF = fontheight*1.3

  ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
;  res@pmLabelBarWidthF = 0.8
;  res@pmLabelBarHeightF = 0.15
;  res@pmLabelBarOrthogonalPosF = 0.1

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
  res@tmXBLabelFontHeightF = fontheight

;  res@tmYLMode = "Explicit"
;  res@tmYLValues = (/0, 100, 200, 300/)
;  res@tmYLMinorValues =  ispan(0,350,50)
;  res@tmYLLabels = res@tmYLValues
  res@tmYLLabelFontHeightF = fontheight

  res@trYMaxF = 3000.
;  res@trYMinF = 0.
  res@trYReverse               = True   ; reverses y-axis
  res@trXMinF = -60.
  res@trXMaxF = 60.

  copy_VarAtts(inres, res)

  rese = res
  rese@cnLineColor = "red"

  plot = new(3, graphic)
  res@tiMainString = "Pacific"
  plot(0) = gsn_csm_contour(wks, cnc_p, res)
  plot_ov = gsn_csm_contour(wks, cne_p, rese)
  overlay(plot(0), plot_ov)

  res@tiMainString = "Atlantic"
  plot(1) = gsn_csm_contour(wks, cnc_a, res)
  plot_ov = gsn_csm_contour(wks, cne_a, rese)
  overlay(plot(1), plot_ov)

  res@tiMainString = "Indian"
  plot(2) = gsn_csm_contour(wks, cnc_i, res)
  plot_ov = gsn_csm_contour(wks, cne_i, rese)
  overlay(plot(2), plot_ov)

   resP = True
   resP@txString = arg@panel_title

   resP@gsnFrame = False
   resP@gsnPanelLabelBar = False
;      resP@gsnPanelBottom = 0.05
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 5
   resP@gsnPanelRowSpec = True

   resP@pmLabelBarWidthF = 0.8
   resP@pmLabelBarHeightF = 0.07
   resP@pmLabelBarOrthogonalPosF = -0.01

;   resP@lbAutoManage = False
   resP@lbLabelFontHeightF = 0.013
   resP@lbPerimOn                = False             ; no box around it
;   resP@lbLabelAutoStride = True
;   resP@lbLabelStride            = 5
;   resP@lbTitleString = "Verical mean sea salinity (psu)"
   resP@lbTitleFontHeightF = 0.013
;   resP@lbBoxLinesOn = False
  resP@lbTitleString = "(~S~o~N~C)"
  resP@lbTitlePosition = "bottom"

   gsn_panel(wks, plot, (/3/), resP)
;  draw(plot)
;  frame(wks)

  txres               = True
  txres@txFontHeightF = fontheight*0.5
  txres@txJust = "BottomLeft"
  text = "control run"
  gsn_text_ndc(wks, text, 0.13, 0.41, txres)

  text = "ex_15S-15N"
  txres@txFontColor = "red"
  gsn_text_ndc(wks, text, 0.13, 0.38, txres)

  delete(wks)
  system("eps2png_trim " + img)
end

img = getenv("NCL_ARG_2")

res = True
res@trYMaxF = 400.

arg = True
arg@exNames = (/"ex_15S15N_p","ex_15S15N_a","ex_15S15N_i"/)
arg@ctrNames = (/"control_p","control_a","control_i"/)
arg@panel_title = "20~S~o~N~C isotherm line movement in meridional"
draw_sec(img, res, arg)
