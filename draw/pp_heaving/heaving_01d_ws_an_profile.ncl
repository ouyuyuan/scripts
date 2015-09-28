
; Description: schematic of zonal profile of wind stress anomaly
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2015-06-15 16:29:57 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;img, dirs, and data files------------------------------{{{1
datDir    = "/home/ou/archive/data/pcom/"
img       = getenv("NCL_ARG_2")

expDir1   = "exp72_heaving_b_Pac_0N-40N/post/"
expDir2   = "exp73_heaving_b_Pac_20N-60N/post/"
expDir3   = "exp74_heaving_b_Pac_40N-80N/post/"

ncWs  = "calc_004_merge_ws_anom.nc"

;get plotting data--------------------------------------{{{1

;get profile of wind stress anomaly {{{2
function get_an(expDir)
begin
  f   = addfile(datDir+expDir+ncWs, "r")
  ws = f->bcu_an({630},:,:); anomaly maximze at 621-640
  lat = f->lat
  delete(f)
  ws = where(ws.eq.0, ws@_FillValue, ws)
  ws = ws*0.1 ; dyne/cm^2 to N/m^2

  mws = dim_avg_n_Wrap(ws(:,{105.5:285.5}),1)
  mws = mws*100
  mws@units = "0.01N m~S~-2"

  return mws
end

line1 = get_an(expDir1)
line2 = get_an(expDir2)
line3 = get_an(expDir3)

;plotting parameters------------------------------------{{{1

fontSize = 0.018
yLabelSize = fontSize*0.8
xLabelSize = fontSize*0.8
plotWid = 0.2
plotHei = 0.4

;autoTicks = True
autoTicks = False

wks = gsn_open_wks ("eps", img)

;resources attributes setting---------------------------{{{1
res = True
res@vpWidthF = plotWid
res@vpHeightF = plotHei
;res@vpXF = -0.01
;res@vpYF = 0.9

res@tiXAxisFontHeightF = xLabelSize
res@tiYAxisFontHeightF = yLabelSize
res@tiXAxisString = line1@units
res@tiYAxisString = "latitude"

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
res@tmXBMinorOn = False

if .not.autoTicks
  res@tmXBMode = "Manual"
  res@tmXBTickStartF   = 0
  res@tmXBTickSpacingF = 0.5
  res@tmXBTickEndF     = 1.0
  res@trXMinF = res@tmXBTickStartF
  res@trXMaxF = res@tmXBTickEndF
  res@trYMinF = -80
  res@trYMaxF = 80
end if

;res@gsnYRefLine = 0.

res@xyLineThicknessF = 2
res@xyDashPattern = 0

;draw plots calling gsn functions-----------------------{{{1
plot = new(3, graphic)

res1 = res
res1@gsnCenterString = "(a) Exp. P-B" 
plot(0) = gsn_csm_xy(wks, line1, line1&lat, res1)

res2 = res
res2@gsnCenterString = "(b) Exp. P-C" 
res2@tiYAxisString = ""
plot(1) = gsn_csm_xy(wks, line2, line2&lat, res2)

res3 = res
res3@gsnCenterString = "(c) Exp. P-D"
res3@tiYAxisString = ""
plot(2) = gsn_csm_xy(wks, line3, line3&lat, res3)

;put plots in a panel-----------------------------------{{{1
resP = True
resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
resP@gsnPanelXWhiteSpacePercent = 5
resP@gsnPanelYWhiteSpacePercent = 10
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.6
resP@gsnPanelFigureStringsPerimOn = False
resP@gsnPanelFigureStringsBackgroundFillColor = "transparent"
resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.65
resP@amParallelPosF = -0.5
gsn_panel(wks, plot, (/3/), resP)

resText = True
resText@txFontHeightF = resP@gsnPanelFigureStringsFontHeightF
;gsn_text_ndc(wks, "(g) PCs", 0.18, 0.34, resText)

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
;-------------------------------------------------------{{{1
; vim:fdm=marker:fdl=0:
; vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
