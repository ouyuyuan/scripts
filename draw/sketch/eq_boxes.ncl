
; Description: schematic of a slice
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-28 15:30:01 BJT
; Last Change: 2015-01-25 20:10:18 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

imgDir = "/home/ou/archive/drawing/sketch/"
img = imgDir + getenv("NCL_ARG_0_base")
wks = gsn_open_wks ("eps", img)

res = True
res@gsnDraw            = False        ; don't draw plot yet
res@gsnFrame           = False        ; don't advance frame yet

res@mpGridAndLimbOn = True
res@mpPerimOn = False
res@mpGridLineColor = "transparent"
res@mpLandFillColor = "gray60"
;  res@mpLandFillColor = "black"

;res@mpProjection = "Robinson"
res@mpProjection = "CylindricalEquidistant"
res@mpCenterLonF = 180
res@mpMinLatF = -80
res@mpMaxLatF = 80
res@mpMinLonF = 120
res@mpMaxLonF = 300
res@mpGreatCircleLinesOn = True

res@tmXBLabelStride = 2
res@mpGreatCircleLinesOn = False

;---Create the map, but it won't be drawn yet.
plot = gsn_csm_map(wks,res)  

;---Resources for the polyline
pres                  = True           ; polyline mods desired
pres@gsLineThicknessF = 6.0            ; line thickness   
pres@gsLineColor      = "red"         ; color of lines

txres               = True
txres@txFontHeightF = 0.02

loncs = (/360-145,\
          360-125,\
          360-105,\
          360-85/)
latcs = (/0,0,0,0/)
names = (/"1","2","3","4"/)
N = dimsizes(names)
do i = 0, N-1
  name = names(i)
  lonc = loncs(i)
  latc = latcs(i)

  lon = (/lonc - 5, lonc - 5/)
  lat = (/latc + 5, latc - 5/)
  dum1 = gsn_add_polyline(wks, plot, lon, lat, pres)
  lon = (/lonc - 5, lonc + 5/)
  lat = (/latc + 5, latc + 5/)
  dum2 = gsn_add_polyline(wks, plot, lon, lat, pres)
  lon = (/lonc + 5, lonc + 5/)
  lat = (/latc + 5, latc - 5/)
  dum3 = gsn_add_polyline(wks, plot, lon, lat, pres)
  lon = (/lonc - 5, lonc + 5/)
  lat = (/latc - 5, latc - 5/)
  dum4 = gsn_add_polyline(wks, plot, lon, lat, pres)

  text_id = gsn_add_text(wks, plot, name, lonc, latc, txres)
draw(plot)
end do

draw(plot)
delete(wks)
system("eps2png_trim " + img)
