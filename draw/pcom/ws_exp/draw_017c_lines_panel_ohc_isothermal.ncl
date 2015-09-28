
; Description: ocean heat content above varying isothermal lines
;              plus rightmost two subplots which are used to served as lengend plac
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-15 14:26:47 BJT
; Last Change: 2015-01-26 10:52:05 BJT

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

function isImg(imgName)
;{{{
begin
Img = False
if isStrSubset(img, imgName) then
  Img = True
end if
return Img
end
;}}}

function get_ohc(fname, varName, timescale)
;{{{
local time, tlev, ntlev
begin

  f = addfile(fname, "r")
  if isStrSubset(fname,"Ishii")
    ohc = f->$varName$({1949:2008},:)
  end if
  if isExp("exp24_")
    ohc = f->$varName$({501:740},{16:25})
  end if
  delete(f)
  time = ohc&$ohc!0$
  nt = dimsizes(time)

  ohc= dtrend_n(ohc, False, 0)
  if isImg("___nino34")
    ohc = ohc*1e-22
    ohc@units = "10~S~22~N~"+ohc@units
  else
    ohc = ohc*1e-23
    ohc@units = "10~S~23~N~"+ohc@units
  end if

  ; low pass filter
  dt = 1  ; year
  sigma = 1.0
  if timescale.eq."decadal" then
    ihp = 0 ; low pass
    t1 = 20; years
    nWgt = 19
    fca = 1./t1
    fcb = 999.

    wgt = filwgts_lanczos(nWgt, ihp, fca, fcb, sigma)
    ohcBPF = wgt_runave_n_Wrap(ohc, wgt, 1, 0)
    return ohcBPF(tlev|:,time|:)
  else if timescale.eq."ElNino" then
    ihp = 2 ; band pass
    t1 = 7 ; years
    t2 = 3
    nWgt = 5
    fca = 1./t1
    fcb = 1./t2

    wgt = filwgts_lanczos(nWgt, ihp, fca, fcb, sigma)
    ohcBPF = wgt_runave_n_Wrap(ohc, wgt, 1, 0)
    return ohcBPF(tlev|:,time|:)
  else
;    ohc = runave_n_Wrap(ohc, 10, 1, 0)
    return ohc(tlev|:,time|:)
  end if
  end if
end
;}}}

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;{{{
rootDir = "/home/ou/archive/data/"
nc = "calc_001d_ohc_isothermal.nc"
varName = "ohc_Pac_T"
if isImg("___nino34")
varName = "ohc_nino34"
end if
ohcSpin = get_ohc(rootDir+"pcom/exp_spinup/post/"+nc, varName, "")
ohcSpinDe = get_ohc(rootDir+"pcom/exp_spinup/post/"+nc, varName, "decadal")
ohcAnom = get_ohc(datDir+nc, varName, "")
ohcAnomDe = get_ohc(datDir+nc, varName, "decadal")

tlev = ohcSpin&tlev
nlines = dimsizes(tlev)
idx20 = ind(tlev.eq.20)

lines1 = ohcSpin
lines2 = ohcAnom
lines3 = ohcSpinDe
lines4 = ohcAnomDe

year = lines1&$lines1!1$
if isPcom
  year = year - 500
  if isExp("exp24_")
;    year = year - 40
  end if
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
plotHei = 0.5
titles = (/"a) exp_ctl", "b) exp_anom",\
           "c) low pass filter of a)", "d) low pass filter of b)"/)
yTitle = lines1@units
xTitle = "model year"
linesMinMaxInc = (/-1., 1.5, 0.5/)
if isImg("___nino34")
linesMinMaxInc = (/-1.5, 1.5, 0.5/)
end if
;autoTicks = False
autoTicks = True
if isExp("exp24_")
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

res@tiXAxisFontHeightF = xLabelSize
res@tiYAxisFontHeightF = yLabelSize
res@tiXAxisString = ""

res@gsnDraw = False
res@gsnFrame = False
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
res@gsnStringFontHeightF = xLabelSize
res@gsnCenterStringOrthogonalPosF = -0.2
res@gsnYRefLine = 0.

res@xyDashPattern = 0 ; solid
res@xyMarkLineMode = "Lines"

;res@tmXTOn = False
;res@tmYROn = False
res@tmYRLabelsOn = False
res@tmYLMinorOn = False
res@tmYRMinorOn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmYRLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize
; }}}

res_lines = res
;{{{
res_lines@tiYAxisString = yTitle
res_lines@tmYLPrecision = 2
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
res_lines@xyLineColors = floattoint( fspan(20., 170., nlines) )
if (cmap.eq."BlGrYeOrReVi200")then
  res_lines@xyLineColors = floattoint( fspan(2., 140., nlines) )
end if
res_lines@xyLineColors(idx20) = 1
res_lines@xyLineThicknessF = 2.
;}}}

res_line = res_lines
delete(res_line@xyLineColors)
res_line@xyLineColor = "black"
res_line@xyLineThicknessF = res_line@xyLineThicknessF*1.5
res_line@tiYAxisString = ""

plot = new(6, graphic)

res_lines@tiMainString = titles(0)
;res_lines@gsnCenterString = titles(0)
;plot(0) = gsn_csm_xy(wks, x, lines1, res_lines)
plot(0) = gsn_csm_xy2(wks, x, lines1, lines1(idx20,:), res_lines, res_line)

res_lines@tiMainString = titles(1)
;res_lines@gsnCenterString = titles(1)
res_lines@tiXAxisString = ""
res_lines@tiYAxisString = ""
;plot(1) = gsn_csm_xy(wks, x, lines2, res_lines)
plot(1) = gsn_csm_xy2(wks, x, lines2, lines2(idx20,:), res_lines, res_line)

res_lines@tiMainString = titles(2)
;res_lines@gsnCenterString = titles(2)
res_lines@tiXAxisString = ""
res_lines@tiYAxisString = yTitle
plot(3) = gsn_csm_xy2(wks, x, lines3, lines3(idx20,:), res_lines, res_line)

res_lines@tiMainString = titles(3)
;res_lines@gsnCenterString = titles(3)
res_lines@tiXAxisString = ""
res_lines@tiYAxisString = ""
plot(4) = gsn_csm_xy2(wks, x, lines4, lines4(idx20,:), res_lines, res_line)

resP = True
resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 5
resP@gsnPanelRowSpec = True
;resP@gsnPanelFigureStrings = (/"a)","","b)",""/)
;resP@gsnPanelFigureStringsFontHeightF = fontSize*0.35
;resP@gsnPanelFigureStringsPerimOn = False
;resP@amJust = "TopLeft5
;resP@amOrthogonalPosF = -0.5
;   resP@txString = "Sea surface salinity"
gsn_panel(wks, plot, (/3,3/), resP)

; legend
txres               = True
;{{{
txres@txFontHeightF = fontSize*0.4
degC = "~S~o~N~C"
texts = "> "+lines1&$lines1!0$ + degC
ntexts = dimsizes(texts)
dposy = 0.04
dposx = 0.1

posx = 0.7
posy = 0.7
txres@txFontColor = res_lines@xyLineColors(ntexts-1)
gsn_text_ndc(wks, texts(ntexts-1), posx, posy, txres)
do j = 0, ntexts-2
  i = ntexts - 2 - j
  txres@txFontColor = res_lines@xyLineColors(i)
  posy = posy - dposy
  gsn_text_ndc(wks, texts(i), posx, posy, txres)
end do
;}}}

frame(wks)
delete(wks)
system("eps2png_trim "+img)
