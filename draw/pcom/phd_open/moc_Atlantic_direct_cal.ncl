
; Description: Atlantic meridional overturning circulation 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-04-01 15:33:48 BJT
; Last Change: 2014-04-14 15:33:21 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; filter basin <<<1
; filter out other basin
undef("filter_basin")
procedure filter_basin( var[*][*][*]: numeric, basin_filename: string )
local f, basin, basin_conform
begin
   f = addfile( basin_filename, "r" )
   basin = f->basin
   delete(f)
   basin = where(basin.eq.2, 1, 0)

   basin_conform = conform( var, basin, (/1,2/) ) 
   var = var * basin_conform
end

; integrate from west to east <<<1
undef("int_w2e")
function int_w2e( var[*][*][*]: numeric )
local lat, lon, dx
begin
   lat = var&lat
   lon = var&lon
   torad = 3.14159265 / 180
   r = 6371220.0
   dlon = abs(lon(2) - lon(1)) * torad * r
   dx = dlon*cos(lat*torad)

   dx_conform = conform(var, dx, 1)
   intvar = dim_sum_n_Wrap(var*dx_conform, 2)

   lev = var&$var!0$

   intvar!0 = "lev"
   intvar!1 = "lat"
   intvar&lev = lev
   intvar&lat = lat
   
   return intvar
end

; indefinite integrate from top to bottom <<<1
undef("int_t2b")
function int_t2b( var[*][*]: numeric )
local lev, nlev, dz, dz_conform, i, t
begin
   lev  = var&$var!0$
   nlev = dimsizes(lev)
   dz = lev*0
   dz(0) = lev(0) * 2
   do i = 1, nlev - 1
      dz(i) = (lev(i) - sum(dz)) * 2
      if (dz(i) .lt. 0) then
         print("thickness of layer is not positive! stop.")
         return
      end if
   end do
   delete(lev)

   dz_conform = conform(var, dz, 0)
   delete(dz)

   t = var
   t = var*dz_conform
   int = t*0
   copy_VarMeta(var, int)
   do i = 0, nlev - 1
      int(i,:) = dim_sum_n_Wrap(t(0:i,:), 0)
   end do
   delete(t)

   int = where(ismissing(var) .eq. "True", var@_FillValue, int)
   int = smth9_Wrap(int, 0.5, 0.25, True)

   return int
end

begin
   
   ; dirs, files <<<1

   draw_dir = "/home/ou/archive/drawing/pcom/phd_open/"
   data_dir = "/home/ou/archive/data/"

   filename_s = data_dir + "soda/climate/climate_1981-2000.nc"
;   filename_p = data_dir + "pcom/climate/fix_fkh/year_mean_081-100_soda_level.nc"
   filename_p = data_dir + "pcom/climate/res_s/year_mean_081-100_soda_level.nc"
   filename_l = data_dir + "licom/climate/unmodified/climate_081-100_soda_level.nc"

;   str = "basin_Atlantic_hand_modified.nc"
   str = "basin_hand.nc"
   filename_basin_s = data_dir + "soda/" + str
;   filename_basin_p = data_dir + "pcom/" + str
   filename_basin_p = data_dir + "pcom/" + str
   filename_basin_l = data_dir + "licom/" + str
;   filename_basin_l = data_dir + "licom/basin_Atlantic_hand_modified.nc"
   delete(str)

   ; data field <<<1

   f = addfile( filename_s, "r" )
   v_s = f->v
   delete(f)

   f = addfile( filename_p, "r" )
   v_p = f->v(0, :, :, :)
   delete(f)

   f = addfile( filename_l, "r" )
   lev = f->lev
   v_l = f->vs(0, :, ::-1, 0:359)
   v_l&lev = lev
   delete(f)

   filter_basin( v_s, filename_basin_s )
   filter_basin( v_p, filename_basin_p )
   filter_basin( v_l, filename_basin_l )

   cn_s = int_t2b( int_w2e(v_s) )
   cn_p = int_t2b( int_w2e(v_p) )
   cn_l = int_t2b( int_w2e(v_l) )
   cn_s = cn_s * 10^(-6)
   cn_p = cn_p * 10^(-6)
   cn_l = cn_l * 10^(-6)
   delete(v_s)
   delete(v_p)
   delete(v_l)

   ; workstation <<<1

   wtype = "eps"
   img = draw_dir + str_sub_str(getenv("NCL_ARG_0"),".ncl","")
   wks = gsn_open_wks(wtype, img)
;   gsn_define_colormap(wks,"BlueYellowRed")  ; choose color map
;   gsn_define_colormap(wks,"cmp_b2r")  ; choose color map
;   gsn_define_colormap(wks,"ncl_default")  ; choose color map
   gsn_define_colormap(wks,"BlGrYeOrReVi200")  ; choose color map

   ; main res. <<<1

   res = True

   ; title  <<<2

