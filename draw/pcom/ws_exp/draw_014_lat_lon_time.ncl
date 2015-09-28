; Description: time evolution of several lat-lon contours
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-12-16 19:51:52 BJT
; Last Change: 2014-12-30 10:35:55 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

datDir = getenv("NCL_ARG_1")
img = getenv("NCL_ARG_2")
autoTicks = True
;autoTicks = False

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

function get_ohc(fname, varName, year)
;{{{
local time
begin
  ohc_basin = f->$varName$({year},0:17) ; first 18 layers, upper 454 m 
  time = ohc_basin&$ohc_basin!0$
  nt = dimsizes(time)
  ohc(i-3,:) = dim_sum_n(ohc_basin(:,{0:depth}), 1)

  if isDiff
    expYears = ohc&time
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

function get_sst_monthly(fname, varName)
;{{{
begin
  f = addfile(fname,"r")
  sst = f->$varName$(:,0,:,:)
  delete(f)
;  sst = lonFlip(sst)
  clm = clmMonTLL(sst)
  sst@units = "~S~o~N~C"
  anom = calcMonAnomTLL(sst, clm)

  yyyymm = cd_calendar(sst&time, -1)
  yrfrac = yyyymm_to_yyyyfrac(yyyymm, 0.0)
  
  time = yrfrac
  anom&time = time

  ; band pass filter
  dt = 1  ; month
  t1 = 7 ; years
  t2 = 3 ; years

  ihp = 2
  sigma = 1.0
  nWgt = 121
  fca = 1./(t1*12.)
  fcb = 1./(t2*12.)
  wgt = filwgts_lanczos(nWgt, ihp, fca, fcb, sigma)

  anBPF = wgt_runave_n_Wrap(anom, wgt, 0, 0)
  return anBPF
end
;}}}

cmap = "NCV_blu_red"

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
cn1 = get_ohc(datDir+"ohc.nc", "Pac", 501)

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; plot model
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

fontSize = 0.03
yLabelSize = fontSize
xLabelSize = fontSize*0.8
plotWid = 0.9
plotHei = 0.1
xTitle = ""
yTitle = ""
mpLatS = -77
mpLatN = -30
if isPcom
  yTitle = "model year"
end if
ohcMinMaxInc = (/-1.6, 1.6, 0.8/)
sstMinMaxInc = (/-0.6, 0.6, 0.05/)
tickY = (/-30, -70/)
yLabels =(/\
"30~S~o~N~S",\
"70~S~o~N~S"/)
tickX = (/30, 90, 150, 210, 270, 330, 30/)
xLabels = (/\
"30~S~o~N~E",\
"90~S~o~N~E",\
"150~S~o~N~E",\
"150~S~o~N~W",\
"90~S~o~N~W",\
"30~S~o~N~W",\
"30~S~o~N~E"/)

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks,cmap)

res_cn = True
;{{{
res_cn@vpWidthF = plotWid
res_cn@vpHeightF = plotHei
;  res_cn@vpXF = 0.1
;  res_cn@vpYF = 0.9

res_cn@tiXAxisString = xTitle
res_cn@tiXAxisFontHeightF = fontSize
res_cn@tiYAxisString = yTitle

res_cn@gsnDraw = False
res_cn@gsnFrame = False
res_cn@gsnStringFontHeightF = fontSize
res_cn@gsnLeftString = ""
res_cn@gsnRightString = ""
res_cn@gsnCenterString = ""
;res_cn@gsnCenterStringOrthogonalPosF = 0.01
;   res_cn@gsnYAxisIrregular2Linear = True
if (cmap.eq."WhiteBlueGreenYellowRed") then
  res_cn@gsnSpreadColorStart  = 20
end if

res_cn@cnLinesOn            = False              ; turn off contour lines
res_cn@cnFillOn             = True               ; turn on color for contours
res_cn@cnLineLabelsOn       = False              ; turn off contour line labels
res_cn@cnInfoLabelOn        = False      ; turns off contour info label
;  res_cn@cnMissingValFillColor = "gray60"
;res_cn@cnFillMode = "RasterFill"
if .not.autoTicks
  res_cn@cnLevelSelectionMode = "ManualLevels"
  res_cn@cnMinLevelValF       = sstMinMaxInc(0)
  res_cn@cnMaxLevelValF       = sstMinMaxInc(1)
  res_cn@cnLevelSpacingF      = sstMinMaxInc(2)
end if

res_cn@mpShapeMode = "FreeAspect"
res_cn@mpMinLatF = mpLatS
res_cn@mpMaxLatF = mpLatN
res_cn@mpCenterLonF = 210
res_cn@mpLandFillColor = "black"

res_cn@lbLabelBarOn = False
res_cn@lbLabelFontHeightF = fontSize*0.8
;res_cn@lbOrientation = "vertical"
;   res_cn@lbLabelStride            = 5
;   res_cn@lbLabelPosition = "Top"
;   res_cn@lbTitlePosition = "Right"
res_cn@lbTitleString = sst@units
res_cn@lbTitleFontHeightF = fontSize*0.8
;res_cn@lbTitleOffsetF = 0.1
res_cn@lbBoxLinesOn = False
;   res_cn@lbPerimOn                = False             ; no box around it

res_cn@tmXTOn = False
res_cn@tmXBOn = False
;res_cn@tmYROn = False
res_cn@tmYLOn = False
res_cn@tmYLLabelFontHeightF = yLabelSize 
res_cn@tmXBLabelFontHeightF = xLabelSize
;res_cn@tmXBLabelAngleF = 90
res_cn@tmLabelAutoStride = True
if .not.autoTicks
  res_cn@tmYLMode = "Explicit"
  res_cn@tmYLValues = tickY
  res_cn@tmYLLabels = tickY
  res_cn@tmXBMode = "Explicit"
  res_cn@tmXBValues = tickX
  res_cn@tmXBLabels = xLabels
end if

;res_cn@pmLabelBarHeightF = 0.8
;res_cn@pmLabelBarWidthF = 0.1
res_cn@pmLabelBarOrthogonalPosF = 0.01
res_cn@pmLabelBarParallelPosF = 0.6

res_cn@trYReverse          = True                  ; reverse y-axis
;}}}

plot = new(9, graphic)

plot(0) = gsn_csm_contour_map(wks, sst({1985.5},:,:), res_cn)
plot(1) = gsn_csm_contour_map(wks, sst({1986},:,:), res_cn)
plot(2) = gsn_csm_contour_map(wks, sst({1986.5},:,:), res_cn)
plot(3) = gsn_csm_contour_map(wks, sst({1987},:,:), res_cn)
plot(4) = gsn_csm_contour_map(wks, sst({1987.5},:,:), res_cn)
plot(5) = gsn_csm_contour_map(wks, sst({1988},:,:), res_cn)
plot(6) = gsn_csm_contour_map(wks, sst({1988.5},:,:), res_cn)
plot(7) = gsn_csm_contour_map(wks, sst({1989},:,:), res_cn)
plot(8) = gsn_csm_contour_map(wks, sst({1989.5},:,:), res_cn)

resAtt1 = True
resAtt1@gsnAttachPlotsXAxis = True
resAtt2 = True
attachid8 = gsn_attach_plots(plot(7), plot(8), resAtt1, resAtt2)
attachid7 = gsn_attach_plots(plot(6), plot(7), resAtt1, resAtt2)
attachid6 = gsn_attach_plots(plot(5), plot(6), resAtt1, resAtt2)
attachid5 = gsn_attach_plots(plot(4), plot(5), resAtt1, resAtt2)
attachid4 = gsn_attach_plots(plot(3), plot(4), resAtt1, resAtt2)
attachid3 = gsn_attach_plots(plot(2), plot(3), resAtt1, resAtt2)
attachid2 = gsn_attach_plots(plot(1), plot(2), resAtt1, resAtt2)
attachid1 = gsn_attach_plots(plot(0), plot(1), resAtt1, resAtt2)

resP = True
resP@gsnFrame = False
resP@gsnMaximize = False
resP@gsnPanelLabelBar = True
;      resP@gsnPanelBottom = 0.05
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 0
; resP@gsnPanelRowSpec = True
;   resP@txString = "Sea surface salinity"
;resP@pmLabelBarWidthF = 0.8
resP@pmLabelBarHeightF = 0.1
resP@pmLabelBarOrthogonalPosF = 0.01
resP@lbTitleString = sst@units
resP@lbTitleFontHeightF = fontSize*0.8
resP@lbTitlePosition = "Bottom"

gsn_panel(wks, plot(0), (/1,1/), resP)

texts = (/ \
"1985-07",\
"1986-01",\
"1986-07",\
"1987-01",\
"1987-07",\
"1988-01",\
"1988-07",\
"1989-01",\
"1989-07"/)

posx = 0.2
posy = 0.97
dposy = plotHei*0.9
txres               = True
txres@txFontHeightF = fontSize*0.8
gsn_text_ndc(wks, texts(0), posx, posy, txres)
do i = 1, 8
  posy = posy - dposy
  gsn_text_ndc(wks, texts(i), posx, posy, txres)
end do

frame(wks)
delete(wks)
system("eps2png_trim "+img)
