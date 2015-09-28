
; Description: EOF of MOC
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2015-06-19 15:03:30 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$HOME/archive/scripts/utils/pcom.ncl"

;img, dirs, and data files------------------------------{{{1
datDir    = "/home/ou/archive/data/pcom/"
img       = getenv("NCL_ARG_2")

expDir1   = "exp72_heaving_b_Pac_0N-40N/post/"
expDir2   = "exp73_heaving_b_Pac_20N-60N/post/"
expDir3   = "exp74_heaving_b_Pac_40N-80N/post/"

nc = "calc_10b_moc_years.nc"

;get plotting data--------------------------------------{{{1

;get coordinates infos array definition-----------------{{{2
f = addfile(datDir+expDir1+nc, "r")
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
local moc, eof, ts
begin
  f = addfile(datDir + expDir + nc, "r")
  moc = f->mocPac
  delete(f)

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

;define coutours and lines for holding plotting data----{{{2
cn1   = new((/nz,nlat/),"float")
var1  = ""

cn2   = cn1
var2  = var1

lines = new((/2,nt/),"float")
;get plotting data by calling procedure-----------------{{{2
get_eof(expDir1, cn1, lines(0,:), var1, "reverse")
get_eof(expDir2, cn2, lines(1,:), var2, "normal")

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
plotWid = 0.5
plotHei = 0.2
cnMinMaxInc1 = (/-2.5, 2.5, 0.1/)
cnMinMaxInc2 = (/-0.6, 0.6, 0.05/)
linesMinMaxInc = (/-2, 2, 1/)
lineColors = (/"blue","green3"/)

autoTicks = False
;autoTicks = True

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks,cmap)

;resources attributes setting---------------------------{{{1
;common-------------------------------------------------{{{2
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
res@gsnRightStringFontHeightF = fontSize*0.8
res@gsnCenterStringOrthogonalPosF = 0.05
res@gsnLeftStringOrthogonalPosF = -0.2
res@gsnLeftStringParallelPosF = 0.02
res@gsnRightStringOrthogonalPosF = 0.05
res@gsnRightStringParallelPosF = 1.15

;res@tmXTOn = False
;res@tmYROn = False
res@tmYLMinorOn = False
res@tmYRMinorOn = False
res@tmXBMinorOn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmYRLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize

;contour------------------------------------------------{{{2
resCn = res

resCn@gsnRightString = cn1@units
resCn@gsnYAxisIrregular2Linear = True
;resCn@gsnYAxisIrregular2Log = True

resCn@tiXAxisString = "latitude"
resCn@tiYAxisString = "depth (m)"

resCn@cnFillOn             = True
resCn@cnLinesOn            = False
;   resCn@cnLineThicknessF = 0.5
resCn@cnLineLabelsOn       = False
resCn@cnInfoLabelOn        = False
resCn@cnMissingValFillColor = "gray60"
;   resCn@cnFillMode = "RasterFill"
resCn@cnLevelSelectionMode = "ManualLevels"

;resCn@lbLabelBarOn = False
resCn@lbOrientation = "vertical"
;resCn@lbTitlePosition = "Right"
resCn@lbTitleFontHeightF = fontSize*0.8
resCn@lbLabelFontHeightF = fontSize*0.6
resCn@lbBoxLinesOn = False

resCn@pmLabelBarWidthF = 0.06
;resCn@pmLabelBarHeightF = plotHei*1.2
;resCn@pmLabelBarOrthogonalPosF = 0.2
;resCn@pmLabelBarParallelPosF = 0.6

;resCn@tmXBLabelStride = 2
resCn@tmXBTickSpacingF = 15

resCn@trYReverse               = True   ; reverses y-axis
resCn@trYMaxF = 1000

;line---------------------------------------------------{{{2
resLine = res

resLine@tiYAxisString = ""
resLine@tiYAxisFontHeightF = fontSize

resLine@gsnYRefLine = 0.

resLine@xyLineThicknessF = 3
resLine@xyDashPattern = 0
resLine@xyLineColors = lineColors

if .not.autoTicks
  resLine@tmYLMode = "Manual"
  resLine@tmYLTickStartF   = linesMinMaxInc(0)
  resLine@tmYLTickSpacingF = linesMinMaxInc(2)
  resLine@tmYLTickEndF     = linesMinMaxInc(1)
  resLine@trYMinF = linesMinMaxInc(0)
  resLine@trYMaxF = linesMinMaxInc(1)
end if

;draw plots calling gsn functions-----------------------{{{1
plot = new(3, graphic)
latN = 61
latS = -31

res1 = resCn
res1@gsnCenterString = "(a) Exp. B"
res1@gsnLeftString = var1
res1@tiXAxisString = ""
if .not.autoTicks
  res1@lbLabelStride  = 0.5/cnMinMaxInc1(2)
  res1@cnMinLevelValF       = cnMinMaxInc1(0)
  res1@cnMaxLevelValF       = cnMinMaxInc1(1)
  res1@cnLevelSpacingF      = cnMinMaxInc1(2)
end if
plot(0) = gsn_csm_contour(wks, cn1(:,{latS:latN}), res1)

res2 = resCn
res2@gsnCenterString = "(b) Exp. C"
res2@gsnLeftString = var2
if .not.autoTicks
  res2@lbLabelStride  = 0.2/cnMinMaxInc2(2)
  res2@cnMinLevelValF       = cnMinMaxInc2(0)
  res2@cnMaxLevelValF       = cnMinMaxInc2(1)
  res2@cnLevelSpacingF      = cnMinMaxInc2(2)
end if
plot(1) = gsn_csm_contour(wks, cn2(:,{latS:latN}), res2)

res3 = resLine
res3@tiXAxisString = "year"
res3@tiYAxisString = ""
res3@gsnCenterString = "(c) PCs"
plot(2) = gsn_csm_xy(wks, lineX, lines, res3)

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
resP@amOrthogonalPosF = -0.68
resP@amParallelPosF = -0.5
;   resP@txString = "Sea surface salinity"
gsn_panel(wks, plot, (/1,1,1/), resP)

;color text as legends {{{1
txres               = True
txres@txFontHeightF = fontSize*0.7
texts = (/"Exp. P-B", "Exp. P-C"/)

dposx = 0.5
dposy = 0.025

posx = 0.6
posy = 0.25
do j = 0, 1 
  txres@txFontColor = lineColors(j)
  gsn_text_ndc(wks, texts(j), posx, posy, txres)
  posy = posy - dposy
end do

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
;-------------------------------------------------------{{{1
; vim:fdm=marker:fdl=0:
; vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
