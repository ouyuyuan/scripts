
; Description: draw nino34 index from model output 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-20 19:10:30 BJT
; Last Change: 2015-01-21 09:45:20 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

datDir = getenv("NCL_ARG_1")
img  = getenv("NCL_ARG_2")
mb = stringtoint(getenv("NCL_ARG_3"))
me = stringtoint(getenv("NCL_ARG_4"))
newOldCalc = getenv("NCL_ARG_5")
wksType = getenv("NCL_ARG_6")

setfileoption("nc", "MissingToFillValue", False)

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

isPcom = False
if isStrSubset(datDir,"pcom") .and. .not.isStrSubset(datDir,"pcom_grid") then
  isPcom = True
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

; change missingvalue to fillvalue
procedure missing2fill (var:numeric)
begin
  var@_FillValue = default_fillvalue(typeof(var))
  var = where(var.gt.10e10, var@_FillValue, var)
  delete(var@missing_value)
end

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo


if newOldCalc.eq."newCalc" then
  ; calc. index
;{{{
  grid_info_file = "/snfs01/ou/data/pcom/grid_info.nc"

  nm = me-mb+1
  latS = -5
  latN = 5
  lonW = 360-170
  lonE = 360-120

  f = addfile(grid_info_file, "r")
  idx = f->idx(0,{latS:latN},{lonW:lonE})
  ds = f->ds({latS:latN},{lonW:lonE})
  delete(f)
  ds = where(idx.eq.1, ds, 0)

  time = ispan(mb,me,1)
  time@long_name = "time"
  if (mb.gt.6000) then
    time@units = "months since 0000-01-01"
  else
    time@units = "months since 0500-01-01"
  end if

  index = new(nm, float)
  index@units = "Celcius degree"
  index@long_name = "sea surface temperature"
  index!0 = "time"
  index&time = time
  index = 0

  do mo = mb, me
    fname = datDir+"monthly/"+sprinti( "N%0.8i.nc", mo )
    tempName = "pt"
    if isStrSubset(datDir,"soda") then
      fname = datDir+"yearly/"+sprinti( "year_%0.4i.nc", mo )
      tempName = "temp"
    end if
    print("processing "+fname+" ~ ~ ~ ~ ~ ~")

    f = addfile(fname, "r")
    temp = f->$tempName$(0,0,{latS:latN},{lonW:lonE})
    delete(f)
    missing2fill( temp )

    area = sum(ds)
    wgt = ds/area
    index({mo}) = sum(temp*wgt)
  end do

  fname = img+".nc"
  system("rm -f "+fname)
  f = addfile(fname, "c")
  f->index = index
  delete(f)
  delete(time)
;}}}
else
  ; read index
;{{{
  f = addfile(img+".nc","r")
  index = f->index({mb:me})
  delete(f)
  f = addfile(datDir+"../exp48_osc_yr_bcf/plot/"+getenv("NCL_ARG_0_base")+".nc","r")
  index_yr = f->index({mb:me})
  delete(f)
  index = index - index_yr
;}}}
end if

time_month = index&time
yyyymm = cd_calendar(time_month, -1)
yrfrac = yyyymm_to_yyyyfrac(yyyymm, 0.0)
time = yrfrac
if isPcom .and. time(0).gt.500
  time = time - 500
end if
index = dtrend_n(index, False, 0)

;do month = 1, 12
;  i = month-1
;  avg_mon = dim_avg_n(index(i::12), 0)
;  index(i::12) = index(i::12) - avg_mon
;end do

lineY1 = index
lineY2 = lineY1
lineX  = time

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; plot model
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

; wavelet
N     = dimsizes(time)
;{{{
mother  = 0
param   = 6.0
dt      = 1./12    ;timesteps in years
s0      = dt
dj      = 0.25
jtot    = 1+floattointeger(((log10(N*dt/s0))/dj)/log10(2.))
npad    = N
nadof   = 0
noise   = 1
siglvl  = .05
isigtest= 0

w = wavelet(lineY1,mother,dt,param,s0,dj,jtot,npad,noise,isigtest,siglvl,nadof)
power            = onedtond(w@power,(/jtot,N/))
power!0          = "period"                        ; Y axis
power&period     = w@period                      ; convert period to units of years
power!1          = "time"                          ; X axis
power&time       = time

; compute significance ( >= 1 is significant)
sig              = power                            ; transfer meta data
sig              = power/conform (power,w@signif,0)

w2 = wavelet(lineY2,mother,dt,param,s0,dj,jtot,npad,noise,isigtest,siglvl,nadof)
power2            = onedtond(w2@power,(/jtot,N/))
power2!0          = "period"                        ; Y axis
power2&period     = w2@period     ; convert period to units of years
power2!1          = "time"                          ; X axis
power2&time       = time

; compute significance ( >= 1 is significant)
sig2              = power2                            ; transfer meta data
sig2              = power2/conform (power,w@signif,0)
;}}}

