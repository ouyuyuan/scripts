
; Description: remove anthropogenic trend 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2014-12-14 15:20:19 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

datDir = getenv("NCL_ARG_1")
nc = getenv("NCL_ARG_1")+"ohc.nc"
img = getenv("NCL_ARG_2")
;guess data
;{{{
isIshii = False
if isStrSubset(datDir, "Ishii") then
  isIshii = True
end if

isSoda = False
if isStrSubset(datDir, "soda") then
  isSoda = True
end if
;}}}

;  cmap = "NCL_default"
;  cmap = "GMT_jet"
cmap = "WhiteBlueGreenYellowRed"

f = addfile( nc, "r" )
ohc_glo = f->glo
time = f->time
delete(f)
y_ori = dim_sum_n_Wrap(ohc_glo, 1)

y = y_ori
y = y*1.0e-26
y@units = "10~S~26~N~J"
y_mean = dim_avg_n(y,0)

; linear trend, four parts
y_d = y
y1_trend = y
y2_trend = y
procedure part_trend(yp_trend, yrb, yre)
local yp, tp, rp
begin
  yp = y({yrb:yre})
  tp = time({yrb:yre})
  rp = regline(tp, yp)
  yp_trend = y
  yp_trend = y@_FillValue
  yp_trend({yrb:yre}) = rp * (tp - rp@xave) + rp@yave
  yfluc = y - yp_trend
  y_d = where(.not.ismissing(yfluc), yfluc, y_d)
end
if isSoda
  part_trend(y1_trend, 1871, 1970)
  part_trend(y2_trend, 1970, 2008)
end if
if isIshii
  part_trend(y1_trend, 1945, 1970)
  part_trend(y2_trend, 1970, 2012)
end if

y_d@long_name = "detrended OHC"
y_d = y_d *1.0e4
y_d@units = "10~S~22~N~J"

N     = dimsizes(time)

y_trend = new((/2,N/), typeof(y))
y_trend(0,:) = y1_trend
y_trend(1,:) = y2_trend

fontSize = 0.03
yLabelSize = fontSize*0.8
xLabelSize = fontSize*0.8
plotWid = 0.8
plotHei = 0.12
xTitle = "year"
ohcMinMaxInc = (/13.921, 13.924, 0.001/)
ohcMinMaxInc_d = (/-9., 9.0, 9./)
if isIshii
  ohcMinMaxInc = (/5.7016, 5.7040, 0.0004/)
  ohcMinMaxInc_d = (/-4, 4, 2/)
end if
percentTicks = (/-0.00008, 0, 0.00008/)
if isIshii
  percentTicks = (/-0.0002, 0, 0.0002/)
end if
autoTicks = False
;autoTicks = True

; wavelet
; {{{
mother  = 0
param   = 6.0
dt      = 1.0    ;timesteps in units of years
s0      = dt
dj      = 0.25
jtot    = 1+floattointeger(((log10(N*dt/s0))/dj)/log10(2.))
npad    = N
nadof   = 0
noise   = 1
siglvl  = .05
isigtest= 0

w = wavelet(y_d,mother,dt,param,s0,dj,jtot,npad,noise,isigtest,siglvl,nadof)
;************************************
; create coodinate arrays for plot
;************************************
power            = onedtond(w@power,(/jtot,N/))
power!0          = "period"                        ; Y axis
power&period     = w@period                      ; convert period to units of years

power!1          = "time"                          ; X axis
power&time       = time

power@long_name  = "Power Spectrum"
power@units      = "1/unit-freq"

; compute significance ( >= 1 is significant)
sig              = power                            ; transfer meta data
sig              = power/conform (power,w@signif,0)
sig@long_name    = "Significance"
sig@units        = " "
;}}}

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
res@gsnDraw = False
res@gsnFrame = False
res@gsnStringFontHeightF = fontSize
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
;res@gsnCenterStringOrthogonalPosF = 0.01
res@tmXTOn = False
res@tmYROn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize
res@tmLabelAutoStride = True
;}}}

res_line = res
;{{{
res_line@gsnAboveYRefLineColor = "IndianRed2"
res_line@gsnBelowYRefLineColor = "SteelBlue2"
res_line@gsnCenterStringOrthogonalPosF = 0.1
res_line@xyMonoLineColor = False
res_line@xyDashPattern = 0 ; solid
res_line@xyMarkLineMode = "Lines"
;  res_line@xyLineColors = (/"magenta1", "cyan", "red", "blue", "forestgreen"/)
;  res_line@xyLineColors = lineColors
res_line@xyLineColor = "blue3"
res_line@xyLineThicknessF = 3
res_line@xyDashPattern = 0
;  res_line@tmYMajorGrid = True
;  res_line@tmYMajorGridLineDashPattern = 2
;  res_line@tmYMajorGridThicknessF = 0.5
;  res_line@tmXMajorGridThicknessF = 0.5
;  res_line@tmXBMode = "Explicit"
;  res_line@tmXBValues = xTicks
;  res_line@tmXBLabels = xTicks
; }}}

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
res_cn@trYMinF = 2
res_cn@trYMaxF = 100
if isIshii
  res_cn@trYMaxF = 64
end if
res_cn@trYReverse          = True                  ; reverse y-axis
if (cmap.eq."WhiteBlueGreenYellowRed") then
  res_cn@gsnSpreadColorStart  = 20
end if
;}}}

