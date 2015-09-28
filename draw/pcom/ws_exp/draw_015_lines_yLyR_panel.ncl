
; Description: 4 subplots, each has multiple lines, and has two y-coordinates
;              the rightmost two subplots are used to served as lengend plac
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2015-03-28 06:46:21 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

datDir = getenv("NCL_ARG_1")
img = getenv("NCL_ARG_2")

;guess data and img
;{{{
isOhc = False
if isStrSubset(img, "___ohc") then
  isOhc = True
end if

isDiff = False
if isStrSubset(img, "___diff") then
  isDiff = True
end if

isRevise = False
if isStrSubset(img, "___revise") then
  isRevise = True
end if

isDetrend = False
if isStrSubset(img, "___detrend") then
  isDetrend = True
end if

isIshii = False
if isStrSubset(datDir, "Ishii") then
  isIshii = True
end if

isSoda = False
if isStrSubset(datDir, "soda") then
  isSoda = True
end if

isPcom = False
if isStrSubset(datDir,"pcom") .and. .not.isStrSubset(datDir,"pcom_grid") then
  isPcom = True
end if

isSpinup = False
if isPcom .and. isStrSubset(datDir, "exp_spinup") then
  isSpinup = True
end if

isFullTime = False
if .not.isStrSubset(img,"___") then
  isFullTime = True
end if

is120yrs = False
if isStrSubset(img,"___120years") then
  is120yrs = True
end if

isSodaLen = False
if isStrSubset(img,"___soda_len") then
  isSodaLen = True
end if
;}}}

function isExp(expName)
;{{{
begin
Exp = False
if isPcom .and. isStrSubset(datDir, expName) then
  Exp = True
end if
return Exp
end
;}}}

function get_ohc_depths(fname, varName)
;{{{
local time
begin

  f = addfile(fname, "r")
  if isStrSubset(fname,"Ishii")
    ohc_basin = f->$varName$({1949:2008},:)
  else
    ohc_basin = f->$varName$({501:560},:)
  end if
  delete(f)
  time = ohc_basin&$ohc_basin!0$
  nt = dimsizes(time)

  ohc = new((/13, nt/), float)
  do i = 3, 15 ; 300 m ~ 1500 m
    depth = i*100
    ohc(i-3,:) = dim_sum_n(ohc_basin(:,{0:depth}), 1)
  end do

  ohc!1 = "time"
  ohc&time = time
  ohc = dim_rmvmean_n(ohc,1)
  ohc = ohc*1e-23
  ohc@units = "10~S~23~N~J"

  return ohc
end
;}}}

function get_sst(fname, varName)
;{{{
begin
  f = addfile(fname, "r")
  if isStrSubset(fname,"Ishii")
    sst = f->$varName$({1949:2008})
  else
    sst = f->$varName$({501:560})
  end if
  delete(f)
  sst = dim_rmvmean_n(sst,0)
  sst@units = "~S~o~N~C"

  return sst
end
;}}}

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;{{{
rootDir = "/home/ou/archive/data/"
nc = "calc_001_ohc.nc"
ohcObs = get_ohc_depths(rootDir+"Ishii/pcom_grid/post/"+nc, "Sou")
ohcAll = get_ohc_depths(rootDir+"pcom/exp43_clm_simu_60yrs/post/"+nc, "Sou")
ohcThe = get_ohc_depths(rootDir+"pcom/exp44_clm_thermal/post/"+nc, "Sou")
ohcWin = get_ohc_depths(rootDir+"pcom/exp45_clm_adi/post/"+nc, "Sou")
ohcSpi = get_ohc_depths(rootDir+"pcom/exp_spinup/post/"+nc, "Sou")

nc = "calc_002_sst.nc"
sstObs = get_sst(rootDir+"Ishii/pcom_grid/post/"+nc, "Sou")
sstAll = get_sst(rootDir+"pcom/exp43_clm_simu_60yrs/post/"+nc, "Sou")
sstThe = get_sst(rootDir+"pcom/exp44_clm_thermal/post/"+nc, "Sou")
sstWin = get_sst(rootDir+"pcom/exp45_clm_adi/post/"+nc, "Sou")

lines1 = ohcWin
lines1 = ohcWin - ohcSpi
lines2 = ohcThe
lines2 = ohcThe - ohcSpi
lines3 = ohcAll
lines3 = ohcAll - ohcSpi
lines4 = ohcObs

line1 = sstWin
line2 = sstThe
line3 = sstAll
line4 = sstObs

titles = (/"exp_ws","exp_th","exp_all","observation"/)

year = lines1&$lines1!1$
if isPcom
  year = year + 1949 - 501
end if

x = year
;}}}


;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; plot model 
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

;  cmap = "NCL_default"
;  cmap = "GMT_jet"
;  cmap = "WhiteBlueGreenYellowRed"
cmap = "BlGrYeOrReVi200"

