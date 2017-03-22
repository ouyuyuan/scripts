
; Description: using only NCL function to plot Lambert projection
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-02-23 20:39:01 BJT
; Last Change: 2014-06-18 09:50:05 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   

begin

;   data_dir = "/media/toshiba_02/radiation4/"
;   draw_dir = "/home/kongxh/ou/drawings/wrf/"
   data_dir = "/home/ou/archive/data/wrf"
   draw_dir = "/home/ou/archive/drawing/wrf"

;   f = addfile(data_dir + "wrfout_d01_1997-12-30_03:00:00", "r")
   f = addfile(data_dir + "/sample_wrfout.nc", "r")
   times  = chartostring(f->Times)         ; convert to type string for plot
   lat2d  = f->XLAT(0,:,:)     
   lon2d  = f->XLONG(0,:,:)      

   time_rec = 15

   t_ori = f->T2(time_rec, :, :)
   t = t_ori - 273.15
   t@description = "TEMP at 2 M"
   t@units = "celcius degree"

   dimll  = dimsizes(lat2d)                ; get size of dimensions
   nlat   = dimll(0)
   nlon   = dimll(1)

   type = "png"
   ; type = "x11"
   wks = gsn_open_wks(type, draw_dir + "/only_ncl_function")       ; Create a plot workstation

   res                       = True        ; plot mods desired
   res@tiMainString          = times(time_rec) + ", only ncl function"
   ;;res@gsnMaximize           = True        ; uncomment to maximize size
   ;res@cnLineThicknessF      = 2.0         ; make twice as thick as default
   ;res@cnLineLabelBackgroundColor = "background" ; no lines through labels
   res@cnFillOn = True                        ; Create a color fill plot
	res@cnLinesOn               = False
;   res@cnLevelSelectionMode = "ManualLevels"
;   res@cnMaxLevelValF = 25.
;   res@cnMinLevelValF = -40.
;   res@cnLevelSpacingF = 5.

   res@gsnAddCyclic          = False       ; regional data: not cyclic 

   res@tfDoNDCOverlay        = True        ; set True for non-native mapping
                                           ; will result in faster plotting
;   res@tfDoNDCOverlay        = False ; can cause problems

   res@pmTickMarkDisplayMode = "Always"         ; turn on tickmarks

   res@mpProjection          = "LambertConformal"
   res@mpGeophysicalLineThicknessF = 2.0
   res@mpNationalLineThicknessF    = 2.0
   res@mpLambertParallel1F   = f@TRUELAT1
   res@mpLambertParallel2F   = f@TRUELAT2
   res@mpLambertMeridianF    = f@CEN_LON
   res@mpLimitMode           = "Corners"  
   res@mpLeftCornerLatF      = lat2d(0,0)
   res@mpLeftCornerLonF      = lon2d(0,0)
   res@mpRightCornerLatF     = lat2d(nlat-1,nlon-1)
   res@mpRightCornerLonF     = lon2d(nlat-1,nlon-1)
   res@mpOutlineDrawOrder    = "PostDraw"  ; draw continental outline last
   res@mpFillDrawOrder       = "PreDraw"
   ;res@mpOutlineBoundarySets = "GeophysicalAndUSStates" ; state boundaries
   res@mpOutlineBoundarySets = "National" ; state boundaries
   res@mpFillOn              = False       ; turn off map fill

   plot                      = gsn_csm_contour_map(wks, t, res)

end
