
; Description: EOF of MOC
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2015-05-15 06:48:10 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$HOME/archive/scripts/utils/pcom.ncl"

datDir    = getenv("NCL_ARG_1")
datDirRef = "/home/ou/archive/data/pcom/exp_spinup/post/"
img       = getenv("NCL_ARG_2")
nc        = "calc_10b_moc_years.nc"

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;{{{
; get the EOF for varname (substract refererce case)
procedure get_diff_eof(varname,eof,ts)
local moc1, moc2
begin
  f = addfile(datDir + nc, "r")
  moc1 = f->$varname$
  delete(f)

  f = addfile(datDirRef + nc, "r")
  moc2 = f->$varname$
  delete(f)

  moc1 = moc1 - moc2
  moc1&time = moc1&time - 600

  pcom_eof(moc1, eof, ts)
end 

; get coordinates infos
f = addfile(datDir+"calc_10b_moc_years.nc", "r")
mocGlo = f->mocGlo(:,:,:)
delete(f)

time = mocGlo&time
z = mocGlo&z
lat = mocGlo&lat
nt = dimsizes(time)
nz = dimsizes(z)
nlat = dimsizes(lat)

eof = new((/2,nz,nlat/),typeof(mocGlo))
ts = new((/2,nt/),typeof(mocGlo))

; global MOC
get_diff_eof("mocGlo",eof,ts)

cnGlo1 = eof(0,:,:)
cnGlo1 = cnGlo1*(-1)
cnGlo2 = eof(1,:,:)
cnGlo2 = cnGlo2*(-1)

linesGlo = ts
linesGlo = linesGlo*(-1)

eofGloVar1 = sprintf("EOF1 (%4.1f",eof@pcvar(0))+"%)"
eofGloVar2 = sprintf("EOF2 (%4.1f",eof@pcvar(1))+"%)"

; Pacific MOC
get_diff_eof("mocPac",eof,ts)
cnPac1        = eof(0,:,:)
cnPac2        = eof(1,:,:)
linesPac     = ts
cnPac1 = cnPac1*(-1)
linesPac(0,:) = linesPac(0,:)*(-1)
eofPacVar1 = sprintf("EOF1 (%4.1f",eof@pcvar(0))+"%)"
eofPacVar2 = sprintf("EOF2 (%3.1f",eof@pcvar(1))+"%)"

lineX = ts&time
;}}}

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; plot model 
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

;  cmap = "NCL_default"
;  cmap = "GMT_jet"
;  cmap = "WhiteBlueGreenYellowRed"
;cmap = "BlGrYeOrReVi200"
cmap = "NCV_blu_red"

fontSize = 0.02
yLabelSize = fontSize*0.9
xLabelSize = fontSize*0.9
plotWid = 0.4
plotHei = 0.2
yTitleCn = "depth (m)"
xTitleLine = "model year"
xTitleCn = "latitude"
cbTitle = mocGlo@units
eof1MinMaxInc = (/-9, 9, 0.5/)
eof2MinMaxInc = (/-0.9, 0.9, 0.05/)
linesMinMaxInc = (/-4, 3, 1/)
tmMaxY = 2000
autoTicks = False
;autoTicks = True
;if isExp("exp24")
;  autoTicks = False
;end if

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
resCn@cnMissingValFillColor = "gray60"
;   resCn@cnFillMode = "RasterFill"

;resCn@lbLabelBarOn = False
resCn@lbOrientation = "vertical"
resCn@lbTitleString = cbTitle
;resCn@lbTitlePosition = "Right"
resCn@lbTitleFontHeightF = fontSize*0.8
resCn@lbLabelFontHeightF = fontSize*0.6
resCn@lbBoxLinesOn = False
;resCn@lbLabelStride = 2

resCn@pmLabelBarWidthF = 0.06
resCn@pmLabelBarHeightF = plotHei*1.2
;resCn@pmLabelBarOrthogonalPosF = 0.2
resCn@pmLabelBarParallelPosF = 0.55

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

