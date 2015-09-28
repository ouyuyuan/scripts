
; Description: sea surface height
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-09-06 17:52:20 BJT
; Last Change: 2014-09-21 07:55:41 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"  
load "/home/ou/archive/scripts/utils/ncl.ncl"

; change, say, "2006-04-05 00:00:00" to filename "20060405.nc"
undef("timestr2fname")
function timestr2fname( str:string )
local y, m, d, fn
begin
  y = str_get_cols(str,0,3)
  m = str_get_cols(str,5,6)
  d = str_get_cols(str,8,9)
  fn = y + m + d + ".nc"

  return fn
end

begin

;  final = False
  final = True
;  cmap = "testcmap"
;  cmap = "BlGrYeOrReVi200"
  cmap = "BlWhRe"
;  cmap = "NCL_default"
  cmap_diff = "BlWhRe"

  img = "/home/ou/archive/drawing/roms/scs/" + getenv("NCL_ARG_0_base")
  data_dir   = "/home/ou/archive/models/roms/roms_734/Apps/scs/"
  data_dir_hycom   = "/home/ou/archive/data/roms/scs/hycom/"
;  fname_grid = data_dir + "in/testgrid.nc"
  fname_grid = data_dir + "in/seagrid.nc"
  fname_data = data_dir + "out_test/his_nof.nc"

  dates = (/"2006-04-05 00:00:00",\
;            "2006-04-07 00:00:00",\
            "2006-04-09 00:00:00",\
;            "2006-04-11 00:00:00",\
;            "2006-04-13 00:00:00",\
            "2006-04-15 00:00:00"/)

  ; get data and variable {{{
  f = addfile( fname_grid, "r" )
  lat2d  = f->lat_rho
  lon2d  = f->lon_rho
  delete(f)

  delta = 1.0
  minlat = min(lat2d) - delta
  maxlat = max(lat2d) + delta
  minlon = min(lon2d) - delta
  maxlon = max(lon2d) + delta + 1.0

  f  = addfile ( fname_data, "r" )
  s_rho  = f->s_rho
  ns = dimsizes(s_rho)
  zeta = f->zeta(:,:,:)
  t = f->ocean_time
  delete(f)

  ou_add_2d( zeta, lat2d, lon2d )

  mincn = min(zeta)
  maxcn = max(zeta)
  ;}}}

  wks  = gsn_open_wks ("eps", img)
;  gsn_define_colormap( wks, cmap )

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
  res@cnFillPalette = cmap

  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMaxLevelValF       = 1.0
  res@cnMinLevelValF       = -1.0
  res@cnLevelSpacingF = 0.1
;  cnlevels = 15
;  mnmxint = nice_mnmxintvl( mincn, maxcn, cnlevels, False )
;  res@cnMinLevelValF       = mnmxint(0)
;  res@cnMaxLevelValF       = mnmxint(1)
;  res@cnLevelSpacingF      = mnmxint(2)

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
  ; The following resources are REQUIRED to properly display
  ; data zoomed on a lambert conformal grid.  

  res@tmXTOn = False
  res@tmYROn = False

  res@pmTickMarkDisplayMode  = "Always"           ; turn on tickmarks
  ;}}}

  ndates = dimsizes(dates)
  plot = new(2*ndates, graphic)

;  print(ou_t2string(t)+"")

  do i = 0, ndates - 1
    ; roms data
    ti = ou_string2ti( dates(i), t )
    cn = zeta(ti,:,:)
    res@tiMainString = dates(i)
    if ( i.eq.0 )
      res@tiMainString = dates(i) + " (initial)"
      dims = dimsizes(cn)
      diff = new( (/ndates,dims(0),dims(1)/), typeof(cn) )
      delete(dims)
    end if
    plot(i) = gsn_csm_contour_map(wks, cn, res)     

    ; hycom data
    fname = data_dir_hycom + timestr2fname(dates(i))
    f = addfile(fname, "r")
    tmp = f->surf_el(0,:,:)
    delete(f)
    cn_h = ou_rgrid2rcm(tmp&lat, tmp&lon, ou_short2double(tmp), lat2d, lon2d)
    ou_add_2d(cn_h, lat2d, lon2d)
    res@tiMainString = "HYCOM, " + dates(i)
    plot(i+ndates) = gsn_csm_contour_map(wks, cn_h, res)     

;    printVarSummary(cn)
;    printVarSummary(cn_h)
;    exit
    diff(i,:,:) = cn - cn_h
    diff@_FillValue = cn@_FillValue
  end do

  res_d = res  ; resource for diff plots
  res_d@cnFillPalette = cmap_diff
  delete_VarAtts(res_d, "gsnSpreadColorEnd")
  cnlevels = 15
;  symMinMaxPlt( diff, cnlevels, False, res_d ) 
;  printMinMax(diff, 0)
;  exit
  res_d@cnLevelSelectionMode = "ManualLevels"
  res_d@cnMaxLevelValF       = 1.5
  res_d@cnMinLevelValF       = -1.5
  res_d@cnLevelSpacingF = 0.2

  plot_d = new(ndates, graphic)
  ou_add_2d( diff, lat2d, lon2d )

  do i = 0, ndates - 1
    res_d@tiMainString = dates(i)
    plot_d(i) = gsn_csm_contour_map(wks, diff(i,:,:), res_d)     
  end do

  resP = True
  ;panel resource {{{
  resP@gsnFrame = False
;  resP@gsnDraw  = False
  resP@gsnPanelBottom = 0.4
  ;      resP@gsnPanelDebug = True
  resP@gsnPanelLabelBar = True
  resP@gsnPanelXWhiteSpacePercent = 5
  resP@gsnPanelYWhiteSpacePercent = 5
  ;   resP@gsnPanelRowSpec = True

  resP@pmLabelBarWidthF = 0.05
  resP@pmLabelBarHeightF = 0.5
  resP@pmLabelBarOrthogonalPosF = 0.02
  resP@pmLabelBarParallelPosF = -0.02 ; make a bit far from the bottom plots

  resP@lbOrientation = "vertical"
  resP@lbLabelFontHeightF = 0.013
  resP@lbLabelAutoStride = True
;  resP@lbTitleString = "sea surface salinity ( PSU )"
  resP@lbTitleFontHeightF = 0.013
  ;   resP@lbBoxLinesOn = False
  ;   resP@lbLabelFontHeightF = 0.007

  ;   resP@txString = "Sea surface salinity"
  ;}}}

  gsn_panel(wks, plot, (/2,ndates/), resP)

  resP@gsnPanelTop = 0.4
  resP@gsnPanelBottom = 0.1
  resP@pmLabelBarHeightF = 0.25
  resP@pmLabelBarParallelPosF = 0.005
;  resP@lbTitleString = "difference (ROMS - HYCOM) of sea surface salinity ( PSU )"
  gsn_panel(wks, plot_d, (/1,ndates/), resP)

  if (final)
    frame(wks)
    delete(wks)
    system("eps2png_trim " + img)
  end if
end
