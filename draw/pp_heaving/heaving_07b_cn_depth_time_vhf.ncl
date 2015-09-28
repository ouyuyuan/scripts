
; Description: vertical heat flux evolves with time
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-11 19:31:11 BJT
; Last Change: 2015-05-08 15:57:12 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir    = getenv("NCL_ARG_1")
img       = getenv("NCL_ARG_2")
datDirRef = "/home/ou/archive/data/pcom/exp_spinup/post/"
nc      = "calc_001e_cn_depth_time_ohc.nc"

; figure control
fontSize      = 0.018
plotWid       = 0.4
plotHei       = 0.2
cbTitle    = "10~S~13~N~W"
gloMinMaxInc   = (/-14.0, 14., 1./)
AtlMinMaxInc   = (/-8.0, 8.0, 1/)
yTitle        = "latitude"
xTitle        = "model year"

autoTicks = False
;autoTicks = True

;cmap = "ncl_default"
;cmap = "BlGrYeOrReVi200"
;  cmap = "testcmap"
cmap = "NCV_blu_red"
wks = gsn_open_wks("eps", img)
gsn_define_colormap(wks,cmap)

; get data
;{{{
function get_diff(varname)
local cn1, cn2
begin
  f = addfile(datDir + nc, "r")
  cn1 = f->$varname$
  delete(f)

  f = addfile(datDirRef + nc, "r")
  cn2 = f->$varname$
  delete(f)

  cn1 = cn1 - cn2 
  cn1&time = cn1&time - 600
  cn1 = cn1*1e-13

  return cn1(z|:,time|:)
end 

cn1 = get_diff("vhfGlo")
cn2 = get_diff("vhfPac")
cn3 = get_diff("vhfInd")
cn4 = get_diff("vhfAtl")

;}}}

; resources
;{{{
res = True

res@vpHeightF = plotHei
res@vpWidthF  = plotWid
;res@vpXF = 0.2
;  res@vpYF = 0.9

res@tiXAxisString      = xTitle
res@tiYAxisString      = yTitle
;res@tiXAxisOffsetYF    = -0.05
;res@tiYAxisOffsetXF    = -0.05
res@tiXAxisFontHeightF = fontSize*0.8
res@tiYAxisFontHeightF = fontSize*0.8

res@gsnDraw = False
res@gsnFrame = False
res@gsnStringFontHeightF = fontSize
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
res@gsnCenterStringOrthogonalPosF = 0.09
;if (cmap.eq."BlGrYeOrReVi200") then
;  res@gsnSpreadColorStart  = 35                 ; start at color 17
  ;   res@gsnSpreadColorEnd    = 240                ; end at color 200
;  res@gsnSpreadColorEnd    = 180                ; end at color 200
;end if
;res@gsnYAxisIrregular2Log = True
res@gsnYAxisIrregular2Linear = True
if (cmap.eq."ncl_default") then
  res@gsnSpreadColorStart  = 27                 ; start at color 17
  res@gsnSpreadColorEnd    = 230                ; end at color 200
end if

res@cnFillOn             = True               ; turn on color for contours
res@cnLinesOn            = False              ; turn off contour lines
res@cnLineThicknessF     = 0.1
res@cnLineLabelsOn       = False              ; turn off contour line labels
res@cnInfoLabelOn        = False      ; turns off contour info label
;res@cnMissingValFillColor = "gray60"
if .not.autoTicks
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       = gloMinMaxInc(0)
  res@cnMaxLevelValF       = gloMinMaxInc(1)
  res@cnLevelSpacingF      = gloMinMaxInc(2)
end if

res@lbPerimOn      = False             ; no box around it
;res@lbLabelBarOn      = False
res@lbOrientation      = "vertical"
res@lbTitleOffsetF     = 0.03
res@lbTitleFontHeightF = fontSize*0.7
res@lbBoxLinesOn       = False
res@lbLabelFontHeightF = fontSize*0.7
res@lbLabelStride      = 4
;res@lbTitlePosition   = "Right"
res@lbTitleString      = cbTitle

;res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
res@pmLabelBarWidthF = 0.06
res@pmLabelBarHeightF = plotHei*1.1
res@pmLabelBarOrthogonalPosF = 0.02
res@pmLabelBarParallelPosF = 0.55

res@tmLabelAutoStride    = True
res@tmYROn               = False
res@tmXTOn               = False
res@tmYLMinorOn          = False
res@tmXBMinorOn          = False
res@tmYLLabelFontHeightF = fontSize*0.8
res@tmXBLabelFontHeightF = fontSize*0.8

res@trYReverse               = True   ; reverses y-axis
;res@trYMaxF = 1000
;}}}

plot = new(6, graphic)

res1 = res
res1@tiXAxisString      = ""
;res1@lbLabelBarOn      = False
plot(0) = gsn_csm_contour(wks, cn1, res1)

res2 = res
res2@tiXAxisString      = ""
res2@tiYAxisString      = ""
plot(1) = gsn_csm_contour(wks, cn2, res2)

res3 = res
;res3@lbLabelBarOn      = False
res3@lbLabelStride      = 5
if .not.autoTicks
  res3@cnLevelSelectionMode = "ManualLevels"
  res3@cnMinLevelValF       = AtlMinMaxInc(0)
  res3@cnMaxLevelValF       = AtlMinMaxInc(1)
  res3@cnLevelSpacingF      = AtlMinMaxInc(2)
end if
plot(3) = gsn_csm_contour(wks, cn3, res3)

res4 = res3
res4@tiYAxisString      = ""
plot(4) = gsn_csm_contour(wks, cn4, res4)

resP = True
;{{{
resP@gsnFrame = False
;resP@gsnPanelLabelBar = True
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 5
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStrings = (/"(a) Global Ocean","(b) Pacific","",\
   "(c) Indian Ocean","(d) Atlantic",""/)
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.6
resP@gsnPanelFigureStringsPerimOn = False

;resP@amJust = "Top"
resP@amOrthogonalPosF = -0.5
resP@amParallelPosF = 0.15

resP@lbPerimOn      = False             ; no box around it
resP@lbOrientation      = "vertical"
resP@lbBoxLinesOn       = False
resP@lbLabelFontHeightF = fontSize*0.6
;resP@lbLabelStride      = 2
;resP@lbTitlePosition   = "Right"
resP@lbTitleString      = cbTitle
resP@lbTitleOffsetF     = -0.03
resP@lbTitleFontHeightF = fontSize*0.7

resP@pmLabelBarWidthF = 0.06
resP@pmLabelBarHeightF = 0.5
resP@pmLabelBarOrthogonalPosF = 0.02
resP@pmLabelBarParallelPosF = 0.05

;}}}

gsn_panel(wks, plot, (/3,3/), resP)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
