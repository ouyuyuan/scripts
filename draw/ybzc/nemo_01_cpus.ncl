
; Description: CPU distribution of the MPI parallel
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-03-11 19:31:11 BJT
; Last Change: 2015-05-21 15:26:27 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;---img, dirs, and data files---------------------------{{{1
load "$HOME/archive/scripts/draw/ybzc/head.ncl"
;nc = "global_variable.nc"
nc = "cpus.nc"

;---get plotting data-----------------------------------{{{1
f = addfile(datDir + nc, "r")
cn = f->cpus(0,:,:)
delete(f)

f = addfile(datDir + "N0480.nc", "r")
ic = f->ic
jc = f->jc
delete(f)

dims = dimsizes(cn)
y = ispan(0, dims(0)-1, 1)
x = ispan(0, dims(1)-1, 1)
cn&y = y
cn&x = x

;---plotting parameters---------------------------------{{{1
fontSize    = 0.02
cnMinMaxInc = (/0, 600, 10/)
plotWid = 0.9
plotHei = 0.6

autoTicks = False
;autoTicks = True

;cmap = "ncl_default"
;cmap = "BlGrYeOrReVi200"
cmap = "NCV_jet"
;cmap = "3saw"
;cmap = "NCV_blu_red"
wks = gsn_open_wks("eps", img)
gsn_define_colormap(wks,cmap)

;---resources attributes setting------------------------{{{1
res = True
res@vpHeightF = plotHei
res@vpWidthF  = plotWid

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
if (cmap.eq."BlGrYeOrReVi200") then
  res@gsnSpreadColorStart  = 35
  res@gsnSpreadColorEnd    = 180
end if
if (cmap.eq."ncl_default") then
  res@gsnSpreadColorStart  = 27
  res@gsnSpreadColorEnd    = 230
end if
if (cmap.eq."NCV_jet") then
  res@gsnSpreadColorStart  = 40
;  res@gsnSpreadColorEnd    = 230
end if

res@cnFillOn             = True
res@cnFillMode           = "RasterFill"
res@cnLinesOn            = False
res@cnLineThicknessF     = 0.1
res@cnLineLabelsOn       = False
res@cnInfoLabelOn        = False
res@cnMissingValFillColor = "gray60"
if .not.autoTicks
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       = cnMinMaxInc(0)
  res@cnMaxLevelValF       = cnMinMaxInc(1)
  res@cnLevelSpacingF      = cnMinMaxInc(2)
end if

res@lbLabelBarOn      = False

res@tmLabelAutoStride    = True
res@tmYROn               = False
res@tmXTOn               = False
res@tmYLMinorOn          = False
res@tmXBMinorOn          = False
res@tmYLLabelFontHeightF = fontSize*0.8
res@tmXBLabelFontHeightF = fontSize*0.8

;---draw plots calling gsn functions--------------------{{{1

plot = new(2, graphic)
plot(0) = gsn_csm_contour(wks, cn, res)

;---write cpu index on the contour plot-----------------{{{1
txres               =  True
txres@txFontHeightF = fontSize*0.5
txres@txJust = "centercenter"

ncpu = dimsizes(ic)
texts = new(ncpu, string)
texts = ""
do i=0, ncpu - 1
  texts(i) = sprinti( "%3i", i )
end do

id = gsn_add_text( wks, plot(0), texts, ic, jc, txres)

;---panel-----------------------------------------------{{{1
resP = True
resP@gsnFrame = False
resP@gsnPanelRowSpec = True
gsn_panel(wks, plot, (/2/), resP)

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
;-------------------------------------------------------{{{1
; vim:fdm=marker:fdl=0:
; vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
