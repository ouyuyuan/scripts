
; Description: check the code robust of pcom1.0
;       Usage: nclrun xxx.ncl
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2016-04-06 20:15:43 BJT
; Last Change: 2016-04-18 08:53:07 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

datDir = "/home/ou/archive/data/pcom/phd/"
img    = "/home/ou/archive/drawing/phdthesis/" + getenv("NCL_ARG_0_base")

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;{{{

undef("rdiff")
function rdiff( newvar:numeric, oldvar: numeric )
begin
  diff = newvar - oldvar
  cn = newvar
  cn = where(abs(oldvar).gt.1.0e-6, diff/oldvar, 0.0)
  cn = where(abs(oldvar).lt.1.0e-6 .and. \
    abs(newvar).gt.1.0e-6, diff/newvar, cn)
  cn = cn*1.0e4

  cn@units = "10~S~-4~N~"
  return cn
end 

fname   = datDir + "N00000110_fillvalue.nc"
f       = addfile( fname, "r" )
pt_old  = f->pt(0,0,:,:)
pt_old@units = "~S~o~N~C"
u_old   = f->u(0,0,:,:)
ssh_old = f->ssh(0,:,:)
delete(f)

fname   = datDir + "results_10yr.nc"
f       = addfile( fname, "r" )
pt_new  = f->pt(109,0,:,:)
pt_new@units = "~S~o~N~C"
u_new   = f->u(109,0,:,:)
ssh_new = f->ssh(109,:,:)
delete(f)

cn1 = pt_new
cn2 = rdiff( pt_new, pt_old )

cn3 = u_new
cn4 = rdiff( u_new, u_old )

cn5 = ssh_new
cn6 = rdiff( ssh_new, ssh_old )
;}}}

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; plot model 
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

;  cmap = "NCL_default"
;  cmap = "GMT_jet"
;  cmap = "WhiteBlueGreenYellowRed"
cmap = "NCV_blu_red"
;cmap = "BlGrYeOrReVi200"

fontSize = 0.025
yLabelSize = fontSize*0.5
xLabelSize = fontSize*0.5
plotWid = 0.4
plotHei = 0.2
cbTitle1 = cn1@units
cbTitle2 = cn2@units
cbTitle3 = cn3@units
cbTitle4 = cn4@units
cbTitle5 = cn5@units
cbTitle6 = cn6@units
cnMinMaxInc1 = (/-4, 30, 2/)
cnMinMaxInc2 = (/-1, 1, 0.2/)
cnMinMaxInc3 = (/-0.5, 0.5, 0.1/)
cnMinMaxInc4 = cnMinMaxInc2
cnMinMaxInc5 = (/-2, 1, 0.2/)
cnMinMaxInc6 = cnMinMaxInc2
autoTicks = False
;autoTicks = True

wks = gsn_open_wks ("eps", img)

res = True
; {{{
res@vpWidthF = plotWid
res@vpHeightF = plotHei
;  res@vpXF = 0.2
;  res@vpYF = 0.9

res@tiXAxisFontHeightF = fontSize*0.8
res@tiYAxisFontHeightF = res@tiXAxisFontHeightF
res@tiXAxisString = ""
res@tiYAxisString = ""

res@gsnDraw = False
res@gsnFrame = False
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
res@gsnStringFontHeightF = res@tiXAxisFontHeightF
res@gsnCenterStringOrthogonalPosF = -0.06
res@gsnCenterStringFontHeightF = fontSize*0.6

res@tmXTOn = False
res@tmYROn = False
res@tmYRMinorOn = False
res@tmXBMinorOn = False
res@tmYRLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize
res@tmXBLabelStride = 2

res@cnFillOn         = True  ; turn on color for contours
res@cnLinesOn        = False ; turn off contour lines
res@cnLineThicknessF = 1.0
res@cnLineLabelFontHeightF = yLabelSize*0.7
;res@cnLineLabelBackgroundColor = "transparent"
res@cnLineLabelsOn   = False ; turn off contour line labels
res@cnInfoLabelOn    = False ; turns off contour info label
;res@cnMissingValFillColor = "gray60"
;   res@cnFillMode = "RasterFill"
if (.not.autoTicks)
res@cnLevelSelectionMode = "ManualLevels"
end if

res@mpShapeMode = "FreeAspect"
res@mpCenterLonF = 200
res@mpMaxLatF = 80
res@mpMinLatF = -80

res@lbLabelBarOn   = True
res@lbOrientation = "Vertical"     ; vertical label bar
res@lbBoxLinesOn = False
;res@lbTitlePosition = "Right"
res@lbTitleOffsetF = -0.04
res@lbTitleFontHeightF = fontSize*0.5
res@lbLabelFontHeightF = fontSize*0.4

res@pmLabelBarOrthogonalPosF = 0.015
res@pmLabelBarParallelPosF = 0.55
res@pmLabelBarWidthF = 0.06
res@pmLabelBarHeightF = plotHei*1.1

;}}}

