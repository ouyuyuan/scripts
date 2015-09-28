
; Description: global average potential temperature
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-04-10 16:41:49 BJT
; Last Change: 2014-10-07 10:50:22 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;  final = False
  final = True
  core_axis = True
;  core_axis = False

  cmap = "BlGrYeOrReVi200"
;  cmap = "NCL_default"
;  cmap = "BlRe"
;  cmap = "hotres"
;  cmap = "precip_11lev"

  data_dir = "/home/ou/archive/data/pcom/moc_re_s/post"
  draw_dir = "/home/ou/archive/drawing/pcom/core"
  img      = draw_dir + "/s_global_ave_pcom"
  fname    = data_dir + "/global_ave.nc"

  if (core_axis) then
    img = img + "_core_axis"
  end if
  wks = gsn_open_wks ("eps", img)
  gsn_define_colormap(wks, cmap)

  f = addfile( fname, "r" )
  sa = f->sa
  year = f->time
  delete(f)

  res = True
  ; resource {{{

  res@vpHeightF = 0.56
  res@vpWidthF = 0.72

;  res@tiMainString = "Global average salinity (psu)"
  res@tiYAxisString = "psu"
  res@tiXAxisString = "year"

  res@gsnDraw = False
  res@gsnFrame = False
  ;   res@gsnMaximize = True
  ;   res@gsnLeftString = "mm"
  res@gsnLeftString = ""
  ;   res@gsnRightString = ""
  ;   res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 

  res@xyMonoLineColor = False
  res@xyDashPattern = 0 ; solid
  ;   res@xyMarkLineMode = "MarkLines"
  res@xyMarkLineMode = "Lines"
  ;   res@xyMarkers = (/6, 11, 16/)
  ;   res@xyMarkerColors = (/"blue", "red", "green"/)
;  res@xyLineColors = (/"black", "blue", "cyan", "red"/)
  res@xyLineColor = "red"
  res@xyLineThicknessF = 3
  res@xyDashPattern = 0

  ;   res@pmLegendDisplayMode = "Always"
  ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
  ;   res@pmLabelBarWidthF = 0.5
  ;   res@pmLabelBarHeightF = 0.05
  ;   res@pmLabelBarOrthogonalPosF = 0.2

  res@tmLabelAutoStride = True
  
  res@tmYROn = False
  res@tmXTOn = False

  if (core_axis) then
    res@tmYLMode = "Explicit"
    res@tmYLValues = (/ 34.68, 34.7, 34.72, 74.74, 34.76 ,  34.78 ,  34.8 ,  34.82 ,  34.84 ,  34.86 , 34.88 ,  34.9/)
;    res@tmYLLabels = (/"34.56", "34.58", "34.6", "34.62", "34.64", "34.66", "34.68", "34.7", "34.72", "34.74"/)
    res@tmYLLabels = res@tmYLValues
;    res@tmYLMode = "Manual"
;    res@tmYLTickEndF = 26.7
;    res@tmYLTickSpacingF = 0.02
;    res@tmYLTickStartF = 26.5
  end if

  res@tmXBMode = "Manual"
  res@tmXBTickStartF   = 0
  res@tmXBTickSpacingF = 50
  res@tmXBTickEndF     = 500

  if (core_axis) then
;    res@trYMaxF = 26.7
    res@trYMinF = 34.66
  end if
  ;   res@trXMaxF = 25
  ;   res@trYReverse               = True   ; reverses y-axis
  ;}}}

  plot = gsn_csm_xy(wks, year, sa, res)

  draw(plot)

  ; add legend
;  txres               = True
;  txres@txFontHeightF = 0.01
;  text = "PCOM, restored"
;  gsn_text_ndc(wks, text, 0.28, 0.65, txres)

  if (final)
    frame(wks)
    delete(wks)
    system("eps2png_trim " + img)
  end if
end
