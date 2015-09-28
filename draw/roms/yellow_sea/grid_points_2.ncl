
; Description: schematic of grid points of model domain
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-08-19 08:58:20 BJT
; Last Change: 2014-08-20 19:33:01 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"  
load "/home/ou/archive/scripts/draw/utils/roms.ncl"
;load "/home/ou/archive/scripts/draw/utils/ncl.ncl"

begin

  final = False
;  final = True
;  cmap = "testcmap"
;  cmap = "BlGrYeOrReVi200"
  cmap = "NCL_default"

  nc = "/home/ou/archive/models/roms/roms_734/Apps/yellow_sea/in/yellow_sea_grid.nc"
  img = "/home/ou/archive/drawing/roms/yellow_sea/" + getenv("NCL_ARG_0_base")

  ; get data and variable {{{
  f = addfile( nc, "r" )
  cn = f->h
  lat2d = f->lat_rho
  lon2d = f->lon_rho
  delete(f)

  add_2d( cn, lat2d, lon2d )

; for domain boundary line
;  dims = dimsizes(lat2d)
;  lat_ul = lat2d(dims(0)-1,0) ; wrf upper left lat
;  lat_ll = lat2d(0,0)         ; wrf lower left lat
;  lat_ur = lat2d(dims(0)-1,dims(1)-1)
;  lat_lr = lat2d(0,dims(1)-1)
;  lon_ul = lon2d(dims(0)-1,0) ; wrf upper left lon
;  lon_ll = lon2d(0,0)         ; wrf lower left lon
;  lon_ur = lon2d(dims(0)-1,dims(1)-1)
;  lon_lr = lon2d(0,dims(1)-1)
;  lat = (/lat_ul, lat_ll, lat_lr, lat_ur, lat_ul/)
;  lon = (/lon_ul, lon_ll, lon_lr, lon_ur, lon_ul/)

  delta = 1.0
  minlat = min(lat2d) - delta
  maxlat = max(lat2d) + delta
  minlon = min(lon2d) - delta
  maxlon = max(lon2d) + delta + 1.0

  mincn = min(cn)
  maxcn = max(cn)
  ;}}}


  wks  = gsn_open_wks ("eps", img)
  gsn_define_colormap( wks, cmap )
  if (cmap .eq. "NCL_default")
    gsn_reverse_colormap(wks)
  end if

  res                        = True               ; plot mods desired
  ; subplot resource {{{
  res@gsnDraw = False
  res@gsnFrame = False
  res@gsnLeftString = ""
  res@gsnRightString = ""
  if ( cmap .eq. "BlGrYeOrReVi200" )
;    res@gsnSpreadColorEnd      = 180
  end if
  if ( cmap .eq. "NCL_default" )
    res@gsnSpreadColorStart  = 130
  end if
  res@gsnLeftStringOrthogonalPosF = 0.03
  res@gsnRightStringOrthogonalPosF = 0.03

;  res@vpXF = 0.3

  res@cnFillOn               = True               ; color fill  
  res@cnLinesOn              = False              ; no contour lines
  res@cnLineLabelsOn         = False              ; no contour labels
  res@cnFillDrawOrder        = "PreDraw"          ; put continents on top
  res@cnInfoLabelOn          = False              ; no contour info label
  if (final) 
    res@cnFillMode = "RasterFill" ; take more time than default fill
  end if

  res@cnLevelSelectionMode = "ManualLevels"
;  res@cnMaxLevelValF       = doubletoint(maxcn)
;  res@cnMinLevelValF       = doubletoint( maxcn * 0.9 )
;  res@cnLevelSpacingF = 0.2
  cnlevels = 100
  mnmxint = nice_mnmxintvl( mincn, maxcn, cnlevels, False )
;  mnmxint = nice_mnmxintvl( maxcn*0.9, maxcn, cnlevels, False )
  res@cnMinLevelValF       = mnmxint(0)
  res@cnMaxLevelValF       = mnmxint(1)
  res@cnLevelSpacingF      = mnmxint(2)

;  res@lbLabelBarOn = False
  res@lbTitleString = "application bathymetry (m)"
;  res@lbOrientation = "Vertical"
  res@lbTitleFontHeightF = 0.017
  res@lbTitleOffsetF = -0.2
  res@lbBoxLinesOn = False
  res@lbLabelStride = 10

  ; The following resources are REQUIRED to properly display
  ; data zoomed on a lambert conformal grid.  

;  res@mpProjection        = "LambertConformal"
  if ( isatt(res,"mpProjection") .and. res@mpProjection .eq. "LambertConformal" ) then
    res@mpLambertParallel1F = minlat
    res@mpLambertParallel2F = maxlat
    res@mpLambertMeridianF  = ( minlon + maxlon ) * 0.5
    res@mpLimitMode         = "Corners"             ; choose range of map
    res@mpLeftCornerLatF    = minlat
    res@mpLeftCornerLonF    = minlon
    res@mpRightCornerLatF   = maxlat
    res@mpRightCornerLonF   = maxlon
  else
    res@mpMinLatF = minlat
    res@mpMaxLatF = maxlat
    res@mpMinLonF = minlon
    res@mpMaxLonF = maxlon
  end if

  res@mpGridAndLimbOn = True
  res@mpGridSpacingF = 2.0
;  res@mpGridLineDashPattern = 2
  res@mpGridLineDashPattern = 14

  ; to check whether the data has the correct map data
;  res@mpFillOn               = False            

;  res@mpOutlineDrawOrder     = "PostDraw"  ; draw continental outline last
;  res@mpOutlineDrawOrder     = "PreDraw"
;  res@mpFillDrawOrder        = "PreDraw"
;  res@mpFillDrawOrder        = "PostDraw"
;  res@mpDataBaseVersion      = "HighRes"          ; use high resolution coast
  res@mpDataBaseVersion      = "MediumRes"

  res@tmXTOn = False
  res@tmYROn = False

  res@pmTickMarkDisplayMode  = "Always"           ; turn on tickmarks
  res@pmLabelBarOrthogonalPosF = 0.1
  ;}}}

;  res@tiMainString = "Application bathymetry (m)"
  plot = gsn_csm_contour_map(wks, cn, res)     

  mres = True
  ; {{{ polymaker resource
  mres@gsMarkerThicknessF = 0.1
  mres@gsMarkerIndex    = 16          ; Filled dots
  mres@gsMarkerSizeF    = 0.01
  mres@gsMarkerColor    = "red"

;---Make markers partly transparent (1.0 is fully opaque)
  mres@gsMarkerOpacityF = 0.70
  ;}}}

  stride = 10
  dum = gsn_add_polymarker(wks, plot, lon2d(::stride,::stride), \
  lat2d(::stride,::stride), mres)
  mres@gsMarkerSizeF    = 0.005
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
