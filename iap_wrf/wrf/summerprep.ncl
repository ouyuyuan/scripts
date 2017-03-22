load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/cnmap/cnmap.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin
  
   f2_thc=addfile("/media/TOSHIBA/OBS/precip/1998/prate.1998.nc","r")
  
   f3_wrf=addfile("/media/toshiba_02/radiation3/wrfout_d01_1998-05-29_00:00:00","r")
   f4_wrf=addfile("/media/toshiba_02/radiation3/wrfout_d01_1998-06-28_00:00:00","r")
   f5_wrf=addfile("/media/toshiba_02/radiation3/wrfout_d01_1998-07-28_00:00:00","r")
   f6_wrf=addfile("/media/toshiba_02/radiation3/wrfout_d01_1998-08-27_00:00:00","r")
   
   f7_wrf=addfile("/media/toshiba_02/radiation4/wrfout_d01_1998-05-29_03:00:00","r")
   f8_wrf=addfile("/media/toshiba_02/radiation4/wrfout_d01_1998-06-28_03:00:00","r")
   f9_wrf=addfile("/media/toshiba_02/radiation4/wrfout_d01_1998-07-28_03:00:00","r")
   f10_wrf=addfile("/media/toshiba_02/radiation4/wrfout_d01_1998-08-27_03:00:00","r")
   
   f11_wrf=addfile("/media/toshiba_02/radiation5/wrfout_d01_1998-05-29_03:00:00","r")
   f12_wrf=addfile("/media/toshiba_02/radiation5/wrfout_d01_1998-06-28_03:00:00","r")
   f13_wrf=addfile("/media/toshiba_02/radiation5/wrfout_d01_1998-07-28_03:00:00","r")
   f14_wrf=addfile("/media/toshiba_02/radiation5/wrfout_d01_1998-08-27_03:00:00","r")
	


   lat2d = f3_wrf->XLAT(0,:,:)
   lon2d = f3_wrf->XLONG(0,:,:)
   
   ;t1 =  f1_thc->air(2672:2919,:,:)
   t2 =  f2_thc->prate(1208:1943,:,:)
   t = f2_thc->prate(0,:,:)
   
   ;ta_thc =  dim_avg_n_Wrap(t1,0) 
   tb_thc =  dim_avg_n_Wrap(t2,0) 
   
   ;t1_thc =  ta_thc*0.01 + 427.66 - 273.15
   t2_thc = ( tb_thc*1.e-07 + 0.0032766)*24*60*60
   ;t_thc =  t*0.01 + 427.66 - 273.15
   ;t_thc =  t1_thc*31./90+t2_thc*59./90.
   t_thc =  t2_thc
   copy_VarCoords(t, t_thc) 
   ;t_thc@lat = f2_thc->t&lat
   ;t_thc@lon = f2_thc->t&lon
   t1_wrf = f3_wrf->RAINC(24:239,:,:) 
   t11_wrf = f3_wrf->RAINNC(24:239,:,:) 
   t2_wrf = f4_wrf->RAINC(0:239,:,:) 
   t22_wrf = f4_wrf->RAINNC(0:239,:,:) 
   t3_wrf = f5_wrf->RAINC(0:239,:,:)
   t33_wrf = f5_wrf->RAINNC(0:239,:,:)
   t4_wrf = f6_wrf->RAINC(0:39,:,:)
   t44_wrf = f6_wrf->RAINNC(0:39,:,:)
   ta_wrf   =  dim_avg_n_Wrap(t1_wrf,0)
   taa_wrf   =  dim_avg_n_Wrap(t11_wrf,0)
   tb_wrf   =  dim_avg_n_Wrap(t2_wrf,0)
   tbb_wrf   =  dim_avg_n_Wrap(t22_wrf,0)
   tc_wrf   =  dim_avg_n_Wrap(t3_wrf,0)
   tcc_wrf   =  dim_avg_n_Wrap(t33_wrf,0)
   td_wrf   =  dim_avg_n_Wrap(t4_wrf,0)
   tdd_wrf   =  dim_avg_n_Wrap(t44_wrf,0)
   ;t_wrf =  ta_wrf*216./736.+tb_wrf*240./736.+tc_wrf*240./736.+td_wrf*40./736.
  ; tt_wrf =  taa_wrf*216./736.+tbb_wrf*240./736.+tcc_wrf*240./736.+tdd_wrf*40./736.
   p_wrf =( ta_wrf*216./736.+tb_wrf*240./736.+tc_wrf*240./736.+td_wrf*40./736.+taa_wrf*216./736.+tbb_wrf*240./736.+tcc_wrf*240./736.+tdd_wrf*40./736.)/92.

   p_wrf@lat2d = lat2d
   p_wrf@lon2d = lon2d
  
   t1_wrf1  =  f7_wrf->RAINC(23:239,:,:) 
   t11_wrf1  =  f7_wrf->RAINNC(23:239,:,:)
   t2_wrf1  =  f8_wrf->RAINC(0:239,:,:)
   t22_wrf1  =  f8_wrf->RAINNC(0:239,:,:)
   t3_wrf1  =  f9_wrf->RAINC(0:239,:,:)
   t33_wrf1  =  f9_wrf->RAINNC(0:239,:,:)
   t4_wrf1  =  f10_wrf->RAINC(0:38,:,:)
   t44_wrf1  =  f10_wrf->RAINNC(0:38,:,:)
   ta_wrf1  =  dim_avg_n_Wrap(t1_wrf1,0) 
   taa_wrf1  =  dim_avg_n_Wrap(t11_wrf1,0) 
   tb_wrf1  =  dim_avg_n_Wrap(t2_wrf1,0) 
   tbb_wrf1  =  dim_avg_n_Wrap(t22_wrf1,0) 
   tc_wrf1  =  dim_avg_n_Wrap(t3_wrf1,0) 
   tcc_wrf1  =  dim_avg_n_Wrap(t33_wrf1,0) 
   td_wrf1  =  dim_avg_n_Wrap(t4_wrf1,0)
   tdd_wrf1  =  dim_avg_n_Wrap(t44_wrf1,0)
