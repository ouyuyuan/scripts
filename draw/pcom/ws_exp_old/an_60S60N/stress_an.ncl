
; Description: Wind stress anormaly
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-27 10:33:06 BJT
; Last Change: 2014-11-12 20:13:01 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure draw_an(img, inres, arg)
begin

  nc = getenv("NCL_ARG_1")
  fontheight = 0.015
;  cmap = "BlGrYeOrReVi200"
  cmap = "ncl_default"
;  cmap = "testcmap"
;  cmap = "NCV_blue_red"
  wks = gsn_open_wks("eps", img)
  gsn_define_colormap(wks,cmap)

  f = addfile(nc, "r")
  control = f->control
  an = f->$arg@exVarName$
  delete(f)

   res = True

  res@vpHeightF = 0.45
  res@vpWidthF = 0.73

   res@gsnDraw = False
   res@gsnFrame = False
   res@gsnSpreadColors      = True               ; use full color map
;   res@gsnSpreadColorStart  = 30                 ; start at color 17
;   res@gsnSpreadColorEnd    = 180
   res@gsnLeftString = ""
   res@gsnRightString = ""

   res@cnFillOn             = True               ; turn on color for contours
   res@cnLinesOn            = False              ; turn off contour lines
;   res@cnLineThicknessF = 0
;   res@cnLineColor = "transparent"
   res@cnLineLabelsOn       = False              ; turn off contour line labels
   res@cnInfoLabelOn        = False      ; turns off contour info label
;   res@cnLevelSelectionMode = "ManualLevels"
;   res@cnMaxLevelValF       =  0.1              ; set max contour level
;   res@cnMinLevelValF       = 0.
;   res@cnLevelSpacingF = 0.05
  res@cnMissingValFillColor = "gray60"
;   res@cnFillMode = "RasterFill"

;   res@lbLabelBarOn = False
  res@lbTitleString = "dyne/cm~S~2"
  res@lbTitlePosition = "bottom"
  res@lbTitleFontHeightF = fontheight*1.3

   res@tmLabelAutoStride = False
   res@tmYROn = False
   res@tmXTOn = False
   res@tmYLLabelFontHeightF = fontheight
   res@tmXBLabelFontHeightF = fontheight
  res@tmYLMode = "Explicit"
  res@tmYLValues = (/-50, 0, 50/)
  res@tmYLLabels = (/"50~S~o~N~S","EQ","50~S~o~N~S"/)
  res@tmXBMode = "Explicit"
  res@tmXBValues = (/0,100,200,300/)
  res@tmXBLabels = (/"0~S~o~N~E", "100~S~o~N~E", "160~S~o~N~W", "60~S~o~N~W"/)

   res_control = res
   res_an = res

   res_control@tiMainString = "Annual mean zonal wind stress in control run"
   res_control@cnLevelSelectionMode = "ManualLevels"
   res_control@cnMaxLevelValF       =  2              ; set max contour level
   res_control@cnMinLevelValF       = -2
   res_control@cnLevelSpacingF = 0.1
   res_control@lbBoxLinesOn = False

   res_an@tiMainString = "("+arg@exTitle+") - (control run)"
;   res_an@gsnSpreadColorEnd = 128
   res_an@cnLevelSelectionMode = "ManualLevels"
   res_an@cnMaxLevelValF       =  arg@cnLevels_ex(0)
   res_an@cnMinLevelValF       =  arg@cnLevels_ex(1)
   res_an@cnLevelSpacingF = arg@cnLevels_ex(2)

   plot = new(2, graphic)
   plot(0) = gsn_csm_contour(wks, control, res_control)
   plot(1) = gsn_csm_contour(wks, an, res_an)

   resP = True
   resP@gsnFrame = False
;   resP@gsnPanelLabelBar = True
;      resP@gsnPanelBottom = 0.05
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 5
   resP@gsnPanelRowSpec = True

   resP@pmLabelBarWidthF = 0.5
   resP@pmLabelBarHeightF = 0.06
   resP@pmLabelBarOrthogonalPosF = -0.01

;   resP@lbAutoManage = False
   resP@lbLabelFontHeightF = 0.013
   resP@lbPerimOn                = False             ; no box around it
;   resP@lbLabelAutoStride = True
   resP@lbLabelStride            = 5
;   resP@lbTitleString = "Verical mean sea salinity (psu)"
   resP@lbTitleFontHeightF = 0.013
;   resP@lbBoxLinesOn = False
;   resP@lbLabelFontHeightF = 0.007

;   resP@txString = "Sea surface salinity"

   gsn_panel(wks, plot, (/2/), resP)

end

img = getenv("NCL_ARG_2")
res = True
arg = True

; anomaly at 60S~60N
;====================
arg@exVarName = "an_60S60N"
arg@exTitle = "exp_60S-60N"
arg@cnLevels_ex = (/0.3, -0.3, 0.05/)
draw_an(img, res, arg)
