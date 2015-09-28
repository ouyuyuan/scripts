
; Description: EOF of a specific case, for 240 yeaers experiments
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2015-06-25 06:43:57 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$HOME/archive/scripts/utils/pcom.ncl"

;img, dirs, and data files------------------------------{{{1
load "$HOME/archive/scripts/draw/pp_heaving/head_one_case.ncl"

;get plotting data--------------------------------------{{{1

;get coordinates infos array definition for EOF---------{{{2
f = addfile(datDir+ncMoc, "r")
time = f->time
lat = f->lat
z = f->z
delete(f)
time = time - 600
nt = dimsizes(time)
nz = dimsizes(z)
nlat = dimsizes(lat)

f = addfile(refDir+ncSsh, "r")
lon = f->lon
delete(f)
nlon = dimsizes(lon)

;get wind anomaly {{{2
f   = addfile(datDir+ncWs, "r")
ws = f->bcu_an({660},:,:)

delete(f)
ws = ws*0.1 ; dyne/cm^2 to N/m^2
ws = ws*100
ws@units = "0.01N m~S~-2"

Bt = new(nt,float)

; calc. B(t)
do t = 1, nt
  if t.le.20 then
    Bt(t-1) = t/20.0 
  else if t.le.100 then
    Bt(t-1) = 1
  else if t.le.140 then
    Bt(t-1) = 6 - t/20.0
  else if t.le.220 then
    Bt(t-1) = -1
  else if t.le.nyear then
    Bt(t-1) = t/20.0 - 12
  end if
  end if
  end if
  end if
  end if
end do

;get volume anomaly {{{2
f = addfile(refDir + ncVol, "r")
;cnR = f->dvolPac(:,{-45:65})
cnR = f->dvolPac
delete(f)

f = addfile(datDir + ncVol, "r")
;cn = f->dvolPac(:,{-45:65})
cn = f->dvolPac
delete(f)

cn = cn - cnR
cn = dim_rmvmean_n_Wrap(cn, 0)
; it seems that detrend introduce artificial oscillations
;  cn = dtrend_n(cn, False, 0) 
cn = cn*1e-10
cn@units = "10~S~10~N~m~S~3~N~/1~S~o"
cn&time = cn&time - 600
vol = cn(lat|:,time|:)
delete(cn)
delete(cnR)

;get anomalous ocean heat content ;{{{2
f = addfile(datDir + ncOhc, "r")
cn = f->ohcPac
delete(f)

f = addfile(refDir + ncOhc, "r")
cnR = f->ohcPac
delete(f)

cn = cn - cnR
cn = dim_rmvmean_n_Wrap(cn, 0)
cn&time = cn&time - 600
cn = cn*1e-19
cn@units = "10~S~19~N~J/m"
ohc = cn(z|:,time|:)
delete(cn)
delete(cnR)

;get MOC EOF {{{2
f = addfile(datDir + ncMoc, "r")
moc = f->mocGlo
delete(f)

f = addfile(refDir + ncMoc, "r")
mocR = f->mocGlo
delete(f)
moc = moc - mocR
moc&time = moc&time - 600

eof = new((/2,nz,nlat/), "float")
ts = new((/2,nt/), "float")

pcom_eof(moc, eof, ts)

pat = moc(0,:,:)
pat = eof(0,:,:)
pc = ts(0,:)
var= sprintf("%4.1f",eof@pcvar(0))+"%"

pat = pat*(-1)
pc = pc*(-1)

mocPat = pat
mocPc  = pc
mocVar = var
delete(pat)
delete(pc)
delete(eof)
delete(ts)
delete(var)

;get DTC EOF {{{2
f = addfile(datDir + ncDtc, "r")
var = f->dtc
delete(f)

f = addfile(refDir + ncDtc, "r")
varR = f->dtc
delete(f)
var = var - varR
var&time = var&time - 600

eof = new((/2,nlat,nlon/), "float")
ts = new((/2,nt/), "float")

pcom_eof(var, eof, ts)

pat = var(0,:,:)
pat = eof(0,:,:)
pc = ts(0,:)
varText= sprintf("%4.1f",eof@pcvar(0))+"%"

pat = pat*(-1)
pc = pc*(-1)

dtcPat = pat
dtcPc = pc
dtcVar = varText
delete(var)
delete(varR)
delete(eof)
delete(ts)
delete(pat)
delete(pc)
delete(varText)

;get BSF EOF {{{2
f = addfile(datDir + ncBsf, "r")
var = f->bsf
delete(f)

f = addfile(refDir + ncBsf, "r")
varR = f->bsf
delete(f)
var = var - varR
var&time = var&time - 600

eof = new((/2,nlat,nlon/), "float")
ts = new((/2,nt/), "float")

pcom_eof(var, eof, ts)

pat = var(0,:,:)
pat = eof(0,:,:)
pc = ts(0,:)
varText= sprintf("%4.1f",eof@pcvar(0))+"%"

pat = pat*(-1)
pc = pc*(-1)

bsfPat = pat
bsfPc = pc
bsfVar = varText
delete(var)
delete(varR)
delete(eof)
delete(ts)
delete(pat)
delete(pc)
delete(varText)

;get SSH EOF {{{2
f = addfile(datDir + ncSsh, "r")
var = f->ssh
delete(f)

f = addfile(refDir + ncSsh, "r")
varR = f->ssh
delete(f)
var = var - varR
var&time = var&time - 600

eof = new((/2,nlat,nlon/), "float")
ts = new((/2,nt/), "float")

var = var*100 
var@units = "cm"

pcom_eof(var, eof, ts)

pat = var(0,:,:)
pat = eof(0,:,:)
pc = ts(0,:)
varText= sprintf("%4.1f",eof@pcvar(0))+"%"

pat = pat*(-1)
pc = pc*(-1)

sshPat = pat
sshPc = pc
sshVar = varText
delete(var)
delete(varR)
delete(eof)
delete(ts)
delete(pat)
delete(pc)
delete(varText)

;define lines for holding PCs and ws--------------------{{{2
lines = new((/5,nt/),"float")
lines(0,:) = sshPc
lines(1,:) = dtcPc
lines(2,:) = bsfPc
lines(3,:) = mocPc
lines(4,:) = (/Bt/)

lineColors = (/"blue","green3","cyan2","gold3","red"/)
lineThicknesses = (/2, 2, 2, 2, 3/)
lineLabels = (/"PC of SSH in (e)", "PC of DTC in (f)",\
  "PC of BSF in (g)", "PC of MOC in (h)", "B(t) of Eq. (1)"/)

lineX = time

;plotting parameters------------------------------------{{{1
;  cmap = "NCL_default"
;  cmap = "GMT_jet"
;  cmap = "WhiteBlueGreenYellowRed"
;cmap = "BlGrYeOrReVi200"
cmap = "NCV_blu_red"

fontSize = 0.018
yLabelSize = fontSize*0.9
xLabelSize = fontSize*0.9
plotWid = 0.4
plotHei = 0.2
xTitleLine = "year"

cbTitleWs  = ws@units
cbTitleSsh = sshPat@units
cbTitleVol = vol@units
cbTitleOhc = ohc@units
cbTitleDtc = dtcPat@units
cbTitleBsf = bsfPat@units
cbTitleMoc = mocPat@units

cnMinMaxIncWs  = (/-1.5, 1.5, 0.1/)
cnMinMaxIncSsh = (/-8.0, 8.0, 0.5/)
cnMinMaxIncVol = (/-8.0, 8.0, 0.5/)
cnMinMaxIncOhc = (/-12.0, 12.0, 0.5/)
cnMinMaxIncDtc = (/-30.0, 30.0, 1.0/)
cnMinMaxIncBsf = (/-5.0, 5.0, 0.25/)
cnMinMaxIncMoc = (/-15.0, 15.0, 0.5/)

linesMinMaxInc = (/-1.5, 1.5, 0.5/)
autoTicks = False
;autoTicks = True

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks,cmap)

;resources attributes setting---------------------------{{{1
;common-------------------------------------------------{{{2
res = True
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
res@gsnStringFontHeightF = fontSize*0.9
res@gsnCenterStringOrthogonalPosF = 0.03
res@gsnLeftStringOrthogonalPosF = -1.15
res@gsnRightStringOrthogonalPosF = -0.14
res@gsnLeftStringParallelPosF = 0.02

res@tmLabelAutoStride    = True
res@tmXTOn = False
res@tmYROn = False
res@tmYLMinorOn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmYRLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize

;contour plots------------------------------------------{{{2
resCn = res

resCn@cnFillOn             = True               ; turn on color for contours
resCn@cnLinesOn            = False              ; turn off contour lines
;   resCn@cnLineThicknessF = 0.5
resCn@cnLineLabelsOn       = False              ; turn off contour line labels
resCn@cnInfoLabelOn        = False      ; turns off contour info label
;resCn@cnMissingValFillColor = "gray60"
;   resCn@cnFillMode = "RasterFill"
resCn@cnLevelSelectionMode = "ManualLevels"

;resCn@lbLabelBarOn = False
resCn@lbOrientation = "vertical"
;resCn@lbTitleString = cbTitle
;resCn@lbTitlePosition = "Right"
resCn@lbTitleFontHeightF = fontSize*0.8
resCn@lbLabelFontHeightF = fontSize*0.7
resCn@lbBoxLinesOn = False
;resCn@lbLabelStride = 10

resCn@pmLabelBarWidthF = 0.1
resCn@pmLabelBarHeightF = plotHei*1.2
;resCn@pmLabelBarOrthogonalPosF = 0.2
resCn@pmLabelBarParallelPosF = 0.6

resCn@tmXBMinorOn = False

;plots with map {{{2
resMap = resCn
;resMap@tiYAxisString = "latitude"
;resMap@tiXAxisString = "longitude"
resMap@mpShapeMode = "FreeAspect"
resMap@mpOutlineOn = True
resMap@mpLandFillColor          = "gray"            ; set land to be gray
;resMapmpMinLonF = 0
;resMap@mpMaxLonF = 360
resMap@mpMinLatF = -80
resMap@mpMaxLatF = 80
resMap@mpCenterLonF = 200

resMap@tmXBLabelStride = 2

;lines plots--------------------------------------------{{{2
resLine = res
resLine@gsnYRefLine = 0.
;resLine@vpWidthF = plotWid*2.15

resLine@tiXAxisString = xTitleLine
resLine@tiXAxisString = "year"
resLine@tiYAxisString = ""
resLine@tiYAxisFontHeightF = fontSize

resLine@xyLineColors = lineColors
;resLine@xyLineThicknessF = 2
resLine@xyLineThicknesses = lineThicknesses
resLine@xyDashPattern = 0
resLine@xyExplicitLegendLabels = lineLabels

resLine@lgPerimOn = False
resLine@lgLabelFontHeightF = fontSize*0.6
resLine@lgPerimFill = "SolidFill"
resLine@lgPerimFillColor = "White"
resLine@lgItemOrder = (/4,3,2,1,0/)

resLine@pmLegendDisplayMode = "Always"
resLine@pmLegendSide = "Right"
resLine@pmLegendOrthogonalPosF = -0.44
resLine@pmLegendParallelPosF = 0.68
resLine@pmLegendWidthF = 0.05
resLine@pmLegendHeightF = 0.13

if .not.autoTicks
  resLine@tmYLMode = "Manual"
  resLine@tmYLTickStartF   = linesMinMaxInc(0)
  resLine@tmYLTickSpacingF = linesMinMaxInc(2)
  resLine@tmYLTickEndF     = linesMinMaxInc(1)
  resLine@trYMinF = linesMinMaxInc(0)
  resLine@trYMaxF = linesMinMaxInc(1)
end if

;resLine@tmYLPrecision = 1
;if autoTicks
;  delete(resLine@tmYLPrecision)
;end if

;draw plots calling gsn functions-----------------------{{{1
plot = new(9, graphic) ; fix bug for xtitle not show entirely

res1 = resMap
;res1@lbLabelBarOn = False
;res1@tiXAxisOn = False
;res1@tmXBOn    = False
res1@lbTitleString = cbTitleWs
if .not.autoTicks
  res1@lbLabelStride = 5
  res1@cnMinLevelValF       = cnMinMaxIncWs(0)
  res1@cnMaxLevelValF       = cnMinMaxIncWs(1)
  res1@cnLevelSpacingF      = cnMinMaxIncWs(2)
end if
plot(0) = gsn_csm_contour_map(wks, ws, res1)

plot(1) = gsn_csm_xy(wks, lineX, lines, resLine)

res3 = resCn
res3@lbTitleString = cbTitleVol
res3@tiXAxisString = "year"
if .not.autoTicks
  res3@lbLabelStride = 2
  res3@pmLabelBarOrthogonalPosF = -0.015
  res3@cnMinLevelValF       = cnMinMaxIncVol(0)
  res3@cnMaxLevelValF       = cnMinMaxIncVol(1)
  res3@cnLevelSpacingF      = cnMinMaxIncVol(2)
end if
plot(2) = gsn_csm_contour(wks, vol, res3)

res4 = resCn
res4@tiXAxisString = "year"
res4@tiYAxisString = "depth (m)"
res4@gsnYAxisIrregular2Log = True
res4@lbTitleString = cbTitleOhc
res4@trYReverse            = True
if .not.autoTicks
  res4@lbLabelStride = 2
  res4@pmLabelBarOrthogonalPosF = -0.012
  res4@cnMinLevelValF       = cnMinMaxIncOhc(0)
  res4@cnMaxLevelValF       = cnMinMaxIncOhc(1)
  res4@cnLevelSpacingF      = cnMinMaxIncOhc(2)
end if
plot(3) = gsn_csm_contour(wks, ohc, res4)

res5 = resMap
res5@gsnRightString = sshVar
;res5@tiXAxisOn = False
;res5@tmXBOn    = False
res5@lbTitleString = cbTitleSsh
if .not.autoTicks
  res5@lbLabelStride = 2
  res5@pmLabelBarOrthogonalPosF = 0.01
  res5@cnMinLevelValF       = cnMinMaxIncSsh(0)
  res5@cnMaxLevelValF       = cnMinMaxIncSsh(1)
  res5@cnLevelSpacingF      = cnMinMaxIncSsh(2)
end if
plot(4) = gsn_csm_contour_map(wks, sshPat, res5)

res6 = resMap
res6@gsnRightString = dtcVar
;res6@tiXAxisOn = False
;res6@tmXBOn    = False
res6@lbTitleString = cbTitleDtc
if .not.autoTicks
  res6@lbLabelStride = 2
  res6@cnMinLevelValF       = cnMinMaxIncDtc(0)
  res6@cnMaxLevelValF       = cnMinMaxIncDtc(1)
  res6@cnLevelSpacingF      = cnMinMaxIncDtc(2)
end if
plot(5) = gsn_csm_contour_map(wks, dtcPat, res6)

res7 = resMap
res7@gsnRightString = bsfVar
;res7@tiXAxisOn = False
;res7@tmXBOn    = False
res7@lbTitleString = cbTitleBsf
if .not.autoTicks
  res7@lbLabelStride = 2
  res7@cnMinLevelValF       = cnMinMaxIncBsf(0)
  res7@cnMaxLevelValF       = cnMinMaxIncBsf(1)
  res7@cnLevelSpacingF      = cnMinMaxIncBsf(2)
end if
plot(6) = gsn_csm_contour_map(wks, bsfPat, res7)

res8 = resCn
res8@gsnYAxisIrregular2Log = True
res8@gsnRightString = mocVar
res8@tiYAxisString = "depth (m)"
res8@tiXAxisString = "latitude"
res8@lbTitleString = cbTitleMoc
res8@trYReverse            = True
if .not.autoTicks
  res8@gsnRightStringOrthogonalPosF = 0.05
  res8@lbLabelStride = 2
  res8@cnMinLevelValF       = cnMinMaxIncMoc(0)
  res8@cnMaxLevelValF       = cnMinMaxIncMoc(1)
  res8@cnLevelSpacingF      = cnMinMaxIncMoc(2)
end if
plot(7) = gsn_csm_contour(wks, mocPat, res8)

;put plots in a panel-----------------------------------{{{1
resP = True
resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
resP@gsnPanelXWhiteSpacePercent = 5
resP@gsnPanelYWhiteSpacePercent = 10
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStrings = (/\
  "(a) "+anTitle,  "(b) ",          "(c) "+volTitle, \
  "(d) "+ohcTitle, "(e) "+sshTitle, "(f) "+dtcTitle, \
  "(g) "+bsfTitle, "(h) "+mocTitle/)
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.6
resP@gsnPanelFigureStringsPerimOn = False
resP@gsnPanelFigureStringsBackgroundFillColor = "transparent"
resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.65
resP@amParallelPosF = -0.5
gsn_panel(wks, plot, (/2,2,2,2,1/), resP)

resText = True
resText@txFontHeightF = resP@gsnPanelFigureStringsFontHeightF
;gsn_text_ndc(wks, "(g) PCs", 0.18, 0.34, resText)

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
;-------------------------------------------------------{{{1
; vim:fdm=marker:fdl=0:
; vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
