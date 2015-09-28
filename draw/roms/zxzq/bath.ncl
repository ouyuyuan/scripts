
; Description: bathymetry at RHO-points
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-04 15:58:31 BJT
; Last Change: 2014-07-08 17:17:48 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"  
load "/home/ou/archive/scripts/draw/utils/roms.ncl"
;load "/home/ou/archive/scripts/draw/utils/ncl.ncl"

begin

;  final = False
  final = True
;  cmap = "testcmap"
;  cmap = "BlGrYeOrReVi200"
  cmap = "NCL_default"

  data_dir   = "/home/ou/archive/data/roms/latte"
  draw_dir   = "/home/ou/archive/drawing/roms/zxzq"
  img  = draw_dir + "/bath"
  fname_data = data_dir + "/TH/lattec_his_nof.nc"

  ; get data and variable {{{
  f = addfile( fname_data, "r" )
  h = f->h(:,:)
  lat2d = f->lat_rho
  lon2d = f->lon_rho
  delete(f)

  add_2d( h, lat2d, lon2d )

  minlat = min(lat2d) - 0.2
  maxlat = max(lat2d) - 0.0
  minlon = min(lon2d) + 0.2
  maxlon = max(lon2d) + 0.2

  mincn = min(h)
  maxcn = max(h)
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

  res@mpProjection        = "LambertConformal"
  res@mpGridAndLimbOn = True
  res@mpGridSpacingF = 1.0
;  res@mpGridLineDashPattern = 2
  res@mpGridLineDashPattern = 14

  res@mpLambertParallel1F = minlat
  res@mpLambertParallel2F = maxlat
  res@mpLambertMeridianF  = ( minlon + maxlon ) * 0.5

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

  res@tmXTOn = False
  res@tmYROn = False

  res@pmTickMarkDisplayMode  = "Always"           ; turn on tickmarks
  res@pmLabelBarOrthogonalPosF = 0.02
  ;}}}

;  res@tiMainString = "Application bathymetry (m)"
  plot = gsn_csm_contour_map(wks, h, res)     

  draw(plot)
  frame(wks)

  if (final)
    delete(wks)
    system("eps2png_trim " + img)
  end if
end
