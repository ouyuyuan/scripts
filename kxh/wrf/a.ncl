load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/cnmap/cnmap.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin

   f  =  addfile("/media/WRF50kmOUT/WRF_run/wrfout_d01_2001-05-21_03:00:00","r")
   
   n1 = 1
   n2 = 1
   n3= 1 

   lat2d =  f->XLAT(0,:,:)
   lon2d =  f->XLONG(0,:,:)

   t1 =  f->T2(0:2,:,:)
   t11   =  dim_avg_n_Wrap(t1,0)
   t2 =  f->T2(32+n1:n2,:,:)
   t22   =  dim_avg_n_Wrap(t2,0)
;-----------------------------1984
   t3 =  f->T2(31+n1+n2:1+n2+n1,:,:)
   t33   =  dim_avg_n_Wrap(t3,0)
   t4 =  f->T2(31+n1*2+n2:1+n2+n1*2,:,:)
   t44   =  dim_avg_n_Wrap(t4,0)
   t5 =  f->T2(31+n1*3+n2:1+n2+n1*3,:,:)
   t55   =  dim_avg_n_Wrap(t5,0)
   t6 =  f->T2(31+n1*4+n2:1+n2*2+n1*3,:,:)
   t66   =  dim_avg_n_Wrap(t6,0)
;----------------------------1988
   t7 =  f->T2(31+n1*4+n2*2:1+n2*2+n1*4,:,:)
   t77   =  dim_avg_n_Wrap(t7,0)
   t8 =  f->T2(31+n1*5+n2*2:1+n2*2+n1*5,:,:)
   t88   =  dim_avg_n_Wrap(t8,0)
   t9 =  f->T2(31+n1*6+n2*2:1+n2*2+n1*6,:,:)
   t99   =  dim_avg_n_Wrap(t9,0)
   t10 =  f->T2(31+n1*7+n2*2:1+n2*3+n1*6,:,:)
   tt10   =  dim_avg_n_Wrap(t10,0)
;----------------------------1992
   t_11 =  f->T2(31+n1*7+n2*3:1+n2*3+n1*7,:,:)
   tt11   =  dim_avg_n_Wrap(t_11,0)
   t12 =  f->T2(31+n1*8+n2*3:1+n2*3+n1*8,:,:)
   tt12   =  dim_avg_n_Wrap(t12,0)
   t13 =  f->T2(31+n1*9+n2*3:1+n2*3+n1*9,:,:)
   tt13   =  dim_avg_n_Wrap(t13,0)
   t14 =  f->T2(31+n1*10+n2*3:1+n2*4+n1*9,:,:)
   tt14   =  dim_avg_n_Wrap(t13,0)
;---------------------------1996 
   t15 =  f->T2(31+n1*10+n2*4:1+n2*4+n1*10,:,:)
   tt15   =  dim_avg_n_Wrap(t15,0)
   t16 =  f->T2(31+n1*11+n2*4:1+n2*4+n1*11,:,:)
   tt16   =  dim_avg_n_Wrap(t16,0)
   t17 =  f->T2(31+n1*12+n2*4:1+n2*4+n1*12,:,:)
   tt17   =  dim_avg_n_Wrap(t17,0)
   t18 =  f->T2(31+n1*13+n2*4:1+n2*5+n1*12,:,:)
   tt18   =  dim_avg_n_Wrap(t18,0)
;---------------------------2000
   t19 =  f->T2(31+n1*13+n2*5:1+n2*5+n1*13,:,:)
   tt19   =  dim_avg_n_Wrap(t19,0)
   t20 =  f->T2(31+n1*14+n2*5:1+n2*5+n1*14,:,:)
   tt20   =  dim_avg_n_Wrap(t20,0)
   t21 =  f->T2(31+n1*15+n2*5:1+n2*5+n1*15,:,:)
   tt21   =  dim_avg_n_Wrap(t21,0)
   t_22 =  f->T2(31+n1*16+n2*5:1+n2*6+n1*15,:,:)
   tt22   =  dim_avg_n_Wrap(t_22,0)
;---------------------------2004
   t23 =  f->T2(31+n1*16+n2*6:1+n2*6+n1*16,:,:)
   tt23   =  dim_avg_n_Wrap(t23,0)
   t24 =  f->T2(31+n1*17+n2*6:1+n2*6+n1*17,:,:)
   tt24   =  dim_avg_n_Wrap(t24,0)
   t25 =  f->T2(31+n1*18+n2*6:1+n2*6+n1*18,:,:)
   tt25   =  dim_avg_n_Wrap(t25,0)
   t26 =  f->T2(31+n1*19+n2*6:1+n2*7+n1*18,:,:)
   tt26   =  dim_avg_n_Wrap(t26,0)
