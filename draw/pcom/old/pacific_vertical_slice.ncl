
; Description: Vertical slice of middle and east of tropical Pacific
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-10-23 15:52:38 CST
; Last Change: 2013-11-13 21:10:49 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   ; variables <<<1

   draw_dir = "/home/ou/archive/drawing/pcom/assess/eps/t_res_monlong"
   data_dir = "/home/ou/archive/data"

   ; data files <<<1

   f_w = addfile(data_dir + "/woa09/temperature_annual_1deg.nc", "r")
   f_s = addfile(data_dir + "/climate/soda/climate_1981-2000.nc", "r")
   f_p = addfile(data_dir + "/climate/pcom/t_res_monlong/climate_031-050.nc", "r")
   f_l = addfile(data_dir + "/climate/licom/unmodified/climate_081-100.nc", "r")

   ; resources  <<<1

   res = True

   ; gsn <<<2
   ;
   res@gsnDraw = False
   res@gsnFrame = False
;   res@gsnMaximize = True
   res@gsnSpreadColors      = True               ; use full color map
   res@gsnSpreadColorStart  = 30                 ; start at color 17
   res@gsnSpreadColorEnd    = 240                ; end at color 200
   res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 

   ; contour <<<2
   ;
   res@cnFillOn             = True               ; turn on color for contours
   res@cnLinesOn            = False              ; turn off contour lines
   res@cnLineLabelsOn       = False              ; turn off contour line labels
   res@cnInfoLabelOn        = False      ; turns off contour info label

   ; laber bar, tick <<<2
   ;
   ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
   ;    res@pmLabelBarWidthF         = 0.08              ; make it thinner
   res@lbLabelBarOn = False
   res@lbOrientation            = "Vertical"     ; vertical label bar
   res@lbPerimOn                = False             ; no box around it
   res@pmLabelBarOrthogonalPosF = -0.04          ; move label bar closer
   ;    res@lbLabelStride            = 4
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

   res@trYMaxF = 500.
