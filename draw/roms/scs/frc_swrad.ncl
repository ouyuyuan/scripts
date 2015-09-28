
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-09-08 09:25:16 BJT
; Last Change: 2014-09-20 10:45:16 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"  
load "/home/ou/archive/scripts/utils/ncl.ncl"

begin

;  final = False
  final = True
;  cmap = "testcmap"
  cmap = "BlGrYeOrReVi200"
;  cmap = "BlWhRe"
;  cmap = "NCL_default"

  data_dir   = "/home/ou/archive/models/roms/roms_734/Apps/scs/in/"
  img = "/home/ou/archive/drawing/roms/scs/" + getenv("NCL_ARG_0_base")
;  fname_grid = data_dir + "testgrid.nc"
  fname_grid = data_dir + "seagrid.nc"

  frc_name = "swrad"
  fname_frc = data_dir + "frc_" + frc_name + ".nc"

  dates = (/"2006-04-05 00:00:00",\
            "2006-04-07 00:00:00",\
            "2006-04-09 00:00:00",\
            "2006-04-11 00:00:00",\
            "2006-04-13 00:00:00",\
            "2006-04-15 00:00:00"/)
  ndates = dimsizes(dates)

  f = addfile( fname_grid, "r" )
  lat2d  = f->lat_rho
  lon2d  = f->lon_rho
  delete(f)

  delta = 1.0
  minlat = min(lat2d) - delta
  maxlat = max(lat2d) + delta
  minlon = min(lon2d) - delta
  maxlon = max(lon2d) + delta + 1.0

  f  = addfile ( fname_frc, "r" )
  frc = f->$frc_name$
  time = f->time
  delete(f)
  ou_add_2d( frc, lat2d, lon2d )

  mincn = min( frc )
  maxcn = max( frc )

  d = dimsizes(lat2d)
  nlat = d(0)
  nlon = d(1)
  delete(d)

  wks  = gsn_open_wks ("eps", img)
  gsn_define_colormap( wks, cmap )

  res                        = True               ; plot mods desired
  ; subplot resource{{{

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
;  res@cnFillDrawOrder        = "PreDraw"          ; put continents on top
;  res@cnFillDrawOrder        = "PostDraw"
  res@cnInfoLabelOn          = False              ; no contour info label

  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMaxLevelValF       = 300
  res@cnMinLevelValF       = 0
  res@cnLevelSpacingF = 10
;  cnlevels = 30
;  mnmxint = nice_mnmxintvl( mincn, maxcn, cnlevels, False )
;  res@cnMinLevelValF       = mnmxint(0)
;  res@cnMaxLevelValF       = mnmxint(1)
;  res@cnLevelSpacingF      = mnmxint(2)
;  symMinMaxPlt( frc, cnlevels, False, res ) 

  res@lbLabelBarOn = False

  res@mpProjection        = "LambertConformal"
;  res@mpGridAndLimbOn = True
  res@mpGridSpacingF = 5
  res@mpGridLineDashPattern = 2
;  res@mpGridLineDashPattern = 14
  res@mpGridLineThicknessF = 0.5

  res@mpOutlineBoundarySets   = "National"
  res@mpLandFillColor = "gray"

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

  plot = new(ndates, graphic)

  do i = 0, ndates - 1
    ti = ou_string2ti( dates(i), time )
    cn = frc(ti,:,:)
    res@tiMainString = dates(i)
    if ( i.eq.0 )
      res@tiMainString = res@tiMainString + " (initial)"
    end if
    plot(i) = gsn_csm_contour_map(wks, cn, res)     
  end do

  resP = True
  ; panel resource {{{
  resP@gsnFrame = False
  ;      resP@gsnPanelDebug = True
  resP@gsnPanelLabelBar = True
  resP@gsnPanelBottom = 0.05
  resP@gsnPanelXWhiteSpacePercent = 5
  resP@gsnPanelYWhiteSpacePercent = 10
  ;   resP@gsnPanelRowSpec = True

  resP@pmLabelBarWidthF = 0.7
  resP@pmLabelBarHeightF = 0.05

  resP@lbLabelFontHeightF = 0.013
  resP@lbLabelAutoStride = True
  resP@lbTitleString = "Atmospheric shortwave radiation forcing (W/m^2)"
  resP@lbTitleFontHeightF = 0.013
  ;   resP@lbBoxLinesOn = False
  ;   resP@lbLabelFontHeightF = 0.007

  ;   resP@txString = "Sea surface temperature"
  ;}}}

  gsn_panel(wks, plot, (/2,3/), resP)

  if (final)
    frame(wks)
    delete(wks)
    system("eps2png_trim " + img)
  end if
end
