
; Description: 4 subplots, each has multiple lines, and has two y-coordinates
;              the rightmost two subplots are used to served as lengend plac
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2015-03-22 20:24:45 BJT

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
nc = "calc_11_drake_transport.nc"
fname = "/home/ou/archive/data/soda/pcom_grid/post/"+nc
f = addfile(fname, "r")
soda = f->tran(:)
delete(f)

fname = datDir + nc
f = addfile(fname, "r")
pcom = f->tran(:)
delete(f)

;let soda correspond to the last years of PCOM
x1 = pcom&time
y1 = pcom

y2 = pcom ; let y2 the same size of y1
y2 = pcom@_FillValue

yS  = soda&time
yP  = pcom&time
nyS = dimsizes(yS)
nyP = dimsizes(yP)

x2 = x1
x2 = x1 + yS(nyS-1) - yP(nyP-1)

if nyS.lt.nyP then
  y2(nyP-nyS:) = soda
else
  y2 = soda(nyS-nyP:)
end if
;}}}

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; plot model 
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

fontSize = 0.03
yLabelSize = fontSize*0.5
xLabelSize = fontSize*0.5
plotWid = 0.6
plotHei = 0.2
yTitle = "Sv"
x1Title = "model year"
x2Title = "year"
lineMinMaxInc = (/100, 160, 10/)
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
res@tiYAxisString = yTitle

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
res@tmYLLabelsOn = False
res@tmXUseBottom = False
res@tmXTLabelsOn = True

res@tmYLMinorOn = False
res@tmYRMinorOn = False
res@tmXBMinorOn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmYRLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize

res@tmYLPrecision = 2
if autoTicks
  delete(res@tmYLPrecision)
end if

if .not.autoTicks
  res@tmYLMode = "Manual"
  res@tmYLTickStartF   = lineMinMaxInc(0)
  res@tmYLTickSpacingF = lineMinMaxInc(2)
  res@tmYLTickEndF     = lineMinMaxInc(1)
  res@trYMinF = lineMinMaxInc(0)
  res@trYMaxF = lineMinMaxInc(1)
end if
; }}}

res1 = res
;{{{
res1@tiXAxisString = x1Title
res1@tiYAxisString = ""
res1@xyLineColor = "blue"
res1@tiXAxisFontColor = res1@xyLineColor
res1@tmXBLabelFontColor = res1@xyLineColor
res1@tmXBMajorLineColor = res1@xyLineColor

res1@tmXBMode    =   "Explicit"
res1@tmXBValues  =   (/99, 199, 299, 399, 499, 599, 699, 799/)
res1@tmXBLabels  = res1@tmXBValues + 1

;}}}

res2 = res
;{{{
res2@tiXAxisString = x2Title
res2@tiXAxisOffsetYF = -0.033
res2@tiXAxisOffsetXF = 0.15

res2@xyLineColor = "red"
res2@tiXAxisFontColor = res2@xyLineColor
res2@tmXTLabelFontColor = res2@xyLineColor
res2@tmXTMajorLineColor = res2@xyLineColor

res2@tmXTMode    =   "Explicit"
res2@tmXTValues  =   (/1908,2008/)
res2@tmXTLabels  = res2@tmXTValues

;}}}

plot = gsn_csm_x2y2(wks, x1, x2, y1, y2, res1, res2)

txres               = True
txres@txFontHeightF = fontSize*0.5
txres@txJust = "CenterLeft"
text1 = "PCOM"
text2 = "SODA"
txColor1 = res1@xyLineColor
txColor2 = res2@xyLineColor

posx1 = 0.6
posy1 = 0.73
posx2 = posx1
posy2 = posy1 + 0.03

txres@txFontColor = txColor1
gsn_text_ndc(wks, text1, posx1, posy1, txres)
txres@txFontColor = txColor2
gsn_text_ndc(wks, text2, posx2, posy2, txres)

draw(plot)
frame(wks)
delete(wks)
system("eps2png_trim "+img)
