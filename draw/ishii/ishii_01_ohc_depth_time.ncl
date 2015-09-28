
; Description: integrated OHC at varying depth
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2014-12-17 22:22:25 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

datDir = getenv("NCL_ARG_1")
img = getenv("NCL_ARG_2")

;guess data and img
;{{{
isDiff = False
if isStrSubset(img, "___diff") then
  isDiff = True
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

isExp33 = False
if isPcom .and. isStrSubset(datDir, "exp33") then
  isExp33 = True
end if

isExp34 = False
if isPcom .and. isStrSubset(datDir, "exp34") then
  isExp34 = True
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

nc = datDir+"ohc.nc"
grid_info_file = datDir+"grid_info.nc"
if isPcom
  grid_info_file = datDir+"../../grid_info.nc"
end if
f = addfile(grid_info_file, "r")
dz = f->dz
delete(f)

function get_ohc_depths(f, varName)
;{{{
local time, ohc
begin
  ohc = f->$varName$
  time = ohc&$ohc!0$
  nt = dimsizes(time)

  if isDiff
    expYears = ohc&time
    nExpYears = dimsizes(expYears)
    year1 = expYears(0)
    year2 = expYears(nExpYears-1)
    fSp = addfile(datDir+"../../exp_spinup/post/ohc.nc","r")
    ohcSp = fSp->$varName$({year1:year2},:)
    delete(fSp)
    ohc = ohc - ohcSp
  end if

  if isDetrend then
    ohc = dtrend_n(ohc,False,0)
  else
    ohc = dim_rmvmean_n(ohc,0)
  end if
  if (isDetrend .and. isPcom) .or. isDiff then
    ohc = ohc*1e-21
    ohc@units = "10~S~21~N~J"
  else
    ohc = ohc*1e-20
    ohc@units = "10~S~20~N~J"
  end if

  dzc = conform(ohc, dz, 1)
  ohc = ohc/dzc ; unit thickness

  return ohc
end
;}}}

function get_sst(f, varName)
;{{{
begin
  sst = f->$varName$
  if isDetrend then
    sst = dtrend_n(sst,False,0)
  else
    sst = dim_rmvmean_n(sst,0)
  end if
  sst@units = "~S~o~N~C"
  if isPcom
    sst = sst*1e2
    sst@units = "10~S~-2 o~N~C"
  end if
;  if isSpinup .or. isDiff
;    if isExp34
;      sst = runave_n_Wrap(sst, 4, 0, 0)
;    else
;      sst = runave_n_Wrap(sst, 10, 0, 0)
;    end if
;  end if
  return sst
end
;}}}

;  cmap = "NCL_default"
;  cmap = "GMT_jet"
;  cmap = "WhiteBlueGreenYellowRed"
;cmap = "BlGrYeOrReVi200"
cmap = "NCV_blu_red"
;  cmap = "MPL_jet"

f = addfile( nc, "r" )
ohc_glo = get_ohc_depths(f, "glo")
ohc_Atl = get_ohc_depths(f, "Atl")
ohc_Sou = get_ohc_depths(f, "Sou")
ohc_Pac = get_ohc_depths(f, "Pac")
ohc_Ind = get_ohc_depths(f, "Ind")
delete(f)
time = ohc_glo&$ohc_glo!1$
if isPcom
  time = time - 500
end if

nc = getenv("NCL_ARG_1")+"sst.nc"
f = addfile( nc, "r" )
sst_glo = get_sst(f, "glo")
sst_Atl = get_sst(f, "Atl")
sst_Sou = get_sst(f, "Sou")
sst_Pac = get_sst(f, "Pac")
sst_Ind = get_sst(f, "Ind")
delete(f)

fontSize = 0.03
yLabelSize = fontSize
xLabelSize = fontSize
plotWid = 0.8
plotHei = 0.5
cbTitle = ohc_glo@units
yTitle = "depth (m)"
yTitle_sst = "SSTa: "+sst_glo@units
xTitle = "year"
if isPcom
  xTitle = "model year"
end if
ohcMinMaxInc = (/-1.6, 1.6, 0.8/)
sstMinMaxInc = (/-0.6, 0.6, 0.3/)
ohcMinMaxInc_basin = (/-0.4, 0.6, 0.2/)
sstMinMaxInc_basin = (/-0.4, 0.6, 0.2/)
;autoTicks = False
autoTicks = True

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks,cmap)

res = True
;{{{
res@vpWidthF = plotWid
res@vpHeightF = plotHei
;  res@vpXF = 0.1
;  res@vpYF = 0.9
res@tiXAxisString = xTitle
res@tiXAxisFontHeightF = xLabelSize
res@gsnDraw = False
res@gsnFrame = False
res@gsnStringFontHeightF = fontSize
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
res@gsnCenterStringOrthogonalPosF = 0.01
;res@tmXTOn = False
res@tmYROn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize
res@tmLabelAutoStride = True
;}}}

res_sst = res
; {{{
res_sst@tiYAxisString = yTitle_sst
res_sst@tiXAxisString = ""

res_sst@gsnYRefLine = 0.

res_sst@xyDashPattern = 0 ; solid
res_sst@xyMarkLineMode = "Lines"
res_sst@xyLineThicknessF = 1.5

;  res_sst@tmXTOn = False
;  res_sst@tmYROn = False

if .not.autoTicks
  res_sst@tmYLPrecision = 2
end if
res_sst@tmYLMinorOn = False
if .not.autoTicks
  res_sst@tmYLMode = "Manual"
  res_sst@tmYLTickStartF   = sstMinMaxInc(0)
  res_sst@tmYLTickSpacingF = sstMinMaxInc(2)
  res_sst@tmYLTickEndF     = sstMinMaxInc(1)
end if

;  res_sst@tmYUseLeft = False
;  res_sst@tmYRLabelsOn = True
res_sst@tmYRLabelFontHeightF = yLabelSize 
;  res_sst@tmYROn = True

res_sst@tmXBLabelFontHeightF = xLabelSize

if .not.autoTicks
  res_sst@trYMinF = ohcMinMaxInc(0)
  res_sst@trYMaxF = ohcMinMaxInc(1)
end if
; }}}

res_ohc = res
;{{{
res_ohc@tiYAxisString = yTitle

;res_ohc@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 

res_ohc@cnFillOn             = True               ; turn on color for contours
res_ohc@cnLinesOn            = False              ; turn off contour lines
;   res_ohc@cnLineThicknessF = 0.5
res_ohc@cnLineLabelsOn       = False              ; turn off contour line labels
res_ohc@cnInfoLabelOn        = False      ; turns off contour info label
if .not.autoTicks
  res_ohc@cnLevelSelectionMode = "ManualLevels"
  res_ohc@cnMinLevelValF       = ohcMinMaxInc(0)
  res_ohc@cnMaxLevelValF       = ohcMinMaxInc(1)
  res_ohc@cnLevelSpacingF      = ohcMinMaxInc(2)
end if
res_ohc@cnMissingValFillColor = "gray60"
;   res_ohc@cnFillMode = "RasterFill"

;res_ohc@lbLabelBarOn = False
res_ohc@lbOrientation = "vertical"
res_ohc@lbTitleString = cbTitle
;res_ohc@lbTitlePosition = "Right"

res_ohc@trYReverse               = True   ; reverses y-axis
;res_ohc@trYMaxF = 400
;res_ohc@trXMinF = 110
;res_ohc@trXMaxF = 345
;}}}

;plot = new(6, graphic)
plot = new(2, graphic)

res_ohc@gsnCenterString = "A - Global Ocean"
plot(1) = gsn_csm_contour(wks, ohc_glo(z|:,time|:), res_ohc)

res_ohc@gsnCenterString = "B - Atlantic"

res_ohc@tiYAxisString = ""
res_ohc@gsnCenterString = "D - Southern Ocean"

res_sst@tiYAxisString = yTitle_sst

res_ohc@gsnCenterString = "C - Pacific"

res_sst@tiYAxisString = ""

res_ohc@gsnCenterString = "E - Indian Ocean"
res_ohc@tiYAxisString = ""

res_sst@tiYAxisString = yTitle_sst

 resP = True
 resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
 resP@gsnPanelXWhiteSpacePercent = 0
 resP@gsnPanelYWhiteSpacePercent = 5
 resP@gsnPanelRowSpec = True
;   resP@txString = "Sea surface salinity"
;gsn_panel(wks, plot, (/2,2,2,2/), resP)
gsn_panel(wks, plot, (/2/), resP)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
