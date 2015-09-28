
; Description: integrated OHC at varying depth
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2015-06-29 14:33:30 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

;img, dirs, and data files------------------------------{{{1
load "$HOME/archive/scripts/draw/ishii/head.ncl"

nc = "ohc.nc"
grid_info_file = datDir+"grid_info.nc"

;get plotting data--------------------------------------{{{1
f = addfile(grid_info_file, "r")
dz = f->dz
delete(f)

function get_ohc(f, varName)
local time, ohc
begin
  ohc = f->$varName$
  time = ohc&$ohc!0$
  nt = dimsizes(time)

;  ohc = dtrend_n(ohc,False,0)
  ohc = dim_rmvmean_n(ohc,0)
  ohc = ohc*1e-20
  ohc@units = "10~S~20~N~J"

  dzc = conform(ohc, dz, 1)
  ohc = ohc/dzc ; unit thickness

  return ohc
end

f = addfile( datDir + nc, "r" )
ohc_glo = get_ohc(f, "glo")
ohc_Atl = get_ohc(f, "Atl")
ohc_Sou = get_ohc(f, "Sou")
ohc_Pac = get_ohc(f, "Pac")
ohc_Ind = get_ohc(f, "Ind")
delete(f)

time = ohc_glo&$ohc_glo!1$

;plotting parameters------------------------------------{{{1
;  cmap = "NCL_default"
;  cmap = "GMT_jet"
;  cmap = "WhiteBlueGreenYellowRed"
;cmap = "BlGrYeOrReVi200"
cmap = "NCV_blu_red"
;  cmap = "MPL_jet"

fontSize = 0.02
yLabelSize = fontSize
xLabelSize = fontSize
plotWid = 0.8
plotHei = 0.5
cbTitle = ohc_glo@units
yTitle = "depth (m)"
xTitle = "year"
ohcMinMaxInc = (/-1.6, 1.6, 0.8/)
;autoTicks = False
autoTicks = True

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks,cmap)

;resources attributes setting---------------------------{{{1
res = True
res@vpWidthF = plotWid
res@vpHeightF = plotHei
;  res@vpXF = 0.1
;  res@vpYF = 0.9

res@tiXAxisString = xTitle
res@tiYAxisString = yTitle
res@tiXAxisFontHeightF = xLabelSize

res@gsnDraw = False
res@gsnFrame = False
res@gsnStringFontHeightF = fontSize
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
res@gsnCenterStringOrthogonalPosF = 0.01
;res@gsnYAxisIrregular2Linear = True

;res@tmXTOn = False
res@tmYROn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize
res@tmLabelAutoStride = True

res@cnFillOn             = True
res@cnLinesOn            = False
;   res@cnLineThicknessF = 0.5
res@cnLineLabelsOn       = False
res@cnInfoLabelOn        = False
if .not.autoTicks
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       = ohcMinMaxInc(0)
  res@cnMaxLevelValF       = ohcMinMaxInc(1)
  res@cnLevelSpacingF      = ohcMinMaxInc(2)
end if
res@cnMissingValFillColor = "gray60"
;   res@cnFillMode = "RasterFill"

;res@lbLabelBarOn = False
res@lbOrientation = "vertical"
res@lbTitleString = cbTitle
;res@lbTitlePosition = "Right"

res@trYReverse               = True
;res@trYMaxF = 400
;res@trXMinF = 110
;res@trXMaxF = 345

;draw plots calling gsn functions-----------------------{{{1
plot = new(2, graphic)

;res@gsnCenterString = "Global Ocean"
;res@gsnCenterString = "Pacific Ocean"
;res@gsnCenterString = "Atlantic Ocean"
;res@gsnCenterString = "Indian Ocean"
res@gsnCenterString = "Souther Ocean"
plot(1) = gsn_csm_contour(wks, ohc_Sou(z|:,time|:), res)

;put plots in a panel-----------------------------------{{{1
resP = True
resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 5
resP@gsnPanelRowSpec = True
gsn_panel(wks, plot, (/2/), resP)

;finalize {{{1
frame(wks)
delete(wks)
system("eps2png_trim "+img)
