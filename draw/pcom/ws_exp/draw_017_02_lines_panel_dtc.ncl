
; Description: 2 subplots, each has multiple lines for isothermal depths
;              plus rightmost two subplots which are used to served as lengend plac
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-15 14:26:47 BJT
; Last Change: 2015-01-19 08:03:31 BJT

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

function get_dtc_basin(fname, varName, timescale)
;{{{
local time
begin

  f = addfile(fname, "r")
  if isStrSubset(fname,"Ishii")
    dtc_basin = f->$varName$({1949:2008},:)
  else
    dtc_basin = f->$varName$({501:620},:)
  end if
  delete(f)
  time = dtc_basin&$dtc_basin!0$
  nt = dimsizes(time)

  dtc_basin = dtrend_n(dtc_basin, False, 0)
;  dtc_basin = dim_rmvmean_n(dtc_basin, 0)

  ; low pass filter
  dt = 1  ; year
  sigma = 1.0
  if timescale.eq."decadal" then
    ihp = 0 ; low pass
    t1 = 10; years
    nWgt = 7
    fca = 1./t1
    fcb = 999.

    wgt = filwgts_lanczos(nWgt, ihp, fca, fcb, sigma)
    dtcBPF = wgt_runave_n_Wrap(dtc_basin, wgt, 0, 0)
    return dtcBPF(tlev|:,time|:)
  else if timescale.eq."ElNino" then
    ihp = 2 ; band pass
    t1 = 7 ; years
    t2 = 3
    nWgt = 5
    fca = 1./t1
    fcb = 1./t2

    wgt = filwgts_lanczos(nWgt, ihp, fca, fcb, sigma)
    dtcBPF = wgt_runave_n_Wrap(dtc_basin, wgt, 0, 0)
    return dtcBPF(tlev|:,time|:)
  else
    return dtc_basin(tlev|:,time|:)
  end if
  end if
end
;}}}

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;{{{
rootDir = "/home/ou/archive/data/"
nc = "calc_007_ave_isothermal.nc"
dtcSpin = get_dtc_basin(rootDir+"pcom/exp_spinup/post/"+nc, "nino3", "")
dtcSpinEl = get_dtc_basin(rootDir+"pcom/exp_spinup/post/"+nc, "nino3", "ElNino")
dtcSpinDe = get_dtc_basin(rootDir+"pcom/exp_spinup/post/"+nc, "nino3", "decadal")
dtcAnom = get_dtc_basin(rootDir+"pcom/exp24_taux_an_40y_N/post/"+nc, "nino3", "")
dtcAnomEl = get_dtc_basin(rootDir+"pcom/exp24_taux_an_40y_N/post/"+nc, "nino3", "ElNino")
dtcAnomDe = get_dtc_basin(rootDir+"pcom/exp24_taux_an_40y_N/post/"+nc, "nino3", "decadal")

tlev = dtcSpin&tlev
nlines = dimsizes(tlev)
idx20 = ind(tlev.eq.20)

lines1 = dtcSpin
lines2 = dtcAnom
lines3 = dtcSpinDe
lines4 = dtcAnomDe
lines5 = dtcSpinEl
lines6 = dtcAnomEl

year = lines1&$lines1!1$
if isPcom
  year = year - 500
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
yLabelSize = fontSize*0.9
xLabelSize = fontSize*0.9
plotWid = 0.8
plotHei = 0.3
titles = (/"a) exp_ctl", "b) exp_anom",\
           "c) exp_ctl, decadal timescale", "d) exp_anom, decadal timescale",\
           "e) exp_ctl, El Nino timescale", "f) exp_anom, El Nino timescale"/)
yTitle = "depth("+lines1@units+")"
xTitle = "model year"
linesMinMaxInc = (/-4., 4., 2./)
;autoTicks = False
autoTicks = True
if isExp("exp24")
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
res_lines@xyLineColors = floattoint( fspan(20., 170., nlines) )
if (cmap.eq."BlGrYeOrReVi200")then
  res_lines@xyLineColors = floattoint( fspan(2., 140., nlines) )
end if
res_lines@xyLineColors(idx20) = 1
res_lines@xyLineThicknessF = 1.5
;}}}

res_line = res_lines
delete(res_line@xyLineColors)
res_line@xyLineColor = "black"
res_line@xyLineThicknessF = res_line@xyLineThicknessF*1.5
res_line@tiYAxisString = ""

plot = new(6, graphic)

;res_lines@tiMainString = "a) exp_ctl"
res_lines@gsnCenterString = titles(0)
;plot(0) = gsn_csm_xy(wks, x, lines1, res_lines)
plot(0) = gsn_csm_xy2(wks, x, lines1, lines1(idx20,:), res_lines, res_line)

;res_lines@tiMainString = "b) exp_anom"
res_lines@gsnCenterString = titles(1)
res_lines@tiXAxisString = ""
res_lines@tiYAxisString = ""
;plot(1) = gsn_csm_xy(wks, x, lines2, res_lines)
plot(1) = gsn_csm_xy2(wks, x, lines2, lines2(idx20,:), res_lines, res_line)

res_lines@gsnCenterString = titles(2)
res_lines@tiXAxisString = ""
res_lines@tiYAxisString = yTitle
plot(3) = gsn_csm_xy2(wks, x, lines3, lines3(idx20,:), res_lines, res_line)

res_lines@gsnCenterString = titles(3)
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
gsn_panel(wks, plot, (/3,3,3/), resP)

; legend
txres               = True
;{{{
txres@txFontHeightF = fontSize*0.31
degC = "~S~o~N~C"
texts = lines1&$lines1!0$ + degC
ntexts = dimsizes(texts)
dposy = 0.03
dposx = 0.1

posx = 0.68
posy = 0.7
txres@txFontColor = res_lines@xyLineColors(ntexts-1)
gsn_text_ndc(wks, texts(ntexts-1), posx, posy, txres)
do i = 1, 11 
  txres@txFontColor = res_lines@xyLineColors(ntexts-1-i)
  posy = posy - dposy
  gsn_text_ndc(wks, texts(ntexts-1-i), posx, posy, txres)
end do
;}}}

frame(wks)
delete(wks)
system("eps2png_trim "+img)
