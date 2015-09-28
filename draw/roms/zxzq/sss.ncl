
; Description: sea surface salinity
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-04 15:58:31 BJT
; Last Change: 2014-07-07 14:27:56 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"  
load "/home/ou/archive/scripts/draw/utils/ncl.ncl"

begin

;  final = False
  final = True
;  cmap = "testcmap"
  cmap = "BlGrYeOrReVi200"
;  cmap = "NCL_default"

  data_dir   = "/home/ou/archive/data/roms/latte"
  draw_dir   = "/home/ou/archive/drawing/roms/zxzq"
  img  = draw_dir + "/sss"
  fname_grid = data_dir + "/in/roms_latte_grid_4b.nc"
  fname_data = data_dir + "/TH/lattec_his_nof.nc"

  ; get data and variable {{{
  f = addfile( fname_grid, "r" )
  lat2d  = f->lat_rho
  lon2d  = f->lon_rho
  delete(f)

  minlat = min(lat2d) - 0.2
  maxlat = max(lat2d) - 0.0
  minlon = min(lon2d) + 0.2
  maxlon = max(lon2d) + 0.2

  f  = addfile ( fname_data, "r" )
  sss = f->salt(:,0,:,:)
  tunits = f->ocean_time@units
  delete(f)

  sss@lat2d = lat2d
  sss@lon2d = lon2d

  mincn = min(sss(0,:,:))
  maxcn = max(sss(0,:,:))
  ;}}}

  wks  = gsn_open_wks ("eps", img)
  gsn_define_colormap( wks, cmap )

  res                        = True               ; plot mods desired
  ; subplot resource {{{
  res@gsnDraw = False
  res@gsnFrame = False
  res@gsnLeftString = ""
  res@gsnRightString = ""
  if ( cmap .eq. "BlGrYeOrReVi200" )
    res@gsnSpreadColorEnd      = 180
  end if
  res@gsnLeftStringOrthogonalPosF = 0.03
  res@gsnRightStringOrthogonalPosF = 0.03

  res@cnFillOn               = True               ; color fill  
  res@cnLinesOn              = False              ; no contour lines
  res@cnLineLabelsOn         = False              ; no contour labels
  res@cnFillDrawOrder        = "PreDraw"          ; put continents on top
  res@cnInfoLabelOn          = False              ; no contour info label

  res@cnLevelSelectionMode = "ManualLevels"
;  res@cnMaxLevelValF       = doubletoint(maxcn)
;  res@cnMinLevelValF       = doubletoint( maxcn * 0.9 )
;  res@cnLevelSpacingF = 0.2
  cnlevels = 15
;  mnmxint = nice_mnmxintvl( mincn, maxcn, cnlevels, False )
  mnmxint = nice_mnmxintvl( maxcn*0.9, maxcn, cnlevels, False )
  res@cnMinLevelValF       = mnmxint(0)
  res@cnMaxLevelValF       = mnmxint(1)
  res@cnLevelSpacingF      = mnmxint(2)

  res@lbLabelBarOn = False

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
  ;}}}

  plot = new(6, graphic)

  dates = (/"2006-04-05 00:00:00",\
            "2006-04-07 00:00:00",\
            "2006-04-09 00:00:00",\
            "2006-04-11 00:00:00",\
            "2006-04-13 00:00:00",\
            "2006-04-15 00:00:00"/)

  do i = 0, 5
    t = ou_string2time( dates(i), tunits )
    cn = sss({t},:,:)
    res@tiMainString = dates(i)
    if ( i.eq.0 )
      res@tiMainString = dates(i) + " (initial)"
    end if
    plot(i) = gsn_csm_contour_map(wks, cn, res)     
  end do

  resP = True
  ;panel resource {{{
  resP@gsnFrame = False
  ;      resP@gsnPanelDebug = True
  resP@gsnPanelLabelBar = True
  ;      resP@gsnPanelBottom = 0.05
  resP@gsnPanelXWhiteSpacePercent = 5
  resP@gsnPanelYWhiteSpacePercent = 10
  ;   resP@gsnPanelRowSpec = True

  resP@pmLabelBarWidthF = 0.7
  resP@pmLabelBarHeightF = 0.05

  resP@lbLabelFontHeightF = 0.013
  resP@lbLabelAutoStride = True
  resP@lbTitleString = "sea surface salinity ( PSU )"
  resP@lbTitleFontHeightF = 0.013
  ;   resP@lbBoxLinesOn = False
  ;   resP@lbLabelFontHeightF = 0.007

  ;   resP@txString = "Sea surface salinity"
  ;}}}

  gsn_panel(wks, plot, (/2,3/), resP)

  if (final)
    frame(wks)
    delete(wks)
    system("eps2png_trim " + img)
  end if
end
