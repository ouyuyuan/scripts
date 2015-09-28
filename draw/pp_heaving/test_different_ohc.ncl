
; Description: SSH, volume anomaly, DTC, OHC evolves with time
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-11 19:31:11 BJT
; Last Change: 2015-06-14 09:01:37 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;---img, dirs, and data files---------------------------{{{1
refDir = "/home/ou/archive/data/pcom/exp_spinup/post/"
datDir    = getenv("NCL_ARG_1")
img       = getenv("NCL_ARG_2")

nca = "calc_006d_ohc_0-300m.nc"
ncb = "calc_006d_ohc_0-700m.nc"
ncc = "calc_006d_ohc_0-1500m.nc"
ncd = "calc_006d_ohc_300-700m.nc"
nce = "calc_006d_ohc_700-1500m.nc"

;---get plotting data-----------------------------------{{{1
; get OHC anomaly {{{2

function get_ohc(nc)
begin
f = addfile(refDir + nc, "r")
cn3d = f->ohc
delete(f)
cnR = dim_sum_n_Wrap(cn3d,2)

f = addfile(datDir + nc, "r")
cn3d = f->ohc
delete(f)
cn = dim_sum_n_Wrap(cn3d,2)

cn = cn - cnR
cn = dim_rmvmean_n_Wrap(cn, 0)
; it seems that detrend introduce artificial oscillations
;  cn = dtrend_n(cn, False, 0) 
cn&time = cn&time - 600
cn = cn*1e-21
cn@units = "10~S~21~N~J"

ohc = cn(lat|:,time|:)
delete(cn)
delete(cnR)
delete(cn3d)

return ohc
end

cna = get_ohc(nca)
cnb = get_ohc(ncb)
cnc = get_ohc(ncc)
cnd = get_ohc(ncd)
cne = get_ohc(nce)

;---plotting parameters---------------------------------{{{1
fontSize      = 0.018
plotWid       = 0.4
plotHei       = 0.2
cbTitle    = "10~S~10~N~m~S~3~N~/1~S~o"
cnMinMaxInca = (/-1.5, 1.5, 0.1/)
cnMinMaxIncb = (/-2.0, 2.0, 0.1/)
cnMinMaxIncc = (/-2.0, 2.0, 0.1/)
cnMinMaxIncd = (/-0.5, 0.5, 0.05/)
cnMinMaxInce = (/-0.2, 0.2, 0.01/)
yTitle        = "latitude"
xTitle        = "year"

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
res@gsnRightStringFontHeightF = fontSize*0.8
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
res@gsnCenterStringOrthogonalPosF = 0.05
res@gsnRightStringOrthogonalPosF = 0.05
res@gsnRightStringParallelPosF = 1.2

if (cmap.eq."ncl_default") then
  res@gsnSpreadColorStart  = 27
  res@gsnSpreadColorEnd    = 230
end if

res@cnFillOn             = True
res@cnLinesOn            = False
res@cnLineThicknessF     = 0.1
res@cnLineLabelsOn       = False 
res@cnInfoLabelOn        = False
res@cnLevelSelectionMode = "ManualLevels"

res@lbPerimOn      = False             ; no box around it
;res@lbLabelBarOn      = False
res@lbOrientation      = "vertical"
res@lbTitleOffsetF     = 0.03
res@lbTitleFontHeightF = fontSize*0.8
res@lbBoxLinesOn       = False
res@lbLabelFontHeightF = fontSize*0.8
;res@lbLabelStride      = 2
;res@lbTitlePosition   = "Right"
;res@lbTitleString      = cbTitle

;res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
res@pmLabelBarWidthF = 0.07
;res@pmLabelBarHeightF = 0.9
res@pmLabelBarOrthogonalPosF = 0.02
res@pmLabelBarParallelPosF = 0.5

res@tmLabelAutoStride    = True
res@tmYROn               = False
res@tmXTOn               = False
res@tmYLMinorOn          = False
res@tmXBMinorOn          = False
res@tmYLLabelFontHeightF = fontSize*0.8
res@tmXBLabelFontHeightF = fontSize*0.8

;---draw plots calling gsn functions--------------------{{{1
plot = new(9, graphic)

res1 = res
;res1@tiXAxisString      = ""
res1@gsnCenterString = "(d) 0-300m"
;res1@gsnRightStringParallelPosF = 1.3
res1@gsnRightString = cna@units
res1@tiYAxisString      = ""
if .not.autoTicks
;  res1@lbLabelStride  = 1.0/cnMinMaxIncOhc(2)
  res1@cnMinLevelValF       = cnMinMaxInca(0)
  res1@cnMaxLevelValF       = cnMinMaxInca(1)
  res1@cnLevelSpacingF      = cnMinMaxInca(2)
end if
plot(0) = gsn_csm_contour(wks, cna, res1)

res2 = res1
res2@gsnCenterString = "(b) 0-700m"
res2@gsnRightString = cnb@units
if .not.autoTicks
  res2@cnMinLevelValF       = cnMinMaxIncb(0)
  res2@cnMaxLevelValF       = cnMinMaxIncb(1)
  res2@cnLevelSpacingF      = cnMinMaxIncb(2)
end if
plot(1) = gsn_csm_contour(wks, cnb, res2)

res3 = res1
res3@gsnCenterString = "(c) 0-1500m"
res3@gsnRightString = cnc@units
if .not.autoTicks
  res3@cnMinLevelValF       = cnMinMaxIncc(0)
  res3@cnMaxLevelValF       = cnMinMaxIncc(1)
  res3@cnLevelSpacingF      = cnMinMaxIncc(2)
end if
plot(3) = gsn_csm_contour(wks, cnc, res3)

res4 = res1
res4@gsnCenterString = "(d) 300-700m"
res4@gsnRightString = cnd@units
if .not.autoTicks
  res4@cnMinLevelValF       = cnMinMaxIncd(0)
  res4@cnMaxLevelValF       = cnMinMaxIncd(1)
  res4@cnLevelSpacingF      = cnMinMaxIncd(2)
end if
plot(4) = gsn_csm_contour(wks, cnd, res4)

res5 = res1
res5@gsnCenterString = "(e) 700-1500m"
if .not.autoTicks
  res5@cnMinLevelValF       = cnMinMaxInce(0)
  res5@cnMaxLevelValF       = cnMinMaxInce(1)
  res5@cnLevelSpacingF      = cnMinMaxInce(2)
end if
plot(6) = gsn_csm_contour(wks, cne, res5)

;res6 = res
;res6@tiYAxisString      = ""
;plot(5) = gsn_csm_contour(wks, cn6, res6)

;---put plots in a panel--------------------------------{{{1
resP = True
resP@gsnFrame = False
;resP@gsnPanelLabelBar = True
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 10
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.7
resP@gsnPanelFigureStringsPerimOn = False

resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.7
resP@amParallelPosF = -0.5

resP@lbPerimOn      = False             ; no box around it
resP@lbOrientation      = "vertical"
resP@lbBoxLinesOn       = False
resP@lbLabelFontHeightF = fontSize*0.7
;resP@lbLabelStride      = 5
;resP@lbTitlePosition   = "Right"
resP@lbTitleString      = cbTitle
resP@lbTitleOffsetF     = -0.03
resP@lbTitleFontHeightF = fontSize*0.7

resP@pmLabelBarWidthF = 0.05
resP@pmLabelBarHeightF = 0.8
resP@pmLabelBarOrthogonalPosF = 0.01
resP@pmLabelBarParallelPosF = 0.05

gsn_panel(wks, plot, (/3,3,3/), resP)

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
;-------------------------------------------------------{{{1
; vim:fdm=marker:fdl=0:
; vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
