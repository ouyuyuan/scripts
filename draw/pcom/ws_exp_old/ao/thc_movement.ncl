
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-28 09:18:37 BJT
; Last Change: 2014-11-14 10:03:20 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

function extract_cross_zero_lon(cn, lonw, lone)
local lon
begin
 newcn = lonFlip(cn)
 cnr = newcn(:,{lonw:lone})
 return cnr
end

procedure draw_lat_sec(img, cnc, cne, inres, arg)
local res, nc, wks
begin
  cmap = "NCL_default"
  fontheight = 0.03

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
  res@cnLineLabelsOn       = True
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

  copy_VarAtts(inres, res)

  rese = res
  rese@cnLineColor = "red"

  plot = new(3, graphic)
  res@tiMainString = "Pacific"
  lonw = 110
  lone = 290
  cnp_ctr = cnc(:,{lonw:lone})
  cnp_ex  = cne(:,{lonw:lone})
  plot(0) = gsn_csm_contour(wks, cnp_ctr, res)
  plot_ov = gsn_csm_contour(wks, cnp_ex, rese)
  overlay(plot(0), plot_ov)

  res@tiMainString = "Atlantic"
  lonw = -50
  lone = 15
  cna_ctr = extract_cross_zero_lon(cnc, lonw, lone)
  cna_ex = extract_cross_zero_lon(cne, lonw, lone)
  res@tmXBTickSpacingF  = 10.
  plot(1) = gsn_csm_contour(wks, cna_ctr, res)
  plot_ov = gsn_csm_contour(wks, cna_ex, rese)
  overlay(plot(1), plot_ov)

  res@tiMainString = "Indian"
  lonw = 40
  lone = 100
  res@tmXBTickSpacingF  = 10.
  cni = cnc(:,{lonw:lone})
  cni_ex = cne(:,{lonw:lone})
  plot(2) = gsn_csm_contour(wks, cni, res)
  plot_ov = gsn_csm_contour(wks, cni_ex, rese)
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
  gsn_text_ndc(wks, text, 0.13, 0.56, txres)

  text = arg@exName
  txres@txFontColor = "red"
  gsn_text_ndc(wks, text, 0.13, 0.53, txres)

  delete(wks)
  system("eps2png_trim " + img)
end

nc = getenv("NCL_ARG_1")
img = getenv("NCL_ARG_2")

arg = True
arg@add_20deg_line = True

res = True
res@trYMaxF = 400.

f = addfile( nc, "r" )

;======================================
cnc = f->ctr64_0N
cne = f->an_ao_0N
arg@exName = "exp_AO"
arg@panel_title = "20~S~o~N~C isotherm line movement"
draw_lat_sec(img, cnc, cne, res, arg)
