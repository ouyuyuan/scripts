
; Description: EOF of barotropic stream function
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2015-05-30 20:31:42 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$HOME/archive/scripts/utils/pcom.ncl"

;---img, dirs, and data files---------------------------{{{1
load "$HOME/archive/scripts/draw/pp_heaving/exp_P_head.ncl"
nc = "post/calc_006c_bsf.nc"

;---get plotting data-----------------------------------{{{1

;---get coordinates infos array definition--------------{{{2
f = addfile(datDir+expDir1+nc, "r")
time = f->time
lat = f->lat
lon = f->lon
delete(f)
time = time - 600
nt = dimsizes(time)
nlon = dimsizes(lon)
nlat = dimsizes(lat)

procedure get_eof(expDir, pat, pc, varText, reverse) ;{{{2
;-----------------------------------------------------------
; return the eof pattern, PC, and explained variance 
;   of a specific experiments of Pacific
;-----------------------------------------------------------
local var, varR, eof, ts
begin
  f = addfile(datDir + expDir + nc, "r")
  var = f->bsf
  delete(f)

  f = addfile(datDir + expDirRef + nc, "r")
  varR = f->bsf
  delete(f)
  var = var - varR
  var&time = var&time - 600

  eof = new((/2,nlat,nlon/), "float")
  ts = new((/2,nt/), "float")

  pcom_eof(var, eof, ts)

  pat = var(0,:,:)
  pat = eof(0,:,:)
  pc = ts(0,:)
  varText= sprintf("%4.1f",eof@pcvar(0))+"%"

  if (.not.ismissing(reverse).and.reverse.eq."reverse") then
    pat = pat*(-1)
    pc = pc*(-1)
  end if
end 

;---define coutours and lines for holding plotting data-{{{2
cn1   = new((/nlat,nlon/),"float")
var1  = ""

cn2   = cn1
var2  = var1

cn3   = cn1
var3  = var1

cn4   = cn1
var4  = var1

cn5   = cn1
var5  = var1

cn6   = cn1
var6  = var1

lines = new((/6,nt/),"float")
;---get plotting data by calling procedure--------------{{{2
get_eof(expDir1, cn1, lines(0,:), var1, "reverse")
get_eof(expDir2, cn2, lines(1,:), var2, "normal")
get_eof(expDir3, cn3, lines(2,:), var3, "normal")
get_eof(expDir4, cn4, lines(3,:), var4, "reverse")
get_eof(expDir5, cn5, lines(4,:), var5, "reverse")
get_eof(expDir6, cn6, lines(5,:), var6, "reverse")

lineX = time

;---plotting parameters---------------------------------{{{1
;  cmap = "NCL_default"
;  cmap = "GMT_jet"
;  cmap = "WhiteBlueGreenYellowRed"
;cmap = "BlGrYeOrReVi200"
cmap = "NCV_blu_red"

fontSize = 0.018
yLabelSize = fontSize*0.9
xLabelSize = fontSize*0.9
plotWid = 0.4
plotHei = 0.2
xTitleLine = "model year"
cbTitle = cn1@units
cnMinMaxInc1 = (/-5.0, 5.0, 0.25/)
cnMinMaxInc2 = (/-3.0, 3.0, 0.1/)
cnMinMaxInc3 = (/-5.0, 5.0, 0.25/)
linesMinMaxInc = (/-2.5, 2.5, 1.0/)
autoTicks = False
;autoTicks = True

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
res@gsnLeftStringOrthogonalPosF = -1.15
res@gsnLeftStringParallelPosF = 0.02

res@tmLabelAutoStride    = True
res@tmXTOn = False
res@tmYROn = False
res@tmYLMinorOn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmYRLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize

;---resource for contour plots--------------------------{{{2
resCn = res

resCn@cnFillOn             = True               ; turn on color for contours
resCn@cnLinesOn            = False              ; turn off contour lines
;   resCn@cnLineThicknessF = 0.5
resCn@cnLineLabelsOn       = False              ; turn off contour line labels
resCn@cnInfoLabelOn        = False      ; turns off contour info label
;resCn@cnMissingValFillColor = "gray60"
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
;resCn@lbLabelStride = 10

resCn@pmLabelBarWidthF = 0.06
resCn@pmLabelBarHeightF = plotHei*1.2
;resCn@pmLabelBarOrthogonalPosF = 0.2
resCn@pmLabelBarParallelPosF = 0.6

resCn@mpShapeMode = "FreeAspect"
resCn@mpOutlineOn = True
resCn@mpLandFillColor          = "gray"            ; set land to be gray
;resCnmpMinLonF = 0
;resCn@mpMaxLonF = 360
resCn@mpMinLatF = -70
resCn@mpMaxLatF = 70
resCn@mpCenterLonF = 200

resCn@tmXBLabelStride = 2
resCn@tmXBMinorOn = False

;---resource for lines----------------------------------{{{2
resLine = res
resLine@vpWidthF = plotWid*2.15

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
    "Exp. P-D","Exp. P-E","Exp. P-F"/)

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
plot = new(9, graphic) ; fix bug for xtitle not show entirely

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
res1@tmXBOn    = False
plot(0) = gsn_csm_contour_map(wks, cn1, res1)

res2 = resCn
res2@gsnLeftString = var2
res2@tiXAxisOn = False
res2@tiYAxisOn = False
res2@lbLabelStride = 10
res2@lbLabelBarOn = True
if .not.autoTicks
  res2@cnMinLevelValF       = cnMinMaxInc2(0)
  res2@cnMaxLevelValF       = cnMinMaxInc2(1)
  res2@cnLevelSpacingF      = cnMinMaxInc2(2)
end if
res2@tmYLLabelsOn = False
res2@tmXBOn = False
plot(1) = gsn_csm_contour_map(wks, cn2, res2)

res3 = resCn
res3@gsnLeftString = var3
res3@tiXAxisOn = False
if .not.autoTicks
  res3@lbLabelBarOn = False
  res3@gsnLeftStringOrthogonalPosF = -0.95
end if
res3@tmXBOn    = False
plot(2) = gsn_csm_contour_map(wks, cn3, res3)

res4 = resCn
res4@gsnLeftString = var4
res4@tiXAxisOn = False
res4@tiYAxisOn = False
if .not.autoTicks
  res4@lbLabelBarOn = False
  res4@gsnLeftStringOrthogonalPosF = -0.95
end if
res4@tmYLLabelsOn    = False
res4@tmXBOn    = False
plot(3) = gsn_csm_contour_map(wks, cn4, res4)

res5 = resCn
res5@gsnLeftString = var5
res5@tiXAxisOn = False
if .not.autoTicks
  res5@lbLabelBarOn = False
  res5@gsnLeftStringOrthogonalPosF = -0.95
end if
plot(4) = gsn_csm_contour_map(wks, cn5, res5)

res6 = resCn
res6@gsnLeftString = var6
res6@tiXAxisOn = False
res6@tiYAxisOn = False
res6@lbLabelStride = 4
;res6@lbLabelBarOn = False
if (.not.autoTicks) then
  res6@gsnLeftStringOrthogonalPosF = -2.45
  res6@lbTitleOffsetF = -0.03
  res6@pmLabelBarHeightF = plotHei*2.2
  ;res6@pmLabelBarOrthogonalPosF = 0.2
  res6@pmLabelBarParallelPosF = 1.3
end if
res6@tmYLLabelsOn    = False
plot(5) = gsn_csm_contour_map(wks, cn6, res6)

plot(6) = gsn_csm_xy(wks, lineX, lines, resLine)

;---put plots in a panel--------------------------------{{{1
resP = True
resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 5
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStrings = \
  (/"(a) "+expNamePA, "(b) "+expNamePB,\
    "(c) "+expNamePC, "(d) "+expNamePD,\
    "(e) "+expNamePE, "(f) "+expNamePF,\
    ""/)
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.6
resP@gsnPanelFigureStringsPerimOn = False
resP@gsnPanelFigureStringsBackgroundFillColor = "transparent"
resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.65
resP@amParallelPosF = -0.5
;   resP@txString = "Sea surface salinity"
gsn_panel(wks, plot, (/2,2,2,2,1/), resP)

resText = True
resText@txFontHeightF = resP@gsnPanelFigureStringsFontHeightF
gsn_text_ndc(wks, "(g) PCs", 0.18, 0.34, resText)

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
;-------------------------------------------------------{{{1
; vim:fdm=marker:fdl=0:
; vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
