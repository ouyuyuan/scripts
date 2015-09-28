
; Description: windstress curl evolve with time
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-11 19:31:11 BJT
; Last Change: 2015-07-22 16:33:17 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;img, dirs, and data files------------------------------{{{1
img = getenv("NCL_ARG_2")
nc  = "/home/ou/archive/data/soda/pcom_grid/post/merge_ws.nc"
;basinFile = "/home/ou/archive/data/pcom/basin/basin_b.nc"
basinFile = "/home/ou/archive/data/pcom/basin/basin.nc"

;get plotting data--------------------------------------{{{1
f = addfile(basinFile, "r")
basin = f->basin
delete(f)
AtlId = 6 ; 6 represents Atlantic in the basin file
SouId = 1
PacId = 2
IndId = 3

f = addfile(nc, "r")
taux = f->taux({1949:2008},:,:)
tauy = f->tauy({1949:2008},:,:)
;tauy = 0
lat = f->lat
lon = f->lon
delete(f)

curl = taux
curl = uv2vr_cfd(taux, tauy, lat, lon, 3)

meanCurl = dim_avg_n_Wrap(curl({1961:1990},:,:), 0)
meanCurlC = conform(curl, meanCurl, (/1,2/))
curlAn = curl
curlAn = curl - meanCurlC
curlAn = curlAn * 1e7
curlAn@units = "10~S~-7~N~N m~S~-3~N~"

cnGlo = dim_avg_n_Wrap(curlAn, 2)

function get_basin(basinId)
local cn, mycurl, mybasin
begin
  mycurl = curlAn
;  mycurl = curl
  mybasin = basin
  mybasin = where(basin.eq.basinId, 1, basin@_FillValue)
  mycurl = mycurl * conform(mycurl, mybasin, (/1,2/))
  cn = dim_avg_n_Wrap(mycurl, 2)

  return cn(lat|:,time|:)
end 

cn1 = cnGlo(lat|:,time|:)

cn2 = get_basin(PacId)
cn3 = get_basin(AtlId)

;plotting parameters------------------------------------{{{1
fontSize      = 0.02
plotWid       = 0.4
plotHei       = 0.2
cnMinMaxInc   = (/-3.0, 3.0, 1.0/)
yTitle        = "latitude"
xTitle        = "model year"

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
if .not.autoTicks
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       = cnMinMaxInc(0)
  res@cnMaxLevelValF       = cnMinMaxInc(1)
  res@cnLevelSpacingF      = cnMinMaxInc(2)
end if

res@lbPerimOn      = False             ; no box around it
;res@lbLabelBarOn      = False
res@lbOrientation      = "vertical"
res@lbTitleOffsetF     = 0.03
res@lbTitleFontHeightF = fontSize*0.8
res@lbBoxLinesOn       = False
res@lbLabelFontHeightF = fontSize*0.8
;res@lbLabelStride      = 2
;res@lbTitlePosition   = "Right"
res@lbTitleString      = cn1@units

;res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
;res@pmLabelBarWidthF = 0.05
;res@pmLabelBarHeightF = 0.9
;res@pmLabelBarOrthogonalPosF = 0.02
;res@pmLabelBarParallelPosF = 0.55

res@tmLabelAutoStride    = True
;res@tmYROn               = False
;res@tmXTOn               = False
;res@tmYLMinorOn          = False
;res@tmXBMinorOn          = False
res@tmYLLabelFontHeightF = fontSize*0.8
res@tmXBLabelFontHeightF = fontSize*0.8

;draw plots calling gsn functions-----------------------{{{1
plot = new(3, graphic)

res1 = res
res1@tiXAxisString      = ""
plot(0) = gsn_csm_contour(wks, cn1, res1)

res2 = res
res2@tiXAxisString      = ""
res2@tiYAxisString      = ""
plot(1) = gsn_csm_contour(wks, cn2, res2)

res3 = res
res3@tiXAxisString      = ""
plot(2) = gsn_csm_contour(wks, cn3, res3)

;res4 = res
;res4@tiXAxisString      = ""
;res4@tiYAxisString      = ""
;plot(3) = gsn_csm_contour(wks, cn4, res4)

;res5 = res
;plot(4) = gsn_csm_contour(wks, cn5, res5)

;put plots in a panel-----------------------------------{{{1
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
resP@lbTitleOffsetF     = -0.03
resP@lbTitleFontHeightF = fontSize*0.7

resP@pmLabelBarWidthF = 0.05
resP@pmLabelBarHeightF = 0.8
resP@pmLabelBarOrthogonalPosF = 0.01
resP@pmLabelBarParallelPosF = 0.05

gsn_panel(wks, plot, (/1,2/), resP)

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
;-------------------------------------------------------{{{1
; vim:fdm=marker:fdl=0:
; vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
