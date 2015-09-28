
; Description: schematic of warm pool
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-08-09 09:21:07 BJT
; Last Change: 2014-08-09 10:45:29 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  final = False
  cmap = "ncl_default"

  draw_dir = "/home/ou/archive/drawing/roms/hyzx/"
  nc_woa = "/home/ou/archive/data/woa09/temperature_annual_1deg.nc"
  img = draw_dir + "warm_pool"

  f = addfile( nc_woa, "r" )
  cn = f->t_mn(0, 0, :, :)
  delete(f)

; warm pool domain
  lat = (/23.5, -18.5, -18.5, 23.5, 23.5/)
  lon = (/77.5, 77.5, 170, 170, 77.5/)

  wks = gsn_open_wks("eps", img)
  gsn_define_colormap(wks, cmap)

;---Resources for the polyline
  pres                  = True           ; polyline mods desired
  pres@gsLineThicknessF = 2.5            ; line thickness   
  pres@gsLineColor      = "white"         ; color of lines

;---Resources for the contour
  res = True

  res@tiMainString = "Model Domain"

  res@gsnDraw = False
  res@gsnFrame = False
  ;   res@gsnMaximize = True
  res@gsnSpreadColors      = True               ; use full color map
  res@gsnLeftString = ""
  res@gsnRightString = ""
  ;   res@gsnSpreadColorStart  = 30                 ; start at color 17
  ;   res@gsnSpreadColorEnd    = 240                ; end at color 200
  ;   res@gsnSpreadColorEnd    = 180                ; end at color 200
;  res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 

  res@cnFillOn             = True               ; turn on color for contours
  res@cnLinesOn            = False              ; turn off contour lines
  res@cnLineLabelsOn       = False              ; turn off contour line labels
  res@cnInfoLabelOn        = False      ; turns off contour info label
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMaxLevelValF       = 28.               ; set max contour level
  res@cnMinLevelValF       = 10.               ; set min contour level
  res@cnLevelSpacingF = 2.

;  res@lbLabelBarOn = False
  ;   res@lbOrientation            = "Vertical"     ; vertical label bar
  res@lbPerimOn                = False             ; no box around it
  ;    res@lbLabelStride            = 4
  res@lbTitleString = "obsevation(WOA09) climate mean SST (~S~o~N~C)"
  res@lbTitleFontHeightF = 0.015
  res@lbLabelFontHeightF = 0.014
  res@lbLabelAutoStride = True

  ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
  ;    res@pmLabelBarWidthF         = 0.08              ; make it thinner
  res@pmLabelBarHeightF = 0.05
  res@pmLabelBarOrthogonalPosF = 0.15          ; move label bar closer

  ;   res@mpLandFillColor          = "gray"            ; set land to be gray
  ;   res@mpMinLonF = 0
  ;   res@mpMaxLonF = 360
  res@mpCenterLonF = 180

  res@tmLabelAutoStride = True
  res@tmYROn = False
  res@tmXTOn = False
  ;   res@tmYLMode = "Manual"
  ;   res@tmYLTickStartF    = 100.
  ;   res@tmYLTickSpacingF  = 100.
  ;   res@tmXBMode = "Manual"
  ;   res@tmXBTickSpacingF = 5
  ;   res@tmXBTickStartF    = -25
  ;   res@tmXBTickEndF      = 25
  ;   res@tmYLTickEndF      = 300.

  ;   res@trYMaxF = 500.
  ;   res@trXMaxF = 25
  ;   res@trXMinF = -25
  ;   res@trYReverse               = True   ; reverses y-axis

  plot = gsn_csm_contour_map_ce(wks, cn, res)

;---Attach the polyline
  dum = gsn_add_polyline(wks, plot, lon, lat, pres)

  draw(plot)

  if (final)
    frame(wks)
    delete(wks)
    system("eps2png_trim " + img)
  end if

end
