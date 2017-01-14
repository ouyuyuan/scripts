
; Description: using wrf arw function to plot Lambert projection
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-02-23 21:05:44 BJT
; Last Change: 2014-02-23 21:13:40 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"  ; Add special wrf functions
;load "$NCARG_ROOT/lib/ncarg/nclscripts/cnmap/cnmap.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
   
;   data_dir = "/media/toshiba_02/radiation4/"
;   draw_dir = "/home/kongxh/ou/drawings/wrf/"
   data_dir = "/home/ou/archive/data/wrf"
   draw_dir = "/home/ou/archive/drawing/wrf"

;   f = addfile(data_dir + "wrfout_d01_1997-12-30_03:00:00", "r")
   f = addfile(data_dir + "/sample_wrfout.nc", "r")
   times  = chartostring(f->Times)         ; convert to type string for plot

   time_rec = 15

   t_ori = wrf_user_getvar(f, "T2", time_rec)
   t = t_ori - 273.15
   t@description = "TEMP at 2 M"
   t@units = "celcius degree"

   type = "png"
   ; type = "x11"
   wks = gsn_open_wks(type, draw_dir + "/wrf_user_arw_function")       ; Create a plot workstation
   ;gsn_define_colormap(wks,"matlab_jet")

   res = True
   res@cnLineLabelsOn        = False            ; turn off contour labels
;   res@MainTitle = "2m temperature of 1998-01-01-00:00:00"
;   res@MainTitle = "2m temperature of " + times(time_rec) + ", WRF ARW function"
   res@MainTitle = "2m temperature of " + times(time_rec)
;   res@tiMainString          = times(time_rec) + ", contributed WRF function"
	;res@gsnSpreadColorStart = 6
	;res@gsnSpreadColorEnd  = 60

   ;res@InitTime = False                        ; Do not plot time or footers
   ;res@Footer = False    
   res@cnFillOn = True                        ; Create a color fill plot
;   res@ContourParameters = (/ -40., 25., 5. /) ; Set the levels
	;res@cnFillDrawOrder         = "PreDraw"

   contour = wrf_contour(f, wks, t, res)

   pltres = True                              ; Set plot options
	;pltres@cnFillDrawOrder         = "PreDraw"

   mpres = True                               ; Set map options
   ;mpres@mpDataBaseVersion = "MediumRes"          ; Default is LowRes
   ;mpres@mpDataBaseVersion = "HighRes"          ; Caused NCL fatal error
   mpres@mpGeophysicalLineThicknessF = 2.0
   mpres@mpNationalLineThicknessF    = 2.0
   ;mpres@mpUSStateLineThicknessF     = 2.0
   ;mpres@mpOutlineDrawOrder    = "PostDraw"           ; Draw map outlines last
   ;mpres@mpOutlineBoundarySets       = "GeophysicalAndUSStates"
   mpres@mpOutlineBoundarySets       = "National"
   mpres@mpGeophysicalLineColor      = "Black"  ; Overwrite basic map settings
   mpres@mpGridLineColor             = "Black"
   mpres@mpLimbLineColor             = "Black"
   mpres@mpNationalLineColor         = "Black"
   ;mpres@mpUSStateLineColor          = "Black"
   mpres@mpPerimLineColor            = "Black"

	;mpres@mpDataSetName           = "Earth..4"
	;mpres@mpAreaMaskingOn         = True
	;mpres@mpMaskAreaSpecifiers    = (/"China","Taiwan","Disputed area between India and China","India:Arunachal Pradesh"/)
	;mpres@mpLandFillColor         = "white"
	;mpres@mpInlandWaterFillColor  = "white"
	;mpres@mpOceanFillColor        = "white"
	;mpres@mpOutlineBoundarySets   = "NoBoundaries"

   plot = wrf_map_overlays(f, wks, (/contour/), pltres, mpres)

end
