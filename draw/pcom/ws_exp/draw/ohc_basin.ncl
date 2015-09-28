
; Description: integrated OHC at varying depth, follows Chen2014, Fig.1
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2014-12-15 10:43:19 BJT

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

function get_ohc_depths(f, varName)
;{{{
local time
begin
  ohc_basin = f->$varName$
  if isStrSubset(datDir,"Ishii") .and. isStrSubset(img,"___Chen2014") then
    delete(ohc_basin)
    ohc_basin = f->$varName$({1970:},:)
  end if
  time = ohc_basin&$ohc_basin!0$
  nt = dimsizes(time)

  if isDiff
    expYears = ohc_basin&time
    nExpYears = dimsizes(expYears)
    year1 = expYears(0)
    year2 = expYears(nExpYears-1)
    fSp = addfile(datDir+"../../exp_spinup/post/ohc.nc","r")
    ohcSp = fSp->$varName$({year1:year2},:)
    delete(fSp)
    ohc_basin = ohc_basin - ohcSp
  end if

  ohc = new((/13, nt/), float)
  do i = 3, 15
    depth = i*100
    ohc(i-3,:) = dim_sum_n(ohc_basin(:,{0:depth}), 1)
  end do

  ohc!1 = "time"
  ohc&time = time
  if isDetrend then
    ohc = dtrend_n(ohc,False,1)
  else
    ohc = dim_rmvmean_n(ohc,1)
  end if
  if (isDetrend .and. isPcom) .or. isDiff then
    ohc = ohc*1e-21
    ohc@units = "10~S~21~N~J"
  else
    ohc = ohc*1e-23
    ohc@units = "10~S~23~N~J"
  end if

  if isDiff
    if isExp34
      ohc = runave_n_Wrap(ohc, 4, 0, 1)
    else
      ohc = runave_n_Wrap(ohc, 10, 0, 1)
    end if
  end if

  return ohc
end
;}}}

function get_sst(f, varName)
;{{{
begin
  sst = f->$varName$
  if isStrSubset(datDir,"Ishii") .and. isStrSubset(img,"___Chen2014") then
    delete(sst)
    sst = f->$varName$({1970:})
  end if
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
  if isSpinup .or. isDiff
    if isExp34
      sst = runave_n_Wrap(sst, 4, 0, 0)
    else
      sst = runave_n_Wrap(sst, 10, 0, 0)
    end if
  end if
  return sst
end
;}}}

nc = datDir+"ohc.nc"
;  cmap = "NCL_default"
;  cmap = "GMT_jet"
;  cmap = "WhiteBlueGreenYellowRed"
cmap = "BlGrYeOrReVi200"
;  cmap = "NCV_jet"
;  cmap = "MPL_jet"

f = addfile( nc, "r" )
;  time = time - 500
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
yTitle = "OHC: "+ohc_glo@units
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

 res_line = True
; {{{
res_line@vpWidthF = plotWid
res_line@vpHeightF = plotHei
;  res_line@vpXF = 0.2
;  res_line@vpYF = 0.9

res_line@tiYAxisString = yTitle
res_line@tiXAxisString = ""
res_line@tiXAxisFontHeightF = fontSize

res_line@gsnDraw = False
res_line@gsnFrame = False
res_line@gsnLeftString = ""
res_line@gsnRightString = ""
res_line@gsnCenterString = ""
res_line@gsnStringFontHeightF = fontSize
res_line@gsnCenterStringOrthogonalPosF = -0.15
res_line@gsnYRefLine = 0.

res_line@xyMonoLineColor = False
res_line@xyDashPattern = 0 ; solid
res_line@xyMarkLineMode = "Lines"
res_line@xyLineColors = floattoint( fspan(20., 170., 13) )
if (cmap.eq."BlGrYeOrReVi200")then
  res_line@xyLineColors = floattoint( fspan(2., 140., 13) )
end if
res_line@xyLineThicknessF = 1.5
if isDiff
  res_line@xyLineThicknessF = 2.
end if

;  res_line@tmYMajorGrid = True
;  res_line@tmYMajorGridLineDashPattern = 2
;  res_line@tmYMajorGridThicknessF = 0.5
;  res_line@tmXMajorGridThicknessF = 0.5

;  res_line@tmXTOn = False
;  res_line@tmYROn = False

res_line@tmYLPrecision = 2
if autoTicks
  delete(res_line@tmYLPrecision)
end if
res_line@tmYLMinorOn = False
if .not.autoTicks
  res_line@tmYLMode = "Manual"
  res_line@tmYLTickStartF   = ohcMinMaxInc(0)
  res_line@tmYLTickSpacingF = ohcMinMaxInc(2)
  res_line@tmYLTickEndF     = ohcMinMaxInc(1)
end if

res_line@tmYLLabelFontHeightF = yLabelSize 

;  res_line@tmYUseLeft = False
;  res_line@tmYRLabelsOn = True
res_line@tmYRLabelFontHeightF = yLabelSize 
;  res_line@tmYROn = True

res_line@tmXBLabelFontHeightF = xLabelSize

if .not.autoTicks
  res_line@trYMinF = ohcMinMaxInc(0)
  res_line@trYMaxF = ohcMinMaxInc(1)
end if
; }}}

plot = new(6, graphic)

res_sst = res_line
res_sst@xyLineThicknessF = 2
res_sst@tiYAxisString = yTitle_sst

