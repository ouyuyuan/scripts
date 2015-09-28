
; Description: Wind stress forcing, control run
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-11 19:31:11 BJT
; Last Change: 2015-07-16 10:12:17 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;img, dirs, and data files------------------------------{{{1
datDir = "/home/ou/archive/data/pcom/exp77_heaving_b_40S-80S/post/"
nc  = "calc_006c_bsf.nc"
img = getenv("NCL_ARG_2")

;get plotting data--------------------------------------{{{1

f = addfile(datDir + nc, "r")
bsf = f->bsf
delete(f)
bsf&time = bsf&time - 600

cn1 = dim_avg_n_Wrap(bsf, 0)
cn2 = dim_avg_n_Wrap(bsf({21:100},:,:), 0)
cn2 = cn2 - cn1

;plotting parameters------------------------------------{{{1
fontSize      = 0.018
plotWid       = 0.4
plotHei       = 0.2
cnMinMaxInc = (/-60,160,20/)
cnMinMaxIncDiff = (/-10,10,2/)

autoTicks = False
;autoTicks = True

;cmap = "ncl_default"
;cmap = "BlGrYeOrReVi200"
;  cmap = "testcmap"
  cmap = "NCV_blu_red"
wks = gsn_open_wks("eps", img)
;gsn_define_colormap(wks,cmap)

;resources attributes setting---------------------------{{{1
res = True

res@vpHeightF = plotHei
res@vpWidthF  = plotWid

res@tiXAxisOffsetYF    = -0.05
res@tiYAxisOffsetXF    = -0.05
res@tiXAxisFontHeightF = fontSize*0.8
res@tiYAxisFontHeightF = fontSize*0.8

res@gsnDraw = False
res@gsnFrame = False

res@gsnStringFontHeightF = fontSize*0.8
res@gsnCenterString = ""
res@gsnCenterStringOrthogonalPosF = 0.05

res@gsnLeftString = ""
res@gsnLeftStringOrthogonalPosF = -1.15
res@gsnLeftStringParallelPosF = 0.02

res@gsnRightString = ""
;res@gsnRightStringOrthogonalPosF = -0.14
res@gsnRightStringParallelPosF = 1.13

res@gsnContourZeroLineThicknessF= 2
res@gsnContourNegLineDashPattern= 2

res@cnFillOn             = True
;res@cnLinesOn            = False
res@cnLineThicknessF     = 0.1
res@cnLineLabelsOn       = False
res@cnInfoLabelOn        = False
;res@cnMissingValFillColor = "gray60"
if (.not.autoTicks) then
  res@cnLevelSelectionMode = "ManualLevels"
end if

res@lbPerimOn      = False
;res@lbLabelBarOn      = False
res@lbOrientation      = "vertical"
;res@lbBoxLinesOn       = False
res@lbLabelFontHeightF = fontSize*0.6
;res@lbLabelStride      = 2

res@pmLabelBarDisplayMode    = "Always"
res@pmLabelBarWidthF = 0.05
;res@pmLabelBarHeightF = plotHei*1.1
;res@pmLabelBarOrthogonalPosF = 0.02
;res@pmLabelBarParallelPosF = 0.55

res@mpShapeMode = "FreeAspect"
res@mpOutlineOn = True
res@mpLandFillColor          = "gray"
;resmpMinLonF = 0
;res@mpMaxLonF = 360
res@mpMinLatF = -80
res@mpMaxLatF = 80
;res@mpCenterLonF = 200

res@tmLabelAutoStride    = True
res@tmYLMinorOn          = False
res@tmXBMinorOn          = False
res@tmYLLabelFontHeightF = fontSize*0.8
res@tmXBLabelFontHeightF = fontSize*0.8

;draw plots calling gsn functions-----------------------{{{1
plot = new(2, graphic)

res1 = res
res1@cnFillPalette      = "testcmap"
res1@gsnCenterString = "(a) 1-240"
res1@gsnRightString = cn1@units
if (.not.autoTicks) then
  res1@cnMinLevelValF   = cnMinMaxInc(0)
  res1@cnMaxLevelValF   = cnMinMaxInc(1)
  res1@cnLevelSpacingF  = cnMinMaxInc(2)
end if
plot(0) = gsn_csm_contour_map(wks, cn1, res1)

res2 = res
res2@cnFillPalette      = "ncv_blu_red"
res2@pmLabelBarOrthogonalPosF = 0.015
res2@lbLabelStride      = 1
if (.not.autoTicks) then
  res2@cnMinLevelValF   = cnMinMaxIncDiff(0)
  res2@cnMaxLevelValF   = cnMinMaxIncDiff(1)
  res2@cnLevelSpacingF  = cnMinMaxIncDiff(2)
end if
res2@gsnCenterString = "(b) (21-100) - (1-240)"
res2@gsnRightString = cn2@units
plot(1) = gsn_csm_contour_map(wks, cn2, res2)

;put plots in a panel-----------------------------------{{{1
resP = True
resP@gsnFrame = False
;resP@gsnPanelLabelBar = True
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 10
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.7
resP@gsnPanelFigureStringsPerimOn = False
;resP@gsnMaximize = True

;resP@amJust = "Top"
resP@amOrthogonalPosF = -0.5
resP@amParallelPosF = 0.15

gsn_panel(wks, plot, (/1,1/), resP)

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
