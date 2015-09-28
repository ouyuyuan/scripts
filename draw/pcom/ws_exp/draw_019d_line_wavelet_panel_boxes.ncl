
; Description: top row: time series of a line
;              bottom row: the wavelet analysis of that time series
;              for compare varying nino regions
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-12 20:01:58 BJT
; Last Change: 2015-01-26 12:14:26 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

datDir  = getenv("NCL_ARG_1")
img     = getenv("NCL_ARG_2")
autoTicks = True

;guess data
;{{{
isNino = False
if isStrSubset(img, "___nino") then
  isNino = True
end if

isIshii = False
if isStrSubset(datDir, "Ishii") then
  isIshii = True
;  autoTicks = False
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

is120yr = False
if isSpinup .and. isStrSubset(img, "___120yr") then
  is120yr = True
end if

isExp24 = False
if isPcom .and. isStrSubset(datDir, "exp24") then
  isExp24 = True
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
if isPcom .and. isStrSubset(img, imgName) then
  Img = True
end if
return Img
end
;}}}

function get_sst_yearly(fname, varName)
;{{{
local sst, f
begin
  f = addfile(fname,"r")
  if isExp("exp_spinup").or.isExp("exp24_")
    sst = f->$varName$({501:740})
  end if
  sst = dtrend_n(sst, False, 0)
  delete(f)
;  sst = sst*10
;  sst@units = "~S~-1 o~N~C"
  sst@units = "~S~o~N~C"

  return sst
end
;}}}

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
nc = "calc_002c_sst_boxes.nc"
box1 = get_sst_yearly( datDir+nc, "box1")
box2 = get_sst_yearly( datDir+nc, "box2")
box3 = get_sst_yearly( datDir+nc, "box3")
box4 = get_sst_yearly( datDir+nc, "box4")
time  = box2&time
if isPcom
  time = time - 500
end if

lineY1 = box1
lineY2 = box2
lineY3 = box3
lineY4 = box4
lineX  = time

; wavelet
function get_wave(line, dt, time)
;  dt: timesteps in units of years
;{{{
local N, mother, param, s0, dj, jot, npad, nadof, noise, siglvl, isigtest, w
begin
  N     = dimsizes(time)
  mother  = 0
  param   = 6.0
  s0      = dt
  dj      = 0.25
  jtot    = 1+floattointeger(((log10(N*dt/s0))/dj)/log10(2.))
  npad    = N
  nadof   = 0
  noise   = 1
  siglvl  = .05
  isigtest= 0
  w = wavelet(line,mother,dt,param,s0,dj,jtot,npad,noise,isigtest,siglvl,nadof)
  return w
end
;}}}

function get_power(w)
;{{{
local power, jtot, N
begin
  jtot = dimsizes(w@dof)
  N = dimsizes(w@coi)
  power            = onedtond(w@power,(/jtot,N/))
  power!0          = "period"                        ; Y axis
  power&period     = w@period     ; convert period to units of years
  power!1          = "time"                          ; X axis
  power&time       = time
  return power
end
;}}}

function get_sig(w, power)
;{{{
local sig
begin
  ; compute significance ( >= 1 is significant)
  sig              = power                            ; transfer meta data
  sig              = power/conform (power,w@signif,0)
  return sig
end
;}}}

dt = 1.
wave1 = get_wave(lineY1, dt, time)
wave2 = get_wave(lineY2, dt, time)
wave3 = get_wave(lineY3, dt, time)
wave4 = get_wave(lineY4, dt, time)

pow1 = get_power(wave1)
pow2 = get_power(wave2)
pow3 = get_power(wave3)
pow4 = get_power(wave4)

sig1 = get_sig(wave1, pow1)
sig2 = get_sig(wave2, pow2)
sig3 = get_sig(wave3, pow3)
sig4 = get_sig(wave4, pow4)

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; plot model
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

yMinMaxInc = (/-0.1, 0.1, 0.05/)
fontSize = 0.04
yLabelSize = fontSize*0.8
xLabelSize = fontSize*0.8
plotWid = 0.6
plotHei = 0.3
cbTitle = "unit^2"
titles = (/\
"a) box1",\
"b) box2",\
"c) box3",\
"d) box4",\
"e) wavelet of a)", \
"f) wavelet of b)", \
"g) wavelet of c)", \
"h) wavelet of d)"/)
yTitle = lineY1@units
xTitle = "year"
if isPcom
  xTitle = "model year"
end if
if isExp("exp24_") .or. isExp("exp_spinup")
;  autoTicks = False
end if

