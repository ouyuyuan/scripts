
; Description: 2 subplots, each is a depth-year contour plot
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2015-09-09 09:34:04 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

datDir = "/home/ou/archive/data/pcom/exp_spinup/post/"
img    = "/home/ou/archive/drawing/pb_qhhj/" + getenv("NCL_ARG_0_base")

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
yLabelSize = fontSize*0.6
xLabelSize = fontSize*0.6
plotWid = 0.7
plotHei = 0.4
yTitle = "depth (meter)"
xTitle = "model year"
cbTitle1 = cn1@units
cbTitle2 = cn2@units
cn1MinMaxInc = (/-3.5, 3.5, 0.5/)
cn2MinMaxInc = (/-0.7, 0.7, 0.1/)
autoTicks = False
;autoTicks = True

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks,cmap)

res = True
; {{{
;res@vpWidthF = plotWid
;res@vpHeightF = plotHei
;  res@vpXF = 0.2
;  res@vpYF = 0.9

res@tiXAxisFontHeightF = fontSize*0.8
;res@tiXAxisString = xTitle
;res@tiYAxisString = yTitle

res@gsnDraw = False
res@gsnFrame = False
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
res@gsnStringFontHeightF = fontSize*0.8
res@gsnCenterStringOrthogonalPosF = 0.03
res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 

;res@tmXTOn = False
;res@tmYROn = False
res@tmYLMinorOn = False
res@tmYRMinorOn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmYRLabelFontHeightF = yLabelSize 
res@tmXBLabelFontHeightF = xLabelSize
res@tmXBMode = "Manual"
res@tmXBTickStartF   = 0
res@tmXBTickSpacingF = 100
res@tmXBTickEndF     = 800

res@cnFillOn             = True               ; turn on color for contours
res@cnLinesOn            = False              ; turn off contour lines
;   res@cnLineThicknessF = 0.5
res@cnLineLabelsOn       = False              ; turn off contour line labels
res@cnInfoLabelOn        = False      ; turns off contour info label
res@cnMissingValFillColor = "gray60"
;   res@cnFillMode = "RasterFill"

res@trYReverse               = True   ; reverses y-axis
;}}}

resU = res
; upper resource{{{

resU@tmXBLabelsOn  =   True
resU@tmXBOn        =   True
resU@tmYLMode          =   "Explicit"
resU@tmYLValues  =   (/0, 250, 500, 750, 1000, 1250, 1500/)
resU@tmYLLabels  =   resU@tmYLValues
;resU@tmYLMinorValues =   ispan(0,1500,500)

resU@vpHeightF       =   0.2
resU@vpWidthF        =   0.8
resU@vpYF            =   0.8
resU@vpXF            =   0.1

resU@lbLabelBarOn   = True
resU@lbOrientation = "Vertical"     ; vertical label bar
resU@lbBoxLinesOn = False
;resU@lbTitlePosition = "Right"
resU@lbTitleFontHeightF = fontSize*0.8
resU@lbLabelFontHeightF = fontSize*0.7

resU@pmLabelBarOrthogonalPosF = 0.01
resU@pmLabelBarWidthF = 0.1
resU@pmLabelBarHeightF = 0.3


resU@trYMaxF = 1500
resU@trYMinF = 0
;}}}

resB = res
; bottom resource{{{
resB@vpHeightF     = resU@vpHeightF * (0.1/0.26)
resB@vpWidthF      = resU@vpWidthF
resB@vpYF          = resU@vpYF - resU@vpHeightF
resB@vpXF          = resU@vpXF

resB@gsnCenterString=""

resB@tmYLMode         =   "Explicit"
resB@tmXTOn        =   True
resB@tmXTLabelsOn  =  False
resB@tmXBLabelsOn  =  True
resB@tmYLValues  =   (/3000, 4000, 5000/)
resB@tmYLLabels  =   resB@tmYLValues
;  resB@tmYLMinorValues  =   ispan(0,6000,200)

resB@lbLabelBarOn = False

resB@trYMaxF = 5000
resB@trYMinF = 1500
;}}}

plot = new(2, graphic)

if .not.autoTicks
  resU@cnLevelSelectionMode = "ManualLevels"
  resU@cnMinLevelValF       = cn1MinMaxInc(0)
  resU@cnMaxLevelValF       = cn1MinMaxInc(1)
  resU@cnLevelSpacingF      = cn1MinMaxInc(2)
  resB@cnLevelSelectionMode = "ManualLevels"
  resB@cnMinLevelValF       = cn1MinMaxInc(0)
  resB@cnMaxLevelValF       = cn1MinMaxInc(1)
  resB@cnLevelSpacingF      = cn1MinMaxInc(2)
end if

resU@gsnCenterString = "temperature"
resU@tiXAxisString = ""
resU@tiYAxisString = yTitle
resU@lbTitleString = cbTitle1
plot(0) = gsn_csm_contour(wks, cn1, resU)
;draw(plot(0))
;plot(0) = gsn_csm_contour(wks, cn1, resB)
resB@tiXAxisString = ""
plotB = gsn_csm_contour(wks, cn1, resB)

resAtt1 = True
resAtt1@gsnAttachPlotsXAxis = True
resAtt2 = True

attachid = gsn_attach_plots(plot(0), plotB, resAtt1, resAtt2)

if .not.autoTicks
  resU@cnLevelSelectionMode = "ManualLevels"
  resU@cnMinLevelValF       = cn2MinMaxInc(0)
  resU@cnMaxLevelValF       = cn2MinMaxInc(1)
  resU@cnLevelSpacingF      = cn2MinMaxInc(2)
  resB@cnLevelSelectionMode = "ManualLevels"
  resB@cnMinLevelValF       = cn2MinMaxInc(0)
  resB@cnMaxLevelValF       = cn2MinMaxInc(1)
  resB@cnLevelSpacingF      = cn2MinMaxInc(2)
end if

resU@gsnCenterString = "salinity"
resU@lbTitleString = cbTitle2
plot(1) = gsn_csm_contour(wks, cn2, resU)
resB@tiXAxisString = xTitle
resB@tiYAxisString = ""
plotB2 = gsn_csm_contour(wks, cn2, resB)

attachid2 = gsn_attach_plots(plot(1), plotB2, resAtt1, resAtt2)

resP = True
;resP@gsnDraw = False
resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
;resP@gsnPanelLabelBar = True
resP@gsnPanelYWhiteSpacePercent = 5
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStrings = (/"a)","b)"/)
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.8
resP@gsnPanelFigureStringsPerimOn = False
resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.8

gsn_panel(wks, plot, (/1,1/), resP)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
