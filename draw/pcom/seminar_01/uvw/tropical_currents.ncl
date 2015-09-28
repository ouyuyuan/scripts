
; Description: Tropical currents
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-10-07 16:43:57 CST
; Last Change: 2013-11-16 19:33:58 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   ; variables <<<1

   draw_dir = "/home/ou/archive/drawing/pcom/assess/eps/t_res_monlong/uvw"
   data_dir = "/home/ou/archive/data/climate"
   lat_min = -25
   lat_max = 25
   lon_min = 98
   lon_max = 282

   img = draw_dir + "/tropical_currents"
   wtype = "eps"

   ; data <<<1

   f_p = addfile(data_dir + "/pcom/t_res_monlong/climate_031-050.nc", "r")
   f_l = addfile(data_dir + "/licom/unmodified/climate_081-100.nc", "r")
   f_s = addfile(data_dir + "/soda/climate_1981-2000.nc", "r")
   u_p = f_p->u(0,0,:,:) ; need global data for interpolation
   v_p = f_p->v(0,0,:,:)
   u_l = f_l->us(0,0,:,:)
   v_l = f_l->vs(0,0,:,:)
   u_s = f_s->u(0,:,:)
   v_s = f_s->v(0,:,:)
   
   ; resources  <<<1

   res = True

   ; gsn <<<2
   ;
   res@gsnDraw = False
   res@gsnFrame = False
   res@gsnSpreadColors      = True               ; use full color map
   res@gsnScalarContour     = True               ; contours desired

   ; contour <<<2
   ;
   res@cnFillOn             = True               ; turn on color for contours
   res@cnLinesOn            = False              ; turn off contour lines
   res@cnLineLabelsOn       = False              ; turn off contour line labels

   ; vector <<<2
   ;
   res@vcLevelSelectionMode = "ManualLevels"
   res@vcRefMagnitudeF       = 1.0                  ; add a reference vector
   res@vcRefLengthF          = 0.045                ; what the ref length is
   res@vcMinDistanceF          = 0.017            ; thin out vectors
   res@vcRefAnnoOrthogonalPosF   = -1.0            ; move ref vector
;   res@vcMonoLineArrowColor  = False                ; vec's colored by their mag_p
   res@vcRefAnnoArrowLineColor   = "black"         ; change ref vector color
   res@vcRefAnnoArrowUseVecColor = False           ; don't use vec color for ref
   res@vcGlyphStyle          = "CurlyVector"        ; turn on curly vectors
   res@vcLineArrowThicknessF   = 0.5               ; change vector thickness
   res@vcVectorDrawOrder       = "PostDraw"        ; draw vectors last

   ; laber bar, map <<<2
   ;
   ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
   ;    res@pmLabelBarWidthF         = 0.08              ; make it thinner
   res@lbOrientation            = "Vertical"     ; vertical label bar
   res@lbPerimOn                = False             ; no box around it
   res@pmLabelBarOrthogonalPosF = -0.01          ; move label bar closer
   ;    res@lbLabelStride            = 4
   res@mpLandFillColor          = "gray"            ; set land to be gray

   res@mpMinLatF                = lat_min
   res@mpMaxLatF                = lat_max
   res@mpMinLonF                = lon_min
   res@mpMaxLonF                = lon_max
   res@mpCenterLonF             = (lon_min+lon_max)/2.0

   ; panel <<<1

   resP = True
   ;    resP@gsnMaximize = True
   resP@txString = "Tropical Currents"
   ;    resP@gsnPanelRowSpec = True

   ; plot procedure <<<1

   ; vector over direction contour <<<2

   procedure plot_vector_over_direction()
   begin

      img_d = img + "_direction"
      wksD = gsn_open_wks(wtype,img_d)
      gsn_define_colormap(wksD,"BlueYellowRed")  ; choose color map

      resD = res
      resD@gsnSpreadColorStart  = 60                 ; start at color 17
      resD@gsnSpreadColorEnd    = 220                ; end at color 200

      resD@vcLineArrowColor        = "black"           ; change vector color

      ; cal. current direction
      ;
      r2d = 45.0/atan(1.0)     ; conversion factor (radians to degrees)
      di = atan2(v_p, u_p)*r2d
      di_l = atan2(v_l, u_l)*r2d
      di_s = atan2(v_s, u_s)*r2d
      copy_VarCoords(v_p, di)
      copy_VarCoords(v_l, di_l)
      copy_VarCoords(v_s, di_s)

      plot = new(3, graphic)
      resD@tiMainString = "SODA"
      plot(0) = gsn_csm_vector_scalar_map_ce(wksD, u_s, v_s, di_s, resD)
      resD@tiMainString = "PCOM"
      plot(1) = gsn_csm_vector_scalar_map_ce(wksD, u_p, v_p, di, resD)
      resD@gsnAddCyclic = False
      resD@tiMainString = "LICOM"
      plot(2) = gsn_csm_vector_scalar_map_ce(wksD, u_l, v_l, di_l, resD)

      gsn_panel(wksD, plot, (/3,1/), resP)

   end

   ; vector over magnitude contour <<<2

   procedure plot_vector_over_magnitude()
   begin

      img_m = img + "_magnitude"
      wksM = gsn_open_wks(wtype,img_m)
      gsn_define_colormap(wksM,"BlueYellowRed")  ; choose color map

      resM = res
      resM@gsnSpreadColorStart  = 100                 ; start at color 17
      resM@gsnSpreadColorEnd    = 240                ; end at color 200

      resM@vcLineArrowColor        = "black"           ; change vector color

      ; cal. magnitude
      ;
      mag_p = sqrt(u_p^2+v_p^2)   
      mag_s = sqrt(u_s^2+v_s^2)   
      mag_l = sqrt(u_l^2+v_l^2)   
      copy_VarCoords(v_p, mag_p)
      copy_VarCoords(v_l, mag_l)
      copy_VarCoords(v_s, mag_s)

      plot = new(3, graphic)
      resM@tiMainString = "SODA"
      plot(0) = gsn_csm_vector_scalar_map_ce(wksM, u_s, v_s, mag_s, resM)
      resM@tiMainString = "PCOM"
      plot(1) = gsn_csm_vector_scalar_map_ce(wksM, u_p, v_p, mag_p, resM)
      resM@gsnAddCyclic = False
      resM@tiMainString = "LICOM"
      plot(2) = gsn_csm_vector_scalar_map_ce(wksM, u_l, v_l, mag_l, resM)

      gsn_panel(wksM, plot, (/3,1/), resP)

   end

   ; plots <<<1

;   plot_vector_over_direction
   plot_vector_over_magnitude

end
