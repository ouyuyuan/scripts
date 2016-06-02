
; Description: 2 subplots, each is a depth-year contour plot
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2016-04-14 09:09:06 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

datDir = "/home/ou/archive/data/pcom/exp_spinup/post/"
img    = "/home/ou/archive/drawing/phdthesis/" + getenv("NCL_ARG_0_base")

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;{{{
fname = datDir + "calc_10_moc.nc"
f = addfile(fname, "r")
cn1 = f->moc_Glo
cn2 = f->moc_Atl
delete(f)

fname = "/home/ou/archive/data/soda/pcom_grid/post/moc.nc"
f = addfile(fname, "r")
cn1_soda = f->moc_Glo
cn2_soda = f->moc_Atl
delete(f)
;}}}

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; plot model 
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

cmap = "ncl_default"
;  cmap = "GMT_jet"
;  cmap = "WhiteBlueGreenYellowRed"
;cmap = "NCV_blu_red"

fontSize = 0.03
yLabelSize = fontSize
xLabelSize = yLabelSize
plotWid = 0.9
plotHei = 0.4
yTitle = "depth (m)"
xTitle = "longitude"
cbTitle = cn1@units
cnMinMaxInc = (/-24, 21, 3/)
autoTicks = False
;autoTicks = True

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks,cmap)

res = True
; {{{
res@vpWidthF = plotWid
res@vpHeightF = plotHei
;  res@vpXF = 0.2
;  res@vpYF = 0.9

res@tiXAxisFontHeightF = xLabelSize
res@tiYAxisFontHeightF = yLabelSize
res@tiXAxisString = xTitle
res@tiYAxisString = yTitle

res@gsnDraw = False
res@gsnFrame = False
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
res@gsnStringFontHeightF = res@tiXAxisFontHeightF
res@gsnCenterStringOrthogonalPosF = 0.01
res@gsnAddCyclic = False
res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 
if (cmap.eq."ncl_default") then
  res@gsnSpreadColorEnd = 230
end if
res@gsnContourZeroLineThicknessF = 2

res@cnFillOn             = True               ; turn on color for contours
;res@cnLinesOn            = False              ; turn off contour lines
res@cnLineThicknessF     = 0.5
;res@cnLineLabelBackgroundColor = "transparent"
res@cnLineLabelsOn       = True
res@cnLineLabelFontHeightF = yLabelSize*0.5
res@cnInfoLabelOn        = False      ; turns off contour info label
;res@cnMissingValFillColor = "gray60"
;   res@cnFillMode = "RasterFill"
if .not.autoTicks
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       = cnMinMaxInc(0)
  res@cnMaxLevelValF       = cnMinMaxInc(1)
  res@cnLevelSpacingF      = cnMinMaxInc(2)
end if

if .not.autoTicks
  res@lbLabelBarOn   = False
end if


;res@tmXTOn = False
;res@tmYROn = False
;res@tmYRMinorOn = False
res@tmYRLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize*0.8
;res@tmXBLabelStride = 2

;res@tmXBMode = "Explicit"
;res@tmXBValues = (/140, 180, 220, 260/)
;res@tmXBMinorValues =  ispan(140,280,20)
;res@tmXBLabels = (/"140~S~o~N~E", "180~S~o", "140~S~o~N~W", "100~S~o~N~W"/)

;res@tmYLMode = "Explicit"
;res@tmYLValues = (/0, 100, 200, 300/)
;res@tmYLMinorValues =  ispan(0,350,50)
;res@tmYLLabels = res@tmYLValues

res@trYReverse               = True   ; reverses y-axis
;}}}

plot = new(4, graphic)

res1 = res
res1@gsnCenterString = "Global, simulated"
res1@tiXAxisString = ""
plot(0) = gsn_csm_contour(wks, cn1, res1)

res2 = res
res2@gsnCenterString = "Global, reanalysis"
res2@tiXAxisString = ""
res2@tiYAxisString = ""
plot(1) = gsn_csm_contour(wks, cn1_soda, res2)

res3 = res
res3@gsnCenterString = "Atlantic, simulated"
plot(2) = gsn_csm_contour(wks, cn2, res3)

res4 = res
res4@gsnCenterString = "Atlantic, reanalysis"
res4@tiYAxisString = ""
plot(3) = gsn_csm_contour(wks, cn2_soda, res4)

resP = True
;resP@gsnDraw = False
resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
if .not.autoTicks
  resP@gsnPanelLabelBar = True
end if
resP@gsnPanelYWhiteSpacePercent = 0
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStrings = (/"a)","b)","c)","d)"/)
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.5
resP@gsnPanelFigureStringsPerimOn = False
resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.7

resP@lbOrientation = "Vertical"     ; vertical label bar
;resP@lbBoxLinesOn = False
;resP@lbTitlePosition = "Right"
resP@lbLabelFontHeightF = fontSize*0.4
resP@lbTitleFontHeightF = yLabelSize*0.5
resP@lbTitleString = cbTitle
resP@lbTitleOffsetF = -0.02

resP@pmLabelBarOrthogonalPosF = 0.015
resP@pmLabelBarParallelPosF = 0.04
resP@pmLabelBarWidthF = 0.05
resP@pmLabelBarHeightF = 0.45

gsn_panel(wks, plot, (/2,2/), resP)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
