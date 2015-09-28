;*************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
 
begin
;************************************************

f4 = addfile("AMOC_ensemble_mean.nc","r")
mean = f4->mean
printVarSummary(mean)
 
model = (/"CanESM2","CCSM4","CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FGOALS-s2","GFDL-CM3","GFDL-ESM2M","GISS-E2-R","HadCM3","HadGEM2-CC","HadGEM2-ES","MIROC-ESM","MPI-ESM-LR","MRI-CGCM3","NorESM1-M"/)

data = (/1850,1850,1850,1850,1850,1850,1850,1850,1850,1850,1850,1850,1850,1850,1850,1850,1850,1850,1860,1860,1860,1861,1850,1850,1850,1860,1860,1860,1860,1860,1860,1860,1850,1850,1850,1850,1850,1850,1850,1850,1850,1850,1850,1850/)


stop_year = (/1908,1969,1914,1934,1972,1982,1901,1911,1966,1981,1903,1918,1932,1963,1971,1903,1970,1982,1964,1982,1913,1973,1982,1912,1948,1913,1969,1982,1908,1919,1938,1982,1911,1921,1973,1983,1910,1973,1982,1981,1972,1981,1984,1974,1909,1942,1976,1964,1902,1972,1982,1932,1912,1941,1973,1902,1916,1948,1971,1982,1912,1964,1983,1921,1969,1928,1964,1979,1967,1965,1965,1982,1914,1939,1965,1982,1935,1973,1908,1919,1939,1965,1982,1916,1933,1973,1982,1911,1930,1964,1981,1912,1939,1965,1982,1929,1911,1973,1915,1941,1970,1982,1907,1927,1941,1982,1910,1973,1907,1966,1982,1902,1932,1954,1976,1912,1929,1965,1983,1903,1902,1911,1971,1903,1964,1905,1972,1981,1966,1911,1943/)
 
printVarSummary(stop_year)
 
num_case = (/2,4,4,5,3,2,3,2,3,4,4,3,1,2,2,4,4,3,5,3,2,3,1,1,2,4,2,5,4,4,5,2,4,4,2,3,4,4,1,3,2,3,1,2/)

print(sum(num_case))
trend= new((/dimsizes(stop_year),10,30,139/),"float")

;;;;;;;;;;;;;;;;;;;;;;;OHC     51
 
file_thetao_sub_name = asciiread("file_AMOC_interpolate_nengyong.txt",-1,"string")
file_ohc = file_thetao_sub_name(:)
;print(file_ohc)
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; OHC  lev

f1 = addfile("FGOALS-s2_interpolate_model_362x196x30.nc","r")
lev = f1->LEV
;lev =  (/10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,163,192,252,354,510,731,1021,1385,1821,2327,2897,3522,4190,4887,5600/);lev = f1->LEV(1:29)

 
lev_mid= 1000.
dis             =   abs(lev(0)-lev_mid)
 
    do  k   =   0, dimsizes(lev)-1
        if (abs(lev(k)-lev_mid) .lt. dis) then
            lev_mid_ind =   k
            dis         =   abs(lev(k)-lev_mid)
        end if
    end do

print(lev_mid_ind)

;;;;;;;;;;;;;;;;;;;;;;;read data


xx = 0
do i = 0,43,1

;print("        k= "+k+"        i=  "+i+"         j= "+j)
f2 = addfile(file_ohc(i),"r")
ohc_index = f2->MSF(:,:,{-31:80})
heat = dble2flt(ohc_index)

heat!0 = "time"
heat&time = ispan(data(i),data(i)+dimsizes(ohc_index&TIME)-1,1)
;print(heat&time)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;sum
do m =0,num_case(i)-1,1

   trend(xx,:,:,:) = heat({stop_year(xx):stop_year(xx)+9},:,:)
;print(trend(j,xx)+"         "+xx)
   xx = xx +1

end do

delete(f2)
delete(ohc_index)
delete(heat)
end do

printVarSummary(trend)


pc = dim_avg_n_Wrap(trend,0)