;   t_wrf1   =  ta_wrf1*217./736.+tb_wrf1*240./736.+tc_wrf1*240./736.+td_wrf1*39./736.
;   tt_wrf1   =  taa_wrf1*217./736.+tbb_wrf1*240./736.+tcc_wrf1*240./736.+tdd_wrf1*39./736.
   p_wrf1   =   (ta_wrf1*217./736.+tb_wrf1*240./736.+tc_wrf1*240./736.+td_wrf1*39./736.+taa_wrf1*217./736.+tbb_wrf1*240./736.+tcc_wrf1*240./736.+tdd_wrf1*39./736.)/92.
 
   p_wrf1@lat2d   =  lat2d
   p_wrf1@lon2d   =  lon2d

   t1_wrf2  =  f11_wrf->RAINC(23:239,:,:)
   t11_wrf2  =  f11_wrf->RAINNC(23:239,:,:)
   t2_wrf2  =  f12_wrf->RAINC(0:239,:,:)
   t22_wrf2  =  f12_wrf->RAINNC(0:239,:,:)
   t3_wrf2  =  f13_wrf->RAINC(0:239,:,:)
   t33_wrf2  =  f13_wrf->RAINNC(0:239,:,:)
   t4_wrf2  =  f14_wrf->RAINC(0:38,:,:)
   t44_wrf2  =  f14_wrf->RAINNC(0:38,:,:)
   ta_wrf2  =  dim_avg_n_Wrap(t1_wrf2,0) 
   taa_wrf2  =  dim_avg_n_Wrap(t11_wrf2,0) 
   tb_wrf2  =  dim_avg_n_Wrap(t2_wrf2,0) 
   tbb_wrf2  =  dim_avg_n_Wrap(t22_wrf2,0) 
   tc_wrf2  =  dim_avg_n_Wrap(t3_wrf2,0) 
   tcc_wrf2  =  dim_avg_n_Wrap(t33_wrf2,0) 
   td_wrf2  =  dim_avg_n_Wrap(t4_wrf2,0) 
   tdd_wrf2  =  dim_avg_n_Wrap(t44_wrf2,0) 
 ;  t_wrf2   =  ta_wrf2*217./736.+tb_wrf2*240./736.+tc_wrf2*240./736.+td_wrf2*39./736.
 ;  tt_wrf2   =  taa_wrf2*217./736.+tbb_wrf2*240./736.+tcc_wrf2*240./736.+tdd_wrf2*39./736.
   p_wrf2   =( ta_wrf2*217./736.+tb_wrf2*240./736.+tc_wrf2*240./736.+td_wrf2*39./736.+taa_wrf2*217./736.+tbb_wrf2*240./736.+tcc_wrf2*240./736.+tdd_wrf2*39./736.)/92.
   p_wrf2@lat2d   =  lat2d
   p_wrf2@lon2d   =  lon2d

