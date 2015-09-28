
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-08-08 08:11:54 BJT
; Last Change: 2014-08-08 19:16:58 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"
load "/home/ou/archive/scripts/draw/utils/ncl.ncl"

begin

  final = False
;  final = True
;  cmap = "testcmap"
  cmap = "BlGrYeOrReVi200"
;  cmap = "NCL_default"

  frc = "Lwrf"
  cfsr_name = "radflx"
  file_cfsr = "sea_2006_01hr_TaqaQrQp_box.nc"

  data_dir   = "/home/ou/archive/data/roms/latte/in/"
  draw_dir   = "/home/ou/archive/drawing/roms/zxzq/"
  img  = draw_dir + "Lwrf_24hrs_old"
  fname_grid = data_dir + "roms_latte_grid_4b.nc"
  fname_frc_old = data_dir + "frc_latte_wrf_" + frc +".nc"
  fname_frc_new = data_dir + "frc_cfsr_" + frc + ".nc"
  fname_cfsr = "/home/ou/archive/data/roms/latte/cfsr/" + file_cfsr

  dates = (/"2006-04-05 00:00:00",\
            "2006-04-05 01:00:00",\
            "2006-04-10 00:00:00"/)

  f = addfile( fname_grid, "r" )
  lat2d  = f->lat_rho
  lon2d  = f->lon_rho
  delete(f)

  minlat = min(lat2d) - 0.2
  maxlat = max(lat2d) - 0.0
  minlon = min(lon2d) + 0.2
  maxlon = max(lon2d) + 0.2

  f  = addfile ( fname_frc_old, "r" )
  frc_old = f->$frc$(:,:,:)
  time_old = f->ncep_time
  delete(f)
  time_old@units = "days since 2006-01-01 00:00:00"

  frc_old@lat2d = lat2d
  frc_old@lon2d = lon2d

  frc_units = frc_old@units

  f  = addfile ( fname_frc_new, "r" )
  frc_new = f->$frc$(:,:,:)
  time_new = f->time
  delete(f)
  frc_new@lat2d = lat2d
  frc_new@lon2d = lon2d

  f  = addfile ( fname_cfsr, "r" )
  frc_cfsr = f->$cfsr_name$(:,:,:)
  time_cfsr = f->time
  delete(f)

  ti = ou_timestring2i( dates(0), time_old )
  mincn = min(frc_old)
  maxcn = max(frc_old)
;  mincn = 0
;  maxcn = 800

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
;  res@cnMaxLevelValF       = doubletoint(maxcn)
;  res@cnMinLevelValF       = doubletoint(mincn)
;  res@cnLevelSpacingF = 0.5
  cnlevels = 100
  mnmxint = nice_mnmxintvl( mincn, maxcn, cnlevels, False )
  res@cnMinLevelValF       = mnmxint(0)
  res@cnMaxLevelValF       = mnmxint(1)
  res@cnLevelSpacingF      = mnmxint(2)

  res@lbLabelBarOn = False

  ; The following resources are REQUIRED to properly display
  ; data zoomed on a lambert conformal grid.  

  res@mpProjection        = "LambertConformal"
  res@mpLambertParallel1F = minlat
  res@mpLambertParallel2F = maxlat
  res@mpLambertMeridianF  = ( minlon + maxlon ) * 0.5

  ; to check whether the data has the correct map data
;  res@mpFillOn               = False            
;  res@mpOutlineOn = False

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

  plot = new(24, graphic)

  do i = 0, 23
;    ti = ou_timestring2i( dates(i), time_old )
;    cn = frc_old(ti,:,:)
    cn = frc_old(i,:,:)
;    printVarSummary(cn)
    date = cd_string( time_old(i), "%Y-%N-%D %H:%M:%S" )
    res@tiMainString = "old forcing: " + date
    res@lbTitleString = frc + " (" + frc_units +")"
    if ( i.eq.0 )
      res@tiMainString = res@tiMainString + " (initial)"
    end if
    plot(i) = gsn_csm_contour_map(wks, cn, res)     
  end do

;  do i = 0, 2
;    ti = ou_timestring2i( dates(i), time_new )
;    cn = frc_new(ti,:,:)
;    res@tiMainString = "new forcing: " + dates(i)
;    if ( i.eq.0 )
;      res@tiMainString = res@tiMainString + " (initial)"
;    end if
;    plot(i+3) = gsn_csm_contour_map(wks, cn, res)     
;  end do

;  delete(cn)
;  res@gsnAddCyclic = False
;  do i = 0, 2
;    ti = ou_timestring2i( dates(i), time_cfsr )
;    tmp = frc_cfsr(ti,:,:)
;    cn = new(dimsizes(tmp), double)
;    cn = tmp*tmp@scale_factor + tmp@add_offset
;    cn!0 = "lat"
;    cn!1 = "lon"
;    cn&lat = tmp&Latitude
;    cn&lon = tmp&Longitude
;    res@tiMainString = "CFSR data: " + dates(i)
;    if ( i.eq.0 )
;      res@tiMainString = res@tiMainString + " (initial)"
;    end if
;    plot(i+6) = gsn_csm_contour_map(wks, cn, res)     
;  end do

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
  resP@lbTitleString = frc + " (" + frc_units +"), atmospheric forcing"
  resP@lbTitleFontHeightF = 0.013
  resP@lbBoxLinesOn = False
  ;   resP@lbLabelFontHeightF = 0.007

  ;   resP@txString = "Sea surface temperature"
  ;}}}

  gsn_panel(wks, plot, (/4,6/), resP)

  if (final)
    frame(wks)
    delete(wks)
    system("eps2png_trim " + img)
  end if
end