printVarSummary(pc)


  x     = ispan(1,10,1)*1.
  tval  = new ((/dimsizes(pc&LEV),dimsizes(pc&LAT)/) , float)    ; explicitly allocate sp
  nptxy = new ((/dimsizes(pc&LEV),dimsizes(pc&LAT)/) , integer)  ; explicitly allocate sp

  rc= regcoef(x,pc(LEV|:,LAT|:,time|:),tval,nptxy)*10.

rc!0 = "lev"
rc!1 = "lat"
rc&lev = pc&LEV
rc&lat = pc&LAT

  copy_VarAtts(rc,tval)
  copy_VarCoords(rc,tval)

printVarSummary(rc)
printVarSummary(tval)

tt = 3.23
;************************************************
; plotting parameters
;************************************************

wks = gsn_open_wks("eps","sign_AMOC_nengyong")
gsn_define_colormap(wks,"amwg_blueyellowred")

;************************************************
; plotting parameters
;************************************************
 
    res     =       True
    ;res@gsnMaximize     =   True
    res@gsnFrame        =    False
    res@gsnDraw         =    False
 
    res@trYReverse              = True
    res@gsnYAxisIrregular2Linear = True
    res@gsnXAxisIrregular2Linear = True
 
    res@cnLinesOn       =     False
    res@cnFillOn        =    True
    res@cnLineLabelsOn   =   False
 
    res@cnInfoLabelOn = False
 
    res@tiYAxisString = ""
    res@tiYAxisFontHeightF = 0.015
   res@tiYAxisFont = "helvetica"
    res@gsnStringFont = "times-roman"
    res@tiXAxisFontHeightF = 0.015
    res@gsnLeftString="(b) Accelerated"
    res@gsnCenterString="";Accelerated"
    res@gsnRightString="Sv (10 yr):S:-1:N:"
    res@gsnRightStringFontHeightF=0.03
    res@gsnLeftStringFontHeightF=0.03
    res@gsnCenterStringFontHeightF=0.03
    res@gsnCenterStringOrthogonalPosF =0.05
    res@gsnRightStringOrthogonalPosF =0.05
 
    res@lbTopMarginF  = 0.1
    res@lbBottomMarginF = 0.5
    res@pmLabelBarWidthF = 0.7
    res@lbLabelFontHeightF = 0.022
    res@lbLabelFont = 25
    res@lbLabelBarOn=False


     res@tmXBLabelFontHeightF = 0.025
     res@tmXBLabelFont = "helvetica"
     res@tmYLLabelFont = "helvetica"
     res@tmYLLabelFontHeightF = 0.025
 
 
    res@gsnSpreadColors         = True
    res@gsnSpreadColorEnd       = 16
    res@gsnSpreadColorStart       = 3
 
 
  res@cnLevelSelectionMode = "ManualLevels"       ; Manually select levels
  res@cnLevelSpacingF      =  0.05                  ; Contour spacing
  res@cnMinLevelValF       = -.5                 ; Min contour level
  res@cnMaxLevelValF       =  .5
 
   res@lbLabelStride       = 2
 
    res_upper   =   res
    res_upper@tiMainString      =   ""
    res_upper@tiXAxisString     =   ""
    res_upper@tmYLMode          =   "Explicit"
    res_upper@tmXBLabelsOn  =   False
    res_upper@tmXBOn        =   False
    res_upper@tmXTOn        =  True
    res_upper@tmYLValues  =   (/1000,500,lev(0)/)
    res_upper@tmYLLabels  =   (/1000,500,0/)
    res_upper@tmYLMinorValues =   ispan(0,1000,100)
 
;    res_upper@tmXBValues  =   (/-30,-20,-10,0,10,20,30/)
;    res_upper@tmXBLabels  =   (/"30S","20S","10S","Eq","10N","20N","30N"/)
;    res_upper@tmXBMinorValues =   ispan(-30,30,5)


 
    res_upper@vpHeightF       =   0.25
    res_upper@vpWidthF        =   0.75
    res_upper@vpYF            =   0.8
    res_upper@vpXF            =   0.2
    res_upper@trYReverse              =  True
    res_upper@lbLabelBarOn   = False
  plot_upper    = gsn_csm_contour(wks,rc(0:lev_mid_ind,:),res_upper)
 
 