resLine@xyLineColors = (/"red","blue"/)
resLine@xyLineThicknessF = 2
resLine@xyDashPattern = 0
resLine@xyExplicitLegendLabels = (/"PC1","PC2"/)

resLine@lgPerimOn = False
resLine@lgLabelFontHeightF = fontSize*0.8
resLine@lgPerimFill = "SolidFill"
resLine@lgPerimFillColor = "White"
resLine@lgItemOrder = (/1,0/)

resLine@pmLegendDisplayMode = "Always"
resLine@pmLegendSide = "Right"
resLine@pmLegendOrthogonalPosF = -0.4
resLine@pmLegendParallelPosF = 0.15
resLine@pmLegendWidthF = 0.05
;resLine@pmLegendHeightF = 0.1

if .not.autoTicks
  resLine@tmYLMode = "Manual"
  resLine@tmYLTickStartF   = linesMinMaxInc(0)
  resLine@tmYLTickSpacingF = linesMinMaxInc(2)
  resLine@tmYLTickEndF     = linesMinMaxInc(1)
  resLine@trYMinF = linesMinMaxInc(0)
  resLine@trYMaxF = linesMinMaxInc(1)
end if

resLine@tmYLPrecision = 1
if autoTicks
  delete(resLine@tmYLPrecision)
end if
;}}}

plot = new(9, graphic)

; Global
resGlo1 = resCn
resGlo1@lbLabelBarOn = False
if .not.autoTicks
  resGlo1@cnLevelSelectionMode = "ManualLevels"
  resGlo1@cnMinLevelValF       = eof1MinMaxInc(0)
  resGlo1@cnMaxLevelValF       = eof1MinMaxInc(1)
  resGlo1@cnLevelSpacingF      = eof1MinMaxInc(2)
end if
resGlo1@tiXAxisOn = False
;resGlo1@tmXBLabelsOn = False
plot(0) = gsn_csm_contour(wks, cnGlo1, resGlo1)

resPac1 = resGlo1
resPac1@tiYAxisOn = False
resPac1@lbLabelBarOn = True
plot(1) = gsn_csm_contour(wks, cnPac1, resPac1)

resGlo2 = resCn
resGlo2@lbLabelBarOn = False
if .not.autoTicks
  resGlo2@cnLevelSelectionMode = "ManualLevels"
  resGlo2@cnMinLevelValF       = eof2MinMaxInc(0)
  resGlo2@cnMaxLevelValF       = eof2MinMaxInc(1)
  resGlo2@cnLevelSpacingF      = eof2MinMaxInc(2)
end if
plot(3) = gsn_csm_contour(wks, cnGlo2, resGlo2)

resPac2 = resGlo2
resPac2@tiYAxisOn = False
resPac2@lbLabelBarOn = True
plot(4) = gsn_csm_contour(wks, cnPac2, resPac2)

resLineGlo = resLine
plot(6) = gsn_csm_xy(wks, lineX, linesGlo, resLineGlo)

resLinePac = resLine
plot(7) = gsn_csm_xy(wks, lineX, linesPac, resLinePac)

resP = True
resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
resP@gsnPanelXWhiteSpacePercent = 5
resP@gsnPanelYWhiteSpacePercent = 25
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStrings = (/"(a) Global, "+eofGloVar1,"(b) Pacific, "+eofPacVar1,"",\
                               "(c) Global, "+eofGloVar2,"(d) Pacific, "+eofPacVar2,"",\
                               "(e) PCs of (a) and (c)","(f) PCs of (b) and (d)",""/)
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.6
resP@gsnPanelFigureStringsPerimOn = False
resP@gsnPanelFigureStringsBackgroundFillColor = "transparent"
resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.7
resP@amParallelPosF = -0.5
;   resP@txString = "Sea surface salinity"
gsn_panel(wks, plot, (/3,3,3/), resP)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
