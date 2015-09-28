
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2014-12-22 16:30:11 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

datDir  = getenv("NCL_ARG_1")
img     = getenv("NCL_ARG_2")
nc      = datDir+"ohc.nc"

;guess data
;{{{
isGlo = False
if isStrSubset(img, "___glo") then
  isGlo = True
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

isExp24 = False
if isPcom .and. isStrSubset(datDir, "exp24") then
  isExp24 = True
end if

isExp33 = False
if isPcom .and. isStrSubset(datDir, "exp33") then
  isExp33 = True
end if

isExp34 = False
if isPcom .and. isStrSubset(datDir, "exp34") then
  isExp34 = True
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

;  cmap = "NCL_default"
;  cmap = "GMT_jet"
cmap    = "WhiteBlueGreenYellowRed"

f = addfile( nc, "r" )
ohc_glo = f->glo
if isSpinup .and. is120yrs then
  delete(ohc_glo)
  ohc_glo = f->glo({501:620}, :)
end if
if isSpinup.and. isSodaLen then
  delete(ohc_glo)
  ohc_glo = f->glo({501:638}, :)
end if
delete(f)

expYears = ohc_glo&time
nExpYears = dimsizes(expYears)
year1 = expYears(0)
year2 = expYears(nExpYears-1)
f = addfile(datDir+"../../exp_spinup/post/ohc.nc","r")
ohcSp = f->glo({year1:year2},:)
delete(f)
ohc_glo = ohc_glo - ohcSp

y = dim_sum_n_Wrap(ohc_glo, 1)
;f = addfile( datDir+"ohc_old.nc", "r" )
;delete(y)
;y = f->ohc_glo
;delete(f)
time = y&time
if isPcom
  time = time - 500
end if
y_d = dtrend(y, True)
y_d@long_name = "detrended OHC"
y_d = y_d *1.0e-22
y_d@units = "10~S~22~N~J"

y = y*1.0e-22
y@units = "10~S~22~N~J"
y_mean = dim_avg_n(y,0)

ohcMinMaxInc = (/14.343, 14.346, 0.001/)
ohcMinMaxInc_d = (/-0.7, 0.7, 0.7/)
if isIshii
  ohcMinMaxInc = (/5.701, 5.704, 0.001/)
  ohcMinMaxInc_d = (/-6, 7, 3/)
end if
if isSoda
  ohcMinMaxInc = (/13.921, 13.9235, 0.001/)
  ohcMinMaxInc_d = (/-12, 12, 6/)
end if
if isSpinup .and. isFullTime
  ohcMinMaxInc = (/14.340, 14.3465, 0.002/)
  ohcMinMaxInc_d = (/-1.0, 1.0, 0.5/)
end if
percentTicks = (/-0.00008, 0, 0.00008/)
if isIshii
  percentTicks = (/-0.0002, 0, 0.0002/)
end if
if isExp33
  percentTicks = (/-0.0001, 0, 0.0001/)
end if
if isSpinup .and. isFullTime
  percentTicks = (/-0.0002, 0, 0.0002/)
end if
;autoTicks = False
autoTicks = True

fontSize = 0.03
yLabelSize = fontSize*0.8
xLabelSize = fontSize*0.8
plotWid = 0.9
plotHei = 0.2
yTitle = y@units
xTitle = "year"
if isPcom
  xTitle = "model year"
end if

;************************************
; compute wavelet
;************************************
N     = dimsizes(time)
;{{{
mother  = 0
param   = 6.0
dt      = 1.    ;timesteps in units of years
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
;sigc = conform(power, w@signif, 0)
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
if .not.autoTicks
  res_cn@tmYLMode = "Explicit"
  res_cn@tmYLValues = (/1,2,4,8,16,32,64,128/)
  res_cn@tmYLLabels = (/"1","2","4","8","16","32","64","128"/)
  res_cn@trYMinF = 2
  res_cn@trYMaxF = 100
  if isSpinup .and. isFullTime
    res_cn@trYMaxF = 128
  end if
  if isIshii
    res_cn@trYMaxF = 64
  end if
end if
res_cn@trYReverse          = True                  ; reverse y-axis
if (cmap.eq."WhiteBlueGreenYellowRed") then
  res_cn@gsnSpreadColorStart  = 20
end if
;}}}

;plot = new(3, graphic)
plot = new(2, graphic)
res_ohc = res_line
;{{{
res_ohc@tiYAxisString = y@units
res_ohc@tiXAxisString = ""
res_ohc@gsnYRefLine = dim_avg_n(y,0)
res_ohc@gsnCenterString = "OHC"

res_ohc@tmYLPrecision = 6
if isSpinup .and. isFullTime
  res_ohc@tmYLPrecision = 5
end if
if isIshii
  res_ohc@tmYLPrecision = 4
end if
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

if .not.autoTicks then
  res_ohc@tmYUseLeft = False
  res_ohc@tmYRLabelsOn = True
  res_ohc@tmYRLabelFontHeightF = yLabelSize *0.9
  res_ohc@tmYROn = True
  res_ohc@tmYRMode = "Explicit"
  res_ohc@tmYRValues = percentTicks*y_mean + y_mean
  res_ohc@tmYRLabels = percentTicks
  res_ohc@trYMinF = ohcMinMaxInc(0)
  res_ohc@trYMaxF = ohcMinMaxInc(1)
end if
;}}}
plot(0) = gsn_csm_xy(wks, time, y, res_ohc)

res_d = res_line
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
;plot(1) = gsn_csm_xy(wks, time, y_d, res_d)

res_wave = res_cn
;{{{
res_wave@gsnCenterString = "Wavelet power spectum of OHC"
 res_wave@cnFillOn             = True               ; turn on color for contours
;   res_wave@cnLineThicknessF = 0.5
;   res_wave@cnLevelSelectionMode = "ManualLevels"
;   res_wave@cnMinLevelValF       = 1
;   res_wave@cnMaxLevelValF       = 7
;   res_wave@cnLevelSpacingF      = 0.1
if .not.autoTicks
 res_wave@cnLevelSelectionMode = "ExplicitLevels"
 res_wave@cnLevels = (/\
   2^-5,\
   2^-4,\
   2^-3,\
   2^-2,\
   2^-1,\
   2^0,\
   2^1,\
   2^2,\
   2^3/)
 if isExp24
   ;{{{
   delete(res_wave@cnLevels)
   res_wave@cnLevels = (/\
     2^-6,\
     2^-5,\
     2^-4,\
     2^-3,\
     2^-2,\
     2^-1,\
     2^0,\
     2^1,\
     2^2,\
     2^3,\
     2^4/)
   ;}}}
 end if
 if isExp33
   ;{{{
   delete(res_wave@cnLevels)
   res_wave@cnLevels = (/\
     2^-4,\
     2^-3,\
     2^-2,\
     2^-1,\
     2^0,\
     2^1,\
     2^2,\
     2^3,\
     2^4,\
     2^5,\
     2^6,\
     2^7,\
     2^8,\
     2^9,\
     2^10,\
     2^11/)
   ;}}}
 end if
 if isSpinup .and. is120yrs then
   ;{{{
   delete(res_wave@cnLevels)
   res_wave@cnLevels = (/\
     2^-7,\
     2^-6,\
     2^-5,\
     2^-4,\
     2^-3,\
     2^-2,\
     2^-1,\
     2^0,\
     2^1/)
   ;}}}
 end if
if isSpinup .and. isFullTime
   ;{{{
   delete(res_wave@cnLevels)
   res_wave@cnLevels = (/\
     2^-8,\
     2^-7,\
     2^-6,\
     2^-5,\
     2^-4,\
     2^-3,\
     2^-2,\
     2^-1,\
     2^0,\
     2^1,\
     2^2,\
     2^3,\
     2^4,\
     2^5/)
   ;}}}
end if
 if isSoda
   ;{{{
   delete(res_wave@cnLevels)
   res_wave@cnLevels = (/\
     2^1,\
     2^2,\
     2^3,\
     2^4,\
     2^5,\
     2^6,\
     2^7,\
     2^8,\
     2^9,\
     2^10,\
     2^11/)
   ;}}}
 end if
 if isIshii
   ;{{{
   delete(res_wave@cnLevels)
   res_wave@cnLevels = (/\
     2^1,\
     2^2,\
     2^3,\
     2^4,\
     2^5,\
     2^6,\
     2^7,\
     2^8,\
     2^9,\
     2^10,\
     2^11/)
   ;}}}
 end if
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

 res_wave@pmLabelBarHeightF = 0.5
 res_wave@pmLabelBarWidthF = 0.01
 res_wave@pmLabelBarOrthogonalPosF = 0.01
 res_wave@pmLabelBarParallelPosF = 0.6
;}}}
plot(1) = gsn_csm_contour(wks,power,res_wave)

res_sig = res_cn ; res_sig probability plots
res_sig@cnLevelSelectionMode = "ManualLevels" ; set manual contour levels
res_sig@cnMinLevelValF      = 0.00        ; set min contour level
res_sig@cnMaxLevelValF      = 2.00        ; set max contour level
res_sig@cnLevelSpacingF     = 1.00        ; set contour spacing
res_sig@cnFillScaleF        = 0.8          ; add extra density
plot_sig = gsn_csm_contour(wks,sig,res_sig)
plot_sig = ShadeGtContour(plot_sig,1.,17)
;  plot(2) = plot_sig
overlay(plot(1),plot_sig)				; overlay probability plot onto power plot

 resP = True
 resP@gsnFrame = False
;   resP@gsnPanelBottom = 0.05
 resP@gsnPanelXWhiteSpacePercent = 5
 resP@gsnPanelYWhiteSpacePercent = 10
if (isSpinup .and. isFullTime) .or. isIshii
 resP@gsnPanelYWhiteSpacePercent = 5
end if
;if isSoda
; resP@gsnPanelYWhiteSpacePercent = 5
;end if
 resP@gsnPanelRowSpec = True
;   resP@txString = "Sea surface salinity"
gsn_panel(wks, plot, (/1,1,1/), resP)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