;   res@tiXAxisString = "latitude"
   res@tiYAxisString = "depth (m)"
   res@tiMainFontHeightF = 0.05

   ; viewport  <<<2

   res@vpWidthF = 1.5

   ; gsn <<<2
   ;
   res@gsnDraw = False
   res@gsnFrame = False
;   res@gsnMaximize = True
   res@gsnSpreadColors      = True               ; use full color map
;   res@gsnSpreadColorStart  = 30                 ; start at color 17
   res@gsnSpreadColorEnd    = 180 ; end at color 200
   res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 
;   res@gsnYAxisIrregular2Log = True   ; converts irreg depth to linear 
   res@gsnLeftString = ""
   res@gsnRightString = ""
   res@gsnLeftStringOrthogonalPosF = 0.03
   res@gsnRightStringOrthogonalPosF = 0.03

   ; contour <<<2
   ;
   res@cnFillOn             = True               ; turn on color for contours
   res@cnLinesOn            = False              ; turn off contour lines
   res@cnLineLabelsOn       = False              ; turn off contour line labels
   res@cnInfoLabelOn        = False      ; turns off contour info label
   res@cnLevelSelectionMode = "ManualLevels"
   res@cnMaxLevelValF       = 20 ; set max contour level
   res@cnMinLevelValF       = -8 ; set min contour level
   res@cnLevelSpacingF = 1
   res@cnMissingValFillColor = "black"

   ; label bar <<<2

;   res@lbLabelBarOn = False
;   res@lbOrientation            = "Vertical"     ; vertical label bar
   res@lbPerimOn                = False             ; no box around it
   ;    res@lbLabelStride            = 4

   ; plot manager <<<2

   ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
   ;    res@pmLabelBarWidthF         = 0.08              ; make it thinner
   res@pmLabelBarOrthogonalPosF = 0.04          ; move label bar closer

   ; map  <<<2

;   res@mpLandFillColor          = "gray"            ; set land to be gray
;   res@mpMinLonF = 0
;   res@mpMaxLonF = 360
;   res@mpCenterLonF = 200

   ; tick mark  <<<2

   res@tmLabelAutoStride = True
   res@tmYROn = False
   res@tmXTOn = False
;   res@tmYLMode = "Manual"
;   res@tmYLTickStartF    = 100.
;   res@tmYLTickSpacingF  = 100.
;   res@tmXBMode = "Manual"
;   res@tmXBTickSpacingF = 5
;   res@tmXBTickStartF    = -75
;   res@tmXBTickEndF      = 75
;   res@tmYLTickEndF      = 300.

   ; transformation <<<2

   res@trYMaxF = 5000
   res@trYMinF = 0
   res@trXMaxF = 60
   res@trXMinF = -32
   res@trYReverse               = True   ; reverses y-axis

   ; individual res. <<<1

   res_s = res
   res_p = res
   res_l = res

   res_s@tiMainString = "Reanalysis (SODA)"
   res_p@tiMainString = "PCOM"
   res_l@tiMainString = "LICOM"
   res_l@gsnXAxisIrregular2Linear = True   ; converts irreg latitude to linear 

   ; gsn plot <<<1

   plot = new(3, graphic)
   plot(0) = gsn_csm_contour(wks, cn_s, res_s)
   plot(1) = gsn_csm_contour(wks, cn_p, res_p)
   plot(2) = gsn_csm_contour(wks, cn_l, res_l)

   ; gsn panel <<<1

   resP = True
   resP@gsnFrame = False
;      resP@gsnPanelDebug = True
   resP@gsnPanelLabelBar = True
;      resP@gsnPanelBottom = 0.05
   resP@gsnPanelRowSpec = True
   resP@gsnPanelXWhiteSpacePercent = 10
   resP@gsnPanelYWhiteSpacePercent = 5

;   resP@pmLabelBarWidthF = 0.6
   resP@pmLabelBarWidthF = 0.6
;   resP@pmLabelBarHeightF = 0.05
   resP@pmLabelBarOrthogonalPosF = -0.025 ; let label bar a bit far

;   resP@lbOrientation = "Vertical"     ; vertical label bar
   resP@lbLabelFontHeightF = 0.013
;   resP@lbLabelAutoStride = True
   resP@lbTitleString = "Atlantic meridional overturning circulation (Sv)"
   resP@lbTitleFontHeightF = 0.013
   resP@lbTitleOffsetF = 0.03
;   resP@lbTitlePosition = "Right"

;   resP@txString = "Meridional overturning circulation, " + basin

   gsn_panel(wks, plot, (/1,2/), resP)

   ; label bar text  <<<1

;   txres               = True
;   txres@txFontHeightF = 0.015
;   text = "zonal current (m/s)"
;   gsn_text_ndc(wks, text, 0.5, 0.11, txres)
   
;   text = "climate mean"
;   gsn_text_ndc(wks, text, 0.2, 0.05, txres)
   frame(wks)

   delete(wks)

   system("eps2png_trim " + img)

end
