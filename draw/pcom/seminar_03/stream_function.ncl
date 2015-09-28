
; Description: baratropic stream function
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-01-02 10:23:02 BJT
; Last Change: 2014-01-04 21:48:41 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   ; data <<<1

   data_dir = "/home/ou/archive/data"
   licom_dir = data_dir + "/licom/climate/unmodified"
   pcom_dir = data_dir + "/pcom/climate/exp_05"

;   f = addfile(pcom_dir + "/year_mean_351-380.nc", "r")
   f = addfile(licom_dir + "/climate_081-100_woa_grid_hori_positive_level.nc", "r")

;   u = f->u(0, :, :, :)
;   v = f->v(0, :, :, :)
;   lat = f->lat(:)
;   lon = f->lon(:)
;   z = f->z(:)

   u = f->us(0, :, :, :)
   v = f->vs(0, :, :, :)
   lat = f->lat(:)
   lon = f->lon(:)
   z = f->lev(:)

   ; cal. stream function <<<2

   ; cal. layer thickness <<<3
   ; assume z locate at the middle of each layer except the first

   nz = dimsizes(z)
   nx = dimsizes(lon)
   ny = dimsizes(lat)

   layer = new(nz, float)
   layer = 0
   layer(0) = ( z(0) + z(1) ) / 2.0    ; make layer more 'uniform'

   do i = 1, nz - 1
      layer(i) = (z(i)-sum(layer)) * 2.0
      if ( layer(i) .le. 0 ) then
         print("Layer thickness less then zero. Stop.")
         return
      end if
   end do

   ; cal. U, V <<<3

   u_intz = new((/ny,nx/), float)
   v_intz = new((/ny,nx/), float)

   do j = 0, ny-1
      do i = 0, nx-1
         u_intz(j,i) = sum(u(:,j,i)*layer)
         v_intz(j,i) = sum(v(:,j,i)*layer)
      end do
   end do

   ; cal. phi <<<3

   a = 6371.0*10^3 ; radius of the earth
   pi = 3.14159265

   lat = lat/180.0 * pi
   lon = lon/180.0 * pi

   dlat = lat(1) - lat(0)
   dlon = lon(1) - lon(0)

   phi = new((/ny,nx/), double)
   do j = 0, ny - 1
      do i = 0, nx - 1
         phi(j,i) = sum( v_intz(j,:) * a * dlon * cos(lat(j)) ) - sum( u_intz(:,i) * a * dlat )
      end do
   end do

   phi = phi*10^(-6)
   phi@long_name = "barotropic stream function"
   phi@units = "Sv"
   phi!0 = "lat"
   phi!1 = "lon"
   phi&lat = f->lat
   phi&lon = f->lon

;   printVarSummary(phi)

   ; workstation <<<1

   wtype = "eps"
   img_dir = "/home/ou/archive/drawing/pcom/seminar_03"
   img = img_dir + "/stream_function"
   wks = gsn_open_wks(wtype, img)
   gsn_define_colormap(wks,"BlueYellowRed")  ; choose color map
;   gsn_define_colormap(wks,"BlGrYeOrReVi200")  ; choose color map
;   gsn_define_colormap(wks,"ncl_default")  ; choose color map

   ; main res. <<<1

   res = True

   ; gsn <<<2
   ;
;   res@gsnDraw = False
;   res@gsnFrame = False
;   res@gsnMaximize = True
   res@gsnSpreadColors      = True               ; use full color map
;   res@gsnSpreadColorStart  = 30                 ; start at color 17
;   res@gsnSpreadColorEnd    = 240                ; end at color 200
;   res@gsnSpreadColorEnd    = 180                ; end at color 200

   ; contour <<<2
   ;
   res@cnFillOn             = True               ; turn on color for contours
   res@cnLinesOn            = False              ; turn off contour lines
   res@cnLineLabelsOn       = False              ; turn off contour line labels
   res@cnInfoLabelOn        = False      ; turns off contour info label
;   res@cnLevelSelectionMode = "ManualLevels"
;   res@cnMaxLevelValF       = 400.               ; set max contour level
;   res@cnMinLevelValF       = -400.               ; set min contour level
;   res@cnLevelSpacingF = 100.

   ; label bar <<<2

;   res@lbLabelBarOn = False
;   res@lbOrientation            = "Vertical"     ; vertical label bar
   res@lbPerimOn                = False             ; no box around it
   ;    res@lbLabelStride            = 4

   ; plot manager <<<2

   ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
   ;    res@pmLabelBarWidthF         = 0.08              ; make it thinner
   res@pmLabelBarOrthogonalPosF = -0.04          ; move label bar closer

   ; map  <<<2

;   res@mpLandFillColor          = "gray"            ; set land to be gray
;   res@mpMinLonF = 0
;   res@mpMaxLonF = 360
   res@mpCenterLonF = 200

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
   res_p = res
   res_l = res

   res_s@tiMainString = "SODA"

   res_p@tiMainString = "PCOM"

   res_l@tiMainString = "LICOM"
;   res_l@gsnAddCyclic = False
;   res_l@gsnXAxisIrregular2Linear = True   ; converts irreg latitude to linear 
   
   ; gsn plot <<<1

   plot = gsn_csm_contour(wks, phi, res_l)
;   plot = gsn_csm_contour(wks, u_intz, res_l)
;   plot = new(4, graphic)
;   plot(0) = gsn_csm_contour_map_ce(wks, cn_s, res_s)
;   plot(1) = gsn_csm_contour_map_ce(wks, cn_p, res_p)
;   plot(2) = gsn_csm_contour_map_ce(wks, cn_l, res_l)
;   plot(3) = gsn_csm_contour_map(wks, cn_l, res_l)
   ; to fix the bug that the last plot will be wrong when using map
;   plot(3) = gsn_csm_contour(wks, cn_l, res_l) 

;   printVarSummary(cn_p)
;   printVarSummary(cn_l)
;   printVarSummary(temp)

   ; panel <<<1
   
   resP = True
   resP@gsnFrame = False
;      resP@gsnPanelDebug = True
   resP@gsnPanelLabelBar = True
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 10
;      resP@gsnPanelBottom = 0.05
   resP@gsnPanelRowSpec = True

   resP@pmLabelBarWidthF = 0.4
   resP@pmLabelBarHeightF = 0.05

   resP@lbLabelFontHeightF = 0.009
   resP@lbLabelAutoStride = True
;   resP@lbLabelFontHeightF = 0.007

   resP@txString = "Vertical integration of zonal currents"

;   gsn_panel(wks, plot, (/1,2/), resP)

   delete(wks)
;   system("eps2png_trim " + img)
end
