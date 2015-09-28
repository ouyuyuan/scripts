
; Description: schematic of MPI subdomain-boxes
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
; Last Change: 2015-04

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

imgDir = "/home/ou/archive/drawing/sketch/"
img = imgDir + getenv("NCL_ARG_0_base")
wks = gsn_open_wks ("eps", img)

res = True
res@gsnDraw            = False        ; don't draw plot yet
res@gsnFrame           = False        ; don't advance frame yet
res@vpXF = 0.2

res@mpGridAndLimbOn = True
res@mpPerimOn = False
res@mpGridLineColor = "transparent"
res@mpLandFillColor = "gray60"
;  res@mpLandFillColor = "black"

;res@mpProjection = "Robinson"
res@mpProjection = "CylindricalEquidistant"
res@mpCenterLonF = 200
res@mpMinLatF = -80
res@mpMaxLatF = 80
;res@mpMinLonF = 120
;res@mpMaxLonF = 300
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
;txres@txJust = "TopLeft"

loncs = (/147,\
          360-85,\
          360-50,\
          5/)
latcs = (/35,-5,-60,-5/)
names = (/"1","2","3","4"/)
N = dimsizes(names)
dlon = 5
dlat = 5
do i = 0, N-1
  name = names(i)
  lonc = loncs(i)
  latc = latcs(i)

  lon = (/lonc - dlon, lonc - dlon/)
  lat = (/latc + dlat, latc - dlat/)
  dum1 = gsn_add_polyline(wks, plot, lon, lat, pres)
  lon = (/lonc - dlon, lonc + dlon/)
  lat = (/latc + dlat, latc + dlat/)
  dum2 = gsn_add_polyline(wks, plot, lon, lat, pres)
  lon = (/lonc + dlon, lonc + dlon/)
  lat = (/latc + dlat, latc - dlat/)
  dum3 = gsn_add_polyline(wks, plot, lon, lat, pres)
  lon = (/lonc - dlon, lonc + dlon/)
  lat = (/latc - dlat, latc - dlat/)
  dum4 = gsn_add_polyline(wks, plot, lon, lat, pres)

  text_id = gsn_add_text(wks, plot, name, lonc, latc, txres)
draw(plot)
end do

draw(plot)
delete(wks)
system("eps2png_trim " + img)
