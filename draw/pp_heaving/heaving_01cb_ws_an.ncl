
; Description: schematic of wind stress anomaly, for 240 years period
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2015-06-24 21:39:14 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;img, dirs, and data files------------------------------{{{1
datDir    = getenv("NCL_ARG_1")
img       = getenv("NCL_ARG_2")
ncWs  = "calc_004_merge_ws_anom.nc"

;get plotting data--------------------------------------{{{1

;get wind anomaly {{{2
f   = addfile(datDir+ncWs, "r")
ws = f->bcu_an({660},:,:); anomaly maximze at 621-700
time = f->time
lat = f->lat
delete(f)
ws = where(ws.eq.0, ws@_FillValue, ws)

ws = ws*0.1 ; dyne/cm^2 to N/m^2

ws = ws*100
ws@units = "0.01N m~S~-2"

time = time - 600

;calc. zonal mean of ws {{{2

mWs = dim_avg_n_Wrap(ws, 1)

; calc. B(t) {{{2
nyear = dimsizes(time)
Bt = new(nyear,float)

do t = 1, nyear
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

lineX = time

;plotting parameters------------------------------------{{{1
;  cmap = "NCL_default"
;  cmap = "GMT_jet"
;  cmap = "WhiteBlueGreenYellowRed"
;cmap = "BlGrYeOrReVi200"
cmap = "NCV_blu_red"

fontSize = 0.018
yLabelSize = fontSize*0.7
xLabelSize = fontSize*0.7
plotWid = 0.4
plotHei = 0.1
xTitleLine = "year"

cbTitleWs  = ws@units

cnMinMaxIncWs  = (/-2.0, 2.0, 0.2/)
;cnMinMaxIncWs  = (/-0.5, 0.5, 0.1/)

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

res@tiXAxisFontHeightF = xLabelSize
res@tiYAxisFontHeightF = yLabelSize

res@gsnDraw = False
res@gsnFrame = False
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
res@gsnStringFontHeightF = xLabelSize
res@gsnCenterStringOrthogonalPosF = 0.05
res@gsnLeftStringOrthogonalPosF = -1.15
res@gsnRightStringOrthogonalPosF = -0.14
res@gsnLeftStringParallelPosF = 0.02

res@tmLabelAutoStride    = True
;res@tmXTOn = False
;res@tmYROn = False
res@tmYLMinorOn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmYRLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize

;contour plots------------------------------------------{{{2
resCn = res

;resCn@tiYAxisString = "latitude"
;resCn@tiXAxisString = "longitude"
;resCn@tiXAxisOn = False

resCn@cnFillOn             = True 
resCn@cnLinesOn            = False
;   resCn@cnLineThicknessF = 0.5
resCn@cnLineLabelsOn       = False
resCn@cnInfoLabelOn        = False
;resCn@cnMissingValFillColor = "gray60"
;   resCn@cnFillMode = "RasterFill"
resCn@cnLevelSelectionMode = "ManualLevels"
if .not.autoTicks
  resCn@lbLabelStride = 5
  resCn@cnMinLevelValF       = cnMinMaxIncWs(0)
  resCn@cnMaxLevelValF       = cnMinMaxIncWs(1)
  resCn@cnLevelSpacingF      = cnMinMaxIncWs(2)
end if

;resCn@lbLabelBarOn = False
;resCn@lbOrientation = "vertical"
resCn@lbPerimOn = True
resCn@lbPerimFill = 0
;resCn@lbTitleString = cbTitleWs
;resCn@lbTitlePosition = "Right"
resCn@lbTitleFontHeightF = fontSize*0.7
resCn@lbLabelFontHeightF = fontSize*0.7
resCn@lbBoxLinesOn = False

resCn@pmLabelBarDisplayMode = "Always"
resCn@pmLabelBarKeepAspect = True
resCn@pmLabelBarWidthF = 0.1
resCn@pmLabelBarHeightF = 0.03
resCn@pmLabelBarOrthogonalPosF = -0.9
resCn@pmLabelBarParallelPosF = 0.7

resCn@tmXBMinorOn = False

resCn@mpShapeMode = "FreeAspect"
resCn@mpOutlineOn = True
resCn@mpLandFillColor = "gray"
;resCn@mpMinLonF = 0
;resCn@mpMaxLonF = 360
resCn@mpMinLatF = -80
resCn@mpMaxLatF = 0
resCn@mpCenterLonF = 200

resCn@tmXBTickSpacingF = 60
;resCn@tmXBOn    = False

;lines plots--------------------------------------------{{{2
resLine = res
;resLine@gsnYRefLine = 0.

resLine@xyLineThicknessF = 2
resLine@xyDashPattern = 0
resLine@tmXBMinorOn = False

;resLine@tmYLPrecision = 1
;if autoTicks
;  delete(resLine@tmYLPrecision)
;end if

;draw plots calling gsn functions-----------------------{{{1
plot = new(4, graphic) ; fix bug for xtitle not show entirely

res1 = resCn
res1@gsnCenterString = "(a) C(~F8~j~F21~) of Eq.(1)"
res1@gsnCenterStringOrthogonalPosF = 0.08
res1@lbLabelStride = 10
plot(0) = gsn_csm_contour_map(wks, ws, res1)

res2 = resLine
res2@vpWidthF = plotWid*0.2
res2@gsnCenterString = "(b) Zonal-mean of (a)"
res2@tiYAxisString = "latitude"
;res2@tiXAxisString = "("+cbTitleWs+"~N~)"
res2@tiXAxisString = ""
;res2@trYReverse = True
;res2@xyLineColor = "red"
if .not.autoTicks
;  res2@tmYLMode = "Manual"
;  res2@tmYLTickStartF   = resCn@mpMinLatF
;  res2@tmYLTickSpacingF = 10
;  res2@tmYLTickEndF     = resCn@mpMaxLatF
  res2@trYMinF = resCn@mpMinLatF
  res2@trYMaxF = resCn@mpMaxLatF

  res2@tmXBMode = "Manual"
  res2@tmXBTickStartF   = 0
  res2@tmXBTickSpacingF = 0.5
  res2@tmXBTickEndF     = 2.0
  res2@trXMinF = res2@tmXBTickStartF
  res2@trXMaxF = res2@tmXBTickEndF
end if
plot(1) = gsn_csm_xy(wks, mWs, mWs&lat, res2)

res3 = resLine
res3@vpWidthF = plotWid*1.44
res3@gsnCenterString = "(c) B(t) of Eq.(1)"
res3@gsnYRefLine = 0.
res3@tiXAxisString = "year"
res3@tiYAxisString = ""
;res3@xyLineColor = "red"
;res3@tmXBMode = "Explicit"
;res3@tmXBValues = (/20, 100, 120, 140, 220, 240/)
;res3@tmXBLabels = res3@tmXBValues
res3@tmXBMode = "Manual"
res3@tmXBTickStartF   = 0
res3@tmXBTickSpacingF = 20
res3@tmXBLabelStride = 2

if .not.autoTicks
  res3@tmYLMode = "Manual"
  res3@tmYLTickStartF   = linesMinMaxInc(0)
  res3@tmYLTickSpacingF = linesMinMaxInc(2)
  res3@tmYLTickEndF     = linesMinMaxInc(1)
  res3@trYMinF = linesMinMaxInc(0)
  res3@trYMaxF = linesMinMaxInc(1)
end if
plot(2) = gsn_csm_xy(wks, lineX, Bt, res3)

;put plots in a panel-----------------------------------{{{1
resP = True
resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
resP@gsnPanelXWhiteSpacePercent = 5
resP@gsnPanelYWhiteSpacePercent = 15
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.6
resP@gsnPanelFigureStringsPerimOn = False
resP@gsnPanelFigureStringsBackgroundFillColor = "transparent"
resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.65
resP@amParallelPosF = -0.5
gsn_panel(wks, plot, (/2,2/), resP)

resText = True
resText@txFontHeightF = resP@gsnPanelFigureStringsFontHeightF
;gsn_text_ndc(wks, "(g) PCs", 0.18, 0.34, resText)

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
;-------------------------------------------------------{{{1
; vim:fdm=marker:fdl=0:
; vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
