
; Description: Wind stress evolving with time
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-11 19:31:11 BJT
; Last Change: 2015-05-09 15:44:54 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

img = "/home/ou/archive/drawing/soda/" + getenv("NCL_ARG_0_base")
nc  = "/home/ou/archive/data/soda/post/wind_stress_lat_time.nc"

; figure control
fontSize    = 0.02
plotWid     = 0.4
plotHei     = 0.3
cbTitle     = "N/m~S~2"
uMinMaxInc  = (/-0.2, 0.2, 0.02/)
vMinMaxInc  = (/-0.04, 0.04, 0.004/)
raMinMaxInc  = (/-0.5, 0.5, 0.1/)
yTitle      = "latitude"
xTitle      = "year"

autoTicks = False
;autoTicks = True

;cmap = "ncl_default"
;cmap = "BlGrYeOrReVi200"
;  cmap = "testcmap"
cmap = "NCV_blu_red"
wks = gsn_open_wks("eps", img)
gsn_define_colormap(wks,cmap)

; get data
;{{{

; cn assume to be (time,lat)
function get_relative_change(cn)
local cn, cnR, mean
begin
  mean = dim_avg_n_Wrap(cn, 0)
  cnR = cn
  cnR = cnR - conform(cnR, mean, 1)
  dims = dimsizes(cn)
  do i = 0, dims(0) - 1
    do j = 0, dims(1) - 1
      if (.not.ismissing(mean(j))) .and. (abs(mean(j)).gt.1.0e-6) then
        cnR(i,j) = cnR(i,j)/mean(j)
      else
        cnR(i,j) = cnR@_FillValue
      end if
    end do
  end do

  return cnR
end

f = addfile(nc, "r")
taux = f->taux({1949:2008},{-65:65})
tauy = f->tauy({1949:2008},{-65:65})
delete(f)

cn1 = taux
cn3 = get_relative_change(cn1)

cn2 = tauy
cn4 = get_relative_change(cn2)
;}}}

; resources
;{{{
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
if (cmap.eq."BlGrYeOrReVi200") then
  res@gsnSpreadColorStart  = 35                 ; start at color 17
  ;   res@gsnSpreadColorEnd    = 240                ; end at color 200
  res@gsnSpreadColorEnd    = 180                ; end at color 200
end if
if (cmap.eq."ncl_default") then
;  res@gsnSpreadColorStart  = 35                 ; start at color 17
  res@gsnSpreadColorEnd    = 230                ; end at color 200
end if

res@cnFillOn             = True               ; turn on color for contours
;res@cnLinesOn            = False              ; turn off contour lines
res@cnLineThicknessF     = 0.1
res@cnLineLabelsOn       = False              ; turn off contour line labels
res@cnInfoLabelOn        = False      ; turns off contour info label
;res@cnMissingValFillColor = "gray60"

res@lbPerimOn      = False             ; no box around it
;res@lbLabelBarOn      = False
res@lbOrientation      = "vertical"
res@lbTitleOffsetF     = -0.03
res@lbTitleFontHeightF = fontSize*0.9
;res@lbBoxLinesOn       = False
res@lbLabelFontHeightF = fontSize*0.7
;res@lbLabelStride      = 2
;res@lbTitlePosition   = "Right"

;res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
res@pmLabelBarWidthF = 0.08
res@pmLabelBarHeightF = plotHei*1.1
res@pmLabelBarOrthogonalPosF = 0.02
res@pmLabelBarParallelPosF = 0.55

res@tmLabelAutoStride    = True
res@tmYROn               = False
res@tmXTOn               = False
res@tmYLMinorOn          = False
res@tmXBMinorOn          = False
res@tmYLLabelFontHeightF = fontSize*0.8
res@tmXBLabelFontHeightF = fontSize*0.8
;}}}

resWs = res
;{{{
resWs@lbTitleString      = cbTitle
;resWs@tmXBOn             = False
;}}}

resRa = res
;{{{
;resRa@tmXBOn             = False
resRa@lbTitleString      = "   "
resRa@tiYAxisString      = yTitle
resRa@cnLinesOn            = False              ; turn off contour lines
if .not.autoTicks
  resRa@cnLevelSelectionMode = "ManualLevels"
  resRa@cnMinLevelValF       = raMinMaxInc(0)
  resRa@cnMaxLevelValF       = raMinMaxInc(1)
  resRa@cnLevelSpacingF      = raMinMaxInc(2)
;  resRa@cnLevelSelectionMode = "ExplicitLevels"
;  resRa@cnLevels =     (/ -1, -0.5, -0.2, -0.15, -0.1, -0.05, 0.02, \
;   0,  0.02, 0.05, 0.1, 0.15, 0.2, 0.5, 1/)
;  resRa@cnFillColors = (/2,20,  40,   60,    90,  100,   110,  130, \
;    140, 150, 160, 175,  190, 200, 220, 235/)
end if
;}}}

plot = new(4, graphic)

res1 = resWs
res1@tiXAxisOn = False
if .not.autoTicks
  res1@cnLevelSelectionMode = "ManualLevels"
  res1@cnMinLevelValF       = uMinMaxInc(0)
  res1@cnMaxLevelValF       = uMinMaxInc(1)
  res1@cnLevelSpacingF      = uMinMaxInc(2)
end if
plot(0) = gsn_csm_contour(wks, cn1(lat|:,time|:), res1)

res2 = resWs
res2@tiXAxisString = ""
res2@tiYAxisString = ""
if .not.autoTicks
  res2@cnLevelSelectionMode = "ManualLevels"
  res2@cnMinLevelValF       = vMinMaxInc(0)
  res2@cnMaxLevelValF       = vMinMaxInc(1)
  res2@cnLevelSpacingF      = vMinMaxInc(2)
end if
plot(1) = gsn_csm_contour(wks, cn2(lat|:,time|:), res2)

res3 = resRa
plot(2) = gsn_csm_contour(wks, cn3(lat|:,time|:), res3)

res4 = resRa
res4@tiYAxisString = ""
plot(3) = gsn_csm_contour(wks, cn4(lat|:,time|:), res4)

resP = True
resP@gsnFrame = False
;resP@gsnPanelLabelBar = True
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 5
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStrings = (/"(a) zonal wind stress", \
"(b) meridional wind stress", \
"(c) relative change of (a)", "(d) relative change of (b)"/)
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.6
resP@gsnPanelFigureStringsPerimOn = False
resP@gsnPanelFigureStringsBackgroundFillColor = "transparent"

resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.6
resP@amParallelPosF = -0.3

gsn_panel(wks, plot, (/2,2/), resP)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
