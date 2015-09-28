
; Description: u different at 20m
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-07 07:41:43 BJT
; Last Change: 2014-08-18 10:17:15 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "/home/ou/archive/scripts/draw/utils/roms.ncl"
load "/home/ou/archive/scripts/draw/utils/ncl.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"  

begin
  final = False
;  final = True

;  cmap = "BlGrYeOrReVi200"
;  cmap = "NCL_default"
  cmap = "BlWhRe"
;  cmap = "hotres"
;  cmap = "precip_11lev"

  data_dir_std   = "/home/ou/archive/models/roms/roms_734/Apps/latte/out_std/"
  draw_dir   = "/home/ou/archive/drawing/roms/zxzq/"
  img        = draw_dir + "diff_u20m"
  fname_std = data_dir_std + "lattec_his_nof.nc"
  fname_test = getenv( "NCL_ARG_1" )

  wks = gsn_open_wks ("eps", img)
  gsn_define_colormap(wks, cmap)

  ; get data and variables 
  ;{{{

  dates = (/"2006-04-05 00:00:00",\
            "2006-04-06 00:00:00",\
            "2006-04-07 00:00:00",\
            "2006-04-08 00:00:00",\
            "2006-04-09 00:00:00",\
            "2006-04-10 00:00:00"/)

  f_std     = addfile (fname_std, "r")
  f_test     = addfile (fname_test, "r")
  lon2d = f_std->lon_rho
  lat2d = f_std->lat_rho
  time  = f_std->ocean_time

  var = "u"
  depth = -20

  a = f_std->temp(0,0,:,:)
  dims = dimsizes(a)
  cn_test = new( (/6,dims(0),dims(1)/), typeof(a) )
  cn_std = new( (/6,dims(0),dims(1)/), typeof(a) )
  cn = new( (/6,dims(0),dims(1)/), typeof(a) )
  delete(a)
  delete(dims)

  do i = 0, 5
    rec = ou_timestring2i( dates(i), time )
    cn_test(i,:,:) = roms_3d_interp( f_test, var, rec, depth )
    cn_std(i,:,:) = roms_3d_interp( f_std, var, rec, depth )
  end do
  cn = cn_test - cn_std

  add_2d( cn, lat2d, lon2d )
  delete(f_std)
  delete(f_test)

  minlat = min(lat2d) - 0.2
  maxlat = max(lat2d) - 0.0
  minlon = min(lon2d) + 0.2
  maxlon = max(lon2d) + 0.2

  mincn = min(cn(0,:,:))
  maxcn = max(cn(0,:,:))
  ;}}}

  res = True               ; plot mods desired
  ; subplot resource {{{
  res@gsnDraw              = False
  res@gsnFrame             = False
;  res@gsnMaximize          = True    ; Maximize plot in frame
;  res@gsnPaperOrientation  = "Portrait"
;  res@gsnScalarContour     = True               ; contours desired
  res@gsnLeftStringOrthogonalPosF = 0.03
  res@gsnRightStringOrthogonalPosF = 0.03
;  res@gsnMaximize           = True
  res@gsnSpreadColors       = True              ; use total colormap
;  res@gsnLeftString  = "u at 10m depth"
  res@gsnLeftString  = ""
  res@gsnRightString = ""
  if ( cmap .eq. "BlGrYeOrReVi200" )
    res@gsnSpreadColorEnd      = 180
  end if

  res@cnFillDrawOrder      = "PreDraw"
  res@cnFillOn             = True               ; turn on color for contours
  res@cnLinesOn            = False              ; turn off contour lines
  res@cnLineLabelsOn       = False              ; turn off contour line labels
;  res@cnFillMode           = "RasterFill"
;  res@cnLevelSelectionMode = "ManualLevels"     ; set manual contour levels
;  res@cnMinLevelValF       = doubletoint(mincn)
;  res@cnMaxLevelValF       = doubletoint(maxcn)
;  res@cnLevelSpacingF      = 0.5
  cnlevels = 15
;  mnmxint = nice_mnmxintvl( mincn, maxcn, cnlevels, False )
;  res@cnMinLevelValF       = mnmxint(0)
;  res@cnMaxLevelValF       = mnmxint(1)
;  res@cnLevelSpacingF      = mnmxint(2)
  symMinMaxPlt( cn, cnlevels, False, res ) 

  res@lbLabelBarOn = False
;  res@lbOrientation        = "Vertical"         ; Vertical label bar
;  res@lbPerimOn            = False              ; no box around it
;  res@lbBoxLinesOn         = True               ; Yes/No labelbar box lines.

  res@tmXTOn = False
  res@tmYROn = False

;  res@mpProjection = "Mercator"
  res@mpProjection        = "LambertConformal"
  res@mpGridAndLimbOn = True
  res@mpGridSpacingF = 1.0
  res@mpGridLineDashPattern = 14

  res@mpLambertParallel1F = minlat
  res@mpLambertParallel2F = maxlat
  res@mpLambertMeridianF  = ( minlon + maxlon ) * 0.5

  res@mpLimitMode         = "Corners"             ; choose range of map
  res@mpLeftCornerLatF    = minlat
  res@mpLeftCornerLonF    = minlon
  res@mpRightCornerLatF   = maxlat
  res@mpRightCornerLonF   = maxlon
;  res@mpDataBaseVersion      = "HighRes"          ; use high resolution coast
  res@mpDataBaseVersion      = "MediumRes"          ; use high resolution coast
;  res@mpLandFillColor      = "gray"             ; set land to be gray
;  res@mpLandFillColor      = -1 ; white

;  res@pmLabelBarOrthogonalPosF = -0.01          ; move label bar closer
;  res@pmLabelBarDisplayMode= "Always"           ; Turn on a label bar.
  res@pmTickMarkDisplayMode  = "Always"           ; turn on tickmarks
  ;}}}

  plot = new(6, graphic)

  do i = 0, 5
    res@tiMainString = dates(i)
    if ( i.eq.0 )
      res@tiMainString = dates(i) + " (initial)"
    end if
    plot(i) = gsn_csm_contour_map( wks, cn(i,:,:), res )
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
  resP@lbTitleString = "diffence (test - standard) of u at " + abs(depth) + " m (m/s)"
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
