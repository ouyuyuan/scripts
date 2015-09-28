
; Description: vertical mean temperature
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-03-14 18:25:34 BJT
; Last Change: 2014-04-16 14:38:10 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; cal. vertical mean <<<1
; assume value is on the center of each layer

function cal_ver_mean(var:numeric)
local nlev, dlev, weight, wgt_con
begin

   lev = var&$var!0$
   nlev = dimsizes(lev)
   dlev = lev*0
   dlev(0) = lev(0) * 2
   do i = 1, nlev - 1
      dlev(i) = (lev(i) - sum(dlev)) * 2
      if (dlev(i) .lt. 0) then
         print("thickness of layer is not positive! stop.")
         return
      end if
   end do
;   print(dlev+0)

   if ( isdouble(dlev) ) then
      weight = doubletofloat(dlev/sum(dlev))
   else
      weight = dlev/sum(dlev)
   end if

   wgt_con = conform_dims(dimsizes(var), weight, 0)

   mean = dim_sum_n( var*wgt_con, 0 )

   mean!0 = "lat"
   mean!1 = "lon"
   mean&lat = var&lat
   mean&lon = var&lon

   return mean

end

begin

   ; directories <<<1

   data_dir = "/home/ou/archive/data/"
   draw_dir = "/home/ou/archive/drawing/pcom/phd_open/"

   ; data files <<<1

   f_s = addfile(data_dir + "soda/climate/climate_1981-2000.nc", "r")
;   f_p = addfile(data_dir + "pcom/climate/fix_fkh/year_mean_081-100_soda_level.nc", "r")
   f_p = addfile(data_dir + "pcom/climate/res_s/year_mean_081-100_soda_level.nc", "r")
;;;   f_p = addfile(data_dir + "pcom/climate/res_s/year_mean_081-100.nc", "r")
;   f_l = addfile(data_dir + "licom/climate/unmodified/climate_081-100_positive_level.nc", "r")
   f_l = addfile(data_dir + "licom/climate/unmodified/climate_081-100_soda_level.nc", "r")

   ; workstation <<<1

   wtype = "eps"
   img = draw_dir + str_sub_str( getenv("NCL_ARG_0"), ".ncl", "" )
   wks = gsn_open_wks(wtype, img)
;   gsn_define_colormap(wks,"BlueYellowRed")  ; choose color map
;   gsn_define_colormap(wks,"GMT_jet")  ; choose color map
;   gsn_define_colormap(wks,"NCL_default")  ; choose color map
   gsn_define_colormap(wks,"BlGrYeOrReVi200")  ; choose color map

   ; data field <<<1

   t_s = f_s->temp
   t_p = f_p->pt(0, :, :, :)
   t_l = f_l->ts(0, :, ::-1, 0:359)

   cn_s = cal_ver_mean(t_s)
   cn_p = cal_ver_mean(t_p)
   cn_l = cal_ver_mean(t_l)

   ; main res. <<<1

   res = True

   ; gsn <<<2
   ;
   res@gsnDraw = False
   res@gsnFrame = False
;   res@gsnMaximize = True
   res@gsnSpreadColors      = True               ; use full color map
;   res@gsnSpreadColorStart  = 30                 ; start at color 17
   res@gsnSpreadColorEnd    = 180
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
   res@cnMaxLevelValF       = 5.               ; set max contour level
   res@cnMinLevelValF       = 0.               ; set min contour level
   res@cnLevelSpacingF = 1
;   res@cnFillMode = "RasterFill"

   ; label bar <<<2

   res@lbLabelBarOn = False
;   res@lbOrientation            = "Vertical"     ; vertical label bar
   res@lbPerimOn                = False             ; no box around it

;   res@lbBoxLinesOn = False
   ;    res@lbLabelStride            = 4

   ; plot manager <<<2

   ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
;   res@pmLabelBarWidthF = 0.5
;   res@pmLabelBarHeightF = 0.05
;   res@pmLabelBarOrthogonalPosF = 0.2

   ; map  <<<2

;   res@mpLandFillColor          = "gray"            ; set land to be gray
;   res@mpMinLonF = 0
;   res@mpMaxLonF = 360
   res@mpCenterLonF = 180

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

   ; individual res. <<<1

   res_s = res
   res_s@tiMainString = "Re-analysis (SODA)"

   res_p = res
   res_p@tiMainString = "PCOM"

   res_l = res
   res_l@tiMainString = "LICOM"
;   res_l@gsnAddCyclic = False
;   res_l@gsnYAxisIrregular2Linear = True   ; converts irreg latitude to linear 

   ; gsn plot <<<1

   plot = new(3, graphic)
   plot(0) = gsn_csm_contour_map_ce(wks, cn_s, res_s)
   plot(1) = gsn_csm_contour_map_ce(wks, cn_p, res_p)
   plot(2) = gsn_csm_contour_map_ce(wks, cn_l, res_l)

   ; gsn panel <<<1

   ; panel <<<2
   
   resP = True
   resP@gsnFrame = False
;      resP@gsnPanelDebug = True
   resP@gsnPanelLabelBar = True
;      resP@gsnPanelBottom = 0.05
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 10
   resP@gsnPanelRowSpec = True

   resP@pmLabelBarWidthF = 0.4
   resP@pmLabelBarHeightF = 0.04
   resP@pmLabelBarOrthogonalPosF = -0.01

   resP@lbLabelFontHeightF = 0.013
   resP@lbLabelAutoStride = True
   resP@lbTitleString = "Verical mean sea temperature ( ~S~o~N~C )"
   resP@lbTitleFontHeightF = 0.013
;   resP@lbBoxLinesOn = False
;   resP@lbLabelFontHeightF = 0.007

;   resP@txString = "Sea surface temperature"

   gsn_panel(wks, plot, (/1,2/), resP)

   frame(wks)

   delete(wks)

   system("eps2png_trim " + img)
end
