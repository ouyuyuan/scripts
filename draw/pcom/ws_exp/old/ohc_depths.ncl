
; Description: integrated OHC at varying depth, follows Chen2014, Fig.1
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:56:55 BJT
; Last Change: 2014-12-07 20:14:00 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

function get_ohc_depths(f, prefix)
local time
begin
  time = f->time
  time = time - 500
  nt = dimsizes(time)
  ohc = new((/13, nt/), float)
  do i = 0, 12
    varName = prefix+"_"+(i+3)*100
    ohc(i,:) = f->$varName$
  end do
;  ohc = ohc(:,::-1)

  ohc!1 = "time"
  ohc&time = time
  ohc = dim_rmvmean_n(ohc,1)
;  ohc = dtrend_n(ohc,False,1)
  ohc = ohc*1e-23
  ohc@units = "10~S~23~N~J"

  return ohc
end

function get_sst(f, varName)
begin
  sst = f->$varName$
  sst = dtrend_n(sst,False,0)
  sst = sst*1e2
  sst@units = "10~S~-2 o~N~C"
  return sst
end

begin
  nc = getenv("NCL_ARG_1")+"ohc.nc"
  img = getenv("NCL_ARG_2")+getenv("NCL_ARG_0_base")
;  cmap = "NCL_default"
;  cmap = "GMT_jet"
  cmap = "WhiteBlueGreenYellowRed"
;  cmap = "NCV_jet"
;  cmap = "MPL_jet"

  f = addfile( nc, "r" )
  time = f->time
  time = time - 500
  ny = dimsizes(time)
  ohc_glo = get_ohc_depths(f, "ohc_glo")
  ohc_Atl = get_ohc_depths(f, "ohc_Atl")
  ohc_Sou = get_ohc_depths(f, "ohc_Sou")
  ohc_Pac = get_ohc_depths(f, "ohc_Pac")
  ohc_Ind = get_ohc_depths(f, "ohc_Ind")
  delete(f)

  nc = getenv("NCL_ARG_1")+"sst.nc"
  f = addfile( nc, "r" )
  sst_glo = get_sst(f, "sst_glo")
  sst_Atl = get_sst(f, "sst_Atl")
  sst_Sou = get_sst(f, "sst_Sou")
  sst_Pac = get_sst(f, "sst_Pac")
  sst_Ind = get_sst(f, "sst_Ind")
  delete(f)

  fontSize = 0.03
  yLabelSize = fontSize
  xLabelSize = fontSize
  plotWid = 0.8
  plotHei = 0.4
  yTitle = "OHC: "+ohc_glo@units
  yTitle_sst = "SSTa: "+sst_glo@units
  xTitle = "model year"
