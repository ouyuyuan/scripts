
; Description: sea surface height
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-04-10 16:41:49 BJT
; Last Change: 2014-04-11 20:49:16 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   ; directories <<<1

   data_dir = "/home/ou/archive/data/"
   draw_dir = "/home/ou/archive/drawing/pcom/phd_open/"
   filename = "calculated/ssh_trend.nc"

   ; data files <<<1

   f_s = addfile(data_dir + "soda/climate/" + filename, "r")
   f_p_n = addfile(data_dir + "pcom/climate/fix_fkh/" + filename, "r")
   f_p_r = addfile(data_dir + "pcom/climate/res_s/" + filename, "r")
   f_l = addfile(data_dir + "licom/climate/unmodified/" + filename, "r")

   ; data field <<<1

   h_s = f_s->ssh
   h_p_r = f_p_r->ssh
   h_p_n = f_p_n->ssh
   h_l = f_l->ssh

   h_s = h_s*1000
   h_p_r = h_p_r*1000
   h_p_n = h_p_n*1000
   h_l = h_l*1000

   h_s@units = "mm"
   h_p_r@units = "mm"
   h_p_n@units = "mm"
   h_l@units = "mm"

   time = h_s&time
   data = new( (/4, dimsizes(time)/), float)
   data(0,:) = h_s
   data(1,:) = h_p_r
   data(2,:) = h_p_n
   data(3,:) = h_l

   ; workstation <<<1

   wtype = "eps"
   img = draw_dir + str_sub_str( getenv("NCL_ARG_0"), ".ncl", "" )
   wks = gsn_open_wks(wtype, img)
;   gsn_define_colormap(wks,"BlueYellowRed")  ; choose color map
;   gsn_define_colormap(wks,"GMT_jet")  ; choose color map
;   gsn_define_colormap(wks,"NCL_default")  ; choose color map
   gsn_define_colormap(wks,"BlGrYeOrReVi200")  ; choose color map

   ; main res. <<<1

   res = True

   ; viewport  <<<2

   res@vpHeightF = 0.2

   ; title <<<2

   res@tiMainString = "Global mean sea surface height"
   res@tiYAxisString = "Sea surface height (mm)"

   ; xy <<<2

   res@xyMonoLineColor = False
   res@xyDashPattern = 0 ; solid
;   res@xyMarkLineMode = "MarkLines"
   res@xyMarkLineMode = "Lines"
;   res@xyMarkers = (/6, 11, 16/)
;   res@xyMarkerColors = (/"blue", "red", "green"/)
   res@xyLineColors = (/"black", "blue", "cyan", "red"/)
   res@xyLineThicknesses = (/3.,3.,3.,3./)
   res@xyDashPatterns = (/0.,0.,0.,0./)

   ; gsn <<<2
   ;
   res@gsnDraw = False
   res@gsnFrame = False
;   res@gsnMaximize = True
;   res@gsnLeftString = "mm"
   res@gsnLeftString = ""
;   res@gsnRightString = ""
;   res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 

   ; plot manager <<<2

;   res@pmLegendDisplayMode = "Always"
   ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
;   res@pmLabelBarWidthF = 0.5
;   res@pmLabelBarHeightF = 0.05
;   res@pmLabelBarOrthogonalPosF = 0.2


   ; tick mark  <<<2

   res@tmLabelAutoStride = True
   res@tmYROn = False
   res@tmXTOn = False
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

   ; gsn plot <<<1

   plot = gsn_csm_xy(wks, time, data, res)

   draw(plot)

   ; add legend <<<1
   txres               = True
   txres@txFontHeightF = 0.01
   text = "LICOM"
   gsn_text_ndc(wks, text, 0.25, 0.79, txres)

   text = "SODA"
   gsn_text_ndc(wks, text, 0.25, 0.73, txres)

   text = "PCOM, restored"
   gsn_text_ndc(wks, text, 0.28, 0.65, txres)

   text = "PCOM, natural"
   gsn_text_ndc(wks, text, 0.28, 0.61, txres)

   frame(wks)
   delete(wks)

   system("eps2png_trim " + img)
end