cres  = True
cres@gsnDraw = False
cres@gsnFrame = False
cres@cnInfoLabelOn = False
cres@cnLinesOn = False
cres@cnLineLabelsOn = False
cres@cnFillOn = True
cres@cnMonoFillPattern    = False        ; Use multiple fill patterns
cres@cnFillPatterns        = (/17,-1,17/)
cres@cnLevelSelectionMode = "ExplicitLevels"
cres@cnLevels = (/-tt,tt/)
;cres@cnFillColors = (/6,11,14/)
cres@lbLabelBarOn         = False
 
    cres_upper   =   cres
    cres_upper@tmYLMode          =   "Explicit"
    cres_upper@tmXBLabelsOn  =   False
    cres_upper@tmXBOn        =   False
    cres_upper@tmXTOn        =   False
    cres_upper@tmYLValues  =    (/1000,500,lev(0)/)
    cres_upper@tmYLLabels  =     (/1000,500,0/)
    cres_upper@tmYLMinorValues =   ispan(0,1000,100)
    cres_upper@vpHeightF       =   0.25
    cres_upper@vpWidthF        =   0.75
    cres_upper@vpYF            =   0.8
    cres_upper@vpXF            =   0.2
    cres_upper@trYReverse              =  True
    cres_upper@lbLabelBarOn   =   False
 
    plot1_upper    = gsn_csm_contour(wks,tval(0:lev_mid_ind,:),cres_upper)

 
 res_upper_ov = res_upper
 
 
    res_upper_ov@vpHeightF       =   0.25
    res_upper_ov@vpWidthF        =   0.75
    res_upper_ov@vpYF            =   0.8
    res_upper_ov@vpXF            =   0.2
     res_upper_ov@cnLinesOn       =   True
    res_upper_ov@cnFillOn        =  False ; True
    res_upper_ov@cnLineLabelsOn   =  True; False
 
  res_upper_ov@cnLevelSelectionMode = "ManualLevels"       ; Manually select levels
  res_upper_ov@cnLevelSpacingF      =  4                  ; Contour spacing
  res_upper_ov@cnMinLevelValF       = -32                 ; Min contour level
  res_upper_ov@cnMaxLevelValF       =  32
  res_upper_ov@gsnContourZeroLineThicknessF = 2.        ; doubles thickness of zero contour
  res_upper_ov@gsnContourNegLineDashPattern = 1                 ; sets negative contours to dash pattern 1
 
  res_upper_ov@cnLabelMasking             = True
  res_upper_ov@cnLineLabelBackgroundColor = "transparent"
  res_upper_ov@cnLineLabelDensityF      = 0.6             ; <1.0 = less, >1.0 = more
  res_upper_ov@cnLineLabelInterval   = 1                 ; labels for every line (default=2)
 
 
  plot_upper_ov    = gsn_csm_contour(wks,mean(0:lev_mid_ind,:),res_upper_ov)



 res_bottom   =   res
    res_bottom@gsnLeftString=""
    res_bottom@gsnRightString=""
    res_bottom@gsnCenterString=""
 
    res_bottom@tiMainString     = ""
    res_bottom@tiYAxisString    = ""
    res_bottom@tiXAxisString    = ""
    res_bottom@tiXAxisFontHeightF    =  0.02
    res_bottom@tmYLMode         =   "Explicit"
    res_bottom@tmXTOn        =   False
    res_bottom@tmYLValues  =   (/6000,5000,4000,3000,2000,1000, lev(0)/)
    res_bottom@tmYLLabels  =   (/6000,5000,4000,3000,2000,1000,0/)
    res_bottom@tmYLMinorValues  =   ispan(0,6000,200)
    res_bottom@tmXBValues  =   (/-30,0,30,60/)
    res_bottom@tmXBLabels  =   (/"30S","Eq","30N","60N"/)
    res_bottom@tmXBMinorValues =   ispan(-30,80,10)
 
 
    res_bottom@vpHeightF        =   0.3
    res_bottom@vpWidthF         =   0.75
    res_bottom@vpYF              =   0.55
    res_bottom@vpXF              =   0.2
    res_bottom@trYReverse              =  True
    res_bottom@lbLabelBarOn   =  True 
    plot_bottom    = gsn_csm_contour(wks,rc(lev_mid_ind:dimsizes(lev)-1,:),res_bottom)
 
 
