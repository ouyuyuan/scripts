
; Description: using wrf contributed function to plot Lambert projection
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-02-23 20:42:34 BJT
; Last Change: 2014-02-23 21:05:23 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"

begin

;   data_dir = "/media/toshiba_02/radiation4/"
;   draw_dir = "/home/kongxh/ou/drawings/wrf/"
   data_dir = "/home/ou/archive/data/wrf"
   draw_dir = "/home/ou/archive/drawing/wrf"

;   f = addfile(data_dir + "wrfout_d01_1997-12-30_03:00:00", "r")
   f = addfile(data_dir + "/sample_wrfout.nc", "r")
   times  = chartostring(f->Times)         ; convert to type string for plot

   time_rec = 15

   t_ori = f->T2(time_rec, :, :)
   t = t_ori - 273.15
   t@description = "TEMP at 2 M"
   t@units = "celcius degree"

   type = "png"
   ; type = "x11"
   wks = gsn_open_wks(type, draw_dir + "/contributed_wrf_function")       ; Create a plot workstation
   ;gsn_define_colormap(wks,"BlAqGrYeOrReVi200") ; select color map

   res                       = True             ; plot mods desired
   res@tiMainString          = times(time_rec) + ", contributed WRF function"
   ;;res@gsnMaximize           = True             ; uncomment to maximize size
   res@gsnSpreadColors       = True             ; use full range of colormap
   res@cnFillOn              = True             ; color plot desired
   res@cnLinesOn             = False            ; turn off contour lines
   res@cnLineLabelsOn        = False            ; turn off contour labels

   WRF_map_c(f, res, 0)                   ; reads info from file

   ; if appropriate, set True for native mapping (faster)
   res@tfDoNDCOverlay       = True     
;   res@tfDoNDCOverlay       = False ; whether true of false is OK, may be
                                    ; because of WRF_map_c function

   ; associate the 2-dimensional coordinates to the variable for plotting
   ; only if non-native plot
   if (.not.res@tfDoNDCOverlay) then
      t@lat2d = f->XLAT(0,:,:)                      ; direct assignment
      t@lon2d = f->XLONG(0,:,:)
   end if

   ; Turn on lat / lon labeling
   res@pmTickMarkDisplayMode = "Always"         ; turn on tickmarks
   ;res@tmXTOn = False            ; turn off top   labels 
   ;res@tmYROn = False            ; turn off right labels

   res@mpGeophysicalLineThicknessF = 2.0
   res@mpNationalLineThicknessF    = 2.0
   res@mpOutlineBoundarySets = "National" ; state boundaries

   plot                 = gsn_csm_contour_map(wks, t(:,:), res)

end
