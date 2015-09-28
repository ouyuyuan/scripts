
; Description: schematic of a region
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-28 15:30:01 BJT
; Last Change: 2014-11-15 16:37:47 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure draw_region(img, inres, arg)
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
  dum1 = gsn_add_polyline(wks, plot, \
  (/arg@lonL, arg@lonL, arg@lonR, arg@lonR, arg@lonL/) , \
  (/arg@latN, arg@latS, arg@latS, arg@latN, arg@latN/) ,pres)

  draw(plot)
  delete(wks)
  system("eps2png_trim " + img)
end


img = getenv("NCL_ARG_2")
arg = True
res = True

; nino 3.4
; Nino 3.4/ONI (5N-5S, 170W-120W) and Nino 4 (5N-5S, 160E-150W)
;====================
arg@latS = -5.0
arg@latN = 5.0
arg@lonL = 190.0
arg@lonR = 240.0
;res@mpProjection = "CylindricalEquidistant"
;res@mpGreatCircleLinesOn = False
draw_region(img, res, arg)