;   res@trXMaxF = 80
;   res@trXMinF = -80
   res@trYReverse               = True   ; reverses y-axis

   ; overlay res. <<<1

   sres = True
   sres@cnFillOn             = False
   sres@cnLinesOn            = True
   sres@cnLevelSelectionMode = "ExplicitLevels"
   sres@cnLevels = (/20/)
   sres@cnLineThicknessF = 2.0

   ; lon string to integer <<<1

   function lon_str2int(str:string)
   local num_str, id, lon
   begin
      num_str = str_get_cols(str, 0, -2)
      id = str_get_cols(str, -1, -1)
      if (id .eq. "E") then
         lon = stringtointeger(num_str)
      else if (id .eq. "W") then
         lon = 360 - stringtointeger(num_str)
      else
         print("Warning: unrecognized suffix of lon string")
      end if
      end if
      return (lon)
   end

   ; lat string to integer <<<1

   function lat_str2int(str:string)
   local num_str, id, lat
   begin
      num_str = str_get_cols(str, 0, -2)
      id = str_get_cols(str, -1, -1)
      if (id .eq. "N") then
         lat = stringtointeger(num_str)
      else if (id .eq. "S") then
         lat = -stringtointeger(num_str)
      else
         print("Warning: unrecognized suffix of lat string")
      end if
      end if
      return (lat)
   end

   ; plot meridional slice <<<1

   procedure plot_slice(par:logical)
   local img, wks, wtype
   begin

      wtype = "eps"

      depm = par@depMin
      depM = par@depMax

      latm = lat_str2int(par@latMin)
      latM = lat_str2int(par@latMax)

      var  = par@var
      id   = par@id
      
      ; get data field <<<2

      ; along one latitude <<<3

      if (id .eq. "one") then
         lonF = lon_str2int(par@lonF)
         if (var .eq. "temp") then
            cn_w = f_w->t_mn(0,{depm:depM},{latm:latM},{lonF})
            cn_s = f_s->temp({depm:depM},{latm:latM},{lonF})
            cn_p = f_p->pt(0,{depm:depM},{latm:latM},{lonF})
            cn_l = f_l->ts(0,{-depM:-depm},{latm:latM},{lonF})
         else if (var .eq. "u") then
            cn_s = f_s->u({depm:depM},{latm:latM},{lonF})
            cn_p = f_p->u(0,{depm:depM},{latm:latM},{lonF})
            cn_l = f_l->us(0,{-depM:-depm},{latm:latM},{lonF})
         else if (var .eq. "v") then
            cn_s = f_s->v({depm:depM},{latm:latM},{lonF})
            cn_p = f_p->v(0,{depm:depM},{latm:latM},{lonF})
            cn_l = f_l->vs(0,{-depM:-depm},{latm:latM},{lonF})
         else if (var .eq. "uv") then
            u_s = f_s->u({depm:depM},{latm:latM},{lonF})
            u_p = f_p->u(0,{depm:depM},{latm:latM},{lonF})
            u_l = f_l->us(0,{-depM:-depm},{latm:latM},{lonF})

            v_s = f_s->v({depm:depM},{latm:latM},{lonF})
            v_p = f_p->v(0,{depm:depM},{latm:latM},{lonF})
            v_l = f_l->vs(0,{-depM:-depm},{latm:latM},{lonF})

            cn_s = sqrt(u_s^2+v_s^2)
            cn_p = sqrt(u_p^2+v_p^2)
            cn_l = sqrt(u_l^2+v_l^2)

            copy_VarCoords(u_s, cn_s)
            copy_VarCoords(u_p, cn_p)
            copy_VarCoords(u_l, cn_l)
         else
            print("Warning: unrecognized var name")
         end if
         end if
         end if
         end if

      ; zonal average <<<3

      else if (id .eq. "avg") then
         lonm = lon_str2int(par@lonMin)
         lonM = lon_str2int(par@lonMax)
         if (var .eq. "temp") then
            t_w_3d = f_w->t_mn(0,{depm:depM},{latm:latM},{lonm:lonM})
            t_s_3d = f_s->temp({depm:depM},{latm:latM},{lonm:lonM})
            t_p_3d = f_p->pt(0,{depm:depM},{latm:latM},{lonm:lonM})
            t_l_3d = f_l->ts(0,{-depM:-depm},{latm:latM},{lonm:lonM})
            cn_w = dim_avg_n_Wrap(t_w_3d,2)
            cn_s = dim_avg_n_Wrap(t_s_3d,2)
            cn_p = dim_avg_n_Wrap(t_p_3d,2)
            cn_l = dim_avg_n_Wrap(t_l_3d,2)
         else if (var .eq. "u") then
            u_s_3d = f_s->u({depm:depM},{latm:latM},{lonm:lonM})
            u_p_3d = f_p->u(0,{depm:depM},{latm:latM},{lonm:lonM})
            u_l_3d = f_l->us(0,{-depM:-depm},{latm:latM},{lonm:lonM})
            cn_s = dim_avg_n_Wrap(u_s_3d,2)
            cn_p = dim_avg_n_Wrap(u_p_3d,2)
            cn_l = dim_avg_n_Wrap(u_l_3d,2)
         else if (var .eq. "v") then
            v_s_3d = f_s->v({depm:depM},{latm:latM},{lonm:lonM})
            v_p_3d = f_p->v(0,{depm:depM},{latm:latM},{lonm:lonM})
            v_l_3d = f_l->vs(0,{-depM:-depm},{latm:latM},{lonm:lonM})
            cn_s = dim_avg_n_Wrap(v_s_3d,2)
            cn_p = dim_avg_n_Wrap(v_p_3d,2)
            cn_l = dim_avg_n_Wrap(v_l_3d,2)
         else if (var .eq. "uv") then
            u_s_3d = f_s->u({depm:depM},{latm:latM},{lonm:lonM})
            u_p_3d = f_p->u(0,{depm:depM},{latm:latM},{lonm:lonM})
            u_l_3d = f_l->us(0,{-depM:-depm},{latm:latM},{lonm:lonM})

            v_s_3d = f_s->v({depm:depM},{latm:latM},{lonm:lonM})
            v_p_3d = f_p->v(0,{depm:depM},{latm:latM},{lonm:lonM})
            v_l_3d = f_l->vs(0,{-depM:-depm},{latm:latM},{lonm:lonM})

            cn_s_3d = sqrt(u_s_3d^2 + v_s_3d^2)
            cn_p_3d = sqrt(u_p_3d^2 + v_p_3d^2)
            cn_l_3d = sqrt(u_l_3d^2 + v_l_3d^2)

            cn_s = dim_avg_n_Wrap(cn_s_3d, 2)
            cn_p = dim_avg_n_Wrap(cn_p_3d, 2)
            cn_l = dim_avg_n_Wrap(cn_l_3d, 2)

            copy_VarCoords(u_s_3d, cn_s)
            copy_VarCoords(u_p_3d, cn_p)
            copy_VarCoords(u_l_3d, cn_l)
         else
            print("Warning: unrecognized var name")
         end if
         end if
         end if
         end if
      else
         print("Warning: unrecognize id name.")
      end if
      end if

      ; determine image name <<<2

      str_lat = par@latMin + "-" + par@latMax
      if (var .eq. "temp") then
         imgname = "pacific_lat_slice_temp" + "_" + str_lat
      else if (var .eq. "uv" ) then
         imgname = "pacific_lat_slice_uv" + "_" + str_lat
      else if (var .eq. "u") then
         imgname = "pacific_lat_slice_u" + "_" + str_lat
      else if (var .eq. "v") then
         imgname = "pacific_lat_slice_v" + "_" + str_lat
      else
         print("Warning: unrecognized variable name")
      end if
      end if
      end if
      end if

      if (id .eq. "one") then
         imgname = imgname + "_" + par@lonF
      else if (id .eq. "avg") then
         str_lon =  par@lonMin + "-" + par@lonMax
         imgname = imgname + "_" + str_lon
      else
         print("Warning: unrecognized id name.")
      end if
      end if

      img = draw_dir + "/" + imgname

      ; define workstation <<<2

      wks = gsn_open_wks(wtype,img)
      gsn_define_colormap(wks,"BlueYellowRed")  ; choose color map
      
      ; customized res <<<2

      if (var .eq. "temp") then 
         res@cnLevelSelectionMode = "ManualLevels"
         res@cnMaxLevelValF       = 28.               ; set max contour level
         res@cnMinLevelValF       = 0.               ; set min contour level
         res@cnLevelSpacingF = 2.
      else
