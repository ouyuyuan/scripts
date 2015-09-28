
; Description: schematic of a slice
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-28 15:30:01 BJT
; Last Change: 2014-10-28 18:44:36 BJT

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

; a slice in meridional Pacific
;==============================
arg@lat1 = -60.
arg@lon1 = 360 - 150.5
arg@lat2 = 60.
arg@lon2 = arg@lon1

;draw_slice(img+"___pacific_lon", res, arg)

; a slice on Pacific equator
;===========================
arg@lat1 = 0.
arg@lon1 = 130.
arg@lat2 = 0.
arg@lon2 = 290.

;draw_slice(img+"___pacific_eq", res, arg)

; a slice on lat. 50S
;======================
arg@lat1 = -50.
arg@lon1 = 0.5
arg@lat2 = arg@lat1
arg@lon2 = 359.5

res@mpProjection = "CylindricalEquidistant"
res@mpGreatCircleLinesOn = False

draw_slice(img+"___50S", res, arg)

; lat. 25S
;===========
arg@lat1 = -25.
arg@lat2 = arg@lat1
draw_slice(img+"___25S", res, arg)

; lat. 5N
;===========
arg@lat1 = 5.
arg@lat2 = arg@lat1
draw_slice(img+"___5N", res, arg)

; lat. 15N
;===========
arg@lat1 = 15.
arg@lat2 = arg@lat1
draw_slice(img+"___15N", res, arg)

; lat. 45N
;===========
arg@lat1 = 45.
arg@lat2 = arg@lat1
draw_slice(img+"___45N", res, arg)

