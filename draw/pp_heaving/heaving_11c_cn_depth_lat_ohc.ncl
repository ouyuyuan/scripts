
; Description: OHC per vertical meter evolves with longitude
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-11 19:31:11 BJT
; Last Change: 2015-07-21 15:58:57 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;img, dirs, and data files------------------------------{{{1
datDir    = "/home/ou/archive/data/pcom/"
img       = getenv("NCL_ARG_2")

refDir    = "exp_spinup/post/"

expDirP1   = "exp71_heaving_b_Pac_20S-20N/post/"
expDirP2   = "exp72_heaving_b_Pac_0N-40N/post/"
expDirP3   = "exp75_heaving_b_Pac_0S-40S/post/"

expDirA1   = "exp78_heaving_b_Atl_20S-20N/post/"
expDirA2   = "exp79_heaving_b_Atl_0N-40N/post/"
expDirA3   = "exp89_heaving_b_Atl_0S-40S/post/"

nc = "calc_006g_ohc_depth_lat.nc"

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
  cn = cn*1e-18
  cn@units = "10~S~18~N~J"

  return cn(:,{-60.5:60.5})
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
cnP1 = get_anom_correction(expDirP1, "ohcPac", yb, ye)
cnP2 = get_anom_correction(expDirP2, "ohcPac", yb, ye)
cnP3 = get_anom_correction(expDirP3, "ohcPac", yb, ye)

cnA1 = get_anom_correction(expDirA1, "ohcAtl", yb, ye)
cnA2 = get_anom_correction(expDirA2, "ohcAtl", yb, ye)
cnA3 = get_anom_correction(expDirA3, "ohcAtl", yb, ye)

;plotting parameters------------------------------------{{{1
fontSize      = 0.018
plotWid       = 0.3
plotHei       = 0.3
cnMinMaxIncP1   = (/-6.0, 6.0, 0.5/)
cnMinMaxIncA1   = (/-2.0, 2.0, 0.1/)
cnMinMaxIncP   = (/-3.0, 3.0, 0.1/)
cnMinMaxIncA   = (/-1.0, 1.0, 0.05/)
yTitle        = "Depth (m)"
xTitle        = "Latitude"

autoTicks = False
;autoTicks = True

;cmap = "ncl_default"
;cmap = "BlGrYeOrReVi200"
;  cmap = "testcmap"
cmap = "NCV_blu_red"
wks = gsn_open_wks("eps", img)
gsn_define_colormap(wks,cmap)

;resources attributes setting---------------------------{{{1
res = True ;{{{2

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

res@gsnRightString = cnP1@units
res@gsnStringFontHeightF = fontSize*0.9
res@gsnRightStringFontHeightF = fontSize*0.8
res@gsnRightStringOrthogonalPosF = 0.05
res@gsnRightStringParallelPosF = 1.2

res@gsnLeftString = ""

res@gsnCenterString = ""
res@gsnCenterStringOrthogonalPosF = 0.05

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
  res@cnLevelSelectionMode = "ManualLevels"
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
;res@pmLabelBarOrthogonalPosF = 0.02
;res@pmLabelBarParallelPosF = 0.55

res@tmLabelAutoStride    = True
;res@tmYROn               = False
;res@tmXTOn               = False
;res@tmYLMinorOn          = False
;res@tmXBMinorOn          = False
res@tmYLLabelFontHeightF = fontSize*0.8
res@tmXBLabelFontHeightF = fontSize*0.8

res@trYReverse               = True   ; reverses y-axis
res@trYMaxF = 1500

resPac = res ;{{{2
if .not.autoTicks
  resPac@lbLabelStride  = 1.0/cnMinMaxIncP(2)
  resPac@cnMinLevelValF       = cnMinMaxIncP(0)
  resPac@cnMaxLevelValF       = cnMinMaxIncP(1)
  resPac@cnLevelSpacingF      = cnMinMaxIncP(2)
end if

resAtl = res ;{{{2
if .not.autoTicks
  resAtl@lbLabelStride  = 0.5/cnMinMaxIncA(2)
  resAtl@cnMinLevelValF       = cnMinMaxIncA(0)
  resAtl@cnMaxLevelValF       = cnMinMaxIncA(1)
  resAtl@cnLevelSpacingF      = cnMinMaxIncA(2)
end if

;draw plots calling gsn functions-----------------------{{{1
plot = new(6, graphic)

res1 = resPac
res1@gsnCenterString = "(a) EXP_PACa"
res1@tiXAxisString      = ""
;res1@lbLabelStride      = 2
if .not.autoTicks
  res1@lbLabelStride  = 2.0/cnMinMaxIncP1(2)
  res1@cnMinLevelValF       = cnMinMaxIncP1(0)
  res1@cnMaxLevelValF       = cnMinMaxIncP1(1)
  res1@cnLevelSpacingF      = cnMinMaxIncP1(2)
end if
plot(0) = gsn_csm_contour(wks, cnP1, res1)

res2 = resPac
res2@gsnCenterString = "(b) EXP_PACb"
res2@tiYAxisString      = ""
res2@tiXAxisString      = ""
plot(1) = gsn_csm_contour(wks, cnP2, res2)

res3 = resPac
res3@gsnCenterString = "(c) EXP_PACc"
res3@tiYAxisString      = ""
res3@tiXAxisString      = ""
plot(2) = gsn_csm_contour(wks, cnP3, res3)

res4 = resAtl
res4@gsnCenterString = "(d) EXP_ATLa"
if .not.autoTicks
  res4@lbLabelStride  = 0.5/cnMinMaxIncA1(2)
  res4@cnMinLevelValF       = cnMinMaxIncA1(0)
  res4@cnMaxLevelValF       = cnMinMaxIncA1(1)
  res4@cnLevelSpacingF      = cnMinMaxIncA1(2)
end if
plot(3) = gsn_csm_contour(wks, cnA1, res4)

res5 = resAtl
res5@gsnCenterString = "(e) EXP_ATLb"
res5@tiYAxisString      = ""
plot(4) = gsn_csm_contour(wks, cnA2, res5)

res6 = resAtl
res6@gsnCenterString = "(f) EXP_ATLc"
res6@tiYAxisString      = ""
plot(5) = gsn_csm_contour(wks, cnA3, res6)

;put plots in a panel-----------------------------------{{{1
resP = True
resP@gsnFrame = False
;resP@gsnPanelLabelBar = True
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 5
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

gsn_panel(wks, plot, (/3,3/), resP)

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
;-------------------------------------------------------{{{1
; vim:fdm=marker:fdl=0:
; vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
