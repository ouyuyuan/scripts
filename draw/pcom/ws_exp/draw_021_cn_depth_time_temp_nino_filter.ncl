
; Description: 4 subplots, each is a depth-year contour plot
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-13 08:39:12 BJT
; Last Change: 2015-01-26 10:33:17 BJT

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

function isImg(imgName)
;{{{
begin
Img = False
if isStrSubset(img, imgName) then
  Img = True
end if
return Img
end
;}}}

function get_dtrend_temp(fname, varName)
;{{{
local time
begin

  f = addfile(fname, "r")
  if isExp("exp40b_ws")
    temp= f->$varName$({501:560},:)
  end if
  if isExp("exp24_")
    temp= f->$varName$({501:740},:)
  end if
  delete(f)

  time = temp&time
  if isPcom
    time = time - 500
    if isExp("exp24_")
      ; discard the first cycle
;      time = time - 40
    end if
  end if
  temp&time = time

;  temp = dim_rmvmean_n(temp,0)
  temp = dtrend_n(temp,False,0)
  temp = temp*10
  temp@units = "10~S~-1 o~N~C"
  return temp(z|:,time|:)
end
;}}}

function filter(temp, timescale)
;{{{
; temp dimension is: z, time
local time
begin

  time = temp&time

  ; low pass filter
  dt = 1  ; year
  sigma = 1.0
  if timescale.eq."decadal" then
    t1 = 10 ; years
    nWgt = 7
    ihp = 0 ; low pass

    fca = 1./t1
    fcb = 999.
  else if timescale .eq. "nino"
    t1 = 7 ; years
    t2 = 3

    nWgt = 5
    ihp = 2 ; band pass

    fca = 1./t1
    fcb = 1./t2
  end if
  end if
  wgt = filwgts_lanczos(nWgt, ihp, fca, fcb, sigma)
  tempBPF = wgt_runave_n_Wrap(temp, wgt, 1, 1)

  return tempBPF
end
;}}}

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;{{{
rootDir = "/home/ou/archive/data/"
nc = "calc_005_temp_depth_time.nc"
tempAnomNino = get_dtrend_temp(datDir+nc, "nino34")
tempSpinNino = get_dtrend_temp(rootDir+"pcom/exp_spinup/post/"+nc, "nino34")

cn1 = tempSpinNino
cn2 = tempAnomNino

cn3 = filter(tempSpinNino, "decadal")
cn4 = filter(tempAnomNino, "decadal")
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
titles = (/"a) exp_ctl", "b) exp_anom", \
          "c) low pass filter of a)", "d) low pass filter of b)"/)
yTitle = "depth (meter)"
xTitle = "year"
cbTitle = cn1@units
cnMinMaxInc = (/-1.1, 1.1, 0.05/)
tmMaxY = 600
if isImg("___nino_timescale")
  cnMinMaxInc = (/-2., 2., 0.1/)
;  tmMaxY = 5000
end if
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
res_cn@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 

res_cn@cnFillOn             = True               ; turn on color for contours
res_cn@cnLinesOn            = False              ; turn off contour lines
;   res_cn@cnLineThicknessF = 0.5
res_cn@cnLineLabelsOn       = False              ; turn off contour line labels
res_cn@cnInfoLabelOn        = False      ; turns off contour info label
if .not.autoTicks
  res_cn@cnLevelSelectionMode = "ManualLevels"
  res_cn@cnMinLevelValF       = cnMinMaxInc(0)
  res_cn@cnMaxLevelValF       = cnMinMaxInc(1)
  res_cn@cnLevelSpacingF      = cnMinMaxInc(2)
end if
res_cn@cnMissingValFillColor = "gray60"
;   res_cn@cnFillMode = "RasterFill"

res_cn@lbLabelBarOn = False
;res_cn@lbOrientation = "vertical"
res_cn@lbTitleString = cbTitle
res_cn@lbBoxLinesOn = False
;res_cn@lbTitlePosition = "Right"
res_cn@lbLabelFontHeightF = fontSize
res_cn@lbTitleFontHeightF = fontSize

res_cn@trYReverse               = True   ; reverses y-axis
if .not.autoTicks
  res_cn@trYMaxF = tmMaxY
end if
;res_cn@trXMinF = 110
;res_cn@trXMaxF = 345
;}}}

plot = new(4, graphic)

res_cn@tiMainString = titles(0)
res_cn@tiXAxisString = ""
plot(0) = gsn_csm_contour(wks, cn1, res_cn)

res_cn@tiMainString = titles(1)
res_cn@tiXAxisString = ""
res_cn@tiYAxisString = ""
plot(1) = gsn_csm_contour(wks, cn2, res_cn)

res_cn@tiMainString = titles(2)
res_cn@tiXAxisString = xTitle
res_cn@tiYAxisString = yTitle
plot(2) = gsn_csm_contour(wks, cn3, res_cn)

res_cn@tiMainString = titles(3)
res_cn@tiXAxisString = xTitle
res_cn@tiYAxisString = ""
plot(3) = gsn_csm_contour(wks, cn4, res_cn)

resP = True
resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
resP@gsnPanelLabelBar = True
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
