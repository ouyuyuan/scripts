
; Description: OHC per vertical meter evolves with longitude
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-11 19:31:11 BJT
; Last Change: 2015-07-23 14:10:40 BJT

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

ncLat = "calc_006g_ohc_depth_lat.nc"
ncLon = "calc_006f_ohc_depth_lon.nc"

;get plotting data--------------------------------------{{{1
function get_anom(expDir, varName, nc, yb, ye) ;{{{2
local cn, cn3d, cn3dR
begin

  f = addfile(datDir + refDir + nc, "r")
  cn3dR = f->$varName$({601:720},:,:)
  delete(f)

  f = addfile(datDir + expDir + nc, "r")
  cn3d = f->$varName$({601:720},:,:)
  delete(f)
  cn3d = cn3d - cn3dR
;  cn3d = dim_rmvmean_n_Wrap(cn3d, 0)
  cn3d&time = cn3d&time - 600

  cn = cn3d(0,:,:)
  cn = dim_avg_n_Wrap(cn3d({yb:ye},:,:), 0)
  cn = cn*1e-18
  cn@units = "10~S~18~N~J"

  cn = smth9_Wrap(cn, 0.5, 0.25, True)
  return cn
;  return cn(:,{-60.5:60.5})
end 

 ;{{{2
yb = 81
ye = 100
cnLon1 = get_anom(expDirP1, "ohcPac", ncLon, yb, ye)
cnLon2 = get_anom(expDirP2, "ohcPac", ncLon, yb, ye)
cnLon3 = get_anom(expDirP3, "ohcPac", ncLon, yb, ye)

cnLat1 = get_anom(expDirP1, "ohcPac", ncLat, yb, ye)
cnLat2 = get_anom(expDirP2, "ohcPac", ncLat, yb, ye)
cnLat3 = get_anom(expDirP3, "ohcPac", ncLat, yb, ye)

;plotting parameters------------------------------------{{{1
fontSize      = 0.018
plotWid       = 0.3
plotHei       = 0.3
yTitle        = "Depth (m)"

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

res@tiYAxisString      = yTitle
;res@tiXAxisOffsetYF    = -0.05
;res@tiYAxisOffsetXF    = -0.05
res@tiXAxisFontHeightF = fontSize*0.8
res@tiYAxisFontHeightF = fontSize*0.8

res@gsnDraw = False
res@gsnFrame = False

res@gsnRightString = cnLon1@units
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
;res@lbLabelBarOn      = False
res@lbOrientation      = "vertical"
res@lbTitleOffsetF     = 0.03
res@lbTitleFontHeightF = fontSize*0.8
;res@lbBoxLinesOn       = False
res@lbLabelFontHeightF = fontSize*0.8
;res@lbTitlePosition   = "Right"

;res@pmLabelBarDisplayMode    = "Always"
res@pmLabelBarWidthF = 0.06
;res@pmLabelBarHeightF = plotHei*1.1
res@pmLabelBarOrthogonalPosF = 0.04
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

;draw plots calling gsn functions-----------------------{{{1
plot = new(6, graphic)

lon1 = 120
lon2 = 360 - 75
res1 = res
res1@gsnCenterString = "(a) EXP_EQ"
res1@tiXAxisString      = "Longitide"
if .not.autoTicks
;  res1@lbLabelStride  = 2.0/0.1
  res1@cnMinLevelValF  = -1.5
  res1@cnMaxLevelValF  = 1.5
  res1@cnLevelSpacingF = 0.3
end if
plot(0) = gsn_csm_contour(wks, cnLon1(:,{lon1:lon2}), res1)

res2 = res
res2@gsnCenterString = "(b) EXP_N"
res2@tiYAxisString      = ""
res2@tiXAxisString      = "Longitide"
if .not.autoTicks
;  res2@lbLabelStride  = 2.0/0.1
  res2@cnMinLevelValF  = -0.5
  res2@cnMaxLevelValF  = 0.5
  res2@cnLevelSpacingF = 0.1
end if
plot(1) = gsn_csm_contour(wks, cnLon2(:,{lon1:lon2}), res2)

res3 = res
res3@gsnCenterString = "(c) EXP_S"
res3@tiYAxisString      = ""
res3@tiXAxisString      = "Longitide"
if .not.autoTicks
;  res3@lbLabelStride  = 2.0/0.1
  res3@cnMinLevelValF  = -0.5
  res3@cnMaxLevelValF  = 0.5
  res3@cnLevelSpacingF = 0.1
end if
plot(2) = gsn_csm_contour(wks, cnLon3(:,{lon1:lon2}), res3)

lat1 = -60.5
lat2 = 60.5
res@pmLabelBarOrthogonalPosF = 0.01

res4 = res
res4@gsnCenterString = "(d) EXP_EQ"
res4@tiXAxisString      = "Latitude"
if .not.autoTicks
;  res4@lbLabelStride  = 2.0/0.1
  res4@cnMinLevelValF  = -8.0
  res4@cnMaxLevelValF  = 8.0
  res4@cnLevelSpacingF = 1.0
end if
plot(3) = gsn_csm_contour(wks, cnLat1(:,{lat1:lat2}), res4)

res5 = res
res5@gsnCenterString = "(e) EXP_N"
res5@tiYAxisString      = ""
res5@tiXAxisString      = "Latitude"
if .not.autoTicks
;  res5@lbLabelStride  = 2.0/0.1
  res5@cnMinLevelValF  = -2.5
  res5@cnMaxLevelValF  = 2.5
  res5@cnLevelSpacingF = 0.5
end if
plot(4) = gsn_csm_contour(wks, cnLat2(:,{lat1:lat2}), res5)

res6 = res
res6@gsnCenterString = "(f) EXP_S"
res6@tiYAxisString      = ""
res6@tiXAxisString      = "Latitude"
if .not.autoTicks
;  res6@lbLabelStride  = 2.0/0.1
  res6@cnMinLevelValF  = -2.5
  res6@cnMaxLevelValF  = 2.5
  res6@cnLevelSpacingF = 0.5
end if
plot(5) = gsn_csm_contour(wks, cnLat3(:,{lat1:lat2}), res6)

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

;resP@pmLabelBarWidthF = 0.06
;resP@pmLabelBarHeightF = 0.5
;resP@pmLabelBarOrthogonalPosF = 0.02
;resP@pmLabelBarParallelPosF = 0.05

gsn_panel(wks, plot, (/3,3/), resP)

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
;-------------------------------------------------------{{{1
; vim:fdm=marker:fdl=0:
; vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
