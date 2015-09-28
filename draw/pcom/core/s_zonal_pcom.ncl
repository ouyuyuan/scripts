
; Description: anomaly of zonal mean salinity of PCOM
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-04-10 16:41:49 BJT
; Last Change: 2014-07-15 11:01:32 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;  final = False
  final = True
;  core_axis = True
;  core_axis = False

;  cmap = "BlGrYeOrReVi200"
  cmap = "NCV_blue_red"
;  cmap = "testcmap"
;  cmap = "NCL_default"
;  cmap = "BlRe"
;  cmap = "hotres"
;  cmap = "precip_11lev"

  data_dir = "/home/ou/archive/data/pcom/input"
  data_dir_post = "/home/ou/archive/data/pcom/moc_re_s/post"
  draw_dir = "/home/ou/archive/drawing/pcom/core"
  img      = draw_dir + "/s_zonal_pcom"
  fname    = data_dir + "/pcom_ini.nc"
  fname_post    = data_dir_post + "/climate_mean_0491-0500.nc"

  wks = gsn_open_wks ("eps", img)
  gsn_define_colormap(wks, cmap)

  f = addfile( fname, "r" )
  s = f->sa(:,:,:)
  cn0 = dim_avg_n_Wrap( s, 2 )
  delete(f)
  delete(s)

  f = addfile( fname_post, "r" )
  s = f->sa(0,:,:,:)
  cn1 = dim_avg_n_Wrap( s, 2 )
  delete(f)
  delete(s)

  cn = cn0
  cn = cn1 - cn0

  res = True
  ; resource{{{
  res@tiMainString = "PCOM zonal bias"
  res@tiMainFontHeightF = 0.04

  res@vpWidthF = 0.7
  res@vpHeightF = res@vpWidthF * (3.6/4.5)
  res@vpXF = 0.15

  ; gsn <<<2
  ;
  res@gsnDraw = False
  res@gsnFrame = False
  ;   res@gsnMaximize = True
  res@gsnSpreadColors      = True               ; use full color map
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
;  res@cnLinesOn            = False              ; turn off contour lines
  ;   res@cnLineThicknessF = 0.5
  res@cnLineLabelsOn       = True ; turn off contour line labels
  res@cnInfoLabelOn        = False      ; turns off contour info label
;  symMinMaxPlt(cn, 50, False, res)
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMaxLevelValF       =  2.            ; set max contour level
  res@cnMinLevelValF       = -2.               ; set min contour level
  res@cnLevelSpacingF = 0.1
  res@cnMissingValFillColor = "black"
;  res@cnFillMode = "RasterFill"

  ; label bar <<<2

;  res@lbLabelBarOn = False
;  res@lbOrientation            = "Vertical"     ; vertical label bar
  res@lbPerimOn                = False             ; no box around it
  res@lbBoxLinesOn = False
  res@lbLabelFontHeightF = 0.02
  ;    res@lbLabelStride            = 4

  ; plot manager <<<2

  ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
  ;   res@pmLabelBarWidthF = 0.5
  res@pmLabelBarHeightF = 0.5
  res@pmLabelBarOrthogonalPosF = -0.01

  ; map  <<<2

  ;   res@mpLandFillColor          = "gray"            ; set land to be gray
  ;   res@mpMinLonF = 0
  ;   res@mpMaxLonF = 360
;  res@mpCenterLonF = 180

  ; tick mark  <<<2

  res@tmXBLabelFontHeightF = 0.02
  res@tmYLLabelFontHeightF = 0.02
  res@tmLabelAutoStride = True
;  res@tmYROn = False
;  res@tmXTOn = False
  ;   res@tmYLMode = "Manual"
  ;   res@tmYLTickStartF    = 100.
  ;   res@tmYLTickSpacingF  = 100.
;  res@tmXBMode = "Manual"
  res@tmXBTickStartF   = -80
  res@tmXBTickSpacingF = 20
  res@tmXBTickEndF     = 90

  ; transformation <<<2

  ;   res@trYMaxF = 500.
  ;   res@trXMaxF = 25
  ;   res@trXMinF = -25
     res@trYReverse               = True   ; reverses y-axis
  ;}}}

  resU = res
  ; upper resource{{{
  resU   =   res
  resU@tiMainString      =   res@tiMainString
  resU@tiMainOffsetYF = -0.01
  resU@tiMainFontHeightF = 0.035
;  resU@tiXAxisString     =   ""
;  resU@gsnCenterString = "PCOM"
;  resU@gsnCenterStringOrthogonalPosF = 0.02

  resU@tmXBLabelsOn  =   False
  resU@tmXBOn        =   False
  resU@tmYLMode          =   "Explicit"
  resU@tmYLValues  =   (/0,400,800,1200/)
  resU@tmYLLabels  =   resU@tmYLValues
  resU@tmYLMinorValues =   ispan(0,1500,200)

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
  resB@tiMainString =""

  resB@tmYLMode         =   "Explicit"
  resB@tmXTOn        =   True
  resB@tmXTLabelsOn  =  False
  resB@tmXBLabelsOn  =  True
  resB@tmYLValues  =   (/2000, 3000, 4000, 5000, 6000/)
  resB@tmYLLabels  =   resB@tmYLValues
  resB@tmYLMinorValues  =   ispan(1500,6000,500)

  resB@vpHeightF     = resU@vpHeightF * (0.1/0.26)
  resB@vpWidthF      = resU@vpWidthF
  resB@vpYF          = resU@vpYF - resU@vpHeightF
  resB@vpXF          = resU@vpXF

  resB@lbLabelBarOn = False

  resB@trYMaxF = 6000
  resB@trYMinF = 1500
  ;}}}

  plotU = gsn_csm_contour(wks, cn, resU)
  plotB = gsn_csm_contour(wks, cn, resB)

  draw(plotU)
  draw(plotB)

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
