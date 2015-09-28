
; Description: for comparison with NOAA result
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-11 10:54:25 BJT
; Last Change: 2014-11-16 19:17:43 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure draw_ohc(lines, year, inres, arg)
begin

  img = arg@img
  wks = gsn_open_wks ("eps", img)

  res = True

;  res@vpHeightF = 0.56
;  res@vpWidthF = 0.72

  res@tiXAxisString = "year"

  res@gsnDraw = False
  res@gsnFrame = False
  res@gsnLeftString = ""
  res@gsnRightString = ""

  res@xyMonoLineColor = False
  res@xyDashPattern = 0 ; solid
  ;   res@xyMarkLineMode = "MarkLines"
  res@xyMarkLineMode = "Lines"
  ;   res@xyMarkers = (/6, 11, 16/)
;     res@xyMarkerColors = (/"blue", "red", "forestgreen"/)
;  res@xyMarkerColors = (/"black", "blue", "red"/)
;  res@xyLineColors = (/"magenta1", "cyan", "red", "blue", "forestgreen"/)
  res@xyLineThicknessF = 3
  res@xyDashPattern = 0

  res@lgPerimOn = False
  res@lgLabelFontHeightF = 0.02
  res@lgPerimFill = "SolidFill"
  res@lgPerimFillColor = "White"

  res@pmLegendDisplayMode = "Always"
  res@pmLegendSide = "Right"
;  res@pmLegendOrthogonalPosF = -0.45
  res@pmLegendWidthF = 0.1
;  res@pmLegendHeightF = 0.5

  res@tmLabelAutoStride = True
  
;  res@tmYROn = False
;  res@tmXTOn = False
  res@tmYMajorGrid = True
  res@tmYMajorGridLineDashPattern = 2
  res@tmYMajorGridThicknessF = 0.5
;  res@tmYLTickStartF   = -80
;  res@tmYLTickSpacingF = 20
;  res@tmYLTickEndF     = 80
  res@tmXMajorGridThicknessF = 0.5

;  res@tmXBMode = "Manual"
;  res@tmXBTickStartF   = 0
;  res@tmXBTickSpacingF = 50
;  res@tmXBTickEndF     = 500
  res@tmXMajorGrid = True
  res@tmXMajorGridLineDashPattern = 2

;   res@trXMaxF = 50
;   res@trXMinF = 10
  ;   res@trYReverse               = True   ; reverses y-axis

  copy_VarAtts(inres, res)
  plot = gsn_csm_xy(wks, year, lines, res)

;  if (isatt(arg, "plotwidth")) then
;    txres               = True
;    text = "aaaa "
;    gsn_text_ndc(wks, text, arg@plotwidth, 0.5, txres)
;  end if

  draw(plot)
  frame(wks)

  delete(wks)
  system("eps2png_trim " + arg@img)
end

arg = True

; ohc by depth
;==============
datDir = getenv("NCL_ARG_1")
imgDir = getenv("NCL_ARG_2")
img = imgDir + getenv("NCL_ARG_0_base")
arg@img = img

itStart = 120 ; remove the first 10 years

f = addfile(datDir+"ohc_700_Glo.nc","r")
ohc700 = f->ohc(itStart:)
delete(f)
f = addfile(datDir+"ohc_1500_Glo.nc","r")
ohc1500 = f->ohc(itStart:)
delete(f)

yyyymm = cd_calendar(ohc700&time, -1)
yrfrac = yyyymm_to_yyyyfrac(yyyymm, 0.0)

baseStrt = 197001
baseLast = 200812
itS = ind(yyyymm.eq.baseStrt)
itL = ind(yyyymm.eq.baseLast)

ohc700 = ohc700 - dim_avg_n(ohc700(itS:itL),0)
ohc1500 = ohc1500 - dim_avg_n(ohc1500(itS:itL),0)

nrun = 12
endopt = 1
ohc700 = runave_n_Wrap( ohc700, nrun, endopt, 0)
ohc1500 = runave_n_Wrap( ohc1500, nrun, endopt, 0)

lines= new( (/2, dimsizes(yyyymm)/), float )
lines(0,:) = ohc700
lines(1,:) = ohc1500

lines = lines * 1.0e-23

res = True
res@tiMainString = "Global ocean heat content"
res@tiYAxisString = "10~S~23~N~J"

res@xyLineColors = (/"red", "blue"/)
res@xyExplicitLegendLabels = (/"0-700m", "0-1500m"/)
res@xyDashPatterns = (/0,0/) ; 0: solid

res@pmLegendOrthogonalPosF = -0.9
res@pmLegendParallelPosF = 0.8
res@pmLegendHeightF = 0.1

draw_ohc(lines, yrfrac, res, arg)