ccres  = True
ccres@gsnDraw = False
ccres@gsnFrame = False
ccres@cnInfoLabelOn = False
ccres@cnLinesOn = False
ccres@cnLineLabelsOn = False
ccres@cnFillOn = True
ccres@cnMonoFillPattern    = False        ; Use multiple fill patterns
ccres@cnFillPatterns        = (/17,-1,17/)
ccres@cnLevelSelectionMode = "ExplicitLevels"
ccres@cnLevels = (/-tt,tt/)
;ccres@cnFillColors = (/6,11,14/)
ccres@lbLabelBarOn         = False

    ccres_bottom   =   ccres
    ccres_bottom@tmYLMode          =   "Explicit"
    ccres_bottom@tmXBLabelsOn  =   False
    ccres_bottom@tmXBOn        =   False
    ccres_bottom@tmXTOn        =   False
    ccres_bottom@tmYLValues  =     (/6000,5000,4000,3000,2000,1000, lev(0)/)
    ccres_bottom@tmYLLabels  =     (/6000,5000,4000,3000,2000,1000,0/)
    ccres_bottom@tmYLMinorValues =   ispan(0,6000,200)
    ccres_bottom@vpHeightF       =   0.3
    ccres_bottom@vpWidthF        =   0.75
    ccres_bottom@vpYF            =   0.55
    ccres_bottom@vpXF            =   0.2
    ccres_bottom@trYReverse              =  True
    ccres_bottom@lbLabelBarOn   =   False
 
    plot1_bottom    = gsn_csm_contour(wks,tval(lev_mid_ind:dimsizes(lev)-1,:),ccres_bottom)
 
 
 res_bottom_ov = res_bottom
 
 
    res_bottom_ov@vpHeightF       =   0.3
    res_bottom_ov@vpWidthF        =   0.75
    res_bottom_ov@vpYF            =   0.55
    res_bottom_ov@vpXF            =   0.2
     res_bottom_ov@cnLinesOn       =   True
    res_bottom_ov@cnFillOn        =  False ; True
    res_bottom_ov@cnLineLabelsOn   =  True; False
 
  res_bottom_ov@cnLevelSelectionMode = "ManualLevels"       ; Manually select levels
  res_bottom_ov@cnLevelSpacingF      =  4                  ; Contour spacing
  res_bottom_ov@cnMinLevelValF       = -32                 ; Min contour level
  res_bottom_ov@cnMaxLevelValF       =  32
  res_bottom_ov@gsnContourZeroLineThicknessF = 2.        ; doubles thickness of zero contour
  res_bottom_ov@gsnContourNegLineDashPattern = 1                 ; sets negative contours to dash pattern 1
 
  res_bottom_ov@cnLabelMasking             = True
  res_bottom_ov@cnLineLabelBackgroundColor = "transparent"
  res_bottom_ov@cnLineLabelDensityF      = 0.6             ; <1.0 = less, >1.0 = more
  res_bottom_ov@cnLineLabelInterval   = 1                 ; labels for every line (default=2)

  plot_bottom_ov    = gsn_csm_contour(wks,mean(lev_mid_ind:dimsizes(lev)-1,:),res_bottom_ov)
 
    overlay(plot_upper,plot1_upper)
    overlay(plot_bottom,plot1_bottom)
    overlay(plot_upper, plot_upper_ov )
    overlay(plot_bottom, plot_bottom_ov )

draw(plot_upper)
draw(plot_bottom)
frame(wks)


end