;---------------------------2008
   t27 =  f->T2(31+n1*19+n2*7:1+n2*7+n1*19,:,:)
   tt27   =  dim_avg_n_Wrap(t27,0)
   t28 =  f->T2(31+n1*20+n2*7:1+n2*7+n1*20,:,:)
   tt28   =  dim_avg_n_Wrap(t28,0)
 
   twin1 =  t11+t33+t44+t55+t77+t88+t99+tt11+tt12+tt13+tt15+tt16+tt17+tt19+tt20+tt21+tt23+tt24+tt25+tt27+tt28
   twin2 =  t66+tt10+tt14+tt18+tt22+tt26
   twin3 = t22
   twin  =  (twin1*720./20215.+twin2*728./20215+twin3*727./20215)-273.15 
  
   s1 =  f->T2(1:2,:,:)
   s11   =  dim_avg_n_Wrap(s1,0)
   s2 =  f->T2(1+n2:2+n2,:,:)
   s22   =  dim_avg_n_Wrap(s2,0)
;------------------------------1984
   s3 =  f->T2(1+n2+n1:1+n2+n1,:,:)
   s33   =  dim_avg_n_Wrap(s3,0)
   s4 =  f->T2(1+n2+n1*2:1+n2+n1*2,:,:) 
   s44   =  dim_avg_n_Wrap(s4,0)
   s5 =  f->T2(1+n2+n1*3:1+n2+n1*3,:,:) 
   s55   =  dim_avg_n_Wrap(s5,0)
   s6 =  f->T2(1+n2*2+n1*3:1+n2*2+n1*3,:,:) 
   s66  =  dim_avg_n_Wrap(s6,0)
;------------------------------1988
   s7 =  f->T2(1+n2*2+n1*4:1+n2*2+n1*4,:,:) 
   s77  =  dim_avg_n_Wrap(s7,0)
   s8 =  f->T2(1+n2*2+n1*5:1+n2*2+n1*5,:,:) 
   s88  =  dim_avg_n_Wrap(s8,0)
   s9 =  f->T2(1+n2*2+n1*6:1+n2*2+n1*6,:,:) 
   s99  =  dim_avg_n_Wrap(s9,0)
   s10 =  f->T2(1+n2*3+n1*6:1+n2*3+n1*6,:,:) 
   ss10  =  dim_avg_n_Wrap(s10,0)
;------------------------------1992
   s_11 =  f->T2(1+n2*3+n1*7:1+n2*3+n1*7,:,:) 
   ss11  =  dim_avg_n_Wrap(s_11,0)
   s12 =  f->T2(1+n2*3+n1*8:1+n2*3+n1*8,:,:) 
   ss12  =  dim_avg_n_Wrap(s12,0)
   s13 =  f->T2(1+n2*3+n1*9:1+n2*3+n1*9,:,:) 
   ss13  =  dim_avg_n_Wrap(s13,0)
   s14 =  f->T2(1+n2*4+n1*9:1+n2*4+n1*9,:,:) 
   ss14  =  dim_avg_n_Wrap(s14,0)
;------------------------------1996
   s15 =  f->T2(1+n2*4+n1*10:1+n2*4+n1*10,:,:) 
   ss15  =  dim_avg_n_Wrap(s15,0)
   s16 =  f->T2(1+n2*4+n1*11:1+n2*4+n1*11,:,:) 
   ss16  =  dim_avg_n_Wrap(s16,0)
   s17 =  f->T2(1+n2*4+n1*12:1+n2*4+n1*12,:,:) 
   ss17  =  dim_avg_n_Wrap(s17,0)
   s18 =  f->T2(1+n2*5+n1*12:1+n2*5+n1*12,:,:) 
   ss18  =  dim_avg_n_Wrap(s18,0)
;-----------------------------2000
   s19 =  f->T2(1+n2*5+n1*13:1+n2*5+n1*13,:,:) 
   ss19  =  dim_avg_n_Wrap(s19,0) 
   s20 =  f->T2(1+n2*5+n1*14:1+n2*5+n1*14,:,:) 
   ss20  =  dim_avg_n_Wrap(s20,0) 
   s21 =  f->T2(1+n2*5+n1*15:1+n2*5+n1*15,:,:) 
   ss21  =  dim_avg_n_Wrap(s21,0) 
   s_22 =  f->T2(1+n2*6+n1*15:1+n2*6+n1*15,:,:) 
   ss22  =  dim_avg_n_Wrap(s_22,0)
