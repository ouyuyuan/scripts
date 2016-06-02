
; Description: schematic of wind stress anomaly
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2016-04-14 15:44:04 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;img, dirs, and data files------------------------------{{{1
datDir = "/home/ou/archive/data/pcom/"
img    = "/home/ou/archive/drawing/phdthesis/" + getenv("NCL_ARG_0_base")

expDir1 = "exp71_heaving_b_Pac_20S-20N/post/"
expDir2 = "exp72_heaving_b_Pac_0N-40N/post/"
expDir3 = "exp75_heaving_b_Pac_0S-40S/post/"

nc  = "calc_004_merge_ws_anom.nc"

;get plotting data--------------------------------------{{{1

function get_profile(expDir)
local ws, time, line
begin
  f   = addfile(datDir + expDir + nc, "r")
  ws = f->bcu_an({630},:,:); anomaly maximze at 621-640
  delete(f)
  ws = where(ws.eq.0, ws@_FillValue, ws)

  ws = ws*0.1 ; dyne/cm^2 to N/m^2
  ws = ws*100
  ws@units = "0.01N m~S~-2"

  ;calc. zonal mean of ws
  line = dim_avg_n_Wrap(ws(:,{105.5:285.5}),1)

  return line
end

f   = addfile(datDir + expDir1 + nc, "r")
time = f->time
lat = f->lat
delete(f)
time = time - 600
nlat = dimsizes(lat)

line1 = get_profile(expDir1)
line2 = get_profile(expDir2)
line3 = get_profile(expDir3)

; calc. B(t) {{{2
nyear = 120
Bt = new(nyear,float)

do t = 1, nyear
  if t.le.20 then
    Bt(t-1) = t/20.0 
  else if t.le.40 then
    Bt(t-1) = 1
  else if t.le.80 then
    Bt(t-1) = 3 - t/20.0
  else if t.le.100 then
    Bt(t-1) = -1
  else if t.le.nyear then
    Bt(t-1) = t/20.0 - 6
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
yLabelSize = fontSize*0.8
xLabelSize = fontSize*0.8
plotWid = 0.4
plotHei = 0.2
xTitleLine = "year"

lineColors = (/"red", "green3", "blue"/)

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

res@xyLineThicknessF = 2
res@xyDashPattern = 0

;ws anomaly---------------------------------------------{{{2
resWs = res
resWs@vpWidthF = plotWid/5.0
resWs@tiYAxisString = "Latitude"
resWs@tiXAxisString = "0.01N m~S~-2~N~"
resWs@tmYLMode = "Explicit"
;resWs@tmYLTickSpacingF = 20
resWs@tmYLValues = (/-60, -40, -20, 0, 20, 40, 60/)
resWs@tmYLLabels = (/\
"60~S~o~N~S",\
"40~S~o~N~S",\
"20~S~o~N~S",\
"EQ",\
"20~S~o~N~N",\
"40~S~o~N~N",\
"60~S~o~N~N"\
/)
if .not.autoTicks
;  resWs@trYMinF = resCn@mpMinLatF
;  resWs@trYMaxF = resCn@mpMaxLatF

  resWs@tmXBMode = "Manual"
  resWs@tmXBTickStartF   = 0
  resWs@tmXBTickSpacingF = 0.5
  resWs@tmXBTickEndF     = 1.0
  resWs@trXMinF = resWs@tmXBTickStartF
  resWs@trXMaxF = resWs@tmXBTickEndF
end if


;resWs@tmYLPrecision = 1
;if autoTicks
;  delete(resWs@tmYLPrecision)
;end if

;draw plots calling gsn functions-----------------------{{{1
plot = new(6, graphic)

latS = -60
latN = 60

res1 = resWs
res1@gsnCenterString = "(a) EXP_EQ"
plot(0) = gsn_csm_xy(wks, line1({latS:latN}), lat({latS:latN}), res1)

res2 = resWs
res2@gsnCenterString = "(b) EXP_N"
res2@tiYAxisString = ""
plot(1) = gsn_csm_xy(wks, line2({latS:latN}), lat({latS:latN}), res2)

res3 = resWs
res3@gsnCenterString = "(c) EXP_S"
res3@tiYAxisString = ""
plot(2) = gsn_csm_xy(wks, line3({latS:latN}), lat({latS:latN}), res3)

res4 = res
res4@vpWidthF = plotWid*1.2
res4@gsnCenterString = "(d) A(t)"
res4@gsnYRefLine = 0.
res4@tiXAxisString = "year"
res4@tiYAxisString = ""
;res4@xyLineColor = "red"
if .not.autoTicks
  res4@tmYLMode = "Manual"
  res4@tmYLTickStartF   = -1.5
  res4@tmYLTickSpacingF = 0.5
  res4@tmYLTickEndF     = 1.5
  res4@trYMinF = -1.5
  res4@trYMaxF = 1.5
end if
plot(3) = gsn_csm_xy(wks, lineX, Bt, res4)

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
gsn_panel(wks, plot, (/3,3/), resP)

resText = True
resText@txFontHeightF = resP@gsnPanelFigureStringsFontHeightF
;gsn_text_ndc(wks, "(g) PCs", 0.18, 0.34, resText)

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
;-------------------------------------------------------{{{1
; vim:fdm=marker:fdl=0:
; vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
