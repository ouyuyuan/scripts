
; Description: top panel: EOF pattern of wind
;              bottom panel: time series of that pattern
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2015-01-18 21:19:58 BJT

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

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;{{{
f = addfile(datDir+"calc_004_merge_ws_anom.nc", "r")
; 120 yrs
if isExp("exp40b_ws")
  u = f->bcu_an({501:560},:,:)
  v = f->bcv_an({501:560},:,:)
end if
delete(f)
u = dim_rmvmean_n(u, 0)
v = dim_rmvmean_n(v, 0)

; EOF
dims = dimsizes(u)
neof   = 1  ; Leading EOF only
optEOF = True       
optETS = False

eof = eofunc_Wrap(u(lat|:,lon|:,time|:), neof, optEOF)      
eof = -eof
ts = eofunc_ts_Wrap (u(lat|:,lon|:,time|:), eof, optETS)
magTs = max(abs(ts))
vecX = eof(0,:,:)
vecX = vecX*magTs

eof = eofunc_Wrap(v(lat|:,lon|:,time|:), neof, optEOF)      
eof = -eof
ts = eofunc_ts_Wrap (v(lat|:,lon|:,time|:), eof, optETS)
magTs = max(abs(ts))
vecY = eof(0,:,:)
vecY = vecY*magTs

cn = u(0,:,:)
cn = sqrt(vecX^2 + vecY^2)
lineY = ts/magTs
lineX = ts&time
if isPcom .and. lineX(0).gt.500
  lineX = lineX - 500
end if
;}}}

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; plot model 
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

;  cmap = "NCL_default"
;  cmap = "GMT_jet"
;  cmap = "WhiteBlueGreenYellowRed"
cmap = "BlGrYeOrReVi200"
;cmap = "NCV_blu_red"

fontSize = 0.02
yLabelSize = fontSize
xLabelSize = fontSize
plotWid = 0.9
plotHei = 0.2
yTitle = "depth (meter)"
xTitle = "model year"
cbTitle = cn@units
cnMinMaxInc = (/-0.6, 0.6, 0.01/)
tmMaxY = 2000
;autoTicks = False
autoTicks = True
;if isExp("exp24")
;  autoTicks = False
;end if

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks,cmap)

res = True
; {{{
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

res_vec = res
;{{{
res_vec@gsnScalarContour     = True               ; contours desired
if cmap .eq. "BlGrYeOrReVi200"
   res_vec@gsnSpreadColorStart  = 35                 ; start at color 17
   res_vec@gsnSpreadColorEnd    = 180                ; end at color 200
end if

;res_vec@vcLevelSelectionMode = "ManualLevels"
;   res_vec@vcMonoLineArrowColor  = False                ; vec's colored by their mag_p_n

res_vec@vcRefMagnitudeF       = 0.6                  ; add a reference vector
res_vec@vcRefAnnoString1 = res_vec@vcRefMagnitudeF
res_vec@vcRefAnnoString2 = "dyne/cm^2"
;res_vec@vcRefAnnoString2On = True
res_vec@vcRefLengthF          = 0.05                ; what the ref length is
res_vec@vcMinDistanceF          = 0.02            ; thin out vectors
res_vec@vcRefAnnoOn = False
res_vec@vcRefAnnoOrthogonalPosF   = -0.6            ; move ref vector
res_vec@vcRefAnnoParallelPosF   = 0.1            ; move ref vector
res_vec@vcRefAnnoArrowLineColor   = "black"         ; change ref vector color
res_vec@vcRefAnnoArrowUseVecColor = False           ; don't use vec color for ref
res_vec@vcRefAnnoOn = True
res_vec@vcRefAnnoJust = "BottomLeft"

;   res_vec@vcGlyphStyle          = "CurlyVector"        ; turn on curly vectors
;res_vec@vcLineArrowThicknessF   = 5               ; change vector thickness
res_vec@vcLineArrowColor        = "black"           ; change vector color
;res_vec@vcLineArrowHeadMaxSizeF = 0.015
;res_vec@vcLineArrowHeadMinSizeF = 0.005  
res_vec@vcVectorDrawOrder       = "PostDraw"        ; draw vectors last

res_vec@cnFillOn             = True               ; turn on color for contours
res_vec@cnLinesOn            = False              ; turn off contour lines
;   res_vec@cnLineThicknessF = 0.5
res_vec@cnLineLabelsOn       = False              ; turn off contour line labels
res_vec@cnInfoLabelOn        = False      ; turns off contour info label
if .not.autoTicks
  res_vec@cnLevelSelectionMode = "ManualLevels"
  res_vec@cnMinLevelValF       = cnMinMaxInc(0)
  res_vec@cnMaxLevelValF       = cnMinMaxInc(1)
  res_vec@cnLevelSpacingF      = cnMinMaxInc(2)
end if
;res_vec@cnMissingValFillColor = "gray60"
;   res_vec@cnFillMode = "RasterFill"

res_vec@mpShapeMode = "FreeAspect"
res_vec@mpMinLatF = 10
res_vec@mpMaxLatF = 65
;res_vec@mpMinLonF = 120
;res_vec@mpMaxLonF = 290
res_vec@mpCenterLonF = 180

;res_vec@lbLabelBarOn = False
res_vec@lbOrientation = "vertical"
res_vec@lbTitleString = cbTitle
;res_vec@lbTitlePosition = "Right"
res_vec@lbTitleFontHeightF = fontSize*0.8
res_vec@lbBoxLinesOn = False
res_vec@lbLabelFontHeightF = fontSize*0.8
res_vec@lbLabelStride = 2

res_vec@pmLabelBarWidthF = 0.02
res_vec@pmLabelBarHeightF = plotHei
;res_vec@pmLabelBarOrthogonalPosF = 0.2
;}}}

res_line = res
;{{{
res_line@vpHeightF = plotHei*1.5

res_line@tiXAxisString = xTitle
res_line@tiYAxisString = yTitle

res_line@gsnYRefLine = 0.

res_line@xyLineColor = "red"
res_line@xyLineThicknessF = 2

if .not.autoTicks
  res_line@tmYLMode = "Manual"
  res_line@tmYLTickStartF   = lineMinMaxInc(0)
  res_line@tmYLTickEndF     = lineMinMaxInc(1)
  res_line@tmYLTickSpacingF = lineMinMaxInc(2)
  res_line@trYMinF = lineMinMaxInc(0)
  res_line@trYMaxF = lineMinMaxInc(1)
end if

res_line@tmYLPrecision = 1
if autoTicks
  delete(res_line@tmYLPrecision)
end if

res_vec@tmXBLabelStride = 2
;}}}

plot = new(2, graphic)
;plot(0) = gsn_csm_vector_scalar_map(wks, vecX, vecY, cn, res_vec)
plot(0) = gsn_csm_vector_scalar_map(wks, vecX, vecY, cn, res_vec)
plot(1) = gsn_csm_xy(wks, lineX, lineY, res_line)

resP = True
resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 10
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStrings = (/"a)","b)"/)
resP@gsnPanelFigureStringsFontHeightF = fontSize
resP@gsnPanelFigureStringsPerimOn = False
resP@gsnPanelFigureStringsBackgroundFillColor = "transparent"
resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.5
;   resP@txString = "Sea surface salinity"
gsn_panel(wks, plot, (/1,1/), resP)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