coef = 10^4
power = power*coef
power2 = power2*coef

yMinMaxInc = (/-0.2, 0.2, 0.1/)
fontSize = 0.03
yLabelSize = fontSize*0.8
xLabelSize = fontSize*0.8
plotWid = 0.7
plotHei = 0.3
cbTitle = 1/coef + "unit^2"
titles = (/"a) exp_ctl", "b) exp_anom", \
"c) wavelet power spectrum of a)", "d) wavelet power spectrum of b)"/)
;yTitle = lineY1@units
yTitle = ""
xTitle = "year"
if isPcom
  xTitle = "model year"
end if
autoTicks = True
if isExp("exp24_")
  autoTicks = False
end if


;  cmap = "NCL_default"
;  cmap = "GMT_jet"
cmap    = "WhiteBlueGreenYellowRed"

wks = gsn_open_wks (wksType, img)
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
  res_cn@trYMaxF = 32
  if isExp("exp24_")
    res_cn@trYMaxF = 64
  end if
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
 res_wave@pmLabelBarWidthF = 0.9
 res_wave@pmLabelBarOrthogonalPosF = 0.1
 res_wave@pmLabelBarParallelPosF = 1.2
;}}}

res_sig = res_cn ; res_sig probability plots
;{{{
res_sig@cnLevelSelectionMode = "ManualLevels" ; set manual contour levels
res_sig@cnMinLevelValF      = 0.00        ; set min contour level
res_sig@cnMaxLevelValF      = 2.00        ; set max contour level
res_sig@cnLevelSpacingF     = 1.00        ; set contour spacing
res_sig@cnFillScaleF        = 0.8          ; add extra density
;}}}

plot = new(4, graphic)
;res_line@tiYAxisString = "10~S~-1~N~"+yTitle
res_line@tiMainString = titles(0)
plot(0) = gsn_csm_xy(wks, lineX, lineY1, res_line)
res_line@tiMainString = titles(1)
res_line@tiYAxisString = ""
plot(1) = gsn_csm_xy(wks, lineX, lineY2, res_line)

res_wave@tiMainString = titles(2)
plot(2) = gsn_csm_contour(wks, power, res_wave)
plot_sig = gsn_csm_contour(wks, sig, res_sig)
plot_sig = ShadeGtContour(plot_sig, 1., 17)
;  plot(2) = plot_sig
overlay(plot(2),plot_sig)				; overlay probability plot onto power plot

res_wave@lbLabelBarOn = False
res_wave@tiMainString = titles(3)
res_wave@tiYAxisString = ""
plot(3) = gsn_csm_contour(wks, power2, res_wave)
plot_sig2 = gsn_csm_contour(wks, sig2, res_sig)
plot_sig2 = ShadeGtContour(plot_sig2, 1., 17)
;  plot(3) = plot_sig
overlay(plot(3),plot_sig2)				; overlay probability plot onto power plot

resP = True
resP@gsnFrame = False
;resP@gsnPanelBottom = 0.05
resP@gsnPanelXWhiteSpacePercent = 5
resP@gsnPanelYWhiteSpacePercent = 5
resP@gsnPanelRowSpec = True
;resP@gsnPanelFigureStrings = (/"a)","b)","c)","d)"/)
;resP@gsnPanelFigureStringsFontHeightF = fontSize*0.6
;resP@gsnPanelFigureStringsPerimOn = False
;resP@amJust = "TopLeft"
;resP@amOrthogonalPosF = -0.8
gsn_panel(wks, plot, (/2,2/), resP)

; fixed the problem
txres               = True
txres@txFontHeightF = xLabelSize*0.65
posx = 0.285
posy = 0.08
gsn_text_ndc(wks, xTitle, posx, posy, txres)

frame(wks)
