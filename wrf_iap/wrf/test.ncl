load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   dir =  "/home/kongxh/process_data"
   
   f =  addfile(dir+"/data/wrfout_d01_1994-08-26_03:00:00","r")
   
   hgt   =  f->HGT(0,:,:)
   hgt@description =   "Terrain Height"
   hgt@units   =  "m"

   lat2d =  f->XLAT
   lon2d =  f->XLONG   
   type  =  "png"
   wks = gsn_open_wks(type, "test")
   
   res   =  True
   res@cnFillOn = False
   res@cnLevelSelectionMode = "ManualLevels"
   res@cnMaxLevelValF   =  5500
   res@cnMinLevelValF   =  0
   res@cnMonoLineThickness   =  False
   res@cnLineThicknesses   =  1.3     
   contour = wrf_contour(f, wks, hgt, res)
  
   pltres = True
 
   mpres = True
   mpres@mpGeophysicalLineThicknessF = 2.0
   mpres@mpNationalLineThicknessF    = 2.0
   mpres@mpOutlineBoundarySets       = "National"
   mpres@mpGeophysicalLineColor      = "Black"  
   mpres@mpGridLineColor             = "Black"
   mpres@mpLimbLineColor             = "Black"
   mpres@mpNationalLineColor         = "Black"
   mpres@mpPerimLineColor            = "Black"
   mpres@mpOutlineDrawOrder          = "PostDraw"
   plot = wrf_map_overlays(f, wks, (/contour/), pltres, mpres)

   gres  =  True
   gres@gsLineThicknessF   =  3.0
   gres@gsLineColor  =  "Red"
   
   xx =  lon2d(0,10,:)
   yy =  lat2d(0,10,:)
   
   gsn_polyline(wks,plot,xx,yy,gres)

end
