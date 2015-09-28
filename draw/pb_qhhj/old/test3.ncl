
; Description: 2 subplots, each is a depth-year contour plot
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2015-03-08 19:58:00 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

datDir = getenv("NCL_ARG_1")
img = getenv("NCL_ARG_2")

f = addfile("/home/ou/archive/data/pcom/grid_info.nc", "r")
dz = f->dz
delete(f)

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
;{{{
function get_deviation(fname, varName)
; get the value devated to the initial value of each layer
local var, f
begin
  f = addfile(fname, "r")
  var = f->$varName$
  delete(f)

  cn = var(z|:,time|:)
  cn0 = conform_dims( dimsizes(cn), cn(:,0), 0 )
  cn = cn - cn0

  if (varName.eq."pt")
    cn@units = "~S~o~N~C"
  end if
  if (varName.eq."sa")
    cn@units = "psu"
  end if

  return cn
end

fname = datDir + "calc_09_layer_ave.nc"
cn1 = get_deviation(fname, "pt")
cn2 = get_deviation(fname, "sa")

;}}}


;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; plot model 
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

;  cmap = "NCL_default"
;  cmap = "GMT_jet"
;  cmap = "WhiteBlueGreenYellowRed"
cmap = "NCV_blu_red"

fontSize = 0.03
yLabelSize = fontSize
xLabelSize = fontSize
plotWid = 0.7
plotHei = 0.4
yTitle = "depth (meter)"
xTitle = "model year"
cbTitle1 = cn1@units
cbTitle2 = cn2@units
cnMinMaxInc = (/-0.6, 0.6, 0.01/)
tmMaxY = 2000
;autoTicks = False
autoTicks = True

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks,cmap)

res = True
; resource{{{

;  res@tiMainString = "Drift of the annual mean potential temperature"

res@gsnDraw = False
res@gsnFrame = False
;   res@gsnMaximize = True
res@gsnSpreadColors      = True               ; use full color map
;   res@gsnSpreadColorStart  = 30                 ; start at color 17
;   res@gsnSpreadColorEnd    = 180
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 
res@gsnLeftStringOrthogonalPosF = 0.03
res@gsnRightStringOrthogonalPosF = 0.03

; contour <<<2
;
res@cnFillOn             = True               ; turn on color for contours
res@cnLinesOn            = False              ; turn off contour lines
;   res@cnLineThicknessF = 0.5
res@cnLineLabelsOn       = False              ; turn off contour line labels
res@cnInfoLabelOn        = False      ; turns off contour info label
;  symMinMaxPlt(cn, 50, False, res)
;res@cnLevelSelectionMode = "ManualLevels"
;res@cnMaxLevelValF       = 2.1               ; set max contour level
;res@cnMinLevelValF       = -2.1               ; set min contour level
;res@cnLevelSpacingF = 0.1
;res@cnFillMode = "RasterFill"

;  res@lbLabelBarOn = False
;  res@lbOrientation            = "Vertical"     ; vertical label bar
res@lbPerimOn                = False             ; no box around it
res@lbBoxLinesOn = False
;   res@lbBoxLinesOn = False
;    res@lbLabelStride            = 4

;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
;   res@pmLabelBarWidthF = 0.5
;   res@pmLabelBarHeightF = 0.05
res@pmLabelBarOrthogonalPosF = -0.01

res@tmXBMode = "Manual"
res@tmXBTickStartF   = 0
res@tmXBTickSpacingF = 100
res@tmXBTickEndF     = 800

res@tmXBLabelFontHeightF = fontSize
res@tmYLLabelFontHeightF = fontSize

res@trYReverse               = True   ; reverses y-axis
; }}}

resU = res
; upper resource{{{
resU@tiMainString      =   "PCOM"
resU@tiMainFontHeightF = 0.04
;  resU@tiXAxisString     =   ""
;  resU@gsnCenterString = "PCOM"
;  resU@gsnCenterStringOrthogonalPosF = 0.02

resU@tmXBLabelsOn  =   True
resU@tmXBOn        =   False
resU@tmYLMode          =   "Explicit"
resU@tmYLValues  =   (/0,500,1000,1500/)
resU@tmYLLabels  =   (/0,500,1000,1500/)
resU@tmYLMinorValues =   ispan(0,1500,500)

resU@vpHeightF       =   0.45
; cal. by cores axis
resU@vpWidthF        =   resU@vpHeightF * (3.6/2.6) * (4.4/3.65)
resU@vpYF            =   0.8
resU@vpXF            =   0.1

resU@lbLabelBarOn   = True
resU@lbOrientation = "Vertical"     ; vertical label bar

resU@trYMaxF = 1500
resU@trYMinF = 0
;}}}

plotU = gsn_csm_contour(wks, cn1, resU)

resB = res
; bottom resource{{{
resB@gsnCenterString=""

resB@tmYLMode         =   "Explicit"
resB@tmXTOn        =   True
resB@tmXTLabelsOn  =  False
resB@tmXBLabelsOn  =  True
resB@tmYLValues  =   (/1500, 3000, 4500, 6000/)
resB@tmYLLabels  =   resB@tmYLValues
;  resB@tmYLMinorValues  =   ispan(0,6000,200)

resB@vpHeightF     = resU@vpHeightF * (0.1/0.26)
resB@vpWidthF      = resU@vpWidthF
resB@vpYF          = resU@vpYF - resU@vpHeightF
resB@vpXF          = resU@vpXF

resB@lbLabelBarOn = False

resB@trYMaxF = 6000
resB@trYMinF = 1500
;}}}

plotB = gsn_csm_contour(wks, cn1, resB)
;  overlay(plotU, plotB)

draw(plotB)
draw(plotU)

;plot(0) = gsn_csm_contour(wks, cn1, res)

;res@gsnCenterString = "salinity"
;res@tiXAxisString = xTitle
;res@tiYAxisString = yTitle
;plot(1) = gsn_csm_contour(wks, cn2, res)
;draw(plot(1))

resP = True
resP@gsnDraw = False
resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
;resP@gsnPanelLabelBar = True
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 5
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStrings = (/"a)","b)"/)
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.6
resP@gsnPanelFigureStringsPerimOn = False
resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.7

resP@pmLabelBarWidthF = 0.7
resP@pmLabelBarHeightF = 0.05

resP@lbLabelFontHeightF = fontSize*0.6
resP@lbTitleFontHeightF = fontSize*0.6
resP@lbTitleString = cbTitle1
resP@lbBoxLinesOn = False

;gsn_panel(wks, plot, (/1,2/), resP)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
