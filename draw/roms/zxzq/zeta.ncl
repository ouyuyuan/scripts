
; Description: sea surface height
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-04 15:58:31 BJT
; Last Change: 2014-07-04 19:10:06 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
begin

  data_dir   = "/home/ou/archive/data/roms/latte"
  draw_dir   = "/home/ou/archive/drawing/roms/zxzq"
  fname_fig  = draw_dir + "/zeta"
  fname_grid = data_dir + "/in/roms_latte_grid_4b.nc"
  fname_data = data_dir + "/TH/lattec_his_nof.nc"

  f = addfile( fname_grid, "r" )
  lat2d  = f->lat_rho
  lon2d  = f->lon_rho
  delete(f)

  minlat = min(lat2d) - 0.2
  maxlat = max(lat2d) - 0.0
  minlon = min(lon2d) + 0.2
  maxlon = max(lon2d) + 0.2

  f  = addfile ( fname_data, "r" )
  cn = f->zeta(0,:,:)
  delete(f)

  cn@lat2d = lat2d
  cn@lon2d = lon2d

  d = dimsizes(lat2d)
  nlat = d(0)
  nlon = d(1)
  delete(d)

  wks  = gsn_open_wks ("png", fname_fig)
  gsn_define_colormap (wks,"testcmap")

                                          
  res                        = True               ; plot mods desired
  res@cnFillOn               = True               ; color fill  
  res@cnLinesOn              = False              ; no contour lines
  res@cnLineLabelsOn         = False              ; no contour labels
;  res@cnFillDrawOrder        = "PreDraw"          ; put continents on top
;  res@cnFillDrawOrder        = "PostDraw"
  res@gsnSpreadColorEnd      = -2                 ; don't use last color
  res@cnInfoLabelOn          = False              ; no contour info label

  ; The following resources are REQUIRED to properly display
  ; data zoomed on a lambert conformal grid.  

  res@mpProjection        = "LambertConformal"
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
  res@pmTickMarkDisplayMode  = "Always"           ; turn on tickmarks

  plot = gsn_csm_contour_map(wks, cn, res)     

end
