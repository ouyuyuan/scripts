
; Description: Boundary forcing of SSS in PCOM
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-04-10 16:41:49 BJT
; Last Change: 2014-07-15 08:12:53 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;  final = False
  final = True

  cmap = "BlGrYeOrReVi200"
;  cmap = "testcmap"
;  cmap = "NCL_default"
;  cmap = "BlRe"
;  cmap = "hotres"
;  cmap = "precip_11lev"

  data_dir = "/home/ou/archive/data/pcom/input"
  draw_dir = "/home/ou/archive/drawing/pcom/core"
  img      = draw_dir + "/sss_obs_pcom"
  fname    = data_dir + "/pcom_bcf_mn.nc"

  wks = gsn_open_wks ("eps", img)
  gsn_define_colormap(wks, cmap)

  f = addfile( fname, "r" )
  bcs = f->bcs(:,:,:)
  lon = f->lon
  cn0 = dim_avg_n_Wrap( bcs, 0 )
  delete(f)

  ; shift lontitude to match CORE coordinates
  nlon = dimsizes(lon)
  idx = ind( lon.eq.100.5 )
  cn = cn0
  cn(:,0:nlon-idx-1) = cn0(:,idx:nlon-1)
  cn(:,nlon-idx:nlon-1) = cn0(:,0:idx-1)
;  exit

  res = True
  ; resource{{{

  res@vpWidthF = 0.7
  res@vpHeightF = res@vpWidthF * (3.6/4.5)
  res@vpXF = 0.15

  res@tiMainString = "OBS SSS (PCOM)"
  res@tiMainFontHeightF = 0.04

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
  ;   res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 

  ; contour <<<2
  ;
  res@cnFillOn             = True               ; turn on color for contours
  res@cnLinesOn            = False              ; turn off contour lines
  ;   res@cnLineThicknessF = 0.5
  res@cnLineLabelsOn       = False              ; turn off contour line labels
  res@cnInfoLabelOn        = False      ; turns off contour info label
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMaxLevelValF       = 42.               ; set max contour level
  res@cnMinLevelValF       = 28.               ; set min contour level
  res@cnLevelSpacingF = 0.5
  res@cnMissingValFillColor = "black"

  ; label bar <<<2

;  res@lbLabelBarOn = False
  res@lbOrientation            = "Vertical"     ; vertical label bar
  res@lbPerimOn                = False             ; no box around it
  res@lbLabelFontHeightF = 0.02
  ;   res@lbBoxLinesOn = False
  ;    res@lbLabelStride            = 4

  ; plot manager <<<2

  ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
  ;    res@pmLabelBarWidthF         = 0.08              ; make it thinner
  res@pmLabelBarHeightF = 0.6
  res@pmLabelBarOrthogonalPosF = -0.001

  ; map  <<<2

  ;   res@mpLandFillColor          = "gray"            ; set land to be gray
  ;   res@mpMinLonF = 0
  ;   res@mpMaxLonF = 360
;  res@mpCenterLonF = 180

  ; tick mark  <<<2

  res@tmLabelAutoStride = True
;  res@tmYROn = False
;  res@tmXTOn = False
;  res@tmXBOn = False
  res@tmXBLabelsOn = False
  ;   res@tmYLMode = "Manual"
  ;   res@tmYLTickStartF    = 100.
  ;   res@tmYLTickSpacingF  = 100.
  ;   res@tmXBMode = "Manual"
  ;   res@tmXBTickSpacingF = 5
  ;   res@tmXBTickStartF    = -25
  ;   res@tmXBTickEndF      = 25
  ;   res@tmYLTickEndF      = 300.

  ; transformation <<<2

  ;   res@trYMaxF = 500.
  ;   res@trXMaxF = 25
  ;   res@trXMinF = -25
  ;   res@trYReverse               = True   ; reverses y-axis
  ;}}}

  plot = gsn_csm_contour(wks, cn, res)

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
