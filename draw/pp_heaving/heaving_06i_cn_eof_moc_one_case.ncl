
; Description: EOF of MOC, for 240 years
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2015-06-25 09:39:04 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$HOME/archive/scripts/utils/pcom.ncl"

;img, dirs, and data files------------------------------{{{1
refDir = "/home/ou/archive/data/pcom/exp_spinup/post/"
datDir = getenv("NCL_ARG_1")
img    = getenv("NCL_ARG_2")
nc = "calc_10b_moc_years.nc"

;get plotting data--------------------------------------{{{1
f = addfile(datDir + nc, "r")
time = f->time
lat = f->lat
z = f->z
delete(f)

time = time - 600
nt = dimsizes(time)
nz = dimsizes(z)
nlat = dimsizes(lat)

f = addfile(datDir + nc, "r")
moc = f->mocGlo
delete(f)

;f = addfile(refDir + nc, "r")
;mocR = f->mocPac
;delete(f)
;moc = moc - mocR
moc&time = moc&time - 600

eof = new((/2,nz,nlat/), "float")
ts = new((/2,nt/), "float")

pcom_eof(moc, eof, ts)

pat = moc(0,:,:)
pat = eof(0,:,:)
pc = ts(0,:)
varText= sprintf("%4.1f",eof@pcvar(0))+"%"

pat = pat*(-1)
pc = pc*(-1)

cn = pat
line = pc

lineX = time

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
cnMinMaxInc = (/-10.0, 10.0, 1.0/)
linesMinMaxInc = (/-2, 2, 1/)
autoTicks = False
;autoTicks = True

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks,cmap)


pcom_eof(moc, eof, ts)

pat = moc(0,:,:)
pat = eof(0,:,:)
pc = ts(0,:)
varText= sprintf("%4.1f",eof@pcvar(0))+"%"

pat = pat*(-1)
pc = pc*(-1)

cn = pat
line = pc

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
plotWid = 0.4
plotHei = 0.2
cnMinMaxInc = (/-2.0, 2.0, 0.2/)
linesMinMaxInc = (/-2, 2, 1/)
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
res@gsnRightStringParallelPosF = 1.2

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
  resCn@cnMinLevelValF       = cnMinMaxInc(0)
  resCn@cnMaxLevelValF       = cnMinMaxInc(1)
  resCn@cnLevelSpacingF      = cnMinMaxInc(2)
end if

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
;resCn@tmXBTickSpacingF = 15

resCn@trYReverse               = True   ; reverses y-axis
;resCn@trYMaxF = 400

;line---------------------------------------------------{{{2
resLine = res

resLine@tiYAxisString = ""
resLine@tiYAxisFontHeightF = fontSize

resLine@gsnYRefLine = 0.

resLine@xyLineThicknessF = 3
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
plot = new(2, graphic)
;latN = 
;latS = -31

res1 = resCn
;res1@lbLabelBarOn = False
res1@tiXAxisString = "latitude"
res1@tiYAxisString = "depth (m)"
res1@gsnCenterString = "(a)"
res1@gsnLeftString = varText
res1@gsnRightString = cn@units
res1@lbLabelStride = 5
if .not.autoTicks
  res1@cnMinLevelValF       = cnMinMaxInc(0)
  res1@cnMaxLevelValF       = cnMinMaxInc(1)
  res1@cnLevelSpacingF      = cnMinMaxInc(2)
end if
;plot(0) = gsn_csm_contour(wks, cn(:,{latS:latN}), res1)
plot(0) = gsn_csm_contour(wks, cn, res1)

res2 = resLine
res2@tiXAxisString = "year"
res2@tiYAxisString = ""
res2@gsnCenterString = "(b)"
plot(1) = gsn_csm_xy(wks, lineX, line, res2)

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
gsn_panel(wks, plot, (/1,1/), resP)

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
;-------------------------------------------------------{{{1
; vim:fdm=marker:fdl=0:
; vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
