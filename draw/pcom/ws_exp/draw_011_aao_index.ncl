
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2014-12-22 21:09:54 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

datDir  = getenv("NCL_ARG_1")
img     = getenv("NCL_ARG_2")
autoTicks = True

function get_idx(fname, varName)
;{{{
local idx, f
begin
  f = addfile(fname,"r")
  idx = f->$varName$
  delete(f)

  yyyymm = cd_calendar(idx&time, -1)
  yrfrac = yyyymm_to_yyyyfrac(yyyymm, 0.0)
  
  time = yrfrac
  idx&time = time
  return idx
end
;}}}

function low_pass(idx, year)
;{{{
local idxLPF, time
begin
  time = idx&time

  ihp = 0
  sigma = 1.0
  nWgt = 121
  fca = 1./(year*12.)
  wgt = filwgts_lanczos(nWgt, ihp, fca, -999., sigma)

  idxBPF = wgt_runave_n_Wrap(idx, wgt, 0, 0)
  return idxBPF
end
;}}}

;  cmap = "NCL_default"
;  cmap = "GMT_jet"
cmap    = "WhiteBlueGreenYellowRed"

; 60S, 120W
idx = get_idx( "/home/ou/archive/data/enso_ao_aao/monthly.aao.index.b79.current.nc", "idx")

time = idx&time
runAvg = runave_n_Wrap(idx, 121, 0, 0)
idxLPF = low_pass(idx, 9)

fontSize = 0.03
yLabelSize = fontSize*0.8
xLabelSize = fontSize*0.8
plotWid = 0.9
plotHei = 0.2
yTitle = idx@units
xTitle = "year"

;************************************
; compute wavelet
;************************************
N     = dimsizes(time)
;{{{
mother  = 0
param   = 6.0
dt      = 1./12.    ;timesteps in units of years
s0      = dt
dj      = 0.25
jtot    = 1+floattointeger(((log10(N*dt/s0))/dj)/log10(2.))
npad    = N
nadof   = 0
noise   = 1
siglvl  = .05
isigtest= 0

w = wavelet(idx,mother,dt,param,s0,dj,jtot,npad,noise,isigtest,siglvl,nadof)
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
res@gsnCenterStringOrthogonalPosF = -0.2
res@tmXTOn = False
res@tmYROn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize
res@tmLabelAutoStride = True
;}}}

res_line = res
;{{{
res_line@gsnCenterStringParallelPosF = 0.17
res_line@gsnAboveYRefLineColor = "IndianRed2"
res_line@gsnBelowYRefLineColor = "SteelBlue2"
res_line@xyMonoLineColor = False
res_line@xyDashPattern = 0 ; solid
res_line@xyMarkLineMode = "Lines"
;  res_line@xyLineColors = (/"magenta1", "cyan", "red", "blue", "forestgreen"/)
;  res_line@xyLineColors = lineColors
;res_line@xyLineColor = "blue3"
res_line@xyLineThicknessF = 0.5
res_line@xyDashPattern = 0
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
res_cn@trYMinF = 0.5
res_cn@trYMaxF = 32
;if autoTicks
;  delete(res_cn@trYMinF)
;  delete(res_cn@trYMaxF)
;end if
res_cn@trYReverse          = True                  ; reverse y-axis
if (cmap.eq."WhiteBlueGreenYellowRed") then
  res_cn@gsnSpreadColorStart  = 20
end if
;}}}

plot = new(2, graphic)
res_idx = res_line
;{{{
res_idx@tiYAxisString = idx@units
res_idx@gsnYRefLine = 0
res_idx@gsnCenterStringOrthogonalPosF = -0.6
;res_idx@gsnCenterString = "AAO index"

res_idx@xyLineColor = "transparent"

;res_idx@tmYLPrecision = 6
res_idx@tmYLMinorOn = False
res_idx@tmXTLabelFontHeightF = xLabelSize *0.9
;res_idx@tmXTOn = True
;res_idx@tmXBOn = False
if .not.autoTicks then
  res_idx@tmYLMode = "Manual"
  res_idx@tmYLTickStartF   = idxMinMaxInc_d(0)
  res_idx@tmYLTickEndF     = idxMinMaxInc_d(1)
  res_idx@tmYLTickSpacingF = idxMinMaxInc_d(2)
  res_idx@trYMinF = idxMinMaxInc_d(0)
  res_idx@trYMaxF = idxMinMaxInc_d(1)
end if
;}}}
plot(0) = gsn_csm_xy(wks, time, idx, res_idx)

res_run = res_line
delete(res_run@gsnAboveYRefLineColor)
delete(res_run@gsnBelowYRefLineColor)
plot_run = gsn_csm_xy(wks, time, runAvg, res_run)
overlay(plot(0),plot_run)

res_wave = res_cn
;{{{
;res_wave@gsnCenterString = "Wavelet power spectum of AAO idx"
res_wave@gsnCenterStringOrthogonalPosF = -0.125
res_wave@cnFillOn             = True               ; turn on color for contours
;   res_wave@cnLineThicknessF = 0.5
res_wave@cnLevelSelectionMode = "ExplicitLevels"
res_wave@cnLevels = (/\
 2^0,\
 2^1,\
 2^2,\
 2^3,\
 2^4/)
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
res_sig@cnFillScaleF        = 0.5          ; add extra density
plot_sig = gsn_csm_contour(wks,sig,res_sig)
plot_sig = ShadeGtContour(plot_sig,1.,17)
;  plot(2) = plot_sig
overlay(plot(1),plot_sig)				; overlay probability plot onto power plot

resP = True
resP@gsnFrame = False
;   resP@gsnPanelBottom = 0.05
resP@gsnPanelXWhiteSpacePercent = 5
resP@gsnPanelYWhiteSpacePercent = 0
resP@gsnPanelRowSpec = True
;   resP@txString = "Sea surface salinity"
gsn_panel(wks, plot, (/1,1/), resP)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
