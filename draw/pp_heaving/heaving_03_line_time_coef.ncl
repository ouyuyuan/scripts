
; Description: analytical line plot, represents period of the perturbation
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2015-04-21 14:30:01 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

datDir = getenv("NCL_ARG_1")
img = getenv("NCL_ARG_2")

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;{{{

nyear = 60
coef = new(nyear+1,float)
coef = 0

do t = 1, nyear
  if t.le.10 then
    coef(t) = 0.1*t 
  else if t.le.20 then
    coef(t) = 1
  else if t.le.40 then
    coef(t) = 3 - t/10.0
  else if t.le.50 then
    coef(t) = -1
  else if t.le.nyear then
    coef(t) = t/10.0 - 6
  end if
  end if
  end if
  end if
  end if
end do

x = ispan(0,nyear,1)
y = coef

;}}}

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; plot model 
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

fontSize = 0.03
yLabelSize = fontSize*0.5
xLabelSize = fontSize*0.5
plotWid = 0.6
plotHei = 0.2
yTitle = "B(t)"
xTitle = "model year"
;autoTicks = False
autoTicks = True

wks = gsn_open_wks ("eps", img)

res = True
; {{{
res@vpWidthF = plotWid
res@vpHeightF = plotHei
;  res@vpXF = 0.2
;  res@vpYF = 0.9

res@tiXAxisFontHeightF = fontSize*0.5
res@tiYAxisString = yTitle
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

res@tmXTOn = False
res@tmYROn = False

res@tmYLMinorOn = False
res@tmXBMinorOn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize

res@tmXBMode    =   "Explicit"
res@tmXBValues  =   (/10, 20, 30, 40, 50, 60/)
res@tmXBLabels  = res@tmXBValues

res@tmXMajorGrid = True
res@tmXMajorGridLineDashPattern = 2
res@tmXMajorGridThicknessF = 0.5

res@tmYLPrecision = 2
if autoTicks
  delete(res@tmYLPrecision)
end if
; }}}

plot = gsn_csm_xy(wks, x, y, res)

txres               = True
txres@txFontHeightF = fontSize*0.5
txres@txJust = "CenterLeft"
text1 = "PCOM"
text2 = "SODA"

posx1 = 0.6
posy1 = 0.73
posx2 = posx1
posy2 = posy1 + 0.03

;gsn_text_ndc(wks, text1, posx1, posy1, txres)
;gsn_text_ndc(wks, text2, posx2, posy2, txres)

draw(plot)
frame(wks)
delete(wks)
system("eps2png_trim "+img)
