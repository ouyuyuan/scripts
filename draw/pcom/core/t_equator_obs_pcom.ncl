
; Description: upper ocean on the equator in the Pacific
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-13 15:08:00 BJT
; Last Change: 2014-10-07 10:02:41 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;  final = False
  final = True

;  cmap = "BlGrYeOrReVi200"
;  cmap = "amwg_blueyellowred"
;  cmap = "NCV_blue_red"
;  cmap = "testcmap"
;  cmap = "NCV_jaisnd"
;  cmap = "BlueWhiteOrangeRed"
;  cmap = "BlWhRe"
  cmap = "NCL_default"
;  cmap = "BlRe"
;  cmap = "hotres"
;  cmap = "precip_11lev"

  data_dir = "/home/ou/archive/data/pcom/input"
  draw_dir = "/home/ou/archive/drawing/pcom/core"
  img      = draw_dir + "/t_equator_obs_pcom"
  fname    = data_dir + "/pcom_ini.nc"

  wks = gsn_open_wks ("eps", img)
  gsn_define_colormap(wks, cmap)

  f = addfile( fname, "r" )
  lat = f->lat
  idx1 = ind(lat.eq.-0.5)
  idx2 = ind(lat.eq.0.5)
  ct1 = f->ct(:,idx1,:)
  ct2 = f->ct(:,idx2,:)
  delete(f)

  cn0 = ct1
  cn0 = ( ct1 + ct2 ) * 0.5 ; PCOM initial field does not have zero latitiude
  cn = cn0(z|:,lon|130:290) ; Pacific

;  copy_VarMeta(cn_w, d_s)

  res = True
  ; resource{{

  res@vpWidthF = 0.7
  res@vpHeightF = res@vpWidthF * (3.6/4.5)
  res@vpXF = 0.1

  res@tiMainString = "temp obs (PCOM)"
;  res@tiYAxisString = "m"
;  res@tiXAxisString = "year"
  ; gsn <<<2
  ;
  res@gsnDraw = False
  res@gsnFrame = False
  ;   res@gsnMaximize = True
  res@gsnSpreadColors      = True               ; use full color map
  ;   res@gsnSpreadColorStart  = 30                 ; start at color 17
  if (cmap.eq."BlGrYeOrReVi200") then
    res@gsnSpreadColorEnd    = 180
  end if
  res@gsnLeftString = ""
  res@gsnRightString = ""
  res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 
  res@gsnLeftStringOrthogonalPosF = 0.03
  res@gsnRightStringOrthogonalPosF = 0.03

  ; contour <<<2
  ;
  res@cnFillOn             = True               ; turn on color for contours
  res@cnLinesOn            = False              ; turn off contour lines
  ;   res@cnLineThicknessF = 0.5
;  res@cnLineLabelsOn       = True ; turn off contour line labels
  res@cnInfoLabelOn        = False      ; turns off contour info label
;  symMinMaxPlt(cn, 50, False, res)
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMaxLevelValF       = 28.               ; set max contour level
  res@cnMinLevelValF       = 8.               ; set min contour level
  res@cnLevelSpacingF = 1
;  res@cnFillMode = "RasterFill"

  ; label bar <<<2

;  res@lbLabelBarOn = False
  res@lbOrientation            = "Vertical"     ; vertical label bar
  res@lbPerimOn                = False             ; no box around it
;  res@lbBoxLinesOn = False

  ;   res@lbBoxLinesOn = False
  ;    res@lbLabelStride            = 4

  ; plot manager <<<2

  ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
  ;   res@pmLabelBarWidthF = 0.5
  ;   res@pmLabelBarHeightF = 0.05
  ;   res@pmLabelBarOrthogonalPosF = 0.2

  ; map  <<<2

  ;   res@mpLandFillColor          = "gray"            ; set land to be gray
  ;   res@mpMinLonF = 0
  ;   res@mpMaxLonF = 360
;  res@mpCenterLonF = 180

  ; tick mark  <<<2

  res@tmLabelAutoStride = True
;  res@tmYROn = False
;  res@tmXTOn = False
  ;   res@tmYLMode = "Manual"
  ;   res@tmYLTickStartF    = 100.
  ;   res@tmYLTickSpacingF  = 100.
  res@tmXBMode = "Explicit"
  res@tmXBValues = (/140, 180, 220, 260/)
  res@tmXBMinorValues =  ispan(140,280,20)
  res@tmXBLabels = res@tmXBValues

  res@tmYLMode = "Explicit"
  res@tmYLValues = (/0, 100, 200, 300/)
  res@tmYLMinorValues =  ispan(0,350,50)
  res@tmYLLabels = res@tmYLValues

  ; transformation <<<2

  res@trYMaxF = 350.
  res@trYMinF = 0.
  res@trYReverse               = True   ; reverses y-axis
  ; }}}

  plot = gsn_csm_contour(wks, cn, res)

  draw(plot)

  if (final)
    frame(wks)
    delete(wks)
    system("eps2png_trim " + img)
  end if
end
