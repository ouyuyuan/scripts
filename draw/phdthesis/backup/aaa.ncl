
; Description: wind stress anomaly
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2016-04-14 15:37:37 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$HOME/archive/scripts/utils/pcom.ncl"

;---img, dirs, and data files---------------------------{{{1
load "head.ncl"
nc = "post/calc_004_merge_ws_anom.nc"

;---get plotting data-----------------------------------{{{1
function get_an(expname,varname)
local var
begin
  f   = addfile(datDir+expname+nc, "r")
  var = f->$varname$({614},:,:); anomaly maximze at 611-620
  delete(f)
  var = var*0.1 ; dyne/cm^2 to N/m^2
  return var
end

nyear = 60
coef = new(nyear+1,float)
coef = 0

; calc. B(t)
do t = 1, nyear
  if t.le.10 then
    coef(t) = 0.1*t 
  else if t.le.20 then
    coef(t) = 1
  else if t.le.40 then
    coef(t) = 3 - t/10.0
  else if t.le.50 then
    coef(t) = -1
  else if t.le.nyear then
    coef(t) = t/10.0 - 6
  end if
  end if
  end if
  end if
  end if
end do

lineX = ispan(0,nyear,1)
lineY = coef

vecX1 = get_an(expDir1,"bcu_an")
vecY1 = get_an(expDir1,"bcv_an")

vecX2 = get_an(expDir2,"bcu_an")
vecY2 = get_an(expDir2,"bcv_an")

vecX3 = get_an(expDir3,"bcu_an")
vecY3 = get_an(expDir3,"bcv_an")

vecX4 = get_an(expDir4,"bcu_an")
vecY4 = get_an(expDir4,"bcv_an")

vecX5 = get_an(expDir5,"bcu_an")
vecY5 = get_an(expDir5,"bcv_an")

vecX6 = get_an(expDir6,"bcu_an")
vecY6 = get_an(expDir6,"bcv_an")
;}}}

;---plotting parameters---------------------------------{{{1

fontSize      = 0.02
yLabelSize    = fontSize
xLabelSize    = fontSize
plotWid       = 0.4
plotHei       = 0.2
cbTitle       = "N/m~S~2"
;arrowDistance = 0.025
arrowDistance = 0.03
unitVec       = 0.015
;unitVecLen    = 0.045
unitVecLen    = 0.03

wks = gsn_open_wks ("eps", img)

;---resources attributes setting------------------------{{{1
;---common resource-------------------------------------{{{2
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
res@gsnStringFontHeightF = fontSize
res@gsnCenterStringOrthogonalPosF = 0.03

;res@tmXTOn = False
;res@tmYROn = False
res@tmYLMinorOn = False
res@tmYRMinorOn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmYRLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize

;---resource for vector plots---------------------------{{{2
resVec = res

;resVec@vcLevelSelectionMode = "ManualLevels"
;resVec@vcMonoLineArrowColor  = False                ; vec's colored by their mag_p_n

resVec@vcRefMagnitudeF          = unitVec
resVec@vcRefLengthF             = unitVecLen
resVec@vcMinDistanceF           = arrowDistance
resVec@vcLineArrowHeadMaxSizeF = 0.015
resVec@vcLineArrowHeadMinSizeF = 0.005  
resVec@vcLineArrowThicknessF   = 1.0               ; change vector thickness

;resVec@vcGlyphStyle          = "CurlyVector"        ; turn on curly vectors
;resVec@vcLineArrowColor        = "black"           ; change vector color
resVec@vcVectorDrawOrder       = "PostDraw"        ; draw vectors last

;resVec@vcRefAnnoOn = False
resVec@vcRefAnnoString1 = resVec@vcRefMagnitudeF
resVec@vcRefAnnoString2 = "N/m~S~2"
resVec@vcRefAnnoString2On = True
resVec@vcRefAnnoOrthogonalPosF   = -1.           ; move ref vector
resVec@vcRefAnnoParallelPosF   = 0.84            ; move ref vector
;resVec@vcRefAnnoArrowLineColor   = "black"         ; change ref vector color
;resVec@vcRefAnnoArrowUseVecColor = False           ; don't use vec color for ref
resVec@vcRefAnnoOn = True
resVec@vcRefAnnoJust = "BottomLeft"
resVec@vcRefAnnoFontHeightF = fontSize*1.2

resVec@mpShapeMode = "FreeAspect"
resVec@mpMinLatF = -45
resVec@mpMaxLatF = 65
resVec@mpMinLonF = 90
resVec@mpMaxLonF = 290
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

resVec@tmXBLabelStride = 2

;---resource for lines----------------------------------{{{2
resLine = res
resLine@vpWidthF = plotWid*2.21

resLine@tiXAxisString = "model year"
;resLine@tiYAxisString = "B(t)"

resLine@gsnYRefLine = 0.

;resLine@xyLineColor = "red"
resLine@xyLineThicknessF = 2

resLine@tmXMajorGrid = True
resLine@tmXMajorGridLineDashPattern = 2
resLine@tmXMajorGridThicknessF = 0.5

;---draw plots calling gsn functions--------------------{{{1
plot = new(10, graphic)

res1 = resVec
res1@tmXBLabelsOn = False
plot(0) = gsn_csm_vector_map(wks, vecX1, vecY1, res1)

res2 = resVec
res2@tmYLLabelsOn = False
res2@tmXBLabelsOn = False
plot(1) = gsn_csm_vector_map(wks, vecX2, vecY2, res2)

res3 = resVec
res3@tmXBLabelsOn = False
plot(2) = gsn_csm_vector_map(wks, vecX3, vecY3, res3)

res4 = resVec
res4@tmXBLabelsOn = False
res4@tmYLLabelsOn = False
plot(3) = gsn_csm_vector_map(wks, vecX4, vecY4, res4)

res5 = resVec
;res5@tiXAxisString = ""
;res5@tiXAxisOffsetYF = -0.1
plot(4) = gsn_csm_vector_map(wks, vecX5, vecY5, res5)

res6 = resVec
res6@tmYLLabelsOn = False

plot(5) = gsn_csm_vector_map(wks, vecX6, vecY6, res6)

plot(6) = gsn_csm_xy(wks, lineX, lineY, resLine)

;---put plots in a panel--------------------------------{{{1
resP = True
resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 15
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStrings = \
(/"(a) "+expNamePA, "(b) "+expNamePB,\
  "(c) "+expNamePC, "(d) "+expNamePD,\
  "(e) "+expNamePE, "(f) "+expNamePF,""/)
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.7
resP@gsnPanelFigureStringsPerimOn = False
resP@gsnPanelFigureStringsBackgroundFillColor = "transparent"
resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.7
resP@amParallelPosF = -0.5
;   resP@txString = "Sea surface salinity"
gsn_panel(wks, plot, (/2,2,2,2,2/), resP)

resText = True
resText@txFontHeightF = resP@gsnPanelFigureStringsFontHeightF
gsn_text_ndc(wks, "(g) B(t)", 0.26, 0.35, resText)

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
;-------------------------------------------------------{{{1
; vim:fdm=marker:fdl=0:
; vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