;         res@vpWidthF = 1.90
;         res@tiMainFontHeightF = 0.04
;         res@tiXAxisFontHeightF = 0.04
;         res@tiYAxisFontHeightF = 0.04
      end if

      ; individual res. <<<2

      res_w = res
      res_s = res
      res_p = res
      res_l = res

      res_w@tiMainString = "WOA09"

      res_s@tiMainString = "SODA"

      res_p@tiMainString = "PCOM"

      res_l@tiMainString = "LICOM"
      res_l@gsnXAxisIrregular2Linear = True   ; converts irreg depth to linear 

      z_l = f_l->lev({-depM:-depm})
      res_l@sfYArray  = -z_l

      ; gsn plot <<<2

      if (var .eq. "temp") then
         plot = new(4, graphic)
         plot(0) = gsn_csm_contour(wks, cn_w, res_w)
         plot(1) = gsn_csm_contour(wks, cn_s, res_s)
         plot(2) = gsn_csm_contour(wks, cn_p, res_p)
         plot(3) = gsn_csm_contour(wks, cn_l, res_l)

         copy_VarAtts(sres, res_w)
         plot_ov_w = gsn_csm_contour(wks, cn_w, res_w)
         overlay(plot(0), plot_ov_w)

         copy_VarAtts(sres, res_s)
         plot_ov_s = gsn_csm_contour(wks, cn_s, res_s)
         overlay(plot(1), plot_ov_s)

         copy_VarAtts(sres, res_p)
         plot_ov_p = gsn_csm_contour(wks, cn_p, res_p)
         overlay(plot(2), plot_ov_p)

         copy_VarAtts(sres, res_l)
         plot_ov_l = gsn_csm_contour(wks, cn_l, res_l)
         overlay(plot(3), plot_ov_l)
      else
         plot = new(3, graphic)
         plot(0) = gsn_csm_contour(wks, cn_s, res_s)
         plot(1) = gsn_csm_contour(wks, cn_p, res_p)
         plot(2) = gsn_csm_contour(wks, cn_l, res_l)
      end if

      ; panel <<<2
      
      resP = True
      resP@gsnFrame = False
;      resP@gsnPanelDebug = True
      resP@gsnPanelLabelBar = True
      resP@lbLabelAutoStride = True
;      resP@lbLabelFontHeightF = 0.007
      resP@gsnPanelBottom = 0.05
      resP@gsnPanelYWhiteSpacePercent = 5
      resP@gsnPanelXWhiteSpacePercent = 5

;      lx = 0.12
;      rx = 0.62
;      resP@gsnPanelXF = (/lx,rx,lx,rx/)    ; Adjust rightmost plots
;      ty = -1
;      by = 0.42
;      resP@gsnPanelYF = (/ty,ty,by,by/)    ; Adjust rightmost plots

      ; determine panel title <<<3

      title = "Meridional slice of Pacific"
      if (id .eq. "one") then
         title = title + ": " + par@lonF
      else if (id .eq. "avg") then
         str_lon =  par@lonMin + "-" + par@lonMax
         title = title + ": " + str_lon
      else
         print("Warning: unrecognized id name.")
      end if
      end if
      resP@txString = title

      if (var .eq. "temp") then
         gsn_panel(wks, plot, (/2,2/), resP)
      else
         resP@gsnPanelRowSpec = True
         gsn_panel(wks, plot, (/1,2/), resP)
      end if
   
      ; figure text  <<<2

      txres               = True
      txres@txFontHeightF = 0.015
      gsn_text_ndc(wks,"Notice the toothed shape of level lines in PCOM", \
         0.5,0.02,txres)
      frame(wks)

   end

   ; plots <<<1

   par = True

   ; temperature <<<2

   par@var = "temp"

;   par@latMin = "60S"
;   par@latMax = "60N"
   par@latMin = "80S"
   par@latMax = "80N"
   par@lonMin = "170W"
   par@lonMax = "90W"
   par@depMin = 0
   par@depMax = 700
   par@lonF = "150W"

;   par@id = "avg"
;   plot_slice(par)

   par@id = "one"
   plot_slice(par)

   ; current <<<2

;   par@latMin = "25S"
;   par@latMax = "25N"

;   par@var = "u"
;   par@id = "one"
;   plot_slice(par)
;   par@id = "avg"
;   plot_slice(par)

;   par@var = "v"
;   par@id = "one"
;   plot_slice(par)
;   par@id = "avg"
;   plot_slice(par)

;   par@var = "uv"
;   par@id = "one"
;   plot_slice(par)
;   par@id = "avg"
;   plot_slice(par)

end
