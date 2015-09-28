
; Description: surface currents
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-06 19:43:19 BJT
; Last Change: 2014-07-07 15:07:51 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "/home/ou/archive/scripts/draw/utils/roms.ncl"
load "/home/ou/archive/scripts/draw/utils/ncl.ncl"
begin

;  final = False
  final = True

;  cmap = "BlGrYeOrReVi200"
;  cmap = "NCL_default"
;  cmap = "BlRe"
;  cmap = "hotres"
  cmap = "precip_11lev"

  data_dir   = "/home/ou/archive/data/roms/latte"
  draw_dir   = "/home/ou/archive/drawing/roms/zxzq"
  img  = draw_dir + "/uv"
  fname_data = data_dir + "/TH/lattec_his_nof.nc"

  wks   = gsn_open_wks ("eps", img)            ; open workstation
  gsn_define_colormap(wks, cmap)

  ; get data and variables {{{

  f      = addfile (fname_data, "r")
  angle  = f->angle
  lat2d  = f->lat_rho
  lon2d  = f->lon_rho
  u = f->u(:,0,:,:)
  v = f->v(:,0,:,:)
  tunits = f->ocean_time@units
  delete(f)

  minlat = min(lat2d) - 0.2
  maxlat = max(lat2d) - 0.0
  minlon = min(lon2d) + 0.2
  maxlon = max(lon2d) + 0.2

;  u = where(ismissing(u), 0.0, u)
;  v = where(ismissing(v), 0.0, v)

  ;}}}

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
  if ( cmap .eq. "hotres" )
    res@gsnSpreadColorEnd     = 190
    res@gsnSpreadColorStart   = 10
  end if
  if ( cmap .eq. "BlGrYeOrReVi200" )
    res@gsnSpreadColorEnd      = 180
  end if

  res@vcLevelSelectionMode = "ManualLevels"
  res@vcMaxLevelValF       = 0.2
  res@vcMinLevelValF       = 0.02
  res@vcLevelSpacingF = 0.02

  res@vcRefMagnitudeF       = 0.5                 ; add a reference vector
  res@vcRefLengthF          = 0.03            ; what the ref length is
  res@vcRefAnnoString1 = res@vcRefMagnitudeF + " m/s"
  res@vcMinDistanceF          = 0.01            ; thin out vectors
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

  ;res@mpDataBaseVersion      = "HighRes"          ; use high resolution coast
  res@mpDataBaseVersion      = "MediumRes"        ; use medium resolution coast

  res@pmTickMarkDisplayMode  = "Always"           ; turn on tickmarks
;  res@pmLabelBarDisplayMode  = "Always"          ; Turn on a label bar.
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
    uvrot = uv_rot( u2rho( u({t},:,:) ), v2rho( v({t},:,:) ), angle )

    ueast  = uvrot(0,:,:)
    vnorth = uvrot(1,:,:)
    add_2d( ueast,  lat2d, lon2d )
    add_2d( vnorth, lat2d, lon2d )

    res@tiMainString = dates(i)
    if ( i.eq.0 )
      res@tiMainString = dates(i) + " (initial)"
    end if
    plot(i) = gsn_csm_vector_map(wks, ueast, vnorth, res)     
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
  resP@lbTitleString = "sea surface currents (m/s)"
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
