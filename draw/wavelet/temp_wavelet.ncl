load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
 
;some useful setting
 img_type = "eps"
 img_name = "amoc_wavelet"
 
 minlat = -90
 maxlat = 90
 minlon = 0
 maxlon = 360
 
 strtdate = 18500116
 lastdate = 20051216
 
 mid1date = 19610116
 mid2date = 19901216

 strtyear = 1850
 lastyear = 2005
 year = ispan(strtyear,lastyear,1)
 nyear = dimsizes(year)

begin
  file1 = addfile("/Volumes/RAID_01/songy/CMIP5/data_analysis/msftyyz/data_atlantic/AMOC_index/amoc_index_Atlantic_msftyyz_Omon_FGOALS-s2_historical_r1i1p1_1850-2005.nc","r")
 
  to = file1->AMOC
 
;************************************
; compute wavelet (Missing values not allowed due to use of FFT)
;************************************  
  mother  = 0
  param   = 6.0
  dt      = 1.0             ;for NAO (timesteps in units of years)
  s0      = dt
  dj      = 0.25
  jtot    = 1 + floattointeger(((log10(nyear*dt/s0))/dj)/log10(2.))
  npad    = nyear
  nadof   = new(2,float)
  noise   = 1 
  siglvl  = 0.95
  isigtest= 0

 wo = wavelet(to,mother,dt,param,s0,dj,jtot,npad,noise,isigtest,siglvl,nadof)
 printVarSummary(wo)
;************************************
; create coodinate arrays for plot
;************************************
 wo!0 = "numb"
 wo!1 = "period"
 wo!2 = "year"
 wo&period = wo@period
 wo&year = year
printVarSummary(wo)
;************************************

  power            = onedtond( wo@power, (/jtot,nyear/) )
  power!0          = "period"                        ; Y axis
  power&period     = wo@period
  power!1          = "time"                          ; X axis
  power&time       = year
  power@long_name  = "Power Spectrum"
  power@units      = "C^2"

                         ; compute significance ( >= 1 is significant)
  SIG  = power           ; transfer metadata
  SIG  = power/conform (power,wo@signif,0)


printVarSummary(SIG)


;************************************
;open a workstation and start to plot
;************************************
 wks = gsn_open_wks(img_type,img_name)
 
; gsn_define_colormap(wks,"nrl_sirkes")
;gsn_define_colormap(wks,"amwg_blueyellowred")
gsn_define_colormap(wks,"ncl_default")
 

 res = True

  res@vpWidthF      = 0.75        ; plot size (width)
  res@vpHeightF     = 0.35        ; plot size (length)

 res@gsnDraw = False
 res@gsnFrame = False
 res@cnFillOn = True
 res@cnLinesOn = False;True
 res@cnLineLabelsOn = False
 res@gsnSpreadColors = True
 res@trYReverse = True                  
 res@tmXTOn = False
 res@lbLabelBarOn =True; False
 res@lbLabelStride =2 
  res@tmXBLabelFontHeightF = 0.02
  res@tmYLLabelFontHeightF = 0.017
  res@tmYLLabelFontThicknessF = 0.8
  res@tmXBLabelFontThicknessF = 0.8
  res@tmYLLabelStride = 0
  res@tmXBLabelFont = 25
  res@tmYLLabelFont = 25
 res@tmXBMode = "Manual"
 res@tmXBTickSpacingF =20
 res@trYMinF = 5.
 res@trYMaxF = 120.
;res@tiXAxisString = "Year"
; res@tmXBMinorValues = ispan(1850,2005,5)
 res@tmYLMode   = "Explicit"
 res@tmYLValues = (/5,10,20,30,50,80,120/)
 res@tmYLLabels = (/"5","10","20","30","50","80","120"/)
 res@tiYAxisString = "Period (Years)"  ; xaxis
 res@tiYAxisFont = 25
 res@tiYAxisFontHeightF = 0.02
 res@cnLevelSelectionMode = "ManualLevels"       ; set manual contour levels
 res@cnMinLevelValF       = -6.                  ; set min contour level
 res@cnMaxLevelValF       = 6.                ; set max contour level
 res@cnLevelSpacingF      = .5
  res@gsnSpreadColors = True    ; use full colormap
  res@gsnSpreadColorEnd       = 239
  res@gsnSpreadColorStart       = 18
; res@cnLevelSelectionMode = "ExplicitLevels" 
; res@cnLevels = (/-4.5,-3.5,-2.5,-2,-1.5,-1.0,-0.6,-0.3,-0.2,-0.1,0,0.1,0.2,0.3,0.6,1.0,1.5,2,2.5,3.5,4.5/)
; res@cnFillColors = (/2,3,4,5,6,7,8,9,10,11,13,14,15,16,17,18,19,20,21,22/)
  res@cnInfoLabelOn       = False
 res@gsnContourNegLineDashPattern = 5
;  res@vpHeightF           = 0.15                   ; height and width of plot
;  res@vpWidthF            = 0.28 
 res@gsnStringFont = "times-roman"
  res@gsnStringFontHeightF = 0.02
  res@gsnRightString = "AMOC"
 res@gsnLeftString = "FGOALS-s2"
 res@lbLabelFontHeightF = 0.017
 res@lbLabelFont = "times-roman"
 
 plot = gsn_csm_contour(wks,wo(0,:,:),res)

res1  = True

 plot = ShadeCOI(wks,plot,wo,year,res1)

  RES = True
  RES@gsnDraw = False
  RES@gsnFrame = False
  RES@cnInfoLabelOn       = False
  RES@cnLevelSelectionMode = "ManualLevels"     ; set manual contour levels
  RES@cnMinLevelValF       = 1.0                ; set min contour level
  RES@cnMaxLevelValF       = 1.1                ; set max contour level
  RES@cnLevelSpacingF      = 1.0                ; set contour spacing
  RES@trYReverse           = True
  RES@gsnRightString = ""
  RES@gsnLeftString = ""
  RES@cnLinesOn = False;True
  RES@cnLineLabelsOn = False

;  pSIG = gsn_csm_contour(wks,SIG(:,:),RES) 
;overlay(plot,pSIG)
  tt=1.0
cres  = True
cres@gsnDraw = False
cres@gsnFrame = False
cres@cnInfoLabelOn = False
cres@cnLinesOn = False
cres@cnLineLabelsOn = False
cres@cnFillOn = True
cres@cnMonoFillPattern    = False        ; Use multiple fill patterns
cres@cnFillScales = 0.001
cres@cnFillPatterns        = (/-1,16,-1/)
cres@cnLevelSelectionMode = "ExplicitLevels"
cres@cnLevels = (/-tt,tt/)
cres@lbLabelBarOn         = False
cres@cnFillColors = (/1,1,1/)
cres@gsnLeftString=""
cres@gsnRightString=""

  psig = gsn_csm_contour(wks,SIG(:,:),cres) 
overlay(plot,psig)

 pres = True
 pres@gsnPanelLabelBar = True
 pres@lbLabelFontHeightF = 0.015
 pres@lbLabelFont = "times-roman"
 pres@lbLabelStride =2 
;  pres@gsnMaximize = True
;  pres@gsnPaperOrientation = "portrait"
;  pres@gsnPanelYWhiteSpacePercent = 5.0
; gsn_panel(wks,plot,(/3,1/),pres)
draw(plot)
frame(wks)
 
end
