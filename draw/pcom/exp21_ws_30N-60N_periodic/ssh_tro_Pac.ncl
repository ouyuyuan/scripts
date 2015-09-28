
; Description: depth of thermocline
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-10 10:19:03 BJT
; Last Change: 2014-11-30 10:53:17 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  img = getenv("NCL_ARG_2")+getenv("NCL_ARG_0_base")
  datDir = getenv("NCL_ARG_1")
  nc = "climatory_y0061-y0120.nc"

  fontSize = 0.03
;  cmap = "NCV_blu_red"
;  cmap = "GMT_jet"
  cmap = "NCL_default"
  wks = gsn_open_wks("eps", img)
  gsn_define_colormap(wks,cmap)

  temp = 20.0
  latS = -20.5
  latN = 20.5
  lonW = 110.5
  lonE = 290.5

  f = addfile("/home/ou/archive/data/pcom/basin/basin.nc", "r")
  basin = f->basin({latS:latN},{lonW:lonE})
  delete(f)

  fname = datDir+"../../exp17_ws_control_cycle_re/post/"+nc
  f = addfile(fname, "r")
  ssh = f->ssh(0,{latS:latN},{lonW:lonE})
  delete(f)
  cn_ctr = ssh
  cn_ctr = smth9(cn_ctr, 0.5, 0.25, False)
  delete(ssh)
  cn_ctr = where(basin.eq.2, cn_ctr, cn_ctr@_FillValue)
  cn_ctr = cn_ctr*100
  cn_ctr@units = "cm"

  fname = datDir+nc
  f = addfile(fname, "r")
  ssh = f->ssh(0,{latS:latN},{lonW:lonE})
  delete(f)
  cn = ssh
  cn = smth9(cn, 0.5, 0.25, False)
  delete(ssh)
  cn = where(basin.eq.2, cn, cn@_FillValue)
  cn = cn*100
  cn@units = "cm"

  cn_diff = cn
  cn_diff = cn - cn_ctr

  plotWid = 0.9
  plotHei = 0.3
  cbWid = 0.8
  cbHei = 0.05
  cbMinMaxInc = (/0.,108.,1/)
;  yAxisTitle = ""

   res = True
  ; {{{ 
  res@vpHeightF = plotHei
  res@vpWidthF = plotWid

;  res@tiYAxisString = yAxisTitle
   res@gsnDraw = False
   res@gsnFrame = False
   res@gsnSpreadColors      = True               ; use full color map
   res@gsnAddCyclic = False
;   res@gsnSpreadColorStart  = 30                 ; start at color 17
   if (cmap.eq."NCL_default") then
    res@gsnSpreadColorEnd    = 230
   end if
   res@gsnLeftString = ""
   res@gsnRightString = ""

   res@cnFillOn             = True               ; turn on color for contours
   res@cnLinesOn            = False              ; turn off contour lines
;   res@cnLineThicknessF = 0.5
   res@cnLineLabelsOn       = False              ; turn off contour line labels
   res@cnInfoLabelOn        = False      ; turns off contour info label
   res@cnLevelSelectionMode = "ManualLevels"
   res@cnMinLevelValF       = cbMinMaxInc(0)
   res@cnMaxLevelValF       = cbMinMaxInc(1)
   res@cnLevelSpacingF      = cbMinMaxInc(2)
;  res@cnMissingValFillColor = "gray60"
;   res@cnFillMode = "RasterFill"

;   res@lbLabelBarOn = False
;   res@lbPerimOn                = False             ; no box around it
   res@lbLabelFontHeightF = fontSize
;   res@lbLabelStride            = 5
   res@lbLabelPosition = "Top"
   res@lbTitleString = cn@units
   res@lbTitlePosition = "Bottom"
   res@lbTitleFontHeightF = fontSize
   res@lbBoxLinesOn = False

   res@tmLabelAutoStride = False
   res@tmYROn = False
   res@tmXTOn = False
   res@tmXBOn = False
   res@tmYLLabelFontHeightF = fontSize
   res@tmXBLabelFontHeightF = fontSize
  res@tmYLMode = "Explicit"
  res@tmYLValues = (/-20, 0, 20/)
  res@tmYLLabels = (/"20~S~o~N~S","EQ","20~S~o~N~N"/)

   res@mpShapeMode = "FreeAspect"
   res@mpMinLatF = latS
   res@mpMaxLatF = latN
   res@mpMinLonF = lonW
   res@mpMaxLonF = lonE
   res@mpCenterLonF = 200

   res@pmLabelBarWidthF = cbWid
   res@pmLabelBarOrthogonalPosF = 0.2
;   res@pmLabelBarParallelPosF = lbPosRight
  ; }}}

   plot = new(3, graphic)
   plot(0) = gsn_csm_contour_map(wks, cn_ctr, res)
   res@lbLabelBarOn = False
   plot(1) = gsn_csm_contour_map(wks, cn, res)
   res@lbLabelBarOn = True
   res@lbBoxLinesOn = True
   res@cnLevelSelectionMode = "ExplicitLevels"
   res@cnLevels = \
   (/-0.5, -0.2, -0.05, \
   0, \
   0.05, 0.2, 0.5/)
   res@cnFillColors = \
    (/"magenta4", "blue2", "cyan1", \
    "azure",  "seashell", \
    "yellow2", "orange1", "red3"/)
   plot(2) = gsn_csm_contour_map(wks, cn_diff, res)

   resP = True
   ; {{{
   resP@gsnFrame = False
;   resP@gsnPanelLabelBar = True
;      resP@gsnPanelBottom = 0.05
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 5
   resP@gsnPanelRowSpec = True

   resP@pmLabelBarWidthF = cbWid
   resP@pmLabelBarHeightF = cbHei

;   resP@lbAutoManage = False
   resP@lbLabelFontHeightF = fontSize*0.8
;   resP@lbPerimOn   = True
;   resP@lbLabelAutoStride = True
   resP@lbLabelStride            = 5
;   resP@lbTitleString = "Verical mean sea salinity (psu)"
   resP@lbTitleFontHeightF = 0.013
   resP@lbBoxLinesOn = False
;   resP@lbLabelFontHeightF = 0.007
  resP@lbLabelPosition = "Top"
  ; }}}

;   resP@txString = "Sea surface salinity"

   gsn_panel(wks, plot, (/1,1,1/), resP)

  txres               = True
  txres@txFontHeightF = fontSize
;  text = "m"
;  gsn_text_ndc(wks, text, lbUnitPosX, lbUnitPosY, txres)

  delete(wks)
  system("eps2png_trim "+img)

end