;----------------------------2004
   s23 =  f->T2(1+n2*6+n1*16:1+n2*6+n1*16,:,:) 
   ss23  =  dim_avg_n_Wrap(s23,0)
   s24 =  f->T2(1+n2*6+n1*17:1+n2*6+n1*17,:,:) 
   ss24  =  dim_avg_n_Wrap(s24,0)
   s25 =  f->T2(1+n2*6+n1*18:1+n2*6+n1*18,:,:) 
   ss25  =  dim_avg_n_Wrap(s25,0)
   s26 =  f->T2(1+n2*7+n1*18:1+n2*7+n1*18,:,:) 
   ss26  =  dim_avg_n_Wrap(s26,0)
;----------------------------2008 
   s27 =  f->T2(1+n2*7+n1*19:1+n2*7+n1*19,:,:) 
   ss27  =  dim_avg_n_Wrap(s27,0)
   s28 =  f->T2(1+n2*7+n1*20:1+n2*7+n1*20,:,:) 
   ss28  =  dim_avg_n_Wrap(s28,0)
   s29 =  f->T2(1+n2*7+n1*21:1+n2*7+n1*21,:,:) 
   ss29  =  dim_avg_n_Wrap(s29,0)

   sum1  =  s11+s33+s44+s55+s77+s88+s99+ss11+ss12+ss13+ss15+ss16+ss17+ss19+ss20+ss21+ss23+ss24+ss25+ss27+ss28+ss29
   sum2  =  s22+s66+ss10+ss14+ss18+ss22+ss26
   tsum  =  (sum1+sum2)/29.-273.15
 
   tsum@lat2d  =  lat2d
   tsum@lon2d  =  lon2d
   twin@lat2d  =  lat2d
   twin@lon2d  =  lon2d

   twin@units  =  "degree celsius"
   tsum@units  =  "degree celsius"
 
   lat   =  fspan(-89.75,89.75,360)
   lon   =  fspan(-179.75,179.75,720)
   lat@units   =  "degree_north"
   lon@units   =  "degree_east"
   delete(twin2)
   twin!0  =  "cdf"
   twin!1  =  "ddd"
   ;twin&lat   =  lat(:)
   ;twin&lon   =  lon(:)
   tsum!0  =  "abc"
   tsum!1  =  "aaaaa"
   ;tsum&lat   =  lat(:)
   ;tsum&lon   =  lon(:)
   twin2 =  rcm2rgrid_Wrap(lat2d,lon2d,twin,lat,lon,0)
   tsum2 =  rcm2rgrid_Wrap(lat2d,lon2d,tsum,lat,lon,0)
   ;twin2 =  rcm2rgrid(lat2d,lon2d,twin,lat,lon,0)
   ;tsum2 =  rcm2rgrid(lat2d,lon2d,tsum,lat,lon,0)
   printVarSummary(twin)
   printVarSummary(tsum)
   twin2!0  =  "lat"
   twin2!1  =  "lon"
   twin2&lat   =  lat(:)
   twin2&lon   =  lon(:)
   tsum2!0  =  "lat"
   tsum2!1  =  "lon"
   tsum2&lat   =  lat(:)
   tsum2&lon   =  lon(:)
    
   ;delete(twin3)   
   ;twin3 =  twin2(123:177,564:610)
   ;tsum3 =  tsum2(123:177,564:610)
   
  
   wks         = gsn_open_wks("eps","test")
   
   gsn_define_colormap(wks,"BlRe")
  
   
   res   =  True
   res@gsnDraw                 = False
   res@gsnFrame                = False
   res@gsnSpreadColors         = True

   res@mpMinLatF               = 16.75
   res@mpMaxLatF               = 43.75
   res@mpMinLonF               = 102.25
   res@mpMaxLonF               = 125.25
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
   res@cnMaxLevelValF = 25.
   res@cnMinLevelValF = -15.
   res@cnLevelSpacingF = 2.5 
   res@gsnAddCyclic = False
   res@lbLabelBarOn  =  False

    plot  =  new(4,graphic)
   res@tiMainString  =  "Bw"
   ;plot(0)=gsn_csm_contour_map(wks,twin,res)  
   res@tiMainString  =  "Aw"
   ;plot(1)=gsn_csm_contour_map(wks,twin2,res)
   res@tiMainString  =  "BS"
   ;plot(2)=gsn_csm_contour_map(wks,tsum,res)
   res@tiMainString  =  "AS"
   ;plot(3)=gsn_csm_contour_map(wks,tsum2,res)
   
   pres1       =  True
   pres1@gsnPanelLabelBar  =  True
   pres1@gsnFrame          =  False
   pres1@lbLabelAutoStride =  True
  ; gsn_panel(wks,plot,(/2,2/),pres1)
 
end
