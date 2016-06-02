
; Description:
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2016-05-23 16:48:42 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

datDir = "/home/ou/archive/data/pcom/phd/"
img    = "/home/ou/archive/drawing/phdthesis/" + getenv("NCL_ARG_0_base")

; get data ;{{{1

f = addfile(datDir+"calc_bsf.nc", "r")
cn1 = f->pcom
cn2 = f->soda
delete(f)

; plot model  ;{{{1

cmap = "NCL_default"
;  cmap = "GMT_jet"
;  cmap = "WhiteBlueGreenYellowRed"
;cmap = "NCV_blu_red"

fontSize = 0.03
yLabelSize = fontSize*0.5
xLabelSize = fontSize*0.5
plotWid = 0.7
plotHei = 0.4
cbTitle1 = cn1@units
cbTitle2 = cn2@units
cnMinMaxInc = (/-4.5, 4.5, 0.25/)
autoTicks = False
;autoTicks = True

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks, cmap)

res = True ;{{{1
; {{{
res@vpWidthF = plotWid
res@vpHeightF = plotHei
;  res@vpXF = 0.2
;  res@vpYF = 0.9

res@tiXAxisFontHeightF = fontSize*0.8
res@tiYAxisFontHeightF = res@tiXAxisFontHeightF

res@gsnDraw = False
res@gsnFrame = False
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
res@gsnStringFontHeightF = res@tiXAxisFontHeightF
res@gsnCenterStringOrthogonalPosF = -0.05

;res@tmXTOn = False
;res@tmYROn = False
res@tmYRMinorOn = False
res@tmYRLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize
res@tmXBLabelStride = 2

res@cnFillOn             = True
res@cnLinesOn            = False
res@cnLineThicknessF     = 1.0
res@cnLineLabelFontHeightF = yLabelSize*0.7
;res@cnLineLabelBackgroundColor = "transparent"
res@cnLineLabelsOn       = False
res@cnInfoLabelOn        = False
;res@cnMissingValFillColor = "gray60"
;   res@cnFillMode = "RasterFill"
if .not.autoTicks
  res@cnLevelSelectionMode = "ExplicitLevels"
  res@cnLevels =     (/ -60, -30., 0., 30., 60., 90., 120., 150., 180./)
  res@cnFillColors = (/2,20,  90, 130, 140, 160, 180,  200,  235, 250 /)
end if

res@mpCenterLonF = 200
res@mpMaxLatF = 80
res@mpMinLatF = -80

res@lbLabelBarOn   = True
res@lbOrientation = "Vertical"     ; vertical label bar
;res@lbBoxLinesOn = False
;res@lbTitlePosition = "Right"
res@lbTitleOffsetF = -0.04
res@lbTitleFontHeightF = fontSize*0.5
res@lbLabelFontHeightF = fontSize*0.4

res@pmLabelBarOrthogonalPosF = 0.015
res@pmLabelBarParallelPosF = 0.55
res@pmLabelBarWidthF = 0.06
res@pmLabelBarHeightF = 0.35

;}}}

res1 = res ;{{{2
res1@gsnCenterString = "PCOM"
res1@gsnCenterStringFontHeightF = fontSize*0.5
res1@tiXAxisString = ""
res1@lbTitleString = cbTitle1

res2 = res ;{{{2
res2@gsnCenterString = "SODA"
res2@gsnCenterStringFontHeightF = res1@gsnCenterStringFontHeightF
res2@lbTitleString = cbTitle2

plot = new(2, graphic) ;{{{1
plot(0) = gsn_csm_contour_map(wks, cn1, res1)
plot(1) = gsn_csm_contour_map(wks, cn2, res2)

resP = True ;{{{1
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