res1 = res  ;{{{1
;res1@tmXBOn = False
res1@gsnCenterString = "SST"
res1@lbTitleString = cbTitle1
if (.not.autoTicks) then
res1@cnMinLevelValF       = cnMinMaxInc1(0)
res1@cnMaxLevelValF       = cnMinMaxInc1(1)
res1@cnLevelSpacingF      = cnMinMaxInc1(2)
end if

res2 = res
;res2@tmYLOn = False
;res2@tmXBOn = False
res2@gsnCenterString = "relative error of a)"
res2@lbTitleString = cbTitle2
if (.not.autoTicks) then
res2@cnMinLevelValF       = cnMinMaxInc2(0)
res2@cnMaxLevelValF       = cnMinMaxInc2(1)
res2@cnLevelSpacingF      = cnMinMaxInc2(2)
end if

res3 = res
;res3@tmXBOn = False
res3@gsnCenterString = "zonal currents"
res3@lbTitleString = cbTitle3
res3@lbTitleString = cbTitle3
if (.not.autoTicks) then
res3@cnMinLevelValF       = cnMinMaxInc3(0)
res3@cnMaxLevelValF       = cnMinMaxInc3(1)
res3@cnLevelSpacingF      = cnMinMaxInc3(2)
end if

res4 = res
;res4@tmXBOn = False
;res4@tmYLOn = False
res4@gsnCenterString = "relative error of c)"
res4@lbTitleString = cbTitle4
if (.not.autoTicks) then
res4@cnMinLevelValF       = cnMinMaxInc4(0)
res4@cnMaxLevelValF       = cnMinMaxInc4(1)
res4@cnLevelSpacingF      = cnMinMaxInc4(2)
end if

res5 = res
res5@gsnCenterString = "SSH"
res5@lbTitleString = cbTitle5
if (.not.autoTicks) then
res5@cnMinLevelValF       = cnMinMaxInc5(0)
res5@cnMaxLevelValF       = cnMinMaxInc5(1)
res5@cnLevelSpacingF      = cnMinMaxInc5(2)
end if

res6 = res
;res6@tmYLOn = False
res6@gsnCenterString = "relative error of e)"
res6@lbTitleString = cbTitle6
if (.not.autoTicks) then
res6@cnMinLevelValF       = cnMinMaxInc6(0)
res6@cnMaxLevelValF       = cnMinMaxInc6(1)
res6@cnLevelSpacingF      = cnMinMaxInc6(2)
end if

plot = new(6, graphic) ;{{{1
plot(0) = gsn_csm_contour_map(wks, cn1, res1)
plot(1) = gsn_csm_contour_map(wks, cn2, res2)
plot(2) = gsn_csm_contour_map(wks, cn3, res3)
plot(3) = gsn_csm_contour_map(wks, cn4, res4)
plot(4) = gsn_csm_contour_map(wks, cn5, res5)
plot(5) = gsn_csm_contour_map(wks, cn6, res6)

resP = True ;{{{1
;resP@gsnDraw = False
resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
;resP@gsnPanelLabelBar = True
resP@gsnPanelYWhiteSpacePercent = 8
resP@gsnPanelXWhiteSpacePercent = 1
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStrings = (/"a)","b)","c)","d)","e)","f)"/)
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.7
resP@gsnPanelFigureStringsPerimOn = False
resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.7
;resP@amParallelPosF = 0.15

gsn_panel(wks, plot, (/2,2,2/), resP)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