if .not.autoTicks
  res_sst@tmYLMode = "Manual"
  res_sst@tmYLTickStartF   = sstMinMaxInc(0)
  res_sst@tmYLTickEndF     = sstMinMaxInc(1)
  res_sst@tmYLTickSpacingF = sstMinMaxInc(2)
end if

res_sst@tmYRPrecision = 1
if autoTicks
  delete(res_sst@tmYRPrecision)
end if
res_sst@tmYRMinorOn = False
if .not.autoTicks
  res_sst@trYMinF = sstMinMaxInc(0)
  res_sst@trYMaxF = sstMinMaxInc(1)
end if

delete(res_sst@xyLineColors)
;  res_sst@tmYRMode = "Explicit"
;  res_sst@tmYRValues = (/-0.6, 0., 0.6/)
;  res_sst@tmYRLabels = res_sst@tmYRValues

res_ohc = res_line
res_ohc@gsnCenterString = "A - Global Ocean"
;  res_ohc@trYMaxF = 0.6
;  res_ohc@trYMinF = - res_ohc@trYMaxF

plot(1) = gsn_csm_xy2(wks, time, ohc_glo, sst_glo, res_ohc, res_sst)

res_ohc@gsnCenterString = "B - Atlantic"
res_ohc@tmYLPrecision = 1
if autoTicks
  delete(res_ohc@tmYLPrecision)
end if
if .not.autoTicks
  res_ohc@tmYLMode = "Manual"
  res_ohc@tmYLTickStartF   = ohcMinMaxInc_basin(0)
  res_ohc@tmYLTickSpacingF = ohcMinMaxInc_basin(2)
  res_ohc@tmYLTickEndF     = ohcMinMaxInc_basin(1)
  res_ohc@trYMinF = ohcMinMaxInc_basin(0)
  res_ohc@trYMaxF = ohcMinMaxInc_basin(1)
end if

res_sst@tiYAxisString = ""
if .not.autoTicks
  res_sst@tmYLTickStartF   = sstMinMaxInc_basin(0)
  res_sst@tmYLTickEndF     = sstMinMaxInc_basin(1)
  res_sst@tmYLTickSpacingF = sstMinMaxInc_basin(2)
  res_sst@trYMinF = sstMinMaxInc_basin(0)
  res_sst@trYMaxF = sstMinMaxInc_basin(1)
end if
;  res_sst@tmYRLabelsOn = False
plot(2) = gsn_csm_xy2(wks, time, ohc_Atl, sst_Atl, res_ohc, res_sst)

res_ohc@tiYAxisString = ""
res_ohc@gsnCenterString = "D - Southern Ocean"
;  res_ohc@tmYLLabelsOn = False

res_sst@tiYAxisString = yTitle_sst
;  res_sst@tmYRLabelsOn = True
plot(3) = gsn_csm_xy2(wks, time, ohc_Sou, sst_Sou, res_ohc, res_sst)

res_ohc@gsnCenterString = "C - Pacific"
res_ohc@tiXAxisString = xTitle
res_ohc@tiYAxisString = yTitle
;  res_ohc@tmYLLabelsOn = True

res_sst@tiYAxisString = ""
;  res_sst@tmYRLabelsOn = False
plot(4) = gsn_csm_xy2(wks, time, ohc_Pac, sst_Pac, res_ohc, res_sst)

res_ohc@gsnCenterString = "E - Indian Ocean"
res_ohc@tiYAxisString = ""
;  res_ohc@tmYLLabelsOn = False

res_sst@tiYAxisString = yTitle_sst
;  res_sst@tmYRLabelsOn = True
plot(5) = gsn_csm_xy2(wks, time, ohc_Ind, sst_Ind, res_ohc, res_sst)

 resP = True
 resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
 resP@gsnPanelXWhiteSpacePercent = 0
 resP@gsnPanelYWhiteSpacePercent = 5
 resP@gsnPanelRowSpec = True
;   resP@txString = "Sea surface salinity"
gsn_panel(wks, plot, (/2,2,2,2/), resP)

txres               = True
txres@txFontHeightF = fontSize*0.5
texts = (/ "0~~300 m", "  ~~400 m", "  ~~500 m", "  ~~600 m", "  ~~700 m", \
  "  ~~800 m", "  ~~900 m", "  ~~1000 m", "  ~~1100 m", "  ~~1200 m", \
  "  ~~1300 m", "  ~~1400 m", "  ~~1500 m"/)
dposy = 0.03
dposx = 0.1

posx = 0.2
posy = 0.95
txres@txFontColor = res_line@xyLineColors(0)
gsn_text_ndc(wks, texts(0), posx, posy, txres)
do i = 1, 5
  txres@txFontColor = res_line@xyLineColors(i)
  posy = posy - dposy
  gsn_text_ndc(wks, texts(i), posx, posy, txres)
end do

posx = posx + dposx
posy = 0.95
txres@txFontColor = res_line@xyLineColors(6)
gsn_text_ndc(wks, texts(6), posx, posy, txres)
do i = 7, 11
  txres@txFontColor = res_line@xyLineColors(i)
  posy = posy - dposy
  gsn_text_ndc(wks, texts(i), posx, posy, txres)
end do

posx = posx + dposx
posy = 0.95
txres@txFontColor = res_line@xyLineColors(12)
gsn_text_ndc(wks, texts(12), posx, posy, txres)

posy = posy - dposy
;  delete(txres@txFontColor)
txres@txFontColor = 1
gsn_text_ndc(wks, "  SSTa", posx, posy, txres)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
