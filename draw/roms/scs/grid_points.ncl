
; Description: schematic of grid points of model domain
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-08-19 08:58:20 BJT
; Last Change: 2014-08-23 21:47:23 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"  
load "/home/ou/archive/scripts/draw/utils/roms.ncl"
;load "/home/ou/archive/scripts/draw/utils/ncl.ncl"

begin

;  final = False
  final = True

  nc = "/home/ou/archive/models/roms/roms_734/Apps/scs/in/seagrid.nc"
  img = "/home/ou/archive/drawing/roms/scs/" + getenv("NCL_ARG_0_base")

  ; get data and variable {{{
  f = addfile( nc, "r" )
  lat2d = f->lat_rho
  lon2d = f->lon_rho
  delete(f)

  delta = 1.0
  minlat = min(lat2d) - delta
  maxlat = max(lat2d) + delta
  minlon = min(lon2d) - delta
  maxlon = max(lon2d) + delta + 1.0

  ;}}}

  wks  = gsn_open_wks ("eps", img)

  res                        = True               ; plot mods desired
  ; subplot resource {{{

  res@gsnDraw = False
  res@gsnFrame = False
  res@gsnLeftString = ""
  res@gsnRightString = ""

  res@mpProjection        = "LambertConformal"
;  res@mpGridAndLimbOn = True
  res@mpGridSpacingF = 5
  res@mpGridLineDashPattern = 2
;  res@mpGridLineDashPattern = 14
  res@mpGridLineThicknessF = 0.5

  res@mpOutlineBoundarySets   = "National"
  res@mpLandFillColor = "black"

  res@mpLambertParallel1F = 0
  res@mpLambertParallel2F = 40
  res@mpLambertMeridianF  = 115

  ; to check whether the data has the correct map data
;  res@mpFillOn               = False            

  res@mpLimitMode         = "Corners"             ; choose range of map
  res@mpLeftCornerLatF    = minlat
  res@mpLeftCornerLonF    = minlon
  res@mpRightCornerLatF   = maxlat
  res@mpRightCornerLonF   = maxlon

;  res@mpOutlineDrawOrder     = "PostDraw"  ; draw continental outline last
;  res@mpOutlineDrawOrder     = "PreDraw"
;  res@mpFillDrawOrder        = "PreDraw"
;  res@mpFillDrawOrder        = "PostDraw"
  res@mpDataBaseVersion      = "HighRes"          ; use high resolution coast
;  res@mpDataBaseVersion      = "MediumRes"
;  res@mpDataBaseVersion      = "LowRes"

  res@tmXTOn = False
  res@tmYROn = False

  res@pmTickMarkDisplayMode  = "Always"           ; turn on tickmarks
  ;}}}

  plot = gsn_csm_map(wks, res)     

  mres = True
  ; {{{ polymaker resource
  mres@gsMarkerThicknessF = 0.1
  mres@gsMarkerIndex    = 16          ; Filled dots
  mres@gsMarkerSizeF    = 0.003
  mres@gsMarkerColor    = "green"

;---Make markers partly transparent (1.0 is fully opaque)
  mres@gsMarkerOpacityF = 0.70
  ;}}}

  stride = 1
  dum = gsn_add_polymarker(wks, plot, lon2d(::stride,::stride), \
  lat2d(::stride,::stride), mres)
  mres@gsMarkerSizeF    = 0.003
  dims = dimsizes(lat2d)
  dum1 = gsn_add_polymarker(wks, plot, lon2d(:,0), lat2d(:,0), mres)
  dum2 = gsn_add_polymarker(wks, plot, lon2d(0,:), lat2d(0,:), mres)
  k = dims(1) - 1
  dum3 = gsn_add_polymarker(wks, plot, lon2d(:,k), lat2d(:,k), mres)
  k = dims(0) - 1
  dum4 = gsn_add_polymarker(wks, plot, lon2d(k,:), lat2d(k,:), mres)

;---Resources for the polyline
;  pres                  = True           ; polyline mods desired
;  pres@gsLineThicknessF = 2.5            ; line thickness   
;  pres@gsLineColor      = "white"         ; color of lines
;  dum2 = gsn_add_polyline(wks, plot, lon, lat, pres)

  draw(plot)
  frame(wks)

  if (final)
    delete(wks)
    system("eps2png_trim " + img)
  end if
end
