load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/cnmap/cnmap.ncl"
load "gsn_csm_simple.ncl"
;load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin
   data_dir =  "/home/ou/archive/data/kxh" 
   draw_dir = "/home/ou/archive/drawing/kxh" 
   figure   = draw_dir + "/China_ratio"

   nc =  addfile(data_dir+"/cru_ts3.21.1901.2012_winter.tmp.nc","r") 
   f7 =  addfile(data_dir+"/wrfout_d01_1994-08-26_03:00:00","r") 
;   f7 =  addfile(data_dir+"/wrf/sample_wrfout.nc","r") 

   lat2d =  f7->XLAT(0,:,:)
   lon2d =  f7->XLONG(0,:,:)
   a  =  nc->tmp(0,:,:)

   dims = dimsizes(lat2d)                ; get size of dimensions
   nlat = dims(0)
   nlon = dims(1)

   tmp     = nc->tmp(242:301,:,:)
   tmp_avg = dim_sum_n_Wrap(tmp,0) / 60.0
   copy_VarCoords(a,tmp_avg)
   
   tmp_avg@units = "degrees celsius"

   wks = gsn_open_wks("png", figure)
   gsn_define_colormap(wks,"BlRe")
  
   
   res   =  True
   res@gsnDraw         = False
   res@gsnFrame        = False
   res@gsnSpreadColors = True
   res@gsnAddCyclic    = False
;   res@gsnMaximize     = True
   res@gsnPaperOrientation  = "auto"
   ;res@gsnSpreadColorStart = 6
   ;res@gsnSpreadColorEnd  = 60

;   res@tfDoNDCOverlay        = True        ; set True for non-native mapping
                                           ; will result in faster plotting

;   res@pmTickMarkDisplayMode = "Always"         ; turn on tickmarks

   res@mpProjection          = "LambertConformal"
   res@mpLimitMode           = "Corners"  
   res@mpLeftCornerLatF      = lat2d(0,0)
   res@mpLeftCornerLonF      = lon2d(0,0)
   res@mpRightCornerLatF     = lat2d(nlat-1,nlon-1)
   res@mpRightCornerLonF     = lon2d(nlat-1,nlon-1)
;   res@mpMinLatF               = 16.75
;   res@mpMaxLatF               = 55.25 
;   res@mpMinLonF               = 72.25
;   res@mpMaxLonF               = 136.25
   res@mpFillOn                = True
   res@mpOutlineOn             = False 
   res@mpDataBaseVersion       = "MediumRes"
   res@mpDataSetName           = "Earth..4"
   res@mpAreaMaskingOn         = True  
   res@mpMaskAreaSpecifiers    = (/"China","Taiwan","Disputed area between India and China","India:Arunachal Pradesh"/)
   res@mpLandFillColor         = "white"
   res@mpInlandWaterFillColor  = "white"
   res@mpOceanFillColor        = "white"
;   res@mpOutlineBoundarySets   = "NoBoundaries"
   
   res@cnFillDrawOrder      = "PreDraw"
   res@cnFillOn             = True
   res@cnLinesOn            = False
   res@cnLineLabelsOn       = False
   res@cnLevelSelectionMode = "ManualLevels"
   res@cnMaxLevelValF       = 25.
   res@cnMinLevelValF       = -15.
   res@cnLevelSpacingF      = 2.5

;   res@lbOrientation            = "Vertical"     ; vertical label bar
   res@lbLabelBarOn  =  False

;   res@vpKeepAspect = True
   res@vpWidthF = 0.8
;   res@vpHeightF = 0.8
   
   plot = gsn_csm_contour_map(wks,tmp_avg,res)  
;   plot = gsn_csm_contour_map_ce(wks,tmp_avg,res)  
;   plot = gsn_csm_contour(wks,tmp_avg,res)  
   
   draw(plot) 
   frame(wks)
   
end
