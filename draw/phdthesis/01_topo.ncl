
; Description: PCOM 2.0 topography
;       Usage: nclrun xxx.ncl
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2016-04-06 20:15:43 BJT
; Last Change: 2016-04-07 18:42:00 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

datDir = "/home/ou/archive/data/pcom/"
img    = "/home/ou/archive/drawing/phdthesis/" + getenv("NCL_ARG_0_base")

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;{{{

fname = datDir + "input/pcom_ini_mod.nc"
f  = addfile( fname, "r" )
cn1 = f->depth
delete(f)

fname = datDir + "phd/bath_eta.nc"
f  = addfile( fname, "r" )
cn2 = f->var(0,:,:)
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
yLabelSize = fontSize*0.5
xLabelSize = fontSize*0.5
plotWid = 0.7
plotHei = 0.4
cbTitle1 = cn1@units
cbTitle2 = ""
cnMinMaxInc1 = (/0, 5000, 100/)
cnMinMaxInc2 = (/0, 1, 0.02/)
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

res@tiXAxisFontHeightF = fontSize*0.8
res@tiYAxisFontHeightF = res@tiXAxisFontHeightF
res@tiXAxisString = ""
res@tiYAxisString = ""

res@gsnDraw = False
res@gsnFrame = False
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
res@gsnStringFontHeightF = res@tiXAxisFontHeightF
res@gsnCenterStringOrthogonalPosF = -0.05
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
;res@cnMissingValFillColor = "gray60"
;   res@cnFillMode = "RasterFill"

res@mpCenterLonF = 200
res@mpMaxLatF = 80
res@mpMinLatF = -80

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

res1 = res
res1@gsnCenterString = "z coordinate"
res1@lbTitleString = cbTitle1
res1@cnLevelSelectionMode = "ManualLevels"
res1@cnMinLevelValF       = cnMinMaxInc1(0)
res1@cnMaxLevelValF       = cnMinMaxInc1(1)
res1@cnLevelSpacingF      = cnMinMaxInc1(2)

res2 = res
res2@gsnCenterString = "eta coordinate"
res2@lbTitleString = cbTitle2
res2@cnMinLevelValF       = cnMinMaxInc2(0)
res2@cnMaxLevelValF       = cnMinMaxInc2(1)
res2@cnLevelSpacingF      = cnMinMaxInc2(2)

plot = new(2, graphic)
plot(0) = gsn_csm_contour_map(wks, cn1, res1)

cn1 = where( ismissing(cn1), cn1, cn2 ) ; get metadata of cn1
plot(1) = gsn_csm_contour_map(wks, cn1, res2)

resP = True
;resP@gsnDraw = False
resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
;resP@gsnPanelLabelBar = True
resP@gsnPanelYWhiteSpacePercent = 5
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStrings = (/"a)","b)"/)
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.8
resP@gsnPanelFigureStringsPerimOn = False
resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.65

gsn_panel(wks, plot, (/1,1/), resP)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
