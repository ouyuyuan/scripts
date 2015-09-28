
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-08 10:30:38 BJT
; Last Change: 2014-10-09 09:10:35 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  cmap = "BlGrYeOrReVi200"
;  cmap = "NCV_blue_red"
;  cmap = "BlueWhiteOrangeRed"
;  cmap = "testcmap"
;  cmap = "NCL_default"
;  cmap = "BlRe"
;  cmap = "hotres"
;  cmap = "precip_11lev"

  img      = getenv("NCL_ENV_image_name")
  fname    = getenv("NCL_ENV_datafile_name")

  wks = gsn_open_wks ("eps", img)
  gsn_define_colormap(wks, cmap)

  f = addfile( fname, "r" )
  cn = f->cn
  delete(f)

  res = True

  res@vpWidthF = 0.7
  res@vpHeightF = res@vpWidthF * (3.6/4.5)
  res@vpXF = 0.15

  ; gsn <<<2
  ;
  res@gsnDraw = False
  res@gsnFrame = False
  res@gsnSpreadColors      = True               ; use full color map
  if (cmap.eq."BlGrYeOrReVi200") then 
    res@gsnSpreadColorEnd    = 180
  end if
  res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 

  ; contour <<<2
  ;
  res@cnFillOn             = True               ; turn on color for contours
  res@cnLinesOn            = False              ; turn off contour lines
  ;   res@cnLineThicknessF = 0.5
  res@cnLineLabelsOn       = False
  res@cnInfoLabelOn        = False      ; turns off contour info label
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMaxLevelValF       =  0.4 ; set max contour level
  res@cnMinLevelValF       = -0.3 ; set min contour level
  res@cnLevelSpacingF = 0.05
  res@cnMissingValFillColor = "black"
;  res@cnFillMode = "RasterFill"

  ; label bar <<<2

;  res@lbLabelBarOn = False
;  res@lbOrientation            = "Vertical"     ; vertical label bar
  res@lbPerimOn                = False             ; no box around it
;  res@lbBoxLinesOn = False
  res@lbLabelFontHeightF = 0.02
  res@lbLabelStride  = 2


  ; tick mark  <<<2

  res@tmXBLabelFontHeightF = 0.02
  res@tmYLLabelFontHeightF = 0.02
  res@tmLabelAutoStride = True
  res@tmXBTickStartF   = -80
  res@tmXBTickSpacingF = 20
  res@tmXBTickEndF     = 90

  res@trYReverse               = True   ; reverses y-axis

  resU   =   res
;  resU@tiMainString = "climatory u at 67.5~S~o~N~ (Drake passage)"
  resU@tiMainFontHeightF = 0.025
  resU@tiMainOffsetYF = -0.01
  resU@gsnLeftString = ""
  resU@gsnRightString = ""
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

  resU@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
  ;   resU@pmLabelBarWidthF = 0.5
  resU@pmLabelBarHeightF = 0.6
  resU@pmLabelBarOrthogonalPosF = -0.01
  resU@pmLabelBarParallelPosF = 0.3

  resU@trYMaxF = 1500
  resU@trYMinF = 0

  plotU = gsn_csm_contour(wks, cn, resU)

  resB = res

  resB@gsnLeftString = ""
  resB@gsnRightString = ""

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

  resB@trYMaxF = 5000
  resB@trYMinF = 1500

  plotU = gsn_csm_contour(wks, cn, resU)
  plotB = gsn_csm_contour(wks, cn, resB)

  draw(plotU)
  draw(plotB)
  
  text = "climatory u at 67.5~S~o~N~ W (Drake passage)"
  txres               = True
  txres@txFontHeightF = 0.025
  gsn_text_ndc(wks, text, 0.5, 0.85, txres)

  text = "m/s"
  txres@txFontHeightF = 0.02
  gsn_text_ndc(wks, text, 0.96, 0.8, txres)

  text = "m"
  txres@txFontHeightF = 0.02
  gsn_text_ndc(wks, text, 0.01, 0.5, txres)

end
