
; Description: sea surface current
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-09-07 20:06:42 BJT
; Last Change: 2014-09-08 08:08:36 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"  
load "/home/ou/archive/scripts/utils/ncl.ncl"
load "/home/ou/archive/scripts/utils/roms.ncl"

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
;  cmap = "precip_11lev"
;  cmap = "NCL_default"
  cmap = "MPL_cool"

  img = "/home/ou/archive/drawing/roms/scs/" + getenv("NCL_ARG_0_base")
  data_dir   = "/home/ou/archive/models/roms/roms_734/Apps/scs/"
  data_dir_hycom   = "/home/ou/archive/data/roms/scs/hycom/"
  fname_grid = data_dir + "in/testgrid.nc"
  fname_data = data_dir + "out_test/his_nof.nc"

  dates = (/"2006-04-05 00:00:00",\
;            "2006-04-07 00:00:00",\
            "2006-04-09 00:00:00",\
;            "2006-04-11 00:00:00",\
;            "2006-04-13 00:00:00",\
            "2006-04-15 00:00:00"/)

  ; get data and variable {{{
  f = addfile( fname_grid, "r" )
  angle  = f->angle
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
  u = f->u(:,ns-1,:,:)
  v = f->v(:,ns-1,:,:)
  t = f->ocean_time
  delete(f)

  ;}}}

  wks  = gsn_open_wks ("eps", img)
  gsn_define_colormap( wks, cmap )

  res                       = True              ; plot mods desired
  ; subplot resource {{{
  res@gsnDraw = False
  res@gsnFrame = False
  res@gsnLeftString = ""
  res@gsnRightString = ""
  res@gsnLeftStringOrthogonalPosF = 0.03
  res@gsnRightStringOrthogonalPosF = 0.03
;  res@gsnMaximize           = True
  res@gsnSpreadColors       = True              ; use total colormap
  if ( cmap .eq. "BlGrYeOrReVi200" )
    res@gsnSpreadColorEnd      = 180
  end if

  res@vcLevelSelectionMode = "ManualLevels"
  res@vcMaxLevelValF       = 1
  res@vcMinLevelValF       = 0.0
  res@vcLevelSpacingF = 0.02

  res@vcRefMagnitudeF       = 0.5                 ; add a reference vector
  res@vcRefLengthF          = 0.03            ; what the ref length is
  res@vcRefAnnoString1 = res@vcRefMagnitudeF + " m/s"
  res@vcMinDistanceF          = 0.02            ; thin out vectors
  res@vcLineArrowHeadMaxSizeF = 0.005
  res@vcLineArrowHeadMinSizeF = 0.003  

  res@vcRefAnnoOrthogonalPosF   = -1.0            ; move ref vector
;  res@vcRefAnnoParallelPosF   = 0.15            ; move ref vector
  res@vcMonoLineArrowColor  = False             ; vec's colored by their mag
  res@vcRefAnnoArrowUseVecColor = False           ; don't use vec color for ref
  res@vcRefAnnoArrowLineColor   = "black"         ; change ref vector color
;  res@vcLineArrowThicknessF   = 0.5               ; change vector thickness
  res@vcVectorDrawOrder       = "PostDraw"        ; draw vectors last
;  res@vcLineArrowColor        = "black"           ; change vector color
  res@vcGlyphStyle          = "CurlyVector"     ; turn on curly vectors

  res@lbLabelBarOn = False
  res@lbPerimOn             = False             ; no box around it
;  res@lbLabelStride         = 2                 ; skip every other label
  ; res@lbLabelAutoStride    = True              ; don't overlap labels

  res@tmXTOn = False
  res@tmYROn = False

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

  res@pmTickMarkDisplayMode  = "Always"           ; turn on tickmarks
;  res@pmLabelBarDisplayMode  = "Always"          ; Turn on a label bar.
  ;}}}

  ndates = dimsizes(dates)
  plot = new(3*ndates, graphic)

  do i = 0, ndates - 1
    ; roms data
    res@tiMainString = dates(i)
    if ( i.eq.0 )
      res@tiMainString = dates(i) + " (initial)"
    end if
    ti = ou_string2ti( dates(i), t )
    cn_u = u2rho( u(ti,:,:) )
    cn_v = v2rho( v(ti,:,:) )

    uvrot = uv_rot( cn_u, cn_v, angle )
    ueast  = uvrot(0,:,:)
    vnorth = uvrot(1,:,:)
    ou_add_2d( ueast,  lat2d, lon2d )
    ou_add_2d( vnorth, lat2d, lon2d )
    plot(i) = gsn_csm_vector_map(wks, ueast, vnorth, res)     

    ; hycom data
    res@tiMainString = "HYCOM, " + dates(i)

    fname = data_dir_hycom + timestr2fname(dates(i))
    f = addfile(fname, "r")
    tmp_u = f->water_u(0,0,:,:)
    tmp_v = f->water_v(0,0,:,:)
    delete(f)

    ueast_h = ou_rgrid2rcm(tmp_u&lat, tmp_u&lon, ou_short2double(tmp_u), lat2d, lon2d)
    vnorth_h = ou_rgrid2rcm(tmp_v&lat, tmp_v&lon, ou_short2double(tmp_v), lat2d, lon2d)
    ou_add_2d( ueast_h,  lat2d, lon2d )
    ou_add_2d( vnorth_h, lat2d, lon2d )
    plot(i+ndates) = gsn_csm_vector_map(wks, ueast_h, vnorth_h, res)     

    ueast_d = ueast - ueast_h
    vnorth_d = vnorth - vnorth_h
    ueast_d@_FillValue = ueast@_FillValue
    vnorth_d@_FillValue = vnorth@_FillValue

    ou_add_2d( ueast_d, lat2d, lon2d )
    ou_add_2d( vnorth_d, lat2d, lon2d )
    res@tiMainString = dates(i)
    plot(i+2*ndates) = gsn_csm_vector_map(wks, ueast_d, vnorth_d, res)     
  end do

  resP = True
  ;panel resource {{{
  resP@gsnFrame = False
;  resP@gsnDraw  = False
;  resP@gsnPanelBottom = 0.4
  ;      resP@gsnPanelDebug = True
  resP@gsnPanelLabelBar = True
  resP@gsnPanelXWhiteSpacePercent = 5
  resP@gsnPanelYWhiteSpacePercent = 5
  ;   resP@gsnPanelRowSpec = True

  resP@pmLabelBarWidthF = 0.05
  resP@pmLabelBarHeightF = 0.7
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

  gsn_panel(wks, plot, (/3,ndates/), resP)

  if (final)
    frame(wks)
    delete(wks)
    system("eps2png_trim " + img)
  end if
end