plot = new(3, graphic)
res_ohc = res_line
;{{{
res_ohc@tiYAxisString = y@units
res_ohc@tiXAxisString = ""
res_ohc@gsnYRefLine = dim_avg_n(y,0)
res_ohc@gsnCenterString = "OHC"

res_ohc@tmYLPrecision = 6
if autoTicks
  delete(res_ohc@tmYLPrecision)
end if
res_ohc@tmYLMinorOn = False
if .not.autoTicks then
  res_ohc@tmYLMode = "Manual"
  res_ohc@tmYLTickStartF   = ohcMinMaxInc(0)
  res_ohc@tmYLTickEndF     = ohcMinMaxInc(1)
  res_ohc@tmYLTickSpacingF = ohcMinMaxInc(2)
end if

res_ohc@tmYUseLeft = False
res_ohc@tmYRLabelsOn = True
res_ohc@tmYRLabelFontHeightF = yLabelSize *0.9
res_ohc@tmYROn = True
res_ohc@tmYRMode = "Explicit"
res_ohc@tmYRValues = percentTicks*y_mean + y_mean
res_ohc@tmYRLabels = percentTicks
if .not.autoTicks then
  res_ohc@trYMinF = ohcMinMaxInc(0)
  res_ohc@trYMaxF = ohcMinMaxInc(1)
end if
;}}}
plot(0) = gsn_csm_xy(wks, time, y, res_ohc)

res_trend = res_line
res_trend@xyLineColors = (/"forestgreen","forestgreen","forestgreen","forestgreen"/)
res_trend@xyLineThicknessF = 3
delete(res_trend@gsnAboveYRefLineColor)
delete(res_trend@gsnBelowYRefLineColor)

plot_trend = gsn_csm_xy(wks, time, y_trend, res_trend)
;  plot(0) = plot_trend
overlay(plot(0),plot_trend)

res_d = res_line
;{{{
res_d@tiYAxisString = y_d@units
res_d@gsnYRefLine = 0.
res_d@gsnCenterString = "Detrended OHC"
res_d@tmYLPrecision = 2
if autoTicks
  delete(res_d@tmYLPrecision)
end if
res_d@tmYLMinorOn = False
if .not.autoTicks then
  res_d@tmYLMode = "Manual"
  res_d@tmYLTickStartF   = ohcMinMaxInc_d(0)
  res_d@tmYLTickEndF     = ohcMinMaxInc_d(1)
  res_d@tmYLTickSpacingF = ohcMinMaxInc_d(2)
  res_d@trYMinF = ohcMinMaxInc_d(0)
  res_d@trYMaxF = ohcMinMaxInc_d(1)
end if
;}}}
plot(1) = gsn_csm_xy(wks, time, y_d, res_d)

res_wave = res_cn
;{{{
res_wave@gsnCenterString = "Wavelet power spectum of detrended OHC"
 res_wave@cnFillOn             = True               ; turn on color for contours
;   res_wave@cnLineThicknessF = 0.5
;   res_wave@cnLevelSelectionMode = "ManualLevels"
;   res_wave@cnMinLevelValF       = 1
;   res_wave@cnMaxLevelValF       = 7
;   res_wave@cnLevelSpacingF      = 0.1
 res_wave@cnLevelSelectionMode = "ExplicitLevels"
 res_wave@cnLevels = (/\
   2^0,\
   2^1,\
   2^2,\
   2^3,\
   2^4,\
   2^5,\
   2^6,\
   2^7,\
   2^8/)
if isIshii 
  delete(res_wave@cnLevels)
 res_wave@cnLevels = (/\
   2^0,\
   2^1,\
   2^2,\
   2^3,\
   2^4,\
   2^5,\
   2^6/)
end if
;   res_wave@cnFillColors = \
;    (/"magenta4", "blue2", "cyan3", \
;    "LightSteelBlue1",  "RosyBrown1", \
;    "yellow2", "orange1", "red3"/)
;   res_wave@lbLabelBarOn = False
res_wave@lbOrientation = "vertical"
;   res_wave@lbLabelStride            = 5
;   res_wave@lbLabelPosition = "Top"
 res_wave@lbTitleString = "unit^2"
;   res_wave@lbTitlePosition = "Right"
 res_wave@lbTitleFontHeightF = fontSize*0.8
;   res_wave@lbTitleOffsetF = 0.1
 res_wave@lbBoxLinesOn = False

 res_wave@pmLabelBarHeightF = 0.3
 res_wave@pmLabelBarWidthF = 0.01
 res_wave@pmLabelBarOrthogonalPosF = 0.01
 res_wave@pmLabelBarParallelPosF = 0.6
;}}}
plot(2) = gsn_csm_contour(wks,power,res_wave)

res_sig = res_cn ; res_sig probability plots
res_sig@cnLevelSelectionMode = "ManualLevels" ; set manual contour levels
res_sig@cnMinLevelValF      = 0.00        ; set min contour level
res_sig@cnMaxLevelValF      = 2.00        ; set max contour level
res_sig@cnLevelSpacingF     = 1.00        ; set contour spacing
res_sig@cnFillScaleF        = 0.8          ; add extra density
plot_sig = gsn_csm_contour(wks,sig,res_sig)
plot_sig = ShadeGtContour(plot_sig,1.,17)
;  plot(2) = plot_sig
overlay(plot(2),plot_sig)				; overlay probability plot onto power plot

 resP = True
 ;{{{
 resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
 resP@gsnPanelXWhiteSpacePercent = 5
 resP@gsnPanelYWhiteSpacePercent = 5
 resP@gsnPanelRowSpec = True

;   resP@txString = "Sea surface salinity"
;}}}
gsn_panel(wks, plot, (/1,1,1/), resP)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
