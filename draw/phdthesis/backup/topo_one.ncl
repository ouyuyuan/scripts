
; Description: PCOM 2.0 topography
;       Usage: nclrun xxx.ncl
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2016-04-06 20:15:43 BJT
; Last Change: 2016-04-07 07:03:22 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

datDir = "/home/ou/archive/data/pcom/input/"
img    = "/home/ou/archive/drawing/phdthesis/" + getenv("NCL_ARG_0_base")

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;{{{

fname = datDir + "pcom_ini_mod.nc"
f  = addfile( fname, "r" )
cn = f->depth
delete(f)

;}}}

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; plot model 
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

;  cmap = "NCL_default"
;  cmap = "GMT_jet"
;  cmap = "WhiteBlueGreenYellowRed"
;cmap = "NCV_blu_red"
cmap = "BlGrYeOrReVi200"

fontSize = 0.03
yLabelSize = fontSize*0.6
xLabelSize = fontSize*0.6
plotWid = 0.7
plotHei = 0.4
cbTitle = cn@units
cnMinMaxInc = (/0, 5000, 100/)
autoTicks = False
;autoTicks = True

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks,cmap)
if (cmap.eq."BlGrYeOrReVi200") then
  gsn_reverse_colormap(wks)
end if

res = True
; {{{
res@vpWidthF = plotWid
res@vpHeightF = plotHei
;  res@vpXF = 0.2
;  res@vpYF = 0.9

res@tiXAxisString = ""
res@tiXAxisFontHeightF = fontSize*0.8
res@tiYAxisFontHeightF = res@tiXAxisFontHeightF

res@gsnDraw = False
res@gsnFrame = False
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
res@gsnStringFontHeightF = res@tiXAxisFontHeightF
res@gsnCenterStringOrthogonalPosF = -0.05
res@gsnCenterString = ""
res@gsnCenterStringFontHeightF = fontSize*0.6
if (cmap.eq."BlGrYeOrReVi200") then
  res@gsnSpreadColorStart  = 70
end if

;res@tmXTOn = False
;res@tmYROn = False
res@tmYRMinorOn = False
res@tmYRLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize
res@tmXBLabelStride = 2

res@cnFillOn             = True               ; turn on color for contours
res@cnLinesOn            = False              ; turn off contour lines
res@cnLineThicknessF     = 1.0
res@cnLineLabelFontHeightF = yLabelSize*0.7
;res@cnLineLabelBackgroundColor = "transparent"
res@cnLineLabelsOn       = False              ; turn off contour line labels
res@cnInfoLabelOn        = False      ; turns off contour info label
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = cnMinMaxInc(0)
res@cnMaxLevelValF       = cnMinMaxInc(1)
res@cnLevelSpacingF      = cnMinMaxInc(2)
;res@cnMissingValFillColor = "gray60"
;   res@cnFillMode = "RasterFill"

res@mpCenterLonF = 200
res@mpMaxLatF = 80
res@mpMinLatF = -80

res@lbTitleString = cbTitle
res@lbLabelBarOn   = True
res@lbOrientation = "Vertical"     ; vertical label bar
res@lbBoxLinesOn = False
;res@lbTitlePosition = "Right"
res@lbTitleOffsetF = -0.04
res@lbTitleFontHeightF = fontSize*0.5
res@lbLabelFontHeightF = fontSize*0.4

res@pmLabelBarOrthogonalPosF = 0.015
res@pmLabelBarParallelPosF = 0.55
res@pmLabelBarWidthF = 0.06
res@pmLabelBarHeightF = 0.35

;}}}

plot = gsn_csm_contour_map(wks, cn, res)

draw(plot)
frame(wks)
delete(wks)
system("eps2png_trim "+img)
