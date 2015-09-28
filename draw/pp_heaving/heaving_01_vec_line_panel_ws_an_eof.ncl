
; Description: top panel: EOF pattern of wind
;              bottom panel: time series of that pattern
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2015-06-06 10:55:08 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$HOME/archive/scripts/utils/pcom.ncl"

datDir = getenv("NCL_ARG_1")
img = getenv("NCL_ARG_2")

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
plotWid = 0.8
plotHei = 0.2
cbTitle = "N/m~S~2"
cnMinMaxInc = (/0.0, 0.014, 0.001/)
arrowDistance = 0.025
unitVec       = 0.015
unitVecLen    = 0.045

autoTicks = False
;autoTicks = True

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks,cmap)

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;{{{
f = addfile(datDir+"calc_004_merge_ws_anom.nc", "r")
u = f->bcu_an(:,:,:)
v = f->bcv_an({620},:,:)
delete(f)
u = dim_rmvmean_n(u, 0)*0.1 ; dyne/cm^2 to N/m^2
v = dim_rmvmean_n(v, 0)*0.1

time = u&time
lat = u&lat
lon = u&lon
nt = dimsizes(time)
nlat = dimsizes(lat)
nlon = dimsizes(lon)

eof = new((/2,nlat,nlon/),typeof(u))
ts = new((/2,nt/),typeof(u))

pcom_eof(u, eof, ts)
eof = -eof
ts = -ts
magTs = max(abs(ts))
vecX = eof(0,:,:)
vecX = vecX*magTs


;pcom_eof(v, eof, ts)
;eof = -eof
;ts = -ts
;magTs = max(abs(ts))
;vecY = eof(0,:,:)
;vecY = vecY*magTs

vecY = vecX ; for only zonal perturbation
vecY = 0

cn = u(0,:,:)
cn = sqrt(vecX^2 + vecY^2)
lineY = ts/magTs
lineX = ts&time - 600
cnV = v
;}}}

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

resVec = res
;{{{
resVec@gsnScalarContour     = True               ; contours desired
if cmap .eq. "BlGrYeOrReVi200"
   resVec@gsnSpreadColorStart  = 35                 ; start at color 17
   resVec@gsnSpreadColorEnd    = 180                ; end at color 200
end if

;resVec@vcLevelSelectionMode = "ManualLevels"
;   resVec@vcMonoLineArrowColor  = False                ; vec's colored by their mag_p_n

resVec@vcRefMagnitudeF          = unitVec
resVec@vcRefLengthF             = unitVecLen
resVec@vcMinDistanceF           = arrowDistance
resVec@vcLineArrowHeadMaxSizeF = 0.01
resVec@vcLineArrowHeadMinSizeF = 0.005  
resVec@vcLineArrowThicknessF   = 2               ; change vector thickness

resVec@vcRefAnnoString1 = resVec@vcRefMagnitudeF
resVec@vcRefAnnoString2 = "N/m~S~2"
;resVec@vcRefAnnoString2On = True
resVec@vcRefAnnoOrthogonalPosF   = -0.95            ; move ref vector
resVec@vcRefAnnoParallelPosF   = 0.04            ; move ref vector
resVec@vcRefAnnoArrowLineColor   = "black"         ; change ref vector color
resVec@vcRefAnnoArrowUseVecColor = False           ; don't use vec color for ref
resVec@vcRefAnnoOn = True
resVec@vcRefAnnoJust = "BottomLeft"

resVec@vcGlyphStyle          = "CurlyVector"        ; turn on curly vectors
resVec@vcLineArrowColor        = "black"           ; change vector color
resVec@vcVectorDrawOrder       = "PostDraw"        ; draw vectors last

resVec@cnFillOn             = True               ; turn on color for contours
resVec@cnLinesOn            = False              ; turn off contour lines
;   resVec@cnLineThicknessF = 0.5
resVec@cnLineLabelsOn       = False              ; turn off contour line labels
resVec@cnInfoLabelOn        = False      ; turns off contour info label
if .not.autoTicks
  resVec@cnLevelSelectionMode = "ManualLevels"
  resVec@cnMinLevelValF       = cnMinMaxInc(0)
  resVec@cnMaxLevelValF       = cnMinMaxInc(1)
  resVec@cnLevelSpacingF      = cnMinMaxInc(2)
end if
;resVec@cnMissingValFillColor = "gray60"
;   resVec@cnFillMode = "RasterFill"

resVec@mpShapeMode = "FreeAspect"
resVec@mpMinLatF = -60
resVec@mpMaxLatF = 60
;resVec@mpMinLonF = 120
;resVec@mpMaxLonF = 290
resVec@mpCenterLonF = 180

;resVec@lbLabelBarOn = False
resVec@lbOrientation = "vertical"
resVec@lbTitleString = cbTitle
;resVec@lbTitlePosition = "Right"
resVec@lbTitleFontHeightF = fontSize*0.8
resVec@lbBoxLinesOn = False
resVec@lbLabelFontHeightF = fontSize*0.8
resVec@lbLabelStride = 2

resVec@pmLabelBarWidthF = 0.02
resVec@pmLabelBarHeightF = plotHei
;resVec@pmLabelBarOrthogonalPosF = 0.2
;}}}

res_line = res
;{{{

res_line@tiXAxisString = "model year"
;res_line@tiYAxisString = "B(t)"

res_line@gsnYRefLine = 0.

res_line@xyLineColor = "red"
res_line@xyLineThicknessF = 2

resVec@tmXBLabelStride = 2
;}}}

plot = new(3, graphic)
;plot(0) = gsn_csm_vector_scalar_map(wks, vecX, vecY, cn, resVec)
plot(0) = gsn_csm_vector_scalar_map(wks, vecX, vecY, cn, resVec)
plot(1) = gsn_csm_vector_scalar_map(wks, vecX, vecY, cnV, resVec)
plot(2) = gsn_csm_xy(wks, lineX, lineY, res_line)

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
gsn_panel(wks, plot, (/1,1,1/), resP)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
