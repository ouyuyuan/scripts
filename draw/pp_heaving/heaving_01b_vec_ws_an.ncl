
; Description: top panel: EOF pattern of wind
;              bottom panel: time series of that pattern
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2015-04-28 20:51:52 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

datDir = getenv("NCL_ARG_1")
img = getenv("NCL_ARG_2")

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;{{{
f = addfile(datDir+"calc_004_merge_ws_anom.nc", "r")
u = f->bcu_an(:,:,:)
v = f->bcv_an(:,:,:)
delete(f)
u = u*0.1 ; change dyne/cm^2 to N/m^2 (1 dyne = 10^-5 N)
v = v*0.1

u = lonFlip(u)
v = lonFlip(v)

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

cn = u(0,:,:) ; get coordinates
cn = sqrt(vecX^2 + vecY^2)
;cn = sqrt(vecY^2)
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
plotWid = 0.6
plotHei = 0.4
cbTitle = "N/m~S~2"
arrowDistance = 0.025
unitVec       = 0.015
unitVecLen    = 0.045
cnMinMaxInc = (/-0.6, 0.6, 0.01/)
;autoTicks = False
autoTicks = True

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
res@gsnScalarContour     = True               ; contours desired
if cmap .eq. "BlGrYeOrReVi200"
   res@gsnSpreadColorStart  = 35                 ; start at color 17
   res@gsnSpreadColorEnd    = 180                ; end at color 200
end if

res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
res@gsnStringFontHeightF = fontSize
res@gsnCenterStringOrthogonalPosF = 0.03

res@cnFillOn             = True               ; turn on color for contours
res@cnLinesOn            = False              ; turn off contour lines
res@cnLineThicknessF = 0.5
res@cnLineLabelsOn       = False              ; turn off contour line labels
res@cnInfoLabelOn        = False      ; turns off contour info label
if .not.autoTicks
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       = cnMinMaxInc(0)
  res@cnMaxLevelValF       = cnMinMaxInc(1)
  res@cnLevelSpacingF      = cnMinMaxInc(2)
end if

;res@lbLabelBarOn = False
res@lbOrientation = "vertical"
res@lbTitleString = cbTitle
;res@lbTitlePosition = "Right"
res@lbTitleFontHeightF = fontSize*0.8
;res@lbBoxLinesOn = False
res@lbLabelFontHeightF = fontSize*0.8
;res@lbLabelStride = 2

res@pmLabelBarWidthF = 0.02
res@pmLabelBarHeightF = plotHei
;res@pmLabelBarOrthogonalPosF = 0.2

res@mpShapeMode = "FreeAspect"
res@mpOutlineOn = True
res@mpLandFillColor          = "gray"            ; set land to be gray
res@mpMinLatF = -30
res@mpMaxLatF = 30
;res@mpMinLonF = -80
;res@mpMaxLonF = 20
res@mpCenterLonF = 200

;res@vcLevelSelectionMode = "ManualLevels"
;   res@vcMonoLineArrowColor  = False                ; vec's colored by their mag_p_n
res@vcRefMagnitudeF          = unitVec
res@vcRefLengthF             = unitVecLen
res@vcMinDistanceF           = arrowDistance
res@vcLineArrowHeadMaxSizeF = 0.01
res@vcLineArrowHeadMinSizeF = 0.005  

res@vcRefAnnoOn = True
res@vcRefAnnoJust = "BottomLeft"
res@vcRefAnnoString1 = res@vcRefMagnitudeF
res@vcRefAnnoString2 = cbTitle
res@vcRefAnnoString2On = True
res@vcRefAnnoOrthogonalPosF   = -0.6            ; move ref vector
res@vcRefAnnoParallelPosF   = 0.1            ; move ref vector
res@vcRefAnnoArrowLineColor   = "black"         ; change ref vector color
res@vcRefAnnoArrowUseVecColor = False           ; don't use vec color for ref

res@vcGlyphStyle          = "CurlyVector"        ; turn on curly vectors
res@vcLineArrowThicknessF   = 2               ; change vector thickness
res@vcLineArrowColor        = "black"           ; change vector color
res@vcVectorDrawOrder       = "PostDraw"        ; draw vectors last

res@tmXTOn = False
res@tmYROn = False
res@tmYLMinorOn = False
res@tmYRMinorOn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmYRLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize
; }}}

plot = gsn_csm_vector_scalar_map(wks, vecX, vecY, cn, res)

draw(plot)
frame(wks)
delete(wks)
system("eps2png_trim "+img)