;  cmap = "NCL_default"
;  cmap = "GMT_jet"
cmap    = "WhiteBlueGreenYellowRed"

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks,cmap)

res = True
;{{{
res@vpWidthF = plotWid
res@vpHeightF = plotHei
;  res@vpXF = 0.1
;  res@vpYF = 0.9
res@tiXAxisString = xTitle
res@tiXAxisFontHeightF = fontSize
res@tiMainFontHeightF = fontSize
res@gsnDraw = False
res@gsnFrame = False
res@gsnStringFontHeightF = fontSize
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
;res@gsnCenterStringOrthogonalPosF = -0.2
res@tmXTOn = False
res@tmYROn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize
res@tmLabelAutoStride = True
;}}}

res_line = res
;{{{
res_line@tiYAxisString = yTitle
res_line@gsnYRefLine = 0.
;res_line@gsnCenterStringOrthogonalPosF = -0.2
;res_line@gsnCenterString = lineY1@long_name
;res_line@gsnCenterStringParallelPosF = 0.17
res_line@gsnAboveYRefLineColor = "IndianRed2"
res_line@gsnBelowYRefLineColor = "SteelBlue2"
res_line@xyMonoLineColor = False
res_line@xyDashPattern = 0 ; solid
res_line@xyMarkLineMode = "Lines"
;  res_line@xyLineColors = (/"magenta1", "cyan", "red", "blue", "forestgreen"/)
;  res_line@xyLineColors = lineColors
;res_line@xyLineColor = "blue3"
res_line@xyLineColor = "transparent"
res_line@xyLineThicknessF = 0.5
res_line@xyDashPattern = 0
;  res_line@tmXBMode = "Explicit"
;  res_line@tmXBValues = xTicks
;  res_line@tmXBLabels = xTicks

;res_line@tmYLPrecision = 6
res_line@tmYLMinorOn = False
;res_line@tmXUseBottom = False
;res_line@tmXTLabelsOn = True
res_line@tmXTLabelFontHeightF = xLabelSize *0.9
res_line@tmXTOn = False
;res_line@tmXBOn = False

if .not.autoTicks then
  res_line@tmYLMode = "Manual"
  res_line@tmYLTickStartF   = yMinMaxInc(0)
  res_line@tmYLTickEndF     = yMinMaxInc(1)
  res_line@tmYLTickSpacingF = yMinMaxInc(2)
  res_line@trYMinF = yMinMaxInc(0)
  res_line@trYMaxF = yMinMaxInc(1)
end if
;}}}

res_cn = res
;{{{
res_cn@vpHeightF = plotHei*2
res_cn@tiYAxisString = "period (year)"
;   res_cn@gsnYAxisIrregular2Linear = True
 res_cn@cnLinesOn            = False              ; turn off contour lines
 res_cn@cnLineLabelsOn       = False              ; turn off contour line labels
 res_cn@cnInfoLabelOn        = False      ; turns off contour info label
;  res_cn@cnMissingValFillColor = "gray60"
;   res_cn@cnFillMode = "RasterFill"
;   res_cn@lbPerimOn                = False             ; no box around it
res_cn@lbLabelFontHeightF = fontSize*0.8
res_cn@tmYLMode = "Explicit"
res_cn@tmYLValues = (/1,2,4,8,16,32,64,128/)
res_cn@tmYLLabels = (/"1","2","4","8","16","32","64","128"/)
if .not. autoTicks
  res_cn@trYMinF = 2
  res_cn@trYMaxF = 128
end if
res_cn@trYReverse          = True                  ; reverse y-axis
if (cmap.eq."WhiteBlueGreenYellowRed") then
  res_cn@gsnSpreadColorStart  = 20
end if
;}}}

res_wave = res_cn
;{{{
;res_wave@gsnCenterString = "Wavelet power spectrum of "+lineY1@long_name
;res_wave@gsnCenterStringOrthogonalPosF = -0.125
 res_wave@cnFillOn             = True               ; turn on color for contours
;   res_wave@cnLineThicknessF = 0.5
if .not.autoTicks
  res_wave@cnLevelSelectionMode = "ExplicitLevels"
; {{{
  res_wave@cnLevels = (/\
   2^-3,\
   2^-2.5,\
   2^-2,\
   2^-1.5,\
   2^-1,\
   2^-0.5,\
   2^0,\
   2^0.5,\
   2^1,\
   2^1.5,\
   2^2,\
   2^2.5,\
   2^3,\
   2^3.5,\
   2^4/)
; }}}
end if

;   res_wave@lbLabelBarOn = False
;res_wave@lbOrientation = "vertical"
;   res_wave@lbLabelStride            = 5
;   res_wave@lbLabelPosition = "Top"
 res_wave@lbTitleString = cbTitle
;   res_wave@lbTitlePosition = "Right"
 res_wave@lbTitleFontHeightF = fontSize*0.8
;   res_wave@lbTitleOffsetF = 0.1
 res_wave@lbBoxLinesOn = False

 res_wave@pmLabelBarHeightF = 0.12
; res_wave@pmLabelBarWidthF = 0.9
 res_wave@pmLabelBarOrthogonalPosF = 0.1
; res_wave@pmLabelBarParallelPosF = 2.5
;}}}

