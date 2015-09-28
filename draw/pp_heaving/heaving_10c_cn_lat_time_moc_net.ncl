
; Description: flux (min/max MOC) evolves with time
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-11 19:31:11 BJT
; Last Change: 2015-06-18 20:48:05 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;img, dirs, and data files------------------------------{{{1
datDir    = "/home/ou/archive/data/pcom/"
img       = getenv("NCL_ARG_2")

refDir    = "exp_spinup/post/"
expDir1   = "exp71_heaving_b_Pac_20S-20N/post/"
expDir2   = "exp72_heaving_b_Pac_0N-40N/post/"
expDir3   = "exp73_heaving_b_Pac_20N-60N/post/"
expDir4   = "exp74_heaving_b_Pac_40N-80N/post/"

nc = "calc_10b_moc_years.nc"

f = addfile(datDir + expDir1 + nc, "r")
sec = f->mocPac(0,:,:)
delete(f)
z = sec&z
lat = sec&lat
nz = dimsizes(z)
nlat = dimsizes(lat)

;idx = new(nlat,integer)
;idx = 0
;do j = 0, nlat-1
;  do k = 0,nz-1
;    if (ismissing(sec(k,j))) then
;      break
;    else
;      idx(j) = idx(j) + 1
;    end if
;  end do
;end do
;print (idx+0)
;exit

;get plotting data--------------------------------------{{{1
function get_flux_top(expDir)
begin
  f = addfile(datDir + expDir + nc, "r")
  moc = f->mocPac
  delete(f)
  moc&time = moc&time - 600
  moc = dim_rmvmean_n(moc, 0)
  flux = moc(:,0,:)
  return flux(lat|:,time|:)
end

function get_flux_bot(expDir)
begin
  f = addfile(datDir + expDir + nc, "r")
  moc = f->mocPac
  delete(f)
  moc&time = moc&time - 600
  moc = dim_rmvmean_n(moc, 0)
  flux = moc(:,nz-1,:)
  return flux(lat|:,time|:)
end

cn1 = get_flux_top(expDir1)
cn3 = get_flux_top(expDir2)
cn5 = get_flux_top(expDir3)

cn2 = get_flux_bot(expDir1)
cn4 = get_flux_bot(expDir2)
cn6 = get_flux_bot(expDir3)

;plotting parameters------------------------------------{{{1
fontSize      = 0.018
plotWid       = 0.4
plotHei       = 0.2
cnMinMaxInc1   = (/-12.0, 12.0, 0.5/)
cnMinMaxInc2   = (/-4.0, 4.0, 0.2/)
cnMinMaxInc3   = (/-1.0, 1.0, 0.1/)
yTitle        = "latitude"
xTitle        = "year"

;autoTicks = False
autoTicks = True

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
res@gsnStringFontHeightF = fontSize*0.8
res@gsnRightStringFontHeightF = fontSize*0.8
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
res@gsnCenterStringOrthogonalPosF = 0.05
res@gsnRightStringOrthogonalPosF = 0.05
res@gsnRightStringParallelPosF = 1.2
res@gsnRightString = cn1@units

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

;res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
res@pmLabelBarWidthF = 0.07
;res@pmLabelBarHeightF = 0.9
res@pmLabelBarOrthogonalPosF = 0.02
res@pmLabelBarParallelPosF = 0.5

res@tmLabelAutoStride    = True
;res@tmYROn               = False
;res@tmXTOn               = False
res@tmYLMinorOn          = False
res@tmXBMinorOn          = False
res@tmYLLabelFontHeightF = fontSize*0.8
res@tmXBLabelFontHeightF = fontSize*0.8
;res@tmYLTickSpacingF = 15

res@trYMinF = -30
;res@trYMinF = 0
res@trYMaxF = 60

;draw plots calling gsn functions-----------------------{{{1
plot = new(6, graphic)

res1 = res
res1@gsnCenterString = "(a) Exp. P-A"
res1@tiXAxisString      = ""
if .not.autoTicks
  res1@lbLabelStride  = 4.0/cnMinMaxInc1(2)
  res1@cnMinLevelValF       = cnMinMaxInc1(0)
  res1@cnMaxLevelValF       = cnMinMaxInc1(1)
  res1@cnLevelSpacingF      = cnMinMaxInc1(2)
end if
plot(0) = gsn_csm_contour(wks, cn1, res1)

res2 = res
;res2@gsnCenterString = "(a) Exp. P-A"
res2@tiXAxisString      = ""
plot(1) = gsn_csm_contour(wks, cn2, res2)

res3 = res
res3@gsnCenterString = "(b) Exp. P-B"
res3@tiXAxisString      = ""
;res3@tiYAxisString      = ""
if .not.autoTicks
  res3@lbLabelStride  = 2.0/cnMinMaxInc2(2)
  res3@cnMinLevelValF       = cnMinMaxInc2(0)
  res3@cnMaxLevelValF       = cnMinMaxInc2(1)
  res3@cnLevelSpacingF      = cnMinMaxInc2(2)
end if
plot(2) = gsn_csm_contour(wks, cn3, res3)

res4 = res
;res4@gsnCenterString = "(b) Exp. P-B"
res4@tiXAxisString      = ""
plot(3) = gsn_csm_contour(wks, cn4, res4)

res5 = res
;res5@tiXAxisString      = ""
res5@gsnCenterString = "(c) Exp. P-C"
if .not.autoTicks
  res5@lbLabelStride  = 0.5/cnMinMaxInc3(2)
  res5@cnMinLevelValF       = cnMinMaxInc3(0)
  res5@cnMaxLevelValF       = cnMinMaxInc3(1)
  res5@cnLevelSpacingF      = cnMinMaxInc3(2)
end if
plot(4) = gsn_csm_contour(wks, cn5, res5)

res6 = res
;res6@gsnCenterString = "(c) Exp. P-C"
plot(5) = gsn_csm_contour(wks, cn6, res6)

;put plots in a panel-----------------------------------{{{1
resP = True
resP@gsnFrame = False
;resP@gsnPanelLabelBar = True
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 5
resP@gsnPanelRowSpec = True

resP@lbPerimOn      = False             ; no box around it
resP@lbOrientation      = "vertical"
resP@lbBoxLinesOn       = False
resP@lbLabelFontHeightF = fontSize*0.7
resP@lbLabelStride      = 5
;resP@lbTitlePosition   = "Right"
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
