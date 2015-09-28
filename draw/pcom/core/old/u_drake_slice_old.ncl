
; Description: u throught the slice of Drake Passage
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-13 15:08:00 BJT
; Last Change: 2014-10-09 08:05:10 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;  final = False
  final = True

  cmap = "BlGrYeOrReVi200"
;  cmap = "amwg_blueyellowred"
;  cmap = "NCV_blue_red"
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
  img      = draw_dir + "/u_drake_slice"
  fname    = data_dir + "/climate_mean_0491-0500.nc"

  wks = gsn_open_wks ("eps", img)
  gsn_define_colormap(wks, cmap)

  lon = 292.5
  f = addfile( fname, "r" )
  u = f->u(0,:,:,{lon})
  delete(f)
;  cn = u(z|:,lat|-68.5:-54.5,lon|292.5:292.5)
;  cn = u(z|:,lat|8:14,lon|92:93)
  cn = u
  delete(u)

;  copy_VarMeta(cn_w, d_s)

  res = True
  ; resource{{

  res@tiMainString = "u on Drake passage section"
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
  res@gsnContourZeroLineThicknessF = 2

  ; contour <<<2
  ;
  res@cnFillOn             = True               ; turn on color for contours
  res@cnLinesOn            = False              ; turn off contour lines
  res@cnLineThicknessF = 0.5
;  res@cnLineLabelsOn       = True ; turn off contour line labels
  res@cnInfoLabelOn        = False      ; turns off contour info label
;  symMinMaxPlt(cn, 50, False, res)
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMaxLevelValF       = 0.4               ; set max contour level
  res@cnMinLevelValF       = -0.4              ; set min contour level
  res@cnLevelSpacingF = 0.1
  res@cnMissingValFillColor = "black"
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

;  res@tmLabelAutoStride = True
;  res@tmYROn = False
;  res@tmXTOn = False
  ;   res@tmYLMode = "Manual"
  ;   res@tmYLTickStartF    = 100.
  ;   res@tmYLTickSpacingF  = 100.
;  res@tmXBMode = "Explicit"
;  res@tmXBValues = (/140, 180, 220, 260/)
;  res@tmXBMinorValues =  ispan(140,280,20)
;  res@tmXBLabels = res@tmXBValues

;  res@tmYLMode = "Explicit"
;  res@tmYLValues = (/0, 100, 200, 300/)
;  res@tmYLMinorValues =  ispan(0,350,50)
;  res@tmYLLabels = res@tmYLValues

  ; transformation <<<2

;  res@trYMaxF = 350.
;  res@trYMinF = 0.
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
