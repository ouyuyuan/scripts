load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/cnmap/cnmap.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin
   data_dir   =  "/home/ou/archive/data/kxh" 
   f1 =  addfile(data_dir+"/cru_ts3.21.1901.2012_winter.tmp.nc","r") 
   f2 =  addfile(data_dir+"/t2m_thc_winter.nc","r")
   f3 =  addfile(data_dir+"/t2m_wrf_winter_8100avg.nc","r")
   f4 =  addfile(data_dir+"/cru_ts3.21.1901.2012_summer.tmp.nc","r")
   f5 =  addfile(data_dir+"/t2m_thc_summer.nc","r")
   f6 =  addfile(data_dir+"/t2m_wrf_summer_8100avg.nc","r") 
   f7 =  addfile(data_dir+"/wrfout_d01_1994-08-26_03:00:00","r") 
   lat2d =  f7->XLAT(0,:,:)
   lon2d =  f7->XLONG(0,:,:)
   
   a  =  f1->tmp(0,:,:)
   b  =  f2->air(0,:,:)
    
   t2m_cru_winter  =  f1->tmp(242:301,:,:)
   sumt2m_cru_winter =  dim_sum_n_Wrap(t2m_cru_winter,0)
   t2m_cru_winter_avg   =  sumt2m_cru_winter/60.
   copy_VarCoords(a,t2m_cru_winter_avg)
   
   t2m_cru_summer =  f4->tmp(240:299,:,:)
   sumt2m_cru_summer =  dim_sum_n_Wrap(t2m_cru_summer,0)
   t2m_cru_summer_avg   =  sumt2m_cru_summer/60.
   copy_VarCoords(a,t2m_cru_summer_avg)
   
   t2m_thc_winter =  f2->air(332:391,:,:)
   ;sumt2m_thc_winter =  dim_sum_n_Wrap( t2m_thc_winter,0)
   ;this is a false way!
   t2m_thc_winter_avgo   = dim_avg_n_Wrap(t2m_thc_winter,0) 
   t2m_thc_winter_avg   =  t2m_thc_winter_avgo*0.01+427.66-273.15
   copy_VarCoords(b,t2m_thc_winter_avg)
   
   t2m_thc_summer =  f5->air(330:389,:,:)
   t2m_thc_summer_avgo   =  dim_avg_n_Wrap(t2m_thc_summer,0)
   t2m_thc_summer_avg   =  t2m_thc_summer_avgo*0.01+427.66-273.15
   copy_VarCoords(b,t2m_thc_summer_avg)
   
   t2m_wrf_winter =  f3->T2(0,:,:)
   t2m_wrf_winter_avg  =   t2m_wrf_winter-273.15
   t2m_wrf_winter_avg@lat2d   =  lat2d
   t2m_wrf_winter_avg@lon2d   =  lon2d
   
   t2m_wrf_summer =  f6->T2(0,:,:)
   t2m_wrf_summer_avg   =  t2m_wrf_summer-273.15
   t2m_wrf_summer_avg@lat2d   =  lat2d
   t2m_wrf_summer_avg@lon2d   =  lon2d
   
   t2m_cru_winter_avg@units   =  "degrees celsius"
   t2m_cru_summer_avg@units   =  "degrees celsius"
   t2m_thc_winter_avg@units   =  "degrees celsius"
   t2m_thc_summer_avg@units   =  "degrees celsius"
   t2m_wrf_winter_avg@units   =  "degrees celsius"
   t2m_wrf_summer_avg@units   =  "degrees celsius"
  
   lat   =  fspan(-89.75,89.75,360)
   lon   =  fspan(-179.75,179.75,720)
   lat@units   =  "degree_north"
   lon@units   =  "degree_east"
   t2m_wrf_winter_avg_interpolation =  rcm2rgrid(lat2d,lon2d,t2m_wrf_winter_avg,lat,lon,0) 
   t2m_wrf_summer_avg_interpolation =  rcm2rgrid(lat2d,lon2d,t2m_wrf_summer_avg,lat,lon,0)
   
   t2m_wrf_winter_avg_interpolation!0  =  "lat"
   t2m_wrf_winter_avg_interpolation!1  =  "lon"
   t2m_wrf_winter_avg_interpolation&lat   =  lat(:)
   t2m_wrf_winter_avg_interpolation&lon   =  lon(:)
   t2m_wrf_summer_avg_interpolation!0  =  "lat"
   t2m_wrf_summer_avg_interpolation!1  =  "lon"
   t2m_wrf_summer_avg_interpolation&lat   =  lat(:)
   t2m_wrf_summer_avg_interpolation&lon   =  lon(:)
   t2m_wrf_winter_avg_interpolation@units =  "degree celsius"
   t2m_wrf_summer_avg_interpolation@units =  "degree celsius"
   
   t2m_thc_winter_avg_1 =  t2m_thc_winter_avg(::-1,:)
   t2m_thc_summer_avg_1 =  t2m_thc_summer_avg(::-1,:)
   t2m_thc_winter_avg_2 = t2m_thc_winter_avg_1
   t2m_thc_winter_avg_2(:,0:95) = t2m_thc_winter_avg_1(:,96:191)
   t2m_thc_winter_avg_2(:,96:191) = t2m_thc_winter_avg_1(:,0:95)
   t2m_thc_summer_avg_2 = t2m_thc_summer_avg_1
   t2m_thc_summer_avg_2(:,0:95) = t2m_thc_summer_avg_1(:,96:191)
   t2m_thc_summer_avg_2(:,96:191) = t2m_thc_summer_avg_1(:,0:95)
   t2m_thc_winter_avg_interpolation =  g2fsh(t2m_thc_winter_avg_2,(/360,720/))
   t2m_thc_summer_avg_interpolation =  g2fsh(t2m_thc_summer_avg_2,(/360,720/))
   t2m_thc_winter_avg_interpolation!0  =  "lat"
   t2m_thc_winter_avg_interpolation!1  =  "lon"
   t2m_thc_winter_avg_interpolation&lat   =  lat(:)
   t2m_thc_winter_avg_interpolation&lon   =  lon(:)
   t2m_thc_summer_avg_interpolation!0  =  "lat"
   t2m_thc_summer_avg_interpolation!1  =  "lon"
   t2m_thc_summer_avg_interpolation&lat   =  lat(:)
   t2m_thc_summer_avg_interpolation&lon   =  lon(:)
   t2m_thc_winter_avg_interpolation@units =  "degree celsius"
   t2m_thc_summer_avg_interpolation@units =  "degree celsius"
  
   t2m_cru_w   =  t2m_cru_winter_avg(213:256,564:610)
   t2m_cru_s   =  t2m_cru_summer_avg(213:256,564:610)
   t2m_thc_w   =  t2m_thc_winter_avg_interpolation(213:256,564:610)
   t2m_thc_s   =  t2m_thc_summer_avg_interpolation(213:256,564:610)
   t2m_wrf_w   =  t2m_wrf_winter_avg_interpolation(213:256,564:610)
   t2m_wrf_s   =  t2m_wrf_summer_avg_interpolation(213:256,564:610)

   clat1  =  cos(0.01745329*lat(213:256))   
   clat2  =  cos(0.01745329*lat(213:256))   
   ra = pattern_cor(t2m_cru_w,t2m_thc_w,clat1, 0)
   rb = pattern_cor(t2m_cru_w,t2m_wrf_w,clat1, 0)
   rc = pattern_cor(t2m_cru_s,t2m_thc_s,clat2, 0)
   rd = pattern_cor(t2m_cru_s,t2m_wrf_s,clat2, 0)
   print(ra)
   print(rb)
   print(rc)
   print(rd)
  

    
   picture_dir = "/home/ou/archive/drawing/kxh" 
   wks         = gsn_open_wks("png",picture_dir+"/china_temp_50km+CRU+20THC+wrfout_8100")
   
   ;gsn_define_colormap(wks,"gui_default")
   ;gsn_define_colormap(wks,"nrl_sirkes")
   gsn_define_colormap(wks,"BlRe")
  
   
   res   =  True
   res@gsnDraw                 = False
   res@gsnFrame                = False
   res@gsnSpreadColors         = True
   ;res@gsnSpreadColorStart = 6
   ;res@gsnSpreadColorEnd  = 60

   ;res@mpMinLatF               = 16.75
   res@mpMinLatF               = 16.75
   ;res@mpMaxLatF               = 43.75 
   res@mpMaxLatF               = 55.25 
   ;res@mpMinLonF               = 102.25
   res@mpMinLonF               = 72.25
   ;res@mpMaxLonF               = 125.25
   res@mpMaxLonF               = 136.25
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
   res@cnLineLabelsOn          = False 
   res@cnLevelSelectionMode = "ManualLevels"
   res@cnMaxLevelValF = 25.
   res@cnMinLevelValF = -15.
   res@cnLevelSpacingF = 2.5 
   res@gsnAddCyclic = False
   res@lbLabelBarOn  =  False
   
   plot  =  new(3,graphic)
  ; res@tiMainString  =  "T2m.DJF.CRU.1980-2000"
   plot(0)=gsn_csm_contour_map(wks,t2m_cru_winter_avg,res)  
  ; res@tiMainString  =  "T2m.DJF.20THC.1980-2000"
   plot(1)=gsn_csm_contour_map(wks,t2m_thc_winter_avg,res)
  ; res@tiMainString  =  "T2m.DJF.CAS_RCM.1980-2000"
   plot(2)=gsn_csm_contour_map(wks,t2m_wrf_winter_avg,res)
   
   pres1       =  True
   pres1@gsnPanelLabelBar  =  True
   pres1@gsnFrame          =  False
   pres1@lbOrientation     =  "vertical"
   pres1@lbLabelAutoStride =  True
   pres1@lbLabelStride    = 2 
   ;pres1@gsnPanelBottom      = 0.5
   pres1@gsnPanelRight      = 0.5
   pres1@pmLabelBarWidthF    =0.05
   pres1@pmLabelBarHeightF    =0.4
   ;gsn_panel(wks,plot,(/1,3/),pres1)
   gsn_panel(wks,plot,(/3,1/),pres1)

   res@cnMinLevelValF   =  -5
   res@cnMaxLevelValF   =  35 
   res@cnLevelSpacingF  =  2.5 
   
   plot2  =  new(3,graphic)
   ;res@tiMainString  =  "T2m.JJA.CRU.1980-2000"
   plot2(0)=gsn_csm_contour_map(wks,t2m_cru_summer_avg,res) 
   ;res@tiMainString  =  "T2m.JJA.20THC.1980-2000"
   plot2(1)=gsn_csm_contour_map(wks,t2m_thc_summer_avg,res)
   ;res@tiMainString  =  "T2m.JJA.CAS_RCM.1980-2000"  
   plot2(2)=gsn_csm_contour_map(wks,t2m_wrf_summer_avg,res)
  
   pres2       =    True
   pres2@gsnPanelLabelBar   =  True
   pres2@gsnFrame           = False
   ;pres2@gsnPanelTop         = 0.5 
   pres2@gsnPanelLeft         = 0.5 
   pres2@lbLabelStride    = 2 
   pres2@lbOrientation      =  "vertical"
   pres2@lbLabelAutoStride  = True
   pres2@pmLabelBarWidthF    =0.05
   pres2@pmLabelBarHeightF    =0.4
   gsn_panel(wks,plot2,(/3,1/),pres2)
   ;gsn_panel(wks,plot2,(/1,3/),pres2)
   
   ;txres =  True
   ;txres@txFontHeightF  =  0.015   
   ;gsn_text_ndc(wks,"p_cor=0.972",0.5,0.53,txres)
   ;gsn_text_ndc(wks,"p_cor=0.965",0.81,0.53,txres)
   ;gsn_text_ndc(wks,"p_cor=0.784",0.5,0.03,txres)
   ;gsn_text_ndc(wks,"p_cor=0.898",0.81,0.03,txres)
   frame(wks)
   
end
