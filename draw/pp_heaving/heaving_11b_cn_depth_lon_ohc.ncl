
; Description: OHC per vertical meter evolves with longitude
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-11 19:31:11 BJT
; Last Change: 2015-07-21 10:48:04 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;img, dirs, and data files------------------------------{{{1
datDir    = "/home/ou/archive/data/pcom/"
img       = getenv("NCL_ARG_2")

refDir    = "exp_spinup/post/"

expDirP   = "exp71_heaving_b_Pac_20S-20N/post/"
expDirA   = "exp78_heaving_b_Atl_20S-20N/post/"

nc = "calc_006f_ohc_depth_lon.nc"

;get plotting data--------------------------------------{{{1
function get_anom(expDir, varName, yb, ye) ;{{{2
local cn, cn3d
begin

  f = addfile(datDir + expDir + nc, "r")
  cn3d = f->$varName$({601:720},:,:)
  delete(f)
  cn3d = dim_rmvmean_n_Wrap(cn3d, 0)
  cn3d&time = cn3d&time - 600

  cn = cn3d(0,:,:)
  cn = dim_avg_n_Wrap(cn3d({yb:ye},:,:), 0)
  cn = cn*1e-17
  cn@units = "10~S~17~N~J"

  return cn
end 

function get_anom_correction(expDir, varName, yb, ye) ;{{{2
local cnR, cn
begin
  cn = get_anom(expDir, varName, yb, ye)
  cnR = get_anom(refDir, varName, yb, ye)
  cn = cn - cnR
  return cn
end 

 ;{{{2
yb = 81
ye = 100
cnP = get_anom_correction(expDirP, "ohcPac", yb, ye)
cnA = get_anom_correction(expDirA, "ohcAtl", yb, ye)
cnA = lonFlip(cnA)

;plotting parameters------------------------------------{{{1
fontSize      = 0.018
plotWid       = 0.4
plotHei       = 0.2
cnMinMaxInc   = (/-12.0, 12.0, 1.0/)
yTitle        = "depth (m)"
xTitle        = "longitude"

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

res@gsnStringFontHeightF = fontSize*0.9
res@gsnCenterString = ""
res@gsnCenterStringOrthogonalPosF = 0.05

res@gsnLeftString = ""

res@gsnRightStringFontHeightF = fontSize*0.8
res@gsnRightString = ""
res@gsnRightString = cnP@units
res@gsnRightStringOrthogonalPosF = 0.05
res@gsnRightStringParallelPosF = 1.2

;res@gsnYAxisIrregular2Log = True
res@gsnYAxisIrregular2Linear = True
if (cmap.eq."ncl_default") then
  res@gsnSpreadColorStart  = 27
  res@gsnSpreadColorEnd    = 230
end if

res@cnFillOn             = True
res@cnLinesOn            = False
res@cnLineThicknessF     = 0.1
res@cnLineLabelsOn       = False
res@cnInfoLabelOn        = False
;res@cnMissingValFillColor = "gray60"
if .not.autoTicks
  res@lbLabelStride  = 4.0/cnMinMaxInc(2)
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       = cnMinMaxInc(0)
  res@cnMaxLevelValF       = cnMinMaxInc(1)
  res@cnLevelSpacingF      = cnMinMaxInc(2)
end if

res@lbPerimOn      = False             ; no box around it
;res@lbLabelStride      = 5
;res@lbLabelBarOn      = False
res@lbOrientation      = "vertical"
res@lbTitleOffsetF     = 0.03
res@lbTitleFontHeightF = fontSize*0.7
res@lbBoxLinesOn       = False
res@lbLabelFontHeightF = fontSize*0.7
;res@lbTitlePosition   = "Right"

;res@pmLabelBarDisplayMode    = "Always"
res@pmLabelBarWidthF = 0.06
;res@pmLabelBarHeightF = plotHei*1.1
res@pmLabelBarOrthogonalPosF = 0.02
;res@pmLabelBarParallelPosF = 0.55

res@tmLabelAutoStride    = True
;res@tmYROn               = False
;res@tmXTOn               = False
;res@tmYLMinorOn          = False
;res@tmXBMinorOn          = False
res@tmYLLabelFontHeightF = fontSize*0.8
res@tmXBLabelFontHeightF = fontSize*0.8
;res@tmXBMode = "Manual"
;res@tmXBTickSpacingF = 30

res@trYReverse               = True   ; reverses y-axis
res@trYMaxF = 1500

;draw plots calling gsn functions-----------------------{{{1
plot = new(2, graphic)

lon1 = 110.5
lon2 = 290.5

res1 = res
res1@gsnCenterString = "(a) EXP_PACa"
plot(0) = gsn_csm_contour(wks, cnP(:,{lon1:lon2}), res1)
;plot(0) = gsn_csm_contour(wks, cnP, res1)

lon1 = -70.5
lon2 = 20.5
res2 = res
res2@vpWidthF  = plotWid*0.5
res2@gsnCenterString = "(b) EXP_ATLa"
res2@gsnRightStringParallelPosF = 1.4
res2@tiYAxisString      = ""
res2@pmLabelBarOrthogonalPosF = 0.04
plot(1) = gsn_csm_contour(wks, cnA(:,{lon1:lon2}), res2)
;plot(1) = gsn_csm_contour(wks, cnA, res2)

;put plots in a panel-----------------------------------{{{1
resP = True
resP@gsnFrame = False
;resP@gsnPanelLabelBar = True
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 2
resP@gsnPanelRowSpec = True
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
resP@lbTitleOffsetF     = -0.03
resP@lbTitleFontHeightF = fontSize*0.7

resP@pmLabelBarWidthF = 0.06
resP@pmLabelBarHeightF = 0.5
resP@pmLabelBarOrthogonalPosF = 0.02
resP@pmLabelBarParallelPosF = 0.05

gsn_panel(wks, plot, (/3/), resP)

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
;-------------------------------------------------------{{{1
; vim:fdm=marker:fdl=0:
; vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
