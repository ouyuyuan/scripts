; Description: time and space structure of Southern Ocean
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-12-16 19:51:52 BJT
; Last Change: 2014-12-22 10:22:40 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

datDir = getenv("NCL_ARG_1")
img = getenv("NCL_ARG_2")
;autoTicks = True
autoTicks = False

;guess data and img
;{{{
isDiff = False
if isStrSubset(img, "___diff") then
  isDiff = True
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

isExp34 = False
if isPcom .and. isStrSubset(datDir, "exp34") then
  isExp34 = True
end if

isWhite1996 = False
if isIshii .and. isStrSubset(img, "___White1996") then
  isWhite1996 = True
  autoTicks = False
end if
;}}}

; make longitude start from longStrt
; assume lon is 0~360
procedure shift_lon(var, lonStrt)
local lon, nlon, iStrt, nlon1, nlon2, varNew, lonNew
;{{{
begin
  lon = var&lon
  nlon = dimsizes(lon)
  iStrt = ind(lon.eq.lonStrt)
  nlon1 = nlon - iStrt
  nlon2 = iStrt

  lonNew = lon
  lonNew(0:nlon1-1) = lon(iStrt:)
  lonNew(nlon1:) = lon(:nlon2-1)+360
  lon = lonNew

  varNew = var
  varNew(:,0:nlon1-1) = var(:,iStrt:)
  varNew(:,nlon1:) = var(:,:nlon2-1)
  varNew&lon = lon
  var = varNew
end
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
  ohc = dim_rmvmean_n(ohc,1)
  if sDiff
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

function get_sst_monthly(fname, varName, lat)
;{{{
begin
  f = addfile(fname,"r")
  sst = f->$varName$(:,0,{lat},:)
  delete(f)
  sst@units = "~S~o~N~C"

  do month = 1, 12
    i = month-1
    monAvg = dim_avg_n(sst(i::12, :), 0)
    sst(i::12,:) = sst(i::12,:) - conform(sst(i::12,:), monAvg, 1)
  end do

  yyyymm = cd_calendar(sst&time, -1)
  yrfrac = yyyymm_to_yyyyfrac(yyyymm, 0.0)
  
  time = yrfrac
  sst&time = time

  ; band pass filter
  dt = 1  ; month

  t1 = 35 ; years
  t2 = 30 ; years
  nWgt = 41
  ihp = 2

  if isWhite1996
    ihp = 2 ; band pass
    t1 = 7 ; years
    t2 = 3 ; years
    nWgt = 121
  end if

  sigma = 1.0
  fca = 1./(t1*12.)
  fcb = 1./(t2*12.)
  wgt = filwgts_lanczos(nWgt, ihp, fca, fcb, sigma)

  sstBPF = wgt_runave_n_Wrap(sst, wgt, 0, 0)

  return sstBPF
end
;}}}

;  cmap = "NCL_default"
;  cmap = "GMT_jet"
;  cmap = "WhiteBlueGreenYellowRed"
  cmap = "NCV_blu_red"
;cmap = "BlGrYeOrReVi200"
;  cmap = "NCV_jet"
;  cmap = "MPL_jet"

sst_lon = get_sst_monthly(datDir+"sst_monthly.nc", "var80", -56)
shift_lon(sst_lon, 30.5)
;sst_lon = get_sst(datDir+"sst.nc", "Sou")

fontSize = 0.03
yLabelSize = fontSize
xLabelSize = fontSize*0.8
plotWid = 0.4
plotHei = 0.9
xTitle = "longitude"
yTitle = "year"
if isWhite1996
  xTitle = ""
end if
if isPcom
  yTitle = "model year"
end if
ohcMinMaxInc = (/-1.6, 1.6, 0.8/)
sstMinMaxInc = (/-0.5, 0.5, 0.1/)
tickY = ispan(1950,2010,10)
if isWhite1996
  tickY = ispan(1982,1995,1)
end if
tickX = (/30, 120, 210, 300, 390/)
xLabels = (/\
"30~S~o~N~E",\
"120~S~o~N~E",\
"150~S~o~N~W",\
"60~S~o~N~W",\
"30~S~o~N~E"/)

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks,cmap)

res = True
;{{{
res@vpWidthF = plotWid
res@vpHeightF = plotHei
;  res@vpXF = 0.1
;  res@vpYF = 0.9
res@tiXAxisString = xTitle
res@tiXAxisFontHeightF = fontSize
res@gsnDraw = False
res@gsnFrame = False
res@gsnStringFontHeightF = fontSize
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
;res@gsnCenterStringOrthogonalPosF = 0.01
res@tmXTOn = False
;res@tmYROn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize
res@tmXBLabelAngleF = 90
res@tmLabelAutoStride = True
;}}}

res_cn = res
;{{{
res_cn@vpHeightF = plotHei
res_cn@tiYAxisString = yTitle
;   res_cn@gsnYAxisIrregular2Linear = True
;res_cn@cnLinesOn            = False              ; turn off contour lines
res_cn@cnLineLabelsOn       = False              ; turn off contour line labels
res_cn@cnInfoLabelOn        = False      ; turns off contour info label
;  res_cn@cnMissingValFillColor = "gray60"
;res_cn@cnFillMode = "RasterFill"
;   res_cn@lbPerimOn                = False             ; no box around it
res_cn@lbLabelFontHeightF = fontSize*0.8
if .not.autoTicks
  res_cn@tmYLMode = "Explicit"
  res_cn@tmYLValues = tickY
  res_cn@tmYLLabels = tickY
  res_cn@trYMinF = tickY(0)
  nticks = dimsizes(tickY)
  res_cn@trYMaxF = tickY(nticks-1)
  if isWhite1996
    res_cn@tmXBMode = "Explicit"
    res_cn@tmXBValues = tickX
    res_cn@tmXBLabels = xLabels
  end if
end if
res_cn@trYReverse          = True                  ; reverse y-axis
if (cmap.eq."WhiteBlueGreenYellowRed") then
  res_cn@gsnSpreadColorStart  = 20
end if
;}}}

res_sst = res_cn
;{{{
;res_sst@gsnCenterString = "zonal average SSTa change with time"
res_sst@cnFillOn             = True               ; turn on color for contours
if .not.autoTicks
  res_sst@cnLevelSelectionMode = "ManualLevels"
  res_sst@cnMinLevelValF       = sstMinMaxInc(0)
  res_sst@cnMaxLevelValF       = sstMinMaxInc(1)
  res_sst@cnLevelSpacingF      = sstMinMaxInc(2)
end if
res_sst@lbOrientation = "vertical"
;   res_sst@lbLabelStride            = 5
;   res_sst@lbLabelPosition = "Top"
;   res_sst@lbTitlePosition = "Right"
res_sst@lbTitleString = sst_lon@units
res_sst@lbTitleFontHeightF = fontSize*0.8
;res_sst@lbTitleOffsetF = 0.1
res_sst@lbBoxLinesOn = False

;res_sst@pmLabelBarHeightF = 0.8
;res_sst@pmLabelBarWidthF = 0.1
res_sst@pmLabelBarOrthogonalPosF = 0.01
res_sst@pmLabelBarParallelPosF = 0.6
;}}}

plot = new(1, graphic)

plot(0) = gsn_csm_contour(wks, sst_lon, res_sst)

 resP = True
 resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
 resP@gsnPanelXWhiteSpacePercent = 0
 resP@gsnPanelYWhiteSpacePercent = 5
 resP@gsnPanelRowSpec = True
;   resP@txString = "Sea surface salinity"
;gsn_panel(wks, plot, (/2,2,2,2/), resP)
gsn_panel(wks, plot, (/1/), resP)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
