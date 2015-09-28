
; Description: EOF of MOC
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2015-07-22 19:28:57 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$HOME/archive/scripts/utils/pcom.ncl"

;img, dirs, and data files------------------------------{{{1
datDir    = "/home/ou/archive/data/pcom/"
img       = getenv("NCL_ARG_2")

refDir    = "exp_spinup/post/"

expDirP1   = "exp71_heaving_b_Pac_20S-20N/post/"
expDirP2   = "exp72_heaving_b_Pac_0N-40N/post/"
expDirP3   = "exp75_heaving_b_Pac_0S-40S/post/"

expDirA1   = "exp78_heaving_b_Atl_20S-20N/post/"
expDirA2   = "exp79_heaving_b_Atl_0N-40N/post/"
expDirA3   = "exp89_heaving_b_Atl_0S-40S/post/"

nc = "calc_10b_moc_years.nc"


;---get plotting data-----------------------------------{{{1

;---get coordinates infos array definition--------------{{{2
f = addfile(datDir+expDirP1+nc, "r")
time = f->time
lat = f->lat
z = f->z
delete(f)
time = time - 600
nt = dimsizes(time)
nz = dimsizes(z)
nlat = dimsizes(lat)

procedure get_eof(expDir, pat, pc, var, reverse) ;{{{2
;-----------------------------------------------------------
; return the eof pattern, PC, and explained variance 
;   of a specific experiments of Pacific
;-----------------------------------------------------------
local moc, mocR, eof, ts
begin
  f = addfile(datDir + expDir + nc, "r")
  moc = f->mocGlo
  delete(f)

;  f = addfile(datDir + expDirRef + nc, "r")
;  mocR = f->mocPac
;  delete(f)
;  moc = moc - mocR
  moc&time = moc&time - 600

  eof = new((/2,nz,nlat/), "float")
  ts = new((/2,nt/), "float")

  pcom_eof(moc, eof, ts)

  pat = moc(0,:,:)
  pat = eof(0,:,:)
  pc = ts(0,:)
  var= sprintf("%4.1f",eof@pcvar(0))+"%"

  if (.not.ismissing(reverse).and.reverse.eq."reverse") then
    pat = pat*(-1)
    pc = pc*(-1)
  end if
end 

;---define coutours and lines for holding plotting data-{{{2
cnP1   = new((/nz,nlat/),"float")
var1  = "EOF1: (xx%)"

cnP2   = cnP1
var2  = var1

cnP3   = cnP1
var3  = var1

cnA1   = cnP1
var4  = var1

cnA2   = cnP1
var5  = var1

cnA3   = cnP1
var6  = var1

lines = new((/6,nt/),"float")
;---get plotting data by calling procedure--------------{{{2
get_eof(expDirP1, cnP1, lines(0,:), var1, "reverse")
get_eof(expDirP2, cnP2, lines(1,:), var2, "reverse")
get_eof(expDirP3, cnP3, lines(2,:), var3, "reverse")
get_eof(expDirA1, cnA1, lines(3,:), var4, "reverse")
get_eof(expDirA2, cnA2, lines(4,:), var5, "reverse")
get_eof(expDirA3, cnA3, lines(5,:), var6, "reverse")

lineX = time

;---plotting parameters---------------------------------{{{1
;  cmap = "NCL_default"
;  cmap = "GMT_jet"
;  cmap = "WhiteBlueGreenYellowRed"
;cmap = "BlGrYeOrReVi200"
cmap = "NCV_blu_red"

fontSize = 0.02
yLabelSize = fontSize*0.9
xLabelSize = fontSize*0.9
plotWid = 0.4
plotHei = 0.2
yTitleCn = "depth (m)"
xTitleLine = "model year"
xTitleCn = "latitude"
cbTitle = cnP1@units
cnMinMaxInc1 = (/-15.0, 15.0, 0.5/)
cnMinMaxInc2 = (/-0.9, 0.9, 0.1/)
cnMinMaxInc3 = (/-6.0, 6.0, 0.1/)
linesMinMaxInc = (/-2, 2, 1/)
tmMaxY = 2000
;autoTicks = False
autoTicks = True

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks,cmap)

;---resources attributes setting------------------------{{{1
;---common resource for contours and lines--------------{{{2
res = True
res@vpWidthF = plotWid
res@vpHeightF = plotHei
;res@vpXF = -0.01
;  res@vpYF = 0.9

res@tiXAxisFontHeightF = fontSize

res@gsnDraw = False
res@gsnFrame = False
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
res@gsnStringFontHeightF = fontSize*0.9
res@gsnCenterStringOrthogonalPosF = 0.03
res@gsnLeftStringOrthogonalPosF = -0.2
res@gsnLeftStringParallelPosF = 0.02

res@tmXTOn = False
res@tmYROn = False
res@tmYLMinorOn = False
res@tmYRMinorOn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmYRLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize

;---resource for contour plots--------------------------{{{2
resCn = res
resCn@tiXAxisString = xTitleCn
resCn@tiYAxisString = yTitleCn

resCn@gsnYAxisIrregular2Linear = True
;resCn@gsnYAxisIrregular2Log = True
resCn@cnFillOn             = True               ; turn on color for contours
resCn@cnLinesOn            = False              ; turn off contour lines
;   resCn@cnLineThicknessF = 0.5
resCn@cnLineLabelsOn       = False              ; turn off contour line labels
resCn@cnInfoLabelOn        = False      ; turns off contour info label
resCn@cnMissingValFillColor = "gray60"
;   resCn@cnFillMode = "RasterFill"
if .not.autoTicks
  resCn@cnLevelSelectionMode = "ManualLevels"
  resCn@cnMinLevelValF       = cnMinMaxInc3(0)
  resCn@cnMaxLevelValF       = cnMinMaxInc3(1)
  resCn@cnLevelSpacingF      = cnMinMaxInc3(2)
end if

;resCn@lbLabelBarOn = False
resCn@lbOrientation = "vertical"
resCn@lbTitleString = cbTitle
;resCn@lbTitlePosition = "Right"
resCn@lbTitleFontHeightF = fontSize*0.8
resCn@lbLabelFontHeightF = fontSize*0.6
resCn@lbBoxLinesOn = False
resCn@lbLabelStride = 10

resCn@pmLabelBarWidthF = 0.06
resCn@pmLabelBarHeightF = plotHei*1.2
;resCn@pmLabelBarOrthogonalPosF = 0.2
resCn@pmLabelBarParallelPosF = 0.6

;resCn@tmXBLabelStride = 2

resCn@trYReverse               = True   ; reverses y-axis
;resCn@trYMaxF = 1500

;---resource for lines----------------------------------{{{2
resLine = res
resLine@vpWidthF = plotWid*2.2

resLine@tiXAxisString = xTitleLine
resLine@tiXAxisString = "model year"
resLine@tiYAxisString = ""
resLine@tiYAxisFontHeightF = fontSize

resLine@gsnYRefLine = 0.

resLine@xyLineColors = \
(/"red","blue","green3","cyan2","gold3","magenta3"/)
resLine@xyLineThicknessF = 2
resLine@xyDashPattern = 0
resLine@xyExplicitLegendLabels = \
  (/"Exp. P-A","Exp. P-B","Exp. P-C",\
    "Exp. A-A","Exp. A-b","Exp. A-C"/)

resLine@lgPerimOn = False
resLine@lgLabelFontHeightF = fontSize*0.8
resLine@lgPerimFill = "SolidFill"
resLine@lgPerimFillColor = "White"
resLine@lgItemOrder = (/5,4,3,2,1,0/)

resLine@pmLegendDisplayMode = "Always"
resLine@pmLegendSide = "Right"
resLine@pmLegendOrthogonalPosF = 0.02
resLine@pmLegendParallelPosF = 0.5
resLine@pmLegendWidthF = 0.05
resLine@pmLegendHeightF = 0.2

if .not.autoTicks
  resLine@tmYLMode = "Manual"
  resLine@tmYLTickStartF   = linesMinMaxInc(0)
  resLine@tmYLTickSpacingF = linesMinMaxInc(2)
  resLine@tmYLTickEndF     = linesMinMaxInc(1)
  resLine@trYMinF = linesMinMaxInc(0)
  resLine@trYMaxF = linesMinMaxInc(1)
end if

;resLine@tmYLPrecision = 1
;if autoTicks
;  delete(resLine@tmYLPrecision)
;end if

;---draw plots calling gsn functions--------------------{{{1
plot = new(9, graphic)
latN = 80
latS = -80

; Global
res1 = resCn
;res1@lbLabelBarOn = False
res1@tiXAxisOn = False
res1@lbLabelStride = 2
res1@gsnLeftString = var1
if .not.autoTicks
  res1@cnMinLevelValF       = cnMinMaxInc1(0)
  res1@cnMaxLevelValF       = cnMinMaxInc1(1)
  res1@cnLevelSpacingF      = cnMinMaxInc1(2)
end if
plot(0) = gsn_csm_contour(wks, cnP1(:,{latS:latN}), res1)

res2 = resCn
res2@gsnLeftString = var2
res2@tiXAxisOn = False
res2@tiYAxisOn = False
res2@lbLabelStride = 1
res2@lbLabelBarOn = True
if .not.autoTicks
  res2@cnMinLevelValF       = cnMinMaxInc2(0)
  res2@cnMaxLevelValF       = cnMinMaxInc2(1)
  res2@cnLevelSpacingF      = cnMinMaxInc2(2)
end if
plot(1) = gsn_csm_contour(wks, cnP2(:,{latS:latN}), res2)

res3 = resCn
res3@gsnLeftString = var3
res3@tiXAxisOn = False
;res3@lbLabelBarOn = False
plot(2) = gsn_csm_contour(wks, cnP3(:,{latS:latN}), res3)

res4 = resCn
res4@gsnLeftString = var4
res4@tiXAxisOn = False
res4@tiYAxisOn = False
;res4@lbLabelBarOn = False
plot(3) = gsn_csm_contour(wks, cnA1(:,{latS:latN}), res4)

res5 = resCn
res5@gsnLeftString = var5
res5@tiXAxisOn = False
;res5@lbLabelBarOn = False
plot(4) = gsn_csm_contour(wks, cnA2(:,{latS:latN}), res5)

res6 = resCn
res6@gsnLeftString = var6
res6@tiXAxisOn = False
res6@tiYAxisOn = False
;res6@lbLabelBarOn = False
;res6@lbTitleOffsetF = -0.03
;res6@pmLabelBarHeightF = plotHei*2.2
;res6@pmLabelBarOrthogonalPosF = 0.2
;res6@pmLabelBarParallelPosF = 1.4
plot(5) = gsn_csm_contour(wks, cnA3(:,{latS:latN}), res6)

plot(6) = gsn_csm_xy(wks, lineX, lines, resLine)

;---put plots in a panel--------------------------------{{{1
resP = True
resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 5
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStrings = \
  (/"(a) EXP_PACa", "(b) EXP_PACb",\
    "(c) EXP_PACc", "(d) EXP_ATLa",\
    "(e) EXP_ATLb", "(f) EXP_ATLc",\
    "(g) PCs"/)
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.6
resP@gsnPanelFigureStringsPerimOn = False
resP@gsnPanelFigureStringsBackgroundFillColor = "transparent"
resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.68
resP@amParallelPosF = -0.5
;   resP@txString = "Sea surface salinity"
gsn_panel(wks, plot, (/2,2,2,2,1/), resP)

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
;-------------------------------------------------------{{{1
; vim:fdm=marker:fdl=0:
; vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
