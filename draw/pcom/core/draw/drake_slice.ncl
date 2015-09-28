
; Description: schematic of Drake strait slice on global map
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-04-10 16:41:49 BJT
; Last Change: 2014-07-16 19:01:37 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

;  final = False
  final = True

  draw_dir = "/home/ou/archive/drawing/pcom/core"
  img      = draw_dir + "/Drake_slice"

  wks = gsn_open_wks ("eps", img)

  npts = 10              ; arbitrary
  
  lat1 = -54.5
  lon1 = 292.5

  lat2 = -68.5
  lon2 = lon1
  
  res                    = True
  res@gsnDraw            = False        ; don't draw plot yet
  res@gsnFrame           = False        ; don't advance frame yet

  res@mpGridAndLimbOn = True
  res@mpPerimOn = False
  res@mpGridLineColor = "transparent"
  res@mpLandFillColor = "black"

;  res@mpProjection = "Robinson"
;  res@mpProjection = "LambertConformal"
  res@mpProjection = "Orthographic"
  res@mpCenterLonF = 204
  res@mpCenterLatF = -90
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

  if (final)
    frame(wks)
    delete(wks)
    system("eps2png_trim " + img)
  end if

end
