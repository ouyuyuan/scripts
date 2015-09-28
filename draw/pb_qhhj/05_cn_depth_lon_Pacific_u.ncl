
; Description: 2 subplots, each is a depth-year contour plot
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2015-09-11 15:20:00 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

datDir = "/home/ou/archive/data/pcom/exp_spinup/post/"
img    = "/home/ou/archive/drawing/pb_qhhj/" + getenv("NCL_ARG_0_base")

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;{{{
f = addfile("/home/ou/archive/data/soda/pcom_grid/post/climate_1971-2000_u.nc", "r")
t = f->u(:,{-0.5:0.5},{130:290})
delete(f)
cn1 = dim_avg_n_Wrap(t,1)
cn1@units = "m/s"
delete(t)

fname = datDir + "climate_791-800.nc"
f = addfile(fname, "r")
t = f->u(0,:,{-0.5:0.5},{130:290})
delete(f)
cn2 = dim_avg_n_Wrap(t,1)
cn2@units = cn1@units
;}}}

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; plot model 
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

;cmap = "NCL_default"
;  cmap = "GMT_jet"
;  cmap = "WhiteBlueGreenYellowRed"
cmap = "NCV_blu_red"

fontSize = 0.03
yLabelSize = fontSize
xLabelSize = yLabelSize
plotWid = 0.9
plotHei = 0.4
yTitle = "depth (m)"
xTitle = "longitude"
cbTitle = cn1@units
cnMinMaxInc = (/-1, 1, 0.1/)
autoTicks = False
;autoTicks = True

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks,cmap)

res = True
; {{{
res@vpWidthF = plotWid
res@vpHeightF = plotHei
;  res@vpXF = 0.2
;  res@vpYF = 0.9

res@tiXAxisFontHeightF = xLabelSize
res@tiYAxisFontHeightF = yLabelSize
res@tiXAxisString = xTitle
res@tiYAxisString = yTitle

res@gsnDraw = False
res@gsnFrame = False
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
res@gsnStringFontHeightF = res@tiXAxisFontHeightF
res@gsnCenterStringOrthogonalPosF = 0.01
res@gsnAddCyclic = False
res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 
if (cmap.eq."ncl_default") then
  res@gsnSpreadColorEnd = 230
end if
res@gsnContourZeroLineThicknessF = 2

res@cnFillOn             = True               ; turn on color for contours
;res@cnLinesOn            = False              ; turn off contour lines
res@cnLineThicknessF     = 0.5
res@cnLineLabelFontHeightF = yLabelSize*0.6
;res@cnLineLabelBackgroundColor = "transparent"
;res@cnLineLabelsOn       = False              ; turn off contour line labels
res@cnInfoLabelOn        = False      ; turns off contour info label
;res@cnMissingValFillColor = "gray60"
;   res@cnFillMode = "RasterFill"
if .not.autoTicks
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       = cnMinMaxInc(0)
  res@cnMaxLevelValF       = cnMinMaxInc(1)
  res@cnLevelSpacingF      = cnMinMaxInc(2)
end if

res@lbLabelBarOn   = False

;res@tmXTOn = False
;res@tmYROn = False
;res@tmYRMinorOn = False
res@tmYRLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize*0.8
;res@tmXBLabelStride = 2

res@tmXBMode = "Explicit"
res@tmXBValues = (/140, 180, 220, 260/)
res@tmXBMinorValues =  ispan(140,280,20)
res@tmXBLabels = (/"140~S~o~N~E", "180~S~o", "140~S~o~N~W", "100~S~o~N~W"/)

res@tmYLMode = "Explicit"
res@tmYLValues = (/0, 100, 200, 300/)
res@tmYLMinorValues =  ispan(0,350,50)
res@tmYLLabels = res@tmYLValues

res@trYMaxF = 350.
res@trYMinF = 0.
res@trYReverse               = True   ; reverses y-axis
;}}}

res1 = res
res1@gsnCenterString = "Reanalysis"
res1@tiXAxisString = ""

res2 = res
res2@gsnCenterString = "Simulated"

plot = new(2, graphic)

plot(0) = gsn_csm_contour(wks, cn1, res1)

plot(1) = gsn_csm_contour(wks, cn2, res2)

resP = True
;resP@gsnDraw = False
resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
resP@gsnPanelLabelBar = True
resP@gsnPanelYWhiteSpacePercent = 0
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStrings = (/"a)","b)"/)
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.8
resP@gsnPanelFigureStringsPerimOn = False
resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.7

resP@lbOrientation = "Vertical"     ; vertical label bar
;resP@lbBoxLinesOn = False
;resP@lbTitlePosition = "Right"
resP@lbLabelFontHeightF = fontSize*0.65
resP@lbTitleFontHeightF = yLabelSize*0.8
resP@lbTitleString = cbTitle
resP@lbTitleOffsetF = -0.05

;resP@pmLabelBarOrthogonalPosF = 0.015
resP@pmLabelBarParallelPosF = 0.05
resP@pmLabelBarWidthF = 0.07
resP@pmLabelBarHeightF = 0.6

gsn_panel(wks, plot, (/1,1/), resP)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
