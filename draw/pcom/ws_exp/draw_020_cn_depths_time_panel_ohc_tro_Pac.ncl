
; Description: 4 subplots, each is a depth-year contour plot
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-13 08:39:12 BJT
; Last Change: 2015-01-15 20:40:16 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

datDir = getenv("NCL_ARG_1")
img = getenv("NCL_ARG_2")

;guess data and img
;{{{
isOhc = False
if isStrSubset(img, "___ohc") then
  isOhc = True
end if

isDiff = False
if isStrSubset(img, "___diff") then
  isDiff = True
end if

isRevise = False
if isStrSubset(img, "___revise") then
  isRevise = True
end if

isDetrend = False
if isStrSubset(img, "___detrend") then
  isDetrend = True
end if

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

isSpinup = False
if isPcom .and. isStrSubset(datDir, "exp_spinup") then
  isSpinup = True
end if

isFullTime = False
if .not.isStrSubset(img,"___") then
  isFullTime = True
end if

is120yrs = False
if isStrSubset(img,"___120years") then
  is120yrs = True
end if

isSodaLen = False
if isStrSubset(img,"___soda_len") then
  isSodaLen = True
end if
;}}}

f = addfile("/home/ou/archive/data/pcom/grid_info.nc", "r")
dz = f->dz
delete(f)

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

function get_ohc_depths(fname, varName)
;{{{
local time
begin

  f = addfile(fname, "r")
;  ohc_basin = f->$varName$({501:620},:)
  ohc_basin = f->$varName$({501:594},:)
  delete(f)

  time = ohc_basin&time
  if isPcom
    time = time - 500
  end if
  ohc_basin&time = time

  dzc = conform(ohc_basin, dz, 1)
  ohc = ohc_basin
  ohc = ohc_basin/dzc ; unit thickness

;  ohc = dim_rmvmean_n(ohc,0)
  ohc = dtrend_n(ohc,False,0)

  ohc = ohc*1e-20
  ohc@units = "10~S~20~N~J/m"

  return ohc(z|:,time|:)
end
;}}}

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;{{{
rootDir = "/home/ou/archive/data/"
nc = "calc_001_ohc.nc"
ohcAnomTrop = get_ohc_depths(datDir+nc, "Pac_T")
ohcAnomNino = get_ohc_depths(datDir+nc, "nino34")
ohcSpinTrop = get_ohc_depths(rootDir+"pcom/exp_spinup/post/"+nc, "Pac_T")
ohcSpinNino = get_ohc_depths(rootDir+"pcom/exp_spinup/post/"+nc, "nino34")

cn1 = ohcSpinTrop
cn2 = ohcAnomTrop
;cn2 = ohcAnomTrop - ohcSpinTrop

cn3 = ohcSpinNino
cn4 = ohcAnomNino
;cn4 = ohcAnomNino - ohcSpinNino
;}}}

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; plot model 
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

;  cmap = "NCL_default"
;  cmap = "GMT_jet"
;  cmap = "WhiteBlueGreenYellowRed"
cmap = "NCV_blu_red"

fontSize = 0.03
yLabelSize = fontSize
xLabelSize = fontSize
plotWid = 0.7
plotHei = 0.4
yTitle = "depth (meter)"
xTitle = "year"
cbTitle = "OHC anomaly ("+cn1@units+")"
cnMinMaxInc = (/-0.6, 0.6, 0.01/)
tmMaxY = 600
;autoTicks = False
autoTicks = True
if isExp("exp24") .or. isExp("exp40_ws")
  autoTicks = False
end if

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks,cmap)

 res = True
; {{{
res@vpWidthF = plotWid
res@vpHeightF = plotHei
;  res@vpXF = 0.2
;  res@vpYF = 0.9

res@tiXAxisFontHeightF = fontSize
res@tiXAxisString = xTitle
res@tiYAxisString = yTitle

res@gsnDraw = False
res@gsnFrame = False
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
res@gsnStringFontHeightF = fontSize
res@gsnCenterStringOrthogonalPosF = 0.03

;res@tmXTOn = False
;res@tmYROn = False
res@tmYLMinorOn = False
res@tmYRMinorOn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmYRLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize
; }}}

res_cn = res
;{{{
;res_cn@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 

res_cn@cnFillOn             = True               ; turn on color for contours
res_cn@cnLinesOn            = False              ; turn off contour lines
;   res_cn@cnLineThicknessF = 0.5
res_cn@cnLineLabelsOn       = False              ; turn off contour line labels
res_cn@cnInfoLabelOn        = False      ; turns off contour info label
;if .not.autoTicks
;  res_cn@cnLevelSelectionMode = "ManualLevels"
;  res_cn@cnMinLevelValF       = cnMinMaxInc(0)
;  res_cn@cnMaxLevelValF       = cnMinMaxInc(1)
;  res_cn@cnLevelSpacingF      = cnMinMaxInc(2)
;end if
res_cn@cnMissingValFillColor = "gray60"
;   res_cn@cnFillMode = "RasterFill"

;res_cn@lbLabelBarOn = False
;res_cn@lbOrientation = "vertical"
res_cn@lbTitleString = cbTitle
res_cn@lbBoxLinesOn = False
;res_cn@lbTitlePosition = "Right"

res_cn@trYReverse               = True   ; reverses y-axis
if .not.autoTicks
  res_cn@trYMaxF = tmMaxY
end if
;res_cn@trXMinF = 110
;res_cn@trXMaxF = 345
;}}}

plot = new(4, graphic)

res_cn@tiMainString = "a) Tropical Pacific OHC in exp_ctl"
res_cn@tiXAxisString = ""
plot(0) = gsn_csm_contour(wks, cn1, res_cn)

res_cn@tiMainString = "b) Tropical Pacific OHC in exp_anom"
res_cn@tiXAxisString = ""
res_cn@tiYAxisString = ""
plot(1) = gsn_csm_contour(wks, cn2, res_cn)

res_cn@tiMainString = "c) NINO34 OHC in exp_ctl"
res_cn@tiXAxisString = xTitle
res_cn@tiYAxisString = yTitle
plot(2) = gsn_csm_contour(wks, cn3, res_cn)

res_cn@tiMainString = "d) NINO34 OHC in exp_anom"
res_cn@tiXAxisString = xTitle
res_cn@tiYAxisString = ""
plot(3) = gsn_csm_contour(wks, cn4, res_cn)

resP = True
resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
;resP@gsnPanelLabelBar = True
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 5
resP@gsnPanelRowSpec = True
;resP@gsnPanelFigureStrings = (/"a)","b)","c)","d)"/)
;resP@gsnPanelFigureStringsFontHeightF = fontSize*0.6
;resP@gsnPanelFigureStringsPerimOn = False
;resP@amJust = "TopLeft"
;resP@amOrthogonalPosF = -0.7

resP@pmLabelBarWidthF = 0.7
resP@pmLabelBarHeightF = 0.05

resP@lbLabelFontHeightF = fontSize*0.6
resP@lbTitleFontHeightF = fontSize*0.6
resP@lbTitleString = cbTitle
resP@lbBoxLinesOn = False

gsn_panel(wks, plot, (/2,2/), resP)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