res_sig = res_cn ; res_sig probability plots
;{{{
res_sig@cnLevelSelectionMode = "ManualLevels" ; set manual contour levels
res_sig@cnMinLevelValF      = 0.00        ; set min contour level
res_sig@cnMaxLevelValF      = 2.00        ; set max contour level
res_sig@cnLevelSpacingF     = 1.00        ; set contour spacing
res_sig@cnFillScaleF        = 0.8          ; add extra density
;}}}

plot = new(8, graphic)
;res_line@tiYAxisString = "10~S~-1~N~"+yTitle
res_line@tiMainString = titles(0)
plot(0) = gsn_csm_xy(wks, lineX, lineY1, res_line)
res_line@tiMainString = titles(1)
res_line@tiYAxisString = ""
plot(1) = gsn_csm_xy(wks, lineX, lineY2, res_line)
res_line@tiMainString = titles(2)
res_line@tiYAxisString = ""
plot(2) = gsn_csm_xy(wks, lineX, lineY3, res_line)
res_line@tiMainString = titles(3)
res_line@tiYAxisString = ""
plot(3) = gsn_csm_xy(wks, lineX, lineY4, res_line)

;coef = 10^4
coef = 1.
pow1 = pow1*coef
pow2 = pow2*coef
pow3 = pow3*coef
pow4 = pow4*coef
;res_wave@lbTitleString = 1./coef+cbTitle
res_wave@tiMainString = titles(4)
res_wave@tiXAxisString = ""
plot(4) = gsn_csm_contour(wks, pow1, res_wave)
plot_sig1 = gsn_csm_contour(wks, sig1, res_sig)
plot_sig1 = ShadeGtContour(plot_sig1, 1., 17)
;  plot(4) = plot_sig
overlay(plot(4),plot_sig1)				; overlay probability plot onto pow plot

;res_wave@lbLabelBarOn = False
res_wave@tiMainString = titles(5)
res_wave@tiYAxisString = ""
;res_wave@tiXAxisString = "model year"
plot(5) = gsn_csm_contour(wks, pow2, res_wave)
plot_sig2 = gsn_csm_contour(wks, sig2, res_sig)
plot_sig2 = ShadeGtContour(plot_sig2, 1., 17)
overlay(plot(5),plot_sig2)				; overlay probability plot onto power plot

res_wave@tiMainString = titles(6)
res_wave@tiYAxisString = ""
plot(6) = gsn_csm_contour(wks, pow3, res_wave)
plot_sig3 = gsn_csm_contour(wks, sig3, res_sig)
plot_sig3 = ShadeGtContour(plot_sig3, 1., 17)
overlay(plot(6),plot_sig3)				; overlay probability plot onto power plot

res_wave@tiMainString = titles(7)
res_wave@tiYAxisString = ""
plot(7) = gsn_csm_contour(wks, pow4, res_wave)
plot_sig4 = gsn_csm_contour(wks, sig4, res_sig)
plot_sig4 = ShadeGtContour(plot_sig4, 1., 17)
overlay(plot(7),plot_sig4)				; overlay probability plot onto power plot

resP = True
resP@gsnFrame = False
;resP@gsnPanelBottom = 0.05
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 5
resP@gsnPanelRowSpec = True
;resP@gsnPanelFigureStrings = (/"a)","b)","c)","d)"/)
;resP@gsnPanelFigureStringsFontHeightF = fontSize*0.6
;resP@gsnPanelFigureStringsPerimOn = False
;resP@amJust = "TopLeft"
;resP@amOrthogonalPosF = -0.8
gsn_panel(wks, plot, (/4,4/), resP)

; fixed the problem
txres               = True
txres@txFontHeightF = xLabelSize*0.65
posx = 0.285
posy = 0.08
;gsn_text_ndc(wks, xTitle, posx, posy, txres)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
