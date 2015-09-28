
; Description: schematic of a slice
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-28 15:30:01 BJT
; Last Change: 2014-11-09 18:39:11 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure draw_slice(img, inres, arg)
begin

  wks = gsn_open_wks ("eps", img)

  res = True
  res@gsnDraw            = False        ; don't draw plot yet
  res@gsnFrame           = False        ; don't advance frame yet

  res@mpGridAndLimbOn = True
  res@mpPerimOn = False
  res@mpGridLineColor = "transparent"
  res@mpLandFillColor = "gray60"

  res@mpProjection = "Robinson"
  res@mpCenterLonF = 180
  res@mpGreatCircleLinesOn = True

  copy_VarAtts(inres, res)

;---Create the map, but it won't be drawn yet.
  plot = gsn_csm_map(wks,res)  

;---Resources for the polyline
  pres                  = True           ; polyline mods desired
  pres@gsLineThicknessF = 6.0            ; line thickness   
  pres@gsLineColor      = "red"         ; color of lines

;---Attach the polyline
  dum1 = gsn_add_polyline(wks, plot, (/arg@lon1, arg@lon2/) , \
  (/arg@lat1, arg@lat2/) ,pres)

  draw(plot)
  delete(wks)
  system("eps2png_trim " + img)
end


img = getenv("NCL_ARG_2")
arg = True
res = True

; a slice on Equator
;====================
arg@lat1 = -0.
arg@lon1 = 0.5
arg@lat2 = arg@lat1
arg@lon2 = 359.5
res@mpProjection = "CylindricalEquidistant"
res@mpGreatCircleLinesOn = False
;draw_slice(img, res, arg)

; a slice in meridional Pacific
;==============================
arg@lat1 = -60.
arg@lon1 = 360 - 150.5
arg@lat2 = 60.
arg@lon2 = arg@lon1
res@mpProjection = "Robinson"
res@mpCenterLonF = arg@lon1
;draw_slice(img+"___lon_pacific", res, arg)

; a slice in meridional Atlantic
;==============================
arg@lat1 = -60.
arg@lon1 = 360 - 25.5
arg@lat2 = 60.
arg@lon2 = arg@lon1
res@mpProjection = "Robinson"
res@mpCenterLonF = arg@lon1
;draw_slice(img+"___lon_Atlantic", res, arg)

; a slice in meridional Indian
;==============================
arg@lat1 = -60.
arg@lon1 = 65.5
arg@lat2 = 25.
arg@lon2 = arg@lon1
res@mpProjection = "Robinson"
res@mpCenterLonF = arg@lon1
draw_slice(img+"___lon_Indian", res, arg)

