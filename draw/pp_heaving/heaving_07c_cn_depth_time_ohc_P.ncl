
; Description: OHC per vertical meter evolves with time, exp-P
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-11 19:31:11 BJT
; Last Change: 2015-06-29 09:45:44 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;img, dirs, and data files------------------------------{{{1
load "$HOME/archive/scripts/draw/pp_heaving/exp_P_head.ncl"
nc = "post/calc_001e_cn_depth_time_ohc.nc"

;get plotting data--------------------------------------{{{1
function get_anom(expDir)
local cn, cnR
begin
  f = addfile(datDir + expDir + nc, "r")
  cn = f->ohcPac
  delete(f)

  f = addfile(datDir + expDirRef + nc, "r")
  cnR = f->ohcPac
  delete(f)

  cn = cn - cnR
  cn = dim_rmvmean_n_Wrap(cn, 0)
  cn&time = cn&time - 600
  cn = cn*1e-19

  return cn(z|:,time|:)
end 

cn1 = get_anom(expDir1)
cn2 = get_anom(expDir2)
cn3 = get_anom(expDir3)
cn4 = get_anom(expDir4)
cn5 = get_anom(expDir5)
cn6 = get_anom(expDir6)

;plotting parameters------------------------------------{{{1
fontSize      = 0.018
plotWid       = 0.4
plotHei       = 0.2
cbTitle    = "10~S~19~N~J/m"
cnMinMaxInc1   = (/-12.0, 12.0, 0.5/)
cnMinMaxInc2   = (/-2.0, 2.0, 0.1/)
cnMinMaxInc5   = (/-6.0, 6.0, 0.1/)
yTitle        = "depth (m)"
xTitle        = "model year"

autoTicks = False
;autoTicks = True

;cmap = "ncl_default"
;cmap = "BlGrYeOrReVi200"
;  cmap = "testcmap"
cmap = "NCV_blu_red"
wks = gsn_open_wks("eps", img)
gsn_define_colormap(wks,cmap)

;resources attributes setting---------------------------{{{1
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
res@gsnYAxisIrregular2Log = True
;res@gsnYAxisIrregular2Linear = True
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
  res@cnMinLevelValF       = cnMinMaxInc5(0)
  res@cnMaxLevelValF       = cnMinMaxInc5(1)
  res@cnLevelSpacingF      = cnMinMaxInc5(2)
end if

res@lbPerimOn      = False             ; no box around it
;res@lbLabelBarOn      = False
res@lbOrientation      = "vertical"
res@lbTitleOffsetF     = 0.03
res@lbTitleFontHeightF = fontSize*0.7
res@lbBoxLinesOn       = False
res@lbLabelFontHeightF = fontSize*0.7
res@lbLabelStride      = 5
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

;draw plots calling gsn functions-----------------------{{{1
plot = new(6, graphic)

res1 = res
res1@tiXAxisString      = ""
;res1@lbLabelBarOn      = False
res1@lbLabelStride      = 2
if .not.autoTicks
  res1@cnMinLevelValF       = cnMinMaxInc1(0)
  res1@cnMaxLevelValF       = cnMinMaxInc1(1)
  res1@cnLevelSpacingF      = cnMinMaxInc1(2)
end if
plot(0) = gsn_csm_contour(wks, cn1, res1)

res2 = res
res2@tiXAxisString      = ""
res2@tiYAxisString      = ""
if .not.autoTicks
  res2@cnMinLevelValF       = cnMinMaxInc2(0)
  res2@cnMaxLevelValF       = cnMinMaxInc2(1)
  res2@cnLevelSpacingF      = cnMinMaxInc2(2)
end if
plot(1) = gsn_csm_contour(wks, cn2, res2)

res3 = res
res3@lbLabelBarOn      = False
res3@lbLabelStride      = 5
res3@tiXAxisString      = ""
plot(2) = gsn_csm_contour(wks, cn3, res3)

res4 = res
res4@lbLabelBarOn      = False
res4@tiXAxisString      = ""
res4@tiYAxisString      = ""
plot(3) = gsn_csm_contour(wks, cn4, res4)

res5 = res
res5@lbLabelBarOn      = False
res5@lbLabelStride      = 10
if .not.autoTicks
  res5@cnMinLevelValF       = cnMinMaxInc5(0)
  res5@cnMaxLevelValF       = cnMinMaxInc5(1)
  res5@cnLevelSpacingF      = cnMinMaxInc5(2)
end if
plot(4) = gsn_csm_contour(wks, cn5, res5)

res6 = res
res6@tiYAxisString      = ""
;res6@lbLabelBarOn = False
res6@lbTitleOffsetF = -0.03
res6@pmLabelBarHeightF = plotHei*2.2
;res6@pmLabelBarOrthogonalPosF = 0.2
res6@pmLabelBarParallelPosF = 1.3
plot(5) = gsn_csm_contour(wks, cn6, res6)

;put plots in a panel-----------------------------------{{{1
resP = True
resP@gsnFrame = False
;resP@gsnPanelLabelBar = True
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 2
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStrings = \
(/"(a) "+expNamePA, "(b) "+expNamePB,\
  "(c) "+expNamePC, "(d) "+expNamePD,\
  "(e) "+expNamePE, "(f) "+expNamePF/)
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.7
resP@gsnPanelFigureStringsPerimOn = False

resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.68
resP@amParallelPosF = -0.5

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

gsn_panel(wks, plot, (/2,2,2/), resP)

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
;-------------------------------------------------------{{{1
; vim:fdm=marker:fdl=0:
; vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
