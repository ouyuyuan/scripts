
; Description: EOF of MOC
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2015-06-24 19:06:48 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$HOME/archive/scripts/utils/pcom.ncl"

datDir = getenv("NCL_ARG_1")
img = getenv("NCL_ARG_2")

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;{{{
f = addfile(datDir+"calc_10b_moc_years.nc", "r")
;moc = f->mocGlo(:,:,:)
moc = f->mocPac(:,:,:)
;moc = f->mocAtl(:,:,:)
;moc = f->mocInd(:,:,:)
;moc = f->mocSou(:,:,:)
delete(f)

time = moc&time
z = moc&z
lat = moc&lat
nt = dimsizes(time)
nz = dimsizes(z)
nlat = dimsizes(lat)

eof = new((/2,nz,nlat/),typeof(moc))
ts = new((/2,nt/),typeof(moc))
pcom_eof(moc,eof,ts)

textVar1 = sprintf("EOF1 (%4.1f)",eof@pcvar(0))+"%"
textVar2 = sprintf("EOF2 (%4.1f)",eof@pcvar(1))+"%"

cn = moc(0,:,:) ; get attributes and units
;cn1 = eof(0,:,{-35:65})
cn1 = eof(0,:,:)
cn1 = cn1*(-1)
;cn2 = eof(1,:,:)
lineX = time - 600
lineY = ts(0,:)
lineY = lineY*(-1)

;}}}

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; plot model 
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

;  cmap = "NCL_default"
;  cmap = "GMT_jet"
;  cmap = "WhiteBlueGreenYellowRed"
;cmap = "BlGrYeOrReVi200"
cmap = "NCV_blu_red"

fontSize = 0.03
yLabelSize = fontSize*0.9
xLabelSize = fontSize*0.9
plotWid = 0.8
plotHei = 0.3
yTitleCn = "depth (meter)"
xTitleLine = "model year"
xTitleCn = "latitude"
cbTitle = cn@units
cnMinMaxInc = (/-9, 9, 0.5/)
tmMaxY = 2000
autoTicks = False
;autoTicks = True

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks,cmap)

res = True
; {{{
res@vpWidthF = plotWid
res@vpHeightF = plotHei
;res@vpXF = -0.01
;  res@vpYF = 0.9

res@tiXAxisFontHeightF = fontSize

res@gsnDraw = False
res@gsnFrame = False
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
res@gsnStringFontHeightF = fontSize
res@gsnCenterStringOrthogonalPosF = 0.03

res@tmXTOn = False
res@tmYROn = False
res@tmYLMinorOn = False
res@tmYRMinorOn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmYRLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize

; }}}

resCn = res
;{{{
resCn@tiXAxisString = xTitleCn
resCn@tiYAxisString = yTitleCn

;resCn@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 
resCn@gsnYAxisIrregular2Log = True
resCn@cnFillOn             = True               ; turn on color for contours
resCn@cnLinesOn            = False              ; turn off contour lines
;   resCn@cnLineThicknessF = 0.5
resCn@cnLineLabelsOn       = False              ; turn off contour line labels
resCn@cnInfoLabelOn        = False      ; turns off contour info label
if .not.autoTicks
  resCn@cnLevelSelectionMode = "ManualLevels"
  resCn@cnMinLevelValF       = cnMinMaxInc(0)
  resCn@cnMaxLevelValF       = cnMinMaxInc(1)
  resCn@cnLevelSpacingF      = cnMinMaxInc(2)
end if
resCn@cnMissingValFillColor = "gray60"
;   resCn@cnFillMode = "RasterFill"

;resCn@lbLabelBarOn = False
resCn@lbOrientation = "vertical"
resCn@lbTitleString = cbTitle
;resCn@lbTitlePosition = "Right"
resCn@lbTitleFontHeightF = fontSize*0.8
resCn@lbLabelFontHeightF = fontSize*0.8
resCn@lbBoxLinesOn = False
;resCn@lbLabelStride = 2

resCn@pmLabelBarWidthF = 0.08
resCn@pmLabelBarHeightF = plotHei
;resCn@pmLabelBarOrthogonalPosF = 0.2

;resCn@tmXBLabelStride = 2

resCn@trYReverse               = True   ; reverses y-axis
;}}}

resLine = res
;{{{
;resLine@vpHeightF = plotHei*0.9

resLine@tiXAxisString = xTitleLine
resLine@tiYAxisString = ""
resLine@tiYAxisFontHeightF = fontSize

resLine@gsnYRefLine = 0.

;resLine@xyLineColors = (/"red","blue"/)
;resLine@xyLineColors = (/"red","blue"/)
resLine@xyLineThicknessF = 3
resLine@xyDashPattern = 0
;resLine@xyExplicitLegendLabels = (/"PC1","PC2"/)

;resLine@lgPerimOn = False
;resLine@lgLabelFontHeightF = fontSize*0.8
;resLine@lgPerimFill = "SolidFill"
;resLine@lgPerimFillColor = "White"
;resLine@lgItemOrder = (/1,0/)

;  resLine@pmLegendDisplayMode = "Always"
;resLine@pmLegendSide = "Right"
;resLine@pmLegendOrthogonalPosF = lgPosRight
;resLine@pmLegendParallelPosF = lgPosUp
;resLine@pmLegendWidthF = lgWid
;resLine@pmLegendHeightF = lgHei

;}}}

plot = new(2, graphic)

res1 = resCn
;res1@tiXAxisOn = False
;res1@tmXBLabelsOn = False
plot(0) = gsn_csm_contour(wks, cn1, res1)

plot(1) = gsn_csm_xy(wks, lineX, lineY, resLine)

resP = True
resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 10
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStrings = (/"a) "+textVar1,""/)
resP@gsnPanelFigureStringsFontHeightF = fontSize
resP@gsnPanelFigureStringsPerimOn = False
resP@gsnPanelFigureStringsBackgroundFillColor = "transparent"
resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.7
resP@amParallelPosF = -0.2
;   resP@txString = "Sea surface salinity"
gsn_panel(wks, plot, (/1,1/), resP)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