;  xTicks = (/450, 475, 500, 525, 550, 575, 600, 625, 650/)

  wks = gsn_open_wks ("eps", img)
  gsn_define_colormap(wks,cmap)

   res = True
  ; {{{

  res@vpWidthF = plotWid
  res@vpHeightF = plotHei
;  res@vpXF = 0.2
;  res@vpYF = 0.9

  res@tiYAxisString = yTitle
  res@tiXAxisString = ""
  res@tiXAxisFontHeightF = fontSize

  res@gsnDraw = False
  res@gsnFrame = False
  res@gsnLeftString = ""
  res@gsnRightString = ""
  res@gsnYRefLine = 0.
;  res@gsnAboveYRefLineColor = "IndianRed2"
;  res@gsnBelowYRefLineColor = "SteelBlue2"
  res@gsnCenterString = ""
  res@gsnStringFontHeightF = fontSize
  res@gsnCenterStringOrthogonalPosF = 0.1

  res@xyMonoLineColor = False
  res@xyDashPattern = 0 ; solid
  ;   res@xyMarkLineMode = "MarkLines"
  res@xyMarkLineMode = "Lines"
  ;   res@xyMarkers = (/6, 11, 16/)
;  res@xyMarkerColors = (/"blue", "red"/)
  res@xyLineColors = floattoint( fspan(70., 170., 13) )
;  res@xyLineColor = "blue3"
  res@xyLineThicknessF = 2.

;  res@tmLabelAutoStride = True
  
;  res@tmYMajorGrid = True
;  res@tmYMajorGridLineDashPattern = 2
;  res@tmYMajorGridThicknessF = 0.5

;  res@tmXTOn = False
;  res@tmYROn = False

;  res@tmYLTickStartF   = -80
;  res@tmYLTickSpacingF = 20
;  res@tmYLTickEndF     = 80
;  res@tmXMajorGridThicknessF = 0.5

  res@tmYLLabelFontHeightF = yLabelSize 
  res@tmYLMode = "Explicit"
  res@tmYLValues = (/-0.6,0.,0.6/)
  res@tmYLLabels = res@tmYLValues

;  res@tmYUseLeft = False
;  res@tmYRLabelsOn = True
;  res@tmYRLabelFontHeightF = yLabelSize 
;  res@tmYROn = True
;  rticks = (/-0.00008, 0, 0.00008/)
;  res@tmYRMode = "Explicit"
;  res@tmYRValues = rticks*y_mean + y_mean
;  res@tmYRLabels = (/"- 0.00008", "0", "0.00008"/)

  res@tmXBLabelFontHeightF = xLabelSize
;  res@tmXBMode = "Explicit"
;  res@tmXBValues = xTicks
;  res@tmXBLabels = xTicks

  ; }}}

  plot = new(6, graphic)

  res_sst = res
  res_sst@xyLineThicknessF = 1.5
  res_sst@tmYRMode = "Explicit"
  res_sst@tiYAxisString = "SSTa: ~S~o~N~C"
  delete(res_sst@xyLineColors)
  res_sst@tmYRValues = (/-0.6, 0., 0.6/)
  res_sst@tmYRLabels = res_sst@tmYRValues
  res_sst@trYMaxF = 1.5
  res_sst@trYMinF = - res_sst@trYMaxF

  res_ohc = res
  res_ohc@gsnCenterString = "A - Global Ocean"
  res_ohc@tmYLValues = (/ -0.4,0.,0.4/)
  res_ohc@tmYLLabels = res_ohc@tmYLValues
  res_ohc@trYMaxF = 0.6
  res_ohc@trYMinF = - res_ohc@trYMaxF

  plot(1) = gsn_csm_xy2(wks, time, ohc_glo, sst_glo, res_ohc, res_sst)

  res_ohc@gsnCenterString = "B - Atlantic"

  res_sst@tiYAxisString = ""
  plot(2) = gsn_csm_xy2(wks, time, ohc_Atl, sst_Atl, res_ohc, res_sst)

  res_ohc@tiYAxisString = ""
  res_ohc@gsnCenterString = "D - Southern Ocean"

  res_sst@tiYAxisString = yTitle_sst
  plot(3) = gsn_csm_xy2(wks, time, ohc_Sou, sst_Sou, res_ohc, res_sst)

  res_ohc@gsnCenterString = "C - Pacific"
  res_ohc@tiXAxisString = xTitle
  res_ohc@tiYAxisString = yTitle

  res_sst@tiYAxisString = ""
  plot(4) = gsn_csm_xy2(wks, time, ohc_Pac, sst_Pac, res_ohc, res_sst)

  res_ohc@gsnCenterString = "E - Indian Ocean"
  res_ohc@tiYAxisString = ""

  res_sst@tiYAxisString = yTitle_sst
  plot(5) = gsn_csm_xy2(wks, time, ohc_Ind, sst_Ind, res_ohc, res_sst)

   resP = True
   resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
   resP@gsnPanelXWhiteSpacePercent = 0
   resP@gsnPanelYWhiteSpacePercent = 5
   resP@gsnPanelRowSpec = True
;   resP@txString = "Sea surface salinity"
  gsn_panel(wks, plot, (/2,2,2,2/), resP)

  txres               = True
  txres@txFontHeightF = fontSize*0.5
  texts = (/ "0~~300 m", "  ~~400 m", "  ~~500 m", "  ~~600 m", "  ~~700 m", \
    "  ~~800 m", "  ~~900 m", "  ~~1000 m", "  ~~1100 m", "  ~~1200 m", \
    "  ~~1300 m", "  ~~1400 m", "  ~~1500 m"/)
  dposy = 0.03
  dposx = 0.1

  posx = 0.2
  posy = 0.95
  txres@txFontColor = res@xyLineColors(0)
  gsn_text_ndc(wks, texts(0), posx, posy, txres)
  do i = 1, 5
    txres@txFontColor = res@xyLineColors(i)
    posy = posy - dposy
    gsn_text_ndc(wks, texts(i), posx, posy, txres)
  end do

  posx = posx + dposx
  posy = 0.95
  txres@txFontColor = res@xyLineColors(6)
  gsn_text_ndc(wks, texts(6), posx, posy, txres)
  do i = 7, 11
    txres@txFontColor = res@xyLineColors(i)
    posy = posy - dposy
    gsn_text_ndc(wks, texts(i), posx, posy, txres)
  end do

  posx = posx + dposx
  posy = 0.95
  txres@txFontColor = res@xyLineColors(12)
  gsn_text_ndc(wks, texts(12), posx, posy, txres)

  posy = posy - dposy
;  delete(txres@txFontColor)
  txres@txFontColor = 1
  gsn_text_ndc(wks, "  SSTa", posx, posy, txres)

  frame(wks)
  delete(wks)
  system("eps2png_trim "+img)

end