;   t_wrf!0 = "lat"
;   t_wrf!1 = "lon"
;   t_wrf&lat = lat2d(:,0);latwrf
;   t_wrf&lon = lon2d(0,:);lonwrf
;   dimll = dimsizes(lat2d)
;   nlat = dimll(0)
;   nlon = dimll(1)

   t_thc@units   =  "Kg.m-2.s-1"
   p_wrf@units   =  "mm"
   p_wrf1@units   =  "mm"
   p_wrf2@units   =  "mm"
 ;  wks         = gsn_open_wks("x11","test")
   picture_dir = "/home/kongxh/process_data/pictures/"
   wks         = gsn_open_wks("png",picture_dir+"summer_prep")
   gsn_define_colormap(wks,"matlab_jet")

   res	=	True
  ; res@tiMainString            ="Temperature at 2m"
   res@gsnDraw                 = False
   res@gsnFrame                = False
	res@gsnSpreadColors         = True
  ; res@gsnSpreadColorStart = 6
  ; res@gsnSpreadColorEnd  = 60
	
   ; turn off lat/lon tick mark, because of Labert projection
   res@tmXTOn = False
   res@tmXBOn = False
   res@tmYLOn = False
   res@tmYROn = False

   res@mpMinLatF               = 17.
   res@mpMaxLatF               = 55.
   res@mpMinLonF               = 72.
   res@mpMaxLonF               = 136.
 
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
;   res@cnMaxLevelValF = 160.
 ;  res@cnMinLevelValF = 20.
  ; res@cnLevelSpacingF = 20.

   res@gsnAddCyclic = False
;   res@mpLimitMode = "Corners"
;   res@mpLeftCornerLatF = lat2d(0,0)
;   res@mpLeftCornerLonF = lon2d(0,0)
;   res@mpRightCornerLatF = lat2d(nlat-1, nlon-1)
;   res@mpRightCornerLonF = lon2d(nlat-1, nlon-1)

 ;  res@lbLabelBarOn  =  False

   cnres    =     True
   cnres@china       =  True
   cnres@river       =  True
   cnres@province    =  False
   cnres@nanhai      =  True
   cnres@diqu        =  False
   
   plot  =  new(4,graphic)
   res@tiMainString  =  "20THC"
	plot(0)=gsn_csm_contour_map(wks,t_thc,res) 
   res@tiMainString  =  "CAM scheme"
   plot(1)=gsn_csm_contour_map(wks,p_wrf,res)
   res@tiMainString  =  "RRTMG scheme"
   plot(2)=gsn_csm_contour_map(wks,p_wrf1,res)
   res@tiMainString  =  "New Goddard scheme"
   plot(3)=gsn_csm_contour_map(wks,p_wrf2,res)

 ;  chinamap    =  add_china_map(wks,plot(0),cnres)
 ;  chinamap    =  add_china_map(wks,plot(1),cnres)
 ;  chinamap    =  add_china_map(wks,plot(2),cnres)
 ;  chinamap    =  add_china_map(wks,plot(3),cnres)
 
 ;  res_text    =  True
 ;  res_text@txFontHeightF    =  0.015
 ;  res_text@txJust           =  "CenterLeft" 

;   dum1  =  gsn_add_text(wks,plot(0),"20thc",75,50,res_text)
;   dum1  =  gsn_add_text(wks,plot(1),"CAM scheme",75,50,res_text)
;   dum1  =  gsn_add_text(wks,plot(2),"RRTMG scheme",75,50,res_text)
;   dum1  =  gsn_add_text(wks,plot(3),"New Goddard scheme",75,50,res_text)
   resP  =  True
   resP@txString  =  "Precipitation  in Summer"
   resP@gsnPanelXWhiteSpacePercent = 5
   resP@gsnPanelYWhiteSpacePercent = 10
   resP@gsnPanelLabelBar   =  True
	gsn_panel(wks,plot,(/2,2/),resP)

end
