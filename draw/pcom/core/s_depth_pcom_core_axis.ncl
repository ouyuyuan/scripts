
; Description: Globally averaged drift of the annual mean salinity as a
;              function of depth (in COREs axis for comparison)
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-13 15:08:00 BJT
; Last Change: 2014-07-14 22:26:11 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;  final = False
  final = True

  cmap = "NCV_blue_red"
;  cmap = "BlGrYeOrReVi200"
;  cmap = "amwg_blueyellowred"
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
  img      = draw_dir + "/s_depth_pcom_core_axis"
  fname    = data_dir + "/layer_ave.nc"

  wks = gsn_open_wks ("eps", img)
  gsn_define_colormap(wks, cmap)

  f = addfile( fname, "r" )
  sa = f->sa
  cn = sa(z|:,time|:)
  delete(f)

  cn0 = conform_dims( dimsizes(cn), cn(:,0), 0 )
  cn = cn - cn0

;  copy_VarMeta(cn_w, d_s)

  res = True
  ; resource{{{

  res@tmXBLabelFontHeightF = 0.02
  res@tmYLLabelFontHeightF = 0.02
  ; gsn <<<2
  ;
  res@gsnDraw = False
  res@gsnFrame = False
  ;   res@gsnMaximize = True
  res@gsnSpreadColors      = True               ; use full color map
  ;   res@gsnSpreadColorStart  = 30                 ; start at color 17
  ;   res@gsnSpreadColorEnd    = 180
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
  res@cnLineLabelsOn       = False              ; turn off contour line labels
  res@cnInfoLabelOn        = False      ; turns off contour info label
;  symMinMaxPlt(cn, 50, False, res)
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMaxLevelValF       = 0.3               ; set max contour level
  res@cnMinLevelValF       = -0.3               ; set min contour level
  res@cnLevelSpacingF = 0.01
  res@cnFillMode = "RasterFill"

  ; label bar <<<2

;  res@lbLabelBarOn = False
;  res@lbOrientation            = "Vertical"     ; vertical label bar
  res@lbPerimOn                = False             ; no box around it
  res@lbBoxLinesOn = False

  ;   res@lbBoxLinesOn = False
  ;    res@lbLabelStride            = 4

  ; plot manager <<<2

  ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
  ;   res@pmLabelBarWidthF = 0.5
  ;   res@pmLabelBarHeightF = 0.05
  res@pmLabelBarOrthogonalPosF = -0.01

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
  res@tmXBValues  =   (/50,150,250,350,450/)
  res@tmXBLabels  = res@tmXBValues
  res@tmXBMinorValues =   ispan(0,500,50)
;  res@tmXBTickStartF   = 0
;  res@tmXBTickSpacingF = 50
;  res@tmXBTickEndF     = 500

  ; transformation <<<2

  ;   res@trYMaxF = 500.
  ;   res@trXMaxF = 25
  ;   res@trXMinF = -25
     res@trYReverse               = True   ; reverses y-axis
  ; }}}

  resU = res
  ; upper resource{{{
  resU   =   res
  resU@tiMainString      =   "PCOM"
  resU@tiMainFontHeightF = 0.04
;  resU@tiXAxisString     =   ""
;  resU@gsnCenterString = "PCOM"
;  resU@gsnCenterStringOrthogonalPosF = 0.02

  resU@tmXBLabelsOn  =   True
  resU@tmXBOn        =   False
  resU@tmYLMode          =   "Explicit"
  resU@tmYLValues  =   (/0,1000/)
  resU@tmYLLabels  =   resU@tmYLValues
  resU@tmYLMinorValues =   ispan(0,1500,500)

  resU@vpHeightF       =   0.45
  ; cal. by cores axis
  resU@vpWidthF        =   resU@vpHeightF * (3.6/2.6) * (4.4/3.65)
  resU@vpYF            =   0.8
  resU@vpXF            =   0.1

  resU@lbLabelBarOn   = True
  resU@lbOrientation = "Vertical"     ; vertical label bar

  resU@trYMaxF = 1500
  resU@trYMinF = 0
  ;}}}

  plotU = gsn_csm_contour(wks, cn, resU)

  resB = res
  ; bottom resource{{{
  resB@gsnCenterString=""

  resB@tmYLMode         =   "Explicit"
  resB@tmXTOn        =   True
  resB@tmXTLabelsOn  =  False
  resB@tmXBLabelsOn  =  True
  resB@tmYLValues  =   (/3000, 6000/)
  resB@tmYLLabels  =   resB@tmYLValues
  resB@tmYLMinorValues  =   ispan(1500,6000,1500)

  resB@vpHeightF     = resU@vpHeightF * (0.1/0.26)
  resB@vpWidthF      = resU@vpWidthF
  resB@vpYF          = resU@vpYF - resU@vpHeightF
  resB@vpXF          = resU@vpXF

  resB@lbLabelBarOn = False

  resB@trYMaxF = 6000
  resB@trYMinF = 1500
  ;}}}

  plotB = gsn_csm_contour(wks, cn, resB)
;  overlay(plotU, plotB)

  draw(plotB)
  draw(plotU)

  if (final)
    frame(wks)
    delete(wks)
    system("eps2png_trim " + img)
  end if
end
