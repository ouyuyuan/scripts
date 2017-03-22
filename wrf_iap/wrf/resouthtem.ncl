load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/cnmap/cnmap.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
begin
   fils =  systemfunc("ls /media/WRF50kmOUT/WRF_run/wrfout_d01*")+".nc"
   f  =  addfiles(fils,"r") 
   ListSetType (f,"cat")

   lat2d =  f[:]->XLAT(0,:,:)
   lon2d =  f[:]->XLONG(0,:,:)
   
   t2 =  f[:]->T2(0,:,:)
   t2@lat2d =  lat2d
   t2@lon2d =  lon2d

   lat   =  fspan(-89.75,89.75,360)
   lon   =  fspan(-179.75,179.75,720)
   lat@units   = "degree_north"
   lon@units   =  "degree_east"
   newt2 =  rcm2rgrid_Wrap(lat2d,lon2d,t2,lat,lon,0)
   newt2@lat   =  lat
   newt2@lon   =  lon
 
   picture_dir = "/home/kongxh/process_data/pictures/" 
   wks         = gsn_open_wks("eps",picture_dir+"WRF_REGRID_TEST")
   
   gsn_define_colormap(wks,"gui_default")
  
   
   res   =  True
   res@gsnDraw                 = False
   res@gsnFrame                = False
   res@gsnSpreadColors         = True
   ;res@gsnSpreadColorStart = 6
   ;res@gsnSpreadColorEnd  = 60

   res@mpMinLatF               = 17
   res@mpMaxLatF               = 50 
   res@mpMinLonF               = 73 
   res@mpMaxLonF               = 130
   res@mpFillOn                = True
   res@mpOutlineOn             = False
   res@mpDataBaseVersion       = "MediumRes"
   res@mpDataSetName           = "Earth..4"
   res@mpAreaMaskingOn         = True  
   res@mpMaskAreaSpecifiers    = (/"China","Taiwan","Disputed area between India and China","India:Arunachal Pradesh"/)
   res@mpLandFillColor         = "white"
   res@mpInlandWaterFillColor  = "white"
   res@mpOceanFillColor        = "white"
   res@mpOutlineBoundarySets   = "NoBoundaries"
   
   res@cnFillDrawOrder         = "PreDraw"
   res@cnFillOn                = True
   res@cnLinesOn               = False 
   res@cnLevelSelectionMode = "ManualLevels"
  ; res@cnMaxLevelValF = 25.
  ; res@cnMinLevelValF = -15.
  ; res@cnLevelSpacingF = 2.5 
   ;res@gsnCenterString  =  "T2 M in Winter"
  ; res@gsnAddCyclic = False
   res@lbLabelBarOn  =  False

    plot  =  new(2,graphic)
   res@tiMainString  =  "beforeW"
   plot(0)=gsn_csm_contour_map(wks,t2,res)  
  
   res@tiMainString  =  "afterW"
   plot(1)=gsn_csm_contour_map(wks,newt2,res)
   
   pres       =  True
   pres@gsnPanelLabelBar  =  True
   pres@gsnFrame          =  False
   pres@lbLabelAutoStride =  True
   gsn_panel(wks,plot,(/2,1/),pres)
 
end
