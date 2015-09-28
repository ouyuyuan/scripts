
; Description: Globally averaged drift of the annual mean temperature as a
;              function of depth
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-13 15:08:00 BJT
; Last Change: 2014-10-07 09:42:12 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;  final = False
  final = True

;  cmap = "BlGrYeOrReVi200"
;  cmap = "amwg_blueyellowred"
  cmap = "NCV_blue_red"
;  cmap = "testcmap"
;  cmap = "NCV_jaisnd"
;  cmap = "BlueWhiteOrangeRed"
;  cmap = "BlWhRe"
;  cmap = "NCL_default"
;  cmap = "BlRe"
;  cmap = "hotres"
;  cmap = "precip_11lev"

  data_dir = "/home/ou/archive/data/pcom/moc_re_s/post"
  draw_dir = "/home/ou/archive/drawing/pcom/core"
  img      = draw_dir + "/t_depth_pcom"
  fname    = data_dir + "/layer_ave.nc"

  wks = gsn_open_wks ("eps", img)
  gsn_define_colormap(wks, cmap)

  f = addfile( fname, "r" )
  pt = f->pt
  cn = pt(z|:,time|:)
  delete(f)

  cn0 = conform_dims( dimsizes(cn), cn(:,0), 0 )
  cn = cn - cn0

;  copy_VarMeta(cn_w, d_s)

  res = True
  ; resource{{{

  res@tiMainString = "Drift of the annual mean potential temperature"
  res@tiYAxisString = "m"
  res@tiXAxisString = "year"
  ; gsn <<<2
  ;
  res@gsnDraw = False
  res@gsnFrame = False
  ;   res@gsnMaximize = True
  res@gsnSpreadColors      = True               ; use full color map
  ;   res@gsnSpreadColorStart  = 30                 ; start at color 17
  ;   res@gsnSpreadColorEnd    = 180
;  res@gsnLeftString = ""
;  res@gsnRightString = ""
;   res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 
  res@gsnLeftStringOrthogonalPosF = 0.03
  res@gsnRightStringOrthogonalPosF = 0.03

  ; contour <<<2
  ;
  res@cnFillOn             = True               ; turn on color for contours
  res@cnLinesOn            = False              ; turn off contour lines
  ;   res@cnLineThicknessF = 0.5
  res@cnLineLabelsOn       = False              ; turn off contour line labels
  res@cnInfoLabelOn        = False      ; turns off contour info label
;  symMinMaxPlt(cn, 50, False, res)
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMaxLevelValF       = 6.               ; set max contour level
  res@cnMinLevelValF       = -6.               ; set min contour level
  res@cnLevelSpacingF = 1
;  res@cnFillMode = "RasterFill"

  ; label bar <<<2

;  res@lbLabelBarOn = False
  res@lbOrientation            = "Vertical"     ; vertical label bar
  res@lbPerimOn                = False             ; no box around it
  res@lbBoxLinesOn = False

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
  res@tmYLMode = "Explicit"
  res@tmYLValues = (/ 200 , 400 , 600 , 800 , 1000 , 2000 , 3000 , 4000/)
  res@tmYLLabels = (/"200","400","600","800","1000","2000","3000","4000"/)

  ; transformation <<<2

  ;   res@trYMaxF = 500.
  ;   res@trXMaxF = 25
  ;   res@trXMinF = -25
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
