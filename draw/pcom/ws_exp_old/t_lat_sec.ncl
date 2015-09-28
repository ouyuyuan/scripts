
; Description: latitude section of experiments compare to control run
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-28 09:18:37 BJT
; Last Change: 2014-10-28 21:23:36 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure draw_lat_sec(img, inres, arg)
local res, nc, wks
begin
  nc = getenv("NCL_ARG_1")
  cmap = "NCL_default"
  fontheight = 0.03

  wks = gsn_open_wks ("eps", img)
  gsn_define_colormap(wks, cmap)

  f = addfile( nc, "r" )
  ctr = f->$arg@ctr_sec_name$
  ex  = f->$arg@exp_sec_name$
  diff = ex
  diff = ex - ctr

  res = True

  res@tiYAxisString = "depth (m)"
  res@tiYAxisFontHeightF = fontheight*1.3
  res@tiMainFontHeightF = fontheight * 1.5

  res@vpWidthF = 0.9
  res@vpHeightF = 0.3
;  res@vpXF = 0.1

  res@gsnDraw = False
  res@gsnFrame = False
  res@gsnSpreadColors      = True               ; use full color map
;  res@gsnSpreadColorEnd    = 250
  if (cmap.eq."BlGrYeOrReVi200") then
    res@gsnSpreadColorEnd    = 180
  end if
  res@gsnLeftString = ""
  res@gsnRightString = ""
  res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 
  res@gsnLeftStringOrthogonalPosF = 0.03
  res@gsnRightStringOrthogonalPosF = 0.03

  res@cnFillOn             = True               ; turn on color for contours
  res@cnLinesOn            = False              ; turn off contour lines
  ;   res@cnLineThicknessF = 0.5
  res@cnLineLabelsOn       = False; turn off contour line labels
  res@cnInfoLabelOn        = False      ; turns off contour info label
  res@cnMissingValFillColor = "black"
;  symMinMaxPlt(cn, 50, False, res)
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMaxLevelValF       = arg@cnlevels_ctr(0)
  res@cnMinLevelValF       = arg@cnlevels_ctr(1)
  res@cnLevelSpacingF      = arg@cnlevels_ctr(2)
;  res@cnFillMode = "RasterFill"

;  res@lbLabelBarOn = False
;  res@lbOrientation            = "Vertical"     ; vertical label bar
  res@lbPerimOn                = False             ; no box around it
;  res@lbBoxLinesOn = False
  ;   res@lbBoxLinesOn = False
  ;    res@lbLabelStride            = 4
  res@lbLabelFontHeightF = fontheight

  ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
  res@pmLabelBarWidthF = 0.8
  res@pmLabelBarHeightF = 0.15
  res@pmLabelBarOrthogonalPosF = 0.1

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

  copy_VarAtts(inres, res)

  plot = new(3, graphic)

   res@tiMainString = "control run"
   plot(0) = gsn_csm_contour(wks, ctr, res)
  res@tiMainString = arg@exp_name
   plot(1) = gsn_csm_contour(wks, ex, res)
  res@tiMainString = "("+arg@exp_name+") - (control run)"
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMaxLevelValF       = arg@cnlevels_ex(0)
  res@cnMinLevelValF       = arg@cnlevels_ex(1)
  res@cnLevelSpacingF      = arg@cnlevels_ex(2)
   plot(2) = gsn_csm_contour(wks, diff, res)

  if (isatt(arg, "add_20deg_line")) then
     sres = True
     sres@tiMainString = ""
     sres@cnFillOn             = False
     sres@cnLinesOn            = True
     sres@cnLevelSelectionMode = "ExplicitLevels"
     sres@cnLevels = (/20/)
     sres@cnLineThicknessF = 2.0
     sres@cnLineLabelsOn       = True
     sres@cnLineColor = "green"

     copy_VarAtts(sres, res)
     plot_ov = gsn_csm_contour(wks, ctr, res)
     overlay(plot(0), plot_ov)
     copy_VarAtts(sres, res)
     plot_ov = gsn_csm_contour(wks, ex, res)
     overlay(plot(1), plot_ov)
  end if

   resP = True
   resP@txString = arg@panel_title

   resP@gsnFrame = False
;   resP@gsnPanelLabelBar = True
;      resP@gsnPanelBottom = 0.05
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 5
   resP@gsnPanelRowSpec = True

   resP@pmLabelBarWidthF = 0.8
   resP@pmLabelBarHeightF = 0.07
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

   gsn_panel(wks, plot, (/1,2/), resP)

  txres               = True
  txres@txFontHeightF = 0.012
  text = "(~S~o~N~C)"
;  gsn_text_ndc(wks, text, 0.88, 0.25, txres)

  delete(wks)
  system("eps2png_trim " + img)
end

img = getenv("NCL_ARG_2")
arg = True
res = True

; anomaly at 70S~30S, plot 50S section
;======================================
arg@ctr_sec_name = "control_50S"
arg@exp_sec_name = "an_70S30S_50S"
arg@exp_name = "an_70S-30S"
arg@cnlevels_ctr = (/10.,0.,1./)
arg@cnlevels_ex  = (/1.2,-1.2,0.2/)
arg@panel_title = "Potential Temperature at 50~S~o~N~S (~S~o~N~C)"
;draw_lat_sec(img+"___50S", res, arg)

; anomaly at 40S~10S, plot 25S section
;======================================
arg@ctr_sec_name = "control_25S"
arg@exp_sec_name = "an_40S10S_25S"
arg@exp_name = "an_40S-10S"
arg@cnlevels_ctr = (/24.,4.,2./)
arg@cnlevels_ex  = (/0.5,-0.5,0.1/)
arg@panel_title = "Potential Temperature at 25~S~o~N~S (~S~o~N~C)"
arg@add_20deg_line = True
res@trYMaxF = 1000.
;draw_lat_sec(img+"___25S", res, arg)

; anomaly at 10S~20N, plot 5N section
;======================================
arg@ctr_sec_name = "control_5N"
arg@exp_sec_name = "an_10S20N_5N"
arg@exp_name = "an_10S-20N"
arg@cnlevels_ctr = (/28.,6.,2./)
arg@cnlevels_ex  = (/2.2,-2.2,0.2/)
arg@panel_title = "Potential Temperature at 5~S~o~N~N (~S~o~N~C)"
arg@add_20deg_line = True
res@trYMaxF = 600.
;draw_lat_sec(img+"___5N", res, arg)

; anomaly at EQ~30N, plot 15N section
;======================================
arg@ctr_sec_name = "control_15N"
arg@exp_sec_name = "an_EQ30N_15N"
arg@exp_name = "an_EQ-30N"
arg@cnlevels_ctr = (/28.,6.,2./)
arg@cnlevels_ex  = (/0.6,-0.6,0.1/)
arg@panel_title = "Potential Temperature at 15~S~o~N~N (~S~o~N~C)"
arg@add_20deg_line = True
res@trYMaxF = 600.
;draw_lat_sec(img+"___15N", res, arg)

; anomaly at 30N~60N, plot 45N section
;======================================
arg@ctr_sec_name = "control_45N"
arg@exp_sec_name = "an_30N60N_45N"
arg@exp_name = "an_30N-60N"
arg@cnlevels_ctr = (/18.,2.,1./)
arg@cnlevels_ex  = (/1.0,-1.0,0.2/)
arg@panel_title = "Potential Temperature at 45~S~o~N~N (~S~o~N~C)"
delete(arg@add_20deg_line)
res@trYMaxF = 1500.
draw_lat_sec(img+"___45N", res, arg)

