
; Description: EOF of barotropic stream function
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2015-06-23 09:49:26 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$HOME/archive/scripts/utils/pcom.ncl"

;img, dirs, and data files------------------------------{{{1
datDir    = "/home/ou/archive/data/pcom/"
img       = getenv("NCL_ARG_2")

refDir    = "exp_spinup/post/"
expDir1   = "exp71_heaving_b_Pac_20S-20N/post/"
expDir2   = "exp72_heaving_b_Pac_0N-40N/post/"
expDir3   = "exp73_heaving_b_Pac_20N-60N/post/"
expDir4   = "exp74_heaving_b_Pac_40N-80N/post/"

nc  = "calc_001f_ohc_4d.nc"
nca = "calc_006d_ohc_0-300m.nc"
ncb = "calc_006d_ohc_300-1500m.nc"

f = addfile(datDir + "basin/basin.nc", "r")
basin = f->basin
delete(f)
AtlId = 6 ; 6 represents Atlantic in the basin file
SouId = 1
PacId = 2
IndId = 3

maskPac = where(basin.eq.PacId, 1, 0)

;get plotting data--------------------------------------{{{1

;get coordinates infos array definition-----------------{{{2
f = addfile(datDir+expDir1+nca, "r")
time = f->time
lat = f->lat
lon = f->lon
delete(f)
time = time - 600
nt = dimsizes(time)
nlon = dimsizes(lon)
nlat = dimsizes(lat)

procedure get_eof(expDir, zt, zb, pat, pc, varText, reverse) ;{{{2
;-----------------------------------------------------------
; return the eof pattern, PC, and explained variance 
;   of a specific experiments of Pacific
;-----------------------------------------------------------
local var, varR, eof, ts
begin
  f = addfile(datDir + expDir + nc, "r")
  var4d = f->ohc(:,zt:zb,:,:)
  delete(f)
  var = dim_sum_n_Wrap(var4d, 1)

  f = addfile(datDir + refDir + nc, "r")
  var4d = f->ohc(:,zt:zb,:,:)
  delete(f)
  varR = dim_sum_n_Wrap(var4d, 1)

  var = var - varR
  var = var*1e-8
  var@units = "10~S~8~N~J/1~S~o"

  maskC = conform(var, maskPac, (/1,2/))
  var = where(maskC.eq.1, var, var@_FillValue)

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

;define coutours and lines for holding plotting data----{{{2
cn1a   = new((/nlat,nlon/),"float")
var1a  = ""

cn1b   = cn1a
var1b  = var1a

cn2a  = cn1a
var2a = var1a

cn2b   = cn1a
var2b  = var1a

cn3a  = cn1a
var3a = var1a

cn3b  = cn1a
var3b = var1a

line1 = new((/2,nt/),"float")
line2 = line1
line3 = line1

;get plotting data by calling procedure-----------------{{{2

; 0~107 m
get_eof(expDir1, 0, 6, cn1a, line1(0,:), var1a, "normal")
; 127~317 m
get_eof(expDir1, 7, 14, cn1b, line1(1,:), var1b, "reverse")

; 0~107 m
get_eof(expDir2, 0, 6, cn2a, line2(0,:), var2a, "reverse")
; 127~433 m
get_eof(expDir2, 7, 17, cn2b, line2(1,:), var2b, "normal")

; 0~628 m
get_eof(expDir3, 0, 21, cn3a, line3(0,:), var3a, "reverse")
; 684~1531 m
get_eof(expDir3, 22, 33, cn3b, line3(1,:), var3b, "reverse")

lineX = time

;plotting parameters------------------------------------{{{1
;  cmap = "NCL_default"
;  cmap = "GMT_jet"
;  cmap = "WhiteBlueGreenYellowRed"
;cmap = "BlGrYeOrReVi200"
cmap = "NCV_blu_red"

fontSize = 0.018
yLabelSize = fontSize*0.9
xLabelSize = fontSize*0.9
plotWid = 0.3
plotHei = 0.2
xTitleLine = "year"
cnMinMaxInc1a = (/-4.0, 4.0, 1.0/)
cnMinMaxInc1b = (/-5.0, 5.0, 1.0/)
cnMinMaxInc2a = (/-4.0, 4.0, 1.0/)
cnMinMaxInc2b = (/-5.0, 5.0, 1.0/)
cnMinMaxInc3a = (/-4.0, 4.0, 1.0/)
cnMinMaxInc3b = (/-5.0, 5.0, 1.0/)
cnMinMaxInc3 = (/-8.0, 8.0, 0.5/)
linesMinMaxInc = (/-2.0, 2.0, 1.0/)

autoTicks = False
;autoTicks = True

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks,cmap)

;resources attributes setting---------------------------{{{1
;common resource for contours and lines-----------------{{{2
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

;resource for contour plots-----------------------------{{{2
resCn = res

resCn@cnFillOn             = True
resCn@cnLinesOn            = False
;   resCn@cnLineThicknessF = 0.5
resCn@cnLineLabelsOn       = False
resCn@cnInfoLabelOn        = False
;resCn@cnMissingValFillColor = "gray60"
;   resCn@cnFillMode = "RasterFill"
resCn@cnLevelSelectionMode = "ManualLevels"

;resCn@lbLabelBarOn = False
resCn@lbOrientation = "vertical"
;resCn@lbTitlePosition = "Right"
resCn@lbTitleFontHeightF = fontSize*0.8
resCn@lbLabelFontHeightF = fontSize*0.6
resCn@lbBoxLinesOn = False
;resCn@lbLabelStride = 10

;resCn@pmLabelBarWidthF = 0.06
;resCn@pmLabelBarHeightF = plotHei*1.2
;resCn@pmLabelBarOrthogonalPosF = 0.2
;resCn@pmLabelBarParallelPosF = 0.6

resCn@mpShapeMode = "FreeAspect"
resCn@mpOutlineOn = True
resCn@mpLandFillColor          = "gray"            ; set land to be gray
;resCnmpMinLonF = 0
;resCn@mpMaxLonF = 360
resCn@mpMinLatF = -35
resCn@mpMaxLatF = 65
resCn@mpCenterLonF = 200
resCn@mpMinLonF = 120
resCn@mpMaxLonF = 290

resCn@tmXBLabelStride = 2
resCn@tmXBMinorOn = False

;resource for lines-------------------------------------{{{2
resLine = res

resLine@tiXAxisString = xTitleLine
resLine@tiXAxisString = "model year"
resLine@tiYAxisString = ""
resLine@tiYAxisFontHeightF = fontSize

resLine@gsnYRefLine = 0.

resLine@xyLineColors = \
(/"red","blue","green3","cyan2","gold3","magenta3"/)
resLine@xyLineThicknessF = 2
resLine@xyDashPattern = 0

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

;draw plots calling gsn functions-----------------------{{{1
plot = new(9, graphic) ; fix bug for xtitle not show entirely

; exp 1 {{{2
res1 = resCn
res1@gsnLeftString = var1a
if .not.autoTicks
  res1@cnMinLevelValF       = cnMinMaxInc1a(0)
  res1@cnMaxLevelValF       = cnMinMaxInc1a(1)
  res1@cnLevelSpacingF      = cnMinMaxInc1a(2)
end if
plot(0) = gsn_csm_contour_map(wks, cn1a, res1)

res2 = resCn
res2@gsnLeftString = var1b
if .not.autoTicks
  res2@cnMinLevelValF       = cnMinMaxInc1b(0)
  res2@cnMaxLevelValF       = cnMinMaxInc1b(1)
  res2@cnLevelSpacingF      = cnMinMaxInc1b(2)
end if
plot(3) = gsn_csm_contour_map(wks, cn1b, res2)

res3 = resLine
plot(6) = gsn_csm_xy(wks, lineX, line1, res3)

; exp 2 {{{2
res4 = resCn
res4@gsnLeftString = var2a
if .not.autoTicks
  res4@cnMinLevelValF       = cnMinMaxInc2a(0)
  res4@cnMaxLevelValF       = cnMinMaxInc2a(1)
  res4@cnLevelSpacingF      = cnMinMaxInc2a(2)
end if
plot(1) = gsn_csm_contour_map(wks, cn2a, res4)

res5 = resCn
res5@gsnLeftString = var2b
if .not.autoTicks
  res5@cnMinLevelValF       = cnMinMaxInc2b(0)
  res5@cnMaxLevelValF       = cnMinMaxInc2b(1)
  res5@cnLevelSpacingF      = cnMinMaxInc2b(2)
end if
plot(4) = gsn_csm_contour_map(wks, cn2b, res5)

res6 = resLine
plot(7) = gsn_csm_xy(wks, lineX, line2, res6)

; exp 3 {{{2
res7 = resCn
res7@gsnLeftString = var3a
if .not.autoTicks
  res7@cnMinLevelValF       = cnMinMaxInc3a(0)
  res7@cnMaxLevelValF       = cnMinMaxInc3a(1)
  res7@cnLevelSpacingF      = cnMinMaxInc3a(2)
end if
plot(2) = gsn_csm_contour_map(wks, cn3a, res7)

res8 = resCn
res8@gsnLeftString = var3b
if .not.autoTicks
  res8@cnMinLevelValF       = cnMinMaxInc3b(0)
  res8@cnMaxLevelValF       = cnMinMaxInc3b(1)
  res8@cnLevelSpacingF      = cnMinMaxInc3b(2)
end if
plot(5) = gsn_csm_contour_map(wks, cn3b, res8)

res9 = resLine
plot(8) = gsn_csm_xy(wks, lineX, line3, res9)

;put plots in a panel-----------------------------------{{{1
resP = True
resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 5
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.6
resP@gsnPanelFigureStringsPerimOn = False
resP@gsnPanelFigureStringsBackgroundFillColor = "transparent"
resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.65
resP@amParallelPosF = -0.5
gsn_panel(wks, plot, (/3,3,3/), resP)

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
;-------------------------------------------------------{{{1
; vim:fdm=marker:fdl=0:
; vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
