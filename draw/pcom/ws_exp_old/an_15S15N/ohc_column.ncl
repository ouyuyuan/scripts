
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-12 19:07:54 BJT
; Last Change: 2014-11-17 09:26:25 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure draw_ohc(img, cn, inres, arg)
begin

  fontheight = 0.015
  cmap = "NCL_default"
  wks = gsn_open_wks("eps", img)
  gsn_define_colormap(wks,cmap)

  cn = smth9( cn, 0.5, 0.25, False )

   res = True

  res@tiMainString = arg@title
  res@vpHeightF = 0.4
  res@vpWidthF = 0.8

   res@tiMainFontHeightF = fontheight*1.2

   res@gsnDraw = False
   res@gsnFrame = False
   res@gsnSpreadColors      = True               ; use full color map
;   res@gsnSpreadColorStart  = 30                 ; start at color 17
;   res@gsnSpreadColorEnd    = 180
   res@gsnLeftString = ""
   res@gsnRightString = ""

   res@cnFillOn             = True               ; turn on color for contours
   res@cnLinesOn            = True
   res@cnLineThicknessF = 0.5
   res@cnLineLabelsOn       = False              ; turn off contour line labels
   res@cnInfoLabelOn        = False      ; turns off contour info label
   res@cnLevelSelectionMode = "ManualLevels"
   res@cnMaxLevelValF       =  arg@cnLevels(0)
   res@cnMinLevelValF       =  arg@cnLevels(1)
   res@cnLevelSpacingF = arg@cnLevels(2)
;  res@cnMissingValFillColor = "gray60"
;   res@cnFillMode = "RasterFill"

   res@tmYLLabelFontHeightF = fontheight
   res@tmXBLabelFontHeightF = fontheight
   res@tmXBLabelStride  = 2

;   res@lbLabelBarOn = False
;   res@lbAutoManage = False
   res@lbLabelFontHeightF = fontheight
   res@lbTitleFontHeightF = fontheight
   res@lbPerimOn                = False             ; no box around it
;  res@lbTitleString = "(m)"
  res@lbTitlePosition = "bottom"

;   res@pmLabelBarWidthF = 0.05
;   res@pmLabelBarHeightF = 0.7
   res@pmLabelBarOrthogonalPosF = 0.1

;   res@mpLandFillColor          = "gray"            ; set land to be gray
;   res@mpMinLonF = 0
;   res@mpMaxLonF = 360
   res@mpShapeMode = "FreeAspect"
   res@mpMinLatF = -80
   res@mpMaxLatF = 80
   res@mpCenterLonF = 200

   copy_VarAtts(inres, res)

   plot = gsn_csm_contour_map(wks, cn, res)
   
   draw(plot)
   frame(wks)

  delete(wks)
  system("eps2png_trim " + img)

end

nc = getenv("NCL_ARG_1")
img = getenv("NCL_ARG_2")
res = True
arg = True

f = addfile(nc, "r")
cnc_700 = f->ctr_700
cnc_2000 = f->ctr_2000
cne_700 = f->an_15S15N_700
cne_2000 = f->an_15S15N_2000
delete(f)

cnd_700 = cnc_700 
cnd_2000 = cnc_2000 
cnd_700 = cne_700 - cnc_700
cnd_2000 = cne_2000 - cnc_2000

; control run
;====================
arg@title = "0-700m OHC, unit water column,  control run"
arg@cnLevels = (/55.,0.,5/)
res@lbTitleString = "(10~S~9~N~J)"
cnc_700 = cnc_700*1e-9
draw_ohc(img+"___ctr_700", cnc_700, res, arg)

; experiment
;====================
arg@title = "0-700m OHC, unit water column, exp_15S-15N"
cne_700 = cne_700*1e-9
draw_ohc(img+"___15S15N_700", cne_700, res, arg)

; different
;====================
arg@title = "0-700m OHC, (exp_15S-15N) - (control run)"
cnd_700 = cnd_700*1e-9
arg@cnLevels = (/2.,-2.,0.2/)
res@cnLinesOn  = False
res@cnFillMode = "RasterFill"
draw_ohc(img+"___diff", cnd_700, res, arg)
