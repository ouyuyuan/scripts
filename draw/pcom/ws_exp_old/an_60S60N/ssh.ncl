
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-26 09:22:54 BJT
; Last Change: 2014-11-12 21:14:11 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure draw_ssh(img, cn, inres, arg)
begin

  fontheight = 0.015
  cmap = "NCL_default"
  wks = gsn_open_wks("eps", img)
  gsn_define_colormap(wks,cmap)

  cn = 10 * cn
  cn@units = "mm"

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
   res@cnLinesOn            = False              ; turn off contour lines
;   res@cnLineThicknessF = 0.5
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
  res@lbTitleString = "(mm)"
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
cnc = f->control
cne = f->an_60S60N

cnd = cne 
cnd = cne - cnc
delete(f)

; control run
;====================
arg@title = "sea surface height (SSH), control run"
arg@cnLevels = (/10.,-10.,2./)
;draw_ssh(img+"___ctr", cnc, res, arg)

; experiment
;====================
arg@title = "sea surface height (SSH), exp_60S-60N"
;draw_ssh(img+"___60S60N", cne, res, arg)

; different
;====================
arg@title = "sea surface height (SSH), (exp_60S-60N) - (control run)"
arg@cnLevels = (/1.6,-1.6,0.2/)
res@cnFillMode = "RasterFill"
draw_ssh(img+"___diff", cnd, res, arg)
