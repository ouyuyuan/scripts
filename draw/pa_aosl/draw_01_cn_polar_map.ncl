
; Description: draw topography and grid of Southern Ocean, for AOSL paper
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-05 19:53:51 BJT
; Last Change: 2015-01-06 08:28:13 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir = getenv("NCL_ARG_1")
img = getenv("NCL_ARG_2")

function isImg(suffix)
;{{{
local is
begin
is = False
if isStrSubset(img, suffix) then
  is = True
end if
return is
end
;}}}

f = addfile("/home/ou/archive/data/pcom/basin/basin.nc","r")
basin = f->basin
delete(f)

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
f = addfile(datDir+"pcom_ini.nc", "r")
depth = f->depth
z = f->z
delete(f)
cn = depth

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; plot model 
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

cmap = "NCL_default"
;  cmap = "GMT_jet"
;  cmap = "WhiteBlueGreenYellowRed"
;cmap = "NCV_blu_red"

fontSize = 0.03
plotWid = 0.7
plotHei = 0.5
cbTitle = cn@units
cnMinMaxInc = (/0., 6400., 200./)
cnValues = floattoint(z)
;autoTicks = False
autoTicks = True
if isImg("___Sou_basin")
  autoTicks = False
end if

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks,cmap)
if (cmap .eq. "NCL_default")
  gsn_reverse_colormap(wks)
end if

res = True
; {{{
;res@vpWidthF = plotWid
res@vpHeightF = plotHei
;res@vpXF = -0.01
;  res@vpYF = 0.9

res@gsnDraw = False
res@gsnFrame = False
res@gsnStringFontHeightF = fontSize
res@gsnLeftString = ""
res@gsnRightString = ""
if ( cmap .eq. "NCL_default" )
  res@gsnSpreadColorStart  = 130
end if

res@gsnPolar = "SH"
res@gsnPolarLabelFontHeightF = fontSize*0.8

res@cnFillOn             = True               ; turn on color for contours
res@cnLinesOn            = False              ; turn off contour lines
;   res@cnLineThicknessF = 0.5
res@cnLineLabelsOn       = False              ; turn off contour line labels
res@cnInfoLabelOn        = False      ; turns off contour info label
if .not.autoTicks
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       = cnMinMaxInc(0)
  res@cnMaxLevelValF       = cnMinMaxInc(1)
  res@cnLevelSpacingF      = cnMinMaxInc(2)
;  res@cnLevelSelectionMode = "ExplicitLevels"
;  res@cnLevels = cnValues
end if
;res@cnMissingValFillColor = "gray60"
;   res@cnFillMode = "RasterFill"

;res@lbLabelBarOn = False
res@lbOrientation = "vertical"
res@lbTitleString = cbTitle
res@lbTitleFontHeightF = fontSize*0.8
res@lbBoxLinesOn = False
res@lbLabelFontHeightF = fontSize*0.8
res@lbLabelStride = 2
;res@lbTitlePosition = "Right"

res@pmLabelBarWidthF = 0.08
res@pmLabelBarHeightF = plotHei
res@pmLabelBarOrthogonalPosF = 0.2

res@mpGridAndLimbOn = True
res@mpPerimOn = False
res@mpGridLineColor = "transparent"
res@mpLandFillColor = "black"

res@mpMaxLatF = -20
;res@mpCenterLonF = 30
;res@mpCenterLatF = -90
res@mpGreatCircleLinesOn = True
;}}}

plot = gsn_csm_contour_map_polar(wks, cn, res)

;---Resources for the polyline
pres                  = True           ; polyline mods desired
pres@gsLineThicknessF = 6.0            ; line thickness   
pres@gsLineColor      = "red"         ; color of lines

; Pacific boundary
lon = fspan(150., 287., 100)
lat = lon
lat = -35
dum1 = gsn_add_polyline(wks, plot, lon , lat ,pres)
; Atlantic
delete(lon)
delete(lat)
lon = fspan(305., 360., 50)
lat = lon
lat = -35
dum2 = gsn_add_polyline(wks, plot, lon , lat ,pres)
;Indian ocean
delete(lon)
delete(lat)
lon = fspan(0., 115., 200)
lat = lon
lat = -35
dum3 = gsn_add_polyline(wks, plot, lon , lat ,pres)

draw(plot)
frame(wks)
delete(wks)
system("eps2png_trim "+img)
