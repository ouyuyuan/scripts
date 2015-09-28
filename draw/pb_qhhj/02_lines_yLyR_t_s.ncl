
; Description: 4 subplots, each has multiple lines, and has two y-coordinates
;              the rightmost two subplots are used to served as lengend plac
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2015-09-11 14:50:47 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

datDir = "/home/ou/archive/data/pcom/exp_spinup/post/"
img    = "/home/ou/archive/drawing/pb_qhhj/" + getenv("NCL_ARG_0_base")


function get_line(fname, varName)
;{{{
begin
  f = addfile(fname, "r")
  line = f->$varName$
  delete(f)

  if (varName.eq."pt")
    line@units = "~S~o~N~C"
  end if
  if (varName.eq."sa")
    line@units = "psu"
  end if

  return line
end
;}}}

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;{{{
pt = get_line(datDir +"calc_08_glo_vol_ave_pt.nc", "pt")
sa = get_line(datDir +"calc_08_glo_vol_ave_sa.nc", "sa")
year = pt&$pt!0$

line1 = pt
line2 = sa
x = year
;}}}


;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; plot model 
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

fontSize = 0.03
yLabelSize = fontSize*0.5
xLabelSize = fontSize*0.5
plotWid = 0.6
plotHei = 0.2
yLTitle = line1@units
yRTitle = line2@units
xTitle = "model year"
lineLMinMaxInc = (/3.4, 4.4, 0.2/)
lineRMinMaxInc = (/34.5, 35.0, 0.05/)
autoTicks = False
;autoTicks = True

wks = gsn_open_wks ("eps", img)

res = True
; {{{
res@vpWidthF = plotWid
res@vpHeightF = plotHei
;  res@vpXF = 0.2
;  res@vpYF = 0.9

res@tiXAxisFontHeightF = fontSize*0.5
res@tiXAxisString = xTitle

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
res@xyMonoLineColor = False
res@xyLineThicknessF = 2

;res@tmXTOn = False
;res@tmYROn = False
res@tmYLMinorOn = False
res@tmYRMinorOn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmYRLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize
res@tmYUseLeft = False
res@tmYRLabelsOn = True

res@tmXBMode = "Manual"
res@tmXBTickSpacingF = 100
; }}}

resL = res
;{{{
resL@tiYAxisString = yLTitle
resL@tmYLPrecision = 2
if autoTicks
  delete(resL@tmYLPrecision)
end if

if .not.autoTicks
  resL@tmYLMode = "Manual"
  resL@tmYLTickStartF   = lineLMinMaxInc(0)
  resL@tmYLTickSpacingF = lineLMinMaxInc(2)
  resL@tmYLTickEndF     = lineLMinMaxInc(1)
  resL@trYMinF = lineLMinMaxInc(0)
  resL@trYMaxF = lineLMinMaxInc(1)
end if

resL@xyLineColor = "red"
resL@tiYAxisFontColor = resL@xyLineColor
resL@tmYLLabelFontColor = resL@xyLineColor
resL@tmYLMajorLineColor = resL@xyLineColor
;}}}

resR = res
;{{{
resR@tiYAxisString = yRTitle
resR@tmYRPrecision = 3
if autoTicks
  delete(resR@tmYRPrecision)
end if

if .not.autoTicks
  resR@tmYLMode = "Manual"
  resR@tmYLTickStartF   = lineRMinMaxInc(0)
  resR@tmYLTickEndF     = lineRMinMaxInc(1)
  resR@tmYLTickSpacingF = lineRMinMaxInc(2)
  resR@trYMinF = lineRMinMaxInc(0)
  resR@trYMaxF = lineRMinMaxInc(1)
end if

resR@xyLineColor = "blue"
resR@tiYAxisFontColor = resR@xyLineColor
resR@tmYRLabelFontColor = resR@xyLineColor
resR@tmYRMajorLineColor = resR@xyLineColor
;}}}

plot = gsn_csm_xy2(wks, x, line1, line2, resL, resR)

txres               = True
txres@txFontHeightF = fontSize*0.5
txres@txJust = "CenterLeft"
textL = "temperature"
textR = "salinity"
txColorL = resL@xyLineColor
txColorR = resR@xyLineColor

posxL = 0.22
posyL = 0.67
posxR = posxL
posyR = posyL - 0.03

txres@txFontColor = txColorL
gsn_text_ndc(wks, textL, posxL, posyL, txres)
txres@txFontColor = txColorR
gsn_text_ndc(wks, textR, posxR, posyR, txres)

draw(plot)
frame(wks)
delete(wks)
system("eps2png_trim "+img)
