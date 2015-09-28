
; Description: volume anomaly evolves with time
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-11 19:31:11 BJT
; Last Change: 2015-05-27 17:15:55 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;---img, dirs, and data files---------------------------{{{1
load "$HOME/archive/scripts/draw/pp_heaving/exp_P_head.ncl"
nc = "post/calc_17_cn_lat_time_dv.nc"

;---get plotting data-----------------------------------{{{1
function get_an(expname)
local cn, cnR
begin
  f = addfile(datDir + expDirRef + nc, "r")
  cnR = f->dvolPac(:,{-45:65})
  delete(f)

  f = addfile(datDir + expname + nc, "r")
  cn = f->dvolPac(:,{-45:65})
  delete(f)

  cn = cn - cnR
  cn = dim_rmvmean_n_Wrap(cn, 0)
; it seems that detrend introduce artificial oscillations
;  cn = dtrend_n(cn, False, 0) 
  cn = cn*1e-10
  cn&time = cn&time - 600
  return cn(lat|:,time|:)
end 

cn1 = get_an(expDir1)
cn2 = get_an(expDir2)
cn3 = get_an(expDir3)
cn4 = get_an(expDir4)
cn5 = get_an(expDir5)
cn6 = get_an(expDir6)

;---plotting parameters---------------------------------{{{1
fontSize      = 0.02
plotWid       = 0.4
plotHei       = 0.2
cbTitle    = "10~S~10~N~m~S~3~N~/1~S~o"
cnMinMaxInc   = (/-8.0, 8.0, 0.2/)
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

;---resources attributes setting------------------------{{{1
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
  res@cnMinLevelValF       = cnMinMaxInc(0)
  res@cnMaxLevelValF       = cnMinMaxInc(1)
  res@cnLevelSpacingF      = cnMinMaxInc(2)
end if

res@lbPerimOn      = False             ; no box around it
res@lbLabelBarOn      = False
res@lbOrientation      = "vertical"
res@lbTitleOffsetF     = 0.03
res@lbTitleFontHeightF = fontSize*0.8
res@lbBoxLinesOn       = False
res@lbLabelFontHeightF = fontSize*0.8
;res@lbLabelStride      = 2
;res@lbTitlePosition   = "Right"
res@lbTitleString      = cbTitle

;res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
res@pmLabelBarWidthF = 0.05
res@pmLabelBarHeightF = 0.9
res@pmLabelBarOrthogonalPosF = 0.02
res@pmLabelBarParallelPosF = 0.55

res@tmLabelAutoStride    = True
res@tmYROn               = False
res@tmXTOn               = False
res@tmYLMinorOn          = False
res@tmXBMinorOn          = False
res@tmYLLabelFontHeightF = fontSize*0.8
res@tmXBLabelFontHeightF = fontSize*0.8

;---draw plots calling gsn functions--------------------{{{1
plot = new(6, graphic)

res1 = res
res1@tiXAxisString      = ""
plot(0) = gsn_csm_contour(wks, cn1, res1)

res2 = res
res2@tiXAxisString      = ""
res2@tiYAxisString      = ""
plot(1) = gsn_csm_contour(wks, cn2, res2)

res3 = res
res3@tiXAxisString      = ""
plot(2) = gsn_csm_contour(wks, cn3, res3)

res4 = res
res4@tiXAxisString      = ""
res4@tiYAxisString      = ""
plot(3) = gsn_csm_contour(wks, cn4, res4)

res5 = res
plot(4) = gsn_csm_contour(wks, cn5, res5)

res6 = res
res6@tiYAxisString      = ""
plot(5) = gsn_csm_contour(wks, cn6, res6)

;---put plots in a panel--------------------------------{{{1
resP = True
resP@gsnFrame = False
resP@gsnPanelLabelBar = True
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 10
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStrings = \
(/"(a) "+expNamePA, "(b) "+expNamePB,\
  "(c) "+expNamePC, "(d) "+expNamePD,\
  "(e) "+expNamePE, "(f) "+expNamePF/)
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.7
resP@gsnPanelFigureStringsPerimOn = False

resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.7
resP@amParallelPosF = -0.5

resP@lbPerimOn      = False             ; no box around it
resP@lbOrientation      = "vertical"
resP@lbBoxLinesOn       = False
resP@lbLabelFontHeightF = fontSize*0.7
resP@lbLabelStride      = 5
;resP@lbTitlePosition   = "Right"
resP@lbTitleString      = cbTitle
resP@lbTitleOffsetF     = -0.03
resP@lbTitleFontHeightF = fontSize*0.7

resP@pmLabelBarWidthF = 0.05
resP@pmLabelBarHeightF = 0.8
resP@pmLabelBarOrthogonalPosF = 0.01
resP@pmLabelBarParallelPosF = 0.05

gsn_panel(wks, plot, (/2,2,2/), resP)

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
;-------------------------------------------------------{{{1
; vim:fdm=marker:fdl=0:
; vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