fontSize = 0.03
yLabelSize = fontSize
xLabelSize = fontSize
plotWid = 0.7
plotHei = 0.4
yTitle = "OHC: "+lines1@units
yTitle_sst = "SSTa: "+line1@units
xTitle = "year"
linesMinMaxInc = (/-0.4, 0.4, 0.2/)
lineMinMaxInc  = (/-0.2, 0.2, 0.1/)
;autoTicks = False
autoTicks = True
if isExp("exp43")
  autoTicks = False
end if

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks,cmap)

 res = True
; {{{
res@vpWidthF = plotWid
res@vpHeightF = plotHei
;  res@vpXF = 0.2
;  res@vpYF = 0.9

res@tiXAxisFontHeightF = fontSize
res@tiXAxisString = ""

res@gsnDraw = False
res@gsnFrame = False
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
res@gsnStringFontHeightF = fontSize
res@gsnCenterStringOrthogonalPosF = -0.17
res@gsnYRefLine = 0.

res@xyDashPattern = 0 ; solid
res@xyMarkLineMode = "Lines"

;res@tmXTOn = False
;res@tmYROn = False
res@tmYLMinorOn = False
res@tmYRMinorOn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmYRLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize
; }}}

res_line = res
;{{{
res_line@tiYAxisString = yTitle_sst
res_line@xyLineThicknessF = 2

if .not.autoTicks
  res_line@tmYLMode = "Manual"
  res_line@tmYLTickStartF   = lineMinMaxInc(0)
  res_line@tmYLTickEndF     = lineMinMaxInc(1)
  res_line@tmYLTickSpacingF = lineMinMaxInc(2)
  res_line@trYMinF = lineMinMaxInc(0)
  res_line@trYMaxF = lineMinMaxInc(1)
end if

res_line@tmYRPrecision = 1
if autoTicks
  delete(res_line@tmYRPrecision)
end if
res@tmYUseLeft = False
res@tmYRLabelsOn = True
;}}}

res_lines = res
;{{{
res_lines@tiYAxisString = yTitle
res_lines@tmYLPrecision = 1
if autoTicks
  delete(res_lines@tmYLPrecision)
end if

if .not.autoTicks
  res_lines@tmYLMode = "Manual"
  res_lines@tmYLTickStartF   = linesMinMaxInc(0)
  res_lines@tmYLTickSpacingF = linesMinMaxInc(2)
  res_lines@tmYLTickEndF     = linesMinMaxInc(1)
  res_lines@trYMinF = linesMinMaxInc(0)
  res_lines@trYMaxF = linesMinMaxInc(1)
end if

res_lines@xyMonoLineColor = False
res_lines@xyLineColors = floattoint( fspan(20., 170., 13) )
if (cmap.eq."BlGrYeOrReVi200")then
  res_lines@xyLineColors = floattoint( fspan(2., 140., 13) )
end if
res_lines@xyLineThicknessF = 1.5
;}}}

plot = new(6, graphic)

res_lines@gsnCenterString = titles(0)

res_line@tiYAxisString = ""
plot(0) = gsn_csm_xy2(wks, x, lines1, line1, res_lines, res_line)

res_lines@gsnCenterString = titles(1)
res_lines@tiXAxisString = ""
res_lines@tiYAxisString = ""
res_line@tiYAxisString = yTitle_sst
plot(1) = gsn_csm_xy2(wks, x, lines2, line2, res_lines, res_line)

res_lines@gsnCenterString = titles(2)
res_lines@tiXAxisString = xTitle
res_lines@tiYAxisString = yTitle
res_line@tiYAxisString = ""
plot(3) = gsn_csm_xy2(wks, x, lines3, line3, res_lines, res_line)

res_lines@gsnCenterString = titles(3)
res_lines@tiXAxisString = xTitle
res_lines@tiYAxisString = ""
res_line@tiYAxisString = yTitle_sst
plot(4) = gsn_csm_xy2(wks, x, lines4, line4, res_lines, res_line)

resP = True
resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 5
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStrings = (/"(a)","(b)","","(c)","(d)",""/)
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.35
resP@gsnPanelFigureStringsPerimOn = False
resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.5
;   resP@txString = "Sea surface salinity"
gsn_panel(wks, plot, (/3,3/), resP)

; legend
txres               = True
;{{{
txres@txFontHeightF = fontSize*0.35
texts = (/ "0~~300 m", "  ~~400 m", "  ~~500 m", "  ~~600 m", "  ~~700 m", \
  "  ~~800 m", "  ~~900 m", "  ~~1000 m", "  ~~1100 m", "  ~~1200 m", \
  "  ~~1300 m", "  ~~1400 m", "  ~~1500 m"/)
dposy = 0.025
dposx = 0.1

posx = 0.72
posy = 0.67
txres@txFontColor = res_lines@xyLineColors(0)
gsn_text_ndc(wks, texts(0), posx, posy, txres)
do i = 1, 12 
  txres@txFontColor = res_lines@xyLineColors(i)
  posy = posy - dposy
  gsn_text_ndc(wks, texts(i), posx, posy, txres)
end do

posy = posy - dposy
txres@txFontColor = 1
gsn_text_ndc(wks, "  SSTA", posx, posy, txres)
;}}}

frame(wks)
delete(wks)
system("eps2png_trim "+img)
