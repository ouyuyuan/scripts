
; Description: schematic of a Pacific meridional slice on global map
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-26 07:12:23 BJT
; Last Change: 2014-10-26 07:20:29 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

  img = getenv("NCL_ARG_2")

  wks = gsn_open_wks ("eps", img)

  lat1 = -60.
  lon1 = 360 - 150.5
  lat2 = 60.
  lon2 = lon1
  
  res                    = True
  res@gsnDraw            = False        ; don't draw plot yet
  res@gsnFrame           = False        ; don't advance frame yet

  res@mpGridAndLimbOn = True
  res@mpPerimOn = False
  res@mpGridLineColor = "transparent"
  res@mpLandFillColor = "black"

  res@mpProjection = "Robinson"
;  res@mpProjection = "LambertConformal"
;  res@mpProjection = "Orthographic"
  res@mpCenterLonF = 180
  res@mpGreatCircleLinesOn = True

;---Create the map, but it won't be drawn yet.
  plot = gsn_csm_map(wks,res)  

;---Resources for the polyline
  pres                  = True           ; polyline mods desired
  pres@gsLineThicknessF = 6.0            ; line thickness   
  pres@gsLineColor      = "red"         ; color of lines

;---Attach the polyline
  dum1 = gsn_add_polyline(wks, plot, (/lon1, lon2/) , (/lat1, lat2/) ,pres)

  draw(plot)

end
