
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 21:12:48 BJT
; Last Change: 2014-11-09 10:35:53 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  nc = getenv("NCL_ARG_1")
  img = getenv("NCL_ARG_2")
  fontheight = 0.012

  cmap = "BlGrYeOrReVi200"
;  cmap = "testcmap"
;  cmap = "NCV_blue_red"
  cmap = "NCl_default"
  wks = gsn_open_wks("eps", img)
  gsn_define_colormap(wks,cmap)

  f = addfile(nc, "r")
  cn = f->cn
  delete(f)

  res = True

;  res@vpHeightF = 0.45
;  res@vpWidthF = 0.73

  res@tiMainString = "Zonal Mean Wind Stress Anormaly Evolve with Time"
   res@gsnDraw = False
   res@gsnFrame = False
;   res@gsnSpreadColors      = False
;   res@gsnSpreadColorStart  = 30                 ; start at color 17
;   res@gsnSpreadColorEnd    = 180
   res@gsnLeftString = ""
   res@gsnRightString = ""

   res@cnFillOn             = True               ; turn on color for contours
   res@cnLinesOn            = False              ; turn off contour lines
;   res@cnLineThicknessF = 0.5
   res@cnLineLabelsOn       = False              ; turn off contour line labels
   res@cnInfoLabelOn        = False      ; turns off contour info label
;   res@cnLevelSelectionMode = "ExplicitLevels"
;   res@cnLevels = (/-0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6, 0.8, 1.0, 1.2, 1.4, \
;   1.6, 1.8, 2.0/)
;   res@cnFillColors = (/2,  8,14, 20, 30, 45,  60,  75,  90, 105, 120, 135, \
;   150, 165, 180/)          
;   res@cnFillMode = "RasterFill"

;   res@lbLabelBarOn = False
;   res@lbBoxLinesOn = False
   res@lbOrientation = "vertical"

;   res@pmLabelBarHeightF = 0.08
   res@pmLabelBarOrthogonalPosF = 0.02

   res@tmLabelAutoStride = False
   res@tmYROn = False
   res@tmXTOn = False

   res@cnLevelSelectionMode = "ManualLevels"
   res@cnMinLevelValF = -0.3
   res@cnMaxLevelValF = 0.3
   res@cnLevelSpacingF = 0.05
;   res@cnSpanFillPalette = True
;   res@cnFillPalette = "ncl_default"

   plot = gsn_csm_contour(wks, cn, res)
   draw(plot)
   frame(wks)

  delete(wks)
   system("eps2png_trim "+img)

end
