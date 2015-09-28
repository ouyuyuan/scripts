
; Description: SSH, volume anomaly, DTC, OHC evolves with time
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-11 19:31:11 BJT
; Last Change: 2015-06-17 15:57:39 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;---img, dirs, and data files---------------------------{{{1
refDir = "/home/ou/archive/data/pcom/exp_spinup/post/"
datDir    = getenv("NCL_ARG_1")
img       = getenv("NCL_ARG_2")

ncSsh = "calc_004b_merge_ssh.nc"
ncDvol = "calc_006e_dvol.nc"
ncDtc = "calc_006b_dtc.nc"
ncOhc = "calc_006d_ohc_0-700m.nc"

;---get plotting data-----------------------------------{{{1
; get SSH anomaly {{{2
f = addfile(refDir + ncSsh, "r")
cn3d = f->ssh
delete(f)
cnR = dim_avg_n_Wrap(cn3d,2)

f = addfile(datDir + ncSsh, "r")
cn3d = f->ssh
delete(f)
cn = dim_avg_n_Wrap(cn3d,2)

cn = cn - cnR
cn = dim_rmvmean_n_Wrap(cn, 0)
; it seems that detrend introduce artificial oscillations
;  cn = dtrend_n(cn, False, 0) 
cn = cn*100 
cn@units = "cm"
cn&time = cn&time - 600
ssh = cn(lat|:,time|:)
delete(cn)
delete(cnR)
delete(cn3d)

; get volume anomaly {{{2
f = addfile(refDir + ncDvol, "r")
cn3d = f->dvol
delete(f)
cnR = dim_sum_n_Wrap(cn3d,2)

f = addfile(datDir + ncDvol, "r")
cn3d = f->dvol
delete(f)
cn = dim_sum_n_Wrap(cn3d,2)

cn = cn - cnR
cn = dim_rmvmean_n_Wrap(cn, 0)
; it seems that detrend introduce artificial oscillations
;  cn = dtrend_n(cn, False, 0) 
cn = cn*1e-10
cn@units = "10~S~10~N~m~S~3~N~/1~S~o"
cn&time = cn&time - 600
vol = cn(lat|:,time|:)
delete(cn)
delete(cnR)
delete(cn3d)

; get DTC anomaly {{{2
f = addfile(refDir + ncDtc, "r")
cn3d = f->dtc
delete(f)
cnR = dim_avg_n_Wrap(cn3d,2)

f = addfile(datDir + ncDtc, "r")
cn3d = f->dtc
delete(f)
cn = dim_avg_n_Wrap(cn3d,2)

cn = cn - cnR
cn = dim_rmvmean_n_Wrap(cn, 0)
; it seems that detrend introduce artificial oscillations
;  cn = dtrend_n(cn, False, 0) 
cn&time = cn&time - 600
dtc = cn(lat|:,time|:)

; beyond 30 degree, dtc is kind of stochasic and over large
lat = dtc&lat
latC = conform(dtc, lat, (/0/))
dtc = where(abs(latC).gt.30.0, dtc@_FillValue, dtc)

delete(cn)
delete(cnR)
delete(cn3d)

; get OHC anomaly {{{2
f = addfile(refDir + ncOhc, "r")
cn3d = f->ohc
delete(f)
cnR = dim_sum_n_Wrap(cn3d,2)

f = addfile(datDir + ncOhc, "r")
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

;---plotting parameters---------------------------------{{{1
fontSize      = 0.018
plotWid       = 0.4
plotHei       = 0.2
cbTitle    = "10~S~10~N~m~S~3~N~/1~S~o"
cnMinMaxIncSsh   = (/-3.0, 3.0, 0.2/)
cnMinMaxIncVol   = (/-6.0, 6.0, 0.5/)
cnMinMaxIncDtc   = (/-15.0, 15.0, 1.0/)
cnMinMaxIncOhc   = (/-2.0, 2.0, 0.1/)
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
res1@gsnCenterString = "(a) Zonal-mean SSH"
res1@gsnRightString = ssh@units
res1@tiXAxisString      = ""
if .not.autoTicks
  res1@lbLabelStride  = 1.0/cnMinMaxIncSsh(2)
  res1@cnMinLevelValF       = cnMinMaxIncSsh(0)
  res1@cnMaxLevelValF       = cnMinMaxIncSsh(1)
  res1@cnLevelSpacingF      = cnMinMaxIncSsh(2)
;  ssh = where(ssh.lt.cnMinMaxIncSsh(0), cnMinMaxIncSsh(0), ssh)
;  ssh = where(ssh.gt.cnMinMaxIncSsh(1), cnMinMaxIncSsh(1), ssh)
end if
plot(0) = gsn_csm_contour(wks, ssh, res1)

res2 = res
res2@gsnCenterString = "(b) Zonal-integrated volume"
res2@gsnRightString = vol@units
res2@gsnRightStringParallelPosF = 1.3
res2@tiXAxisString      = ""
res2@tiYAxisString      = ""
if .not.autoTicks
  res2@lbLabelStride  = 1.0/cnMinMaxIncVol(2)
  res2@cnMinLevelValF       = cnMinMaxIncVol(0)
  res2@cnMaxLevelValF       = cnMinMaxIncVol(1)
  res2@cnLevelSpacingF      = cnMinMaxIncVol(2)
end if
plot(1) = gsn_csm_contour(wks, vol, res2)

res3 = res
;res3@tiXAxisString      = ""
res3@gsnCenterString = "(c) Zonal-mean DTC"
res3@gsnRightString = dtc@units
if .not.autoTicks
  res3@cnMinLevelValF       = cnMinMaxIncDtc(0)
  res3@cnMaxLevelValF       = cnMinMaxIncDtc(1)
  res3@cnLevelSpacingF      = cnMinMaxIncDtc(2)
end if
plot(3) = gsn_csm_contour(wks, dtc, res3)

res4 = res
;res4@tiXAxisString      = ""
res4@gsnCenterString = "(d) Zonal-integrated OHC"
;res4@gsnRightStringParallelPosF = 1.3
res4@gsnRightString = ohc@units
res4@tiYAxisString      = ""
if .not.autoTicks
  res4@lbLabelStride  = 1.0/cnMinMaxIncOhc(2)
  res4@cnMinLevelValF       = cnMinMaxIncOhc(0)
  res4@cnMaxLevelValF       = cnMinMaxIncOhc(1)
  res4@cnLevelSpacingF      = cnMinMaxIncOhc(2)
end if
plot(4) = gsn_csm_contour(wks, ohc, res4)

;res5 = res
;plot(4) = gsn_csm_contour(wks, cn5, res5)

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
resP@lbLabelStride      = 5
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
