load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

;--------------------------------------------------------------------
; CREATE SAME WAVELET FIGURE AS TORRENCE & COMPO using seasonal Nino3
; from 1871-1997
;--------------------------------------------------------------------

begin
  ninoseas = asciiread("wave_fortran/sst_nino3.dat",-1,"float")
  ninoseas!0 = "time"
  ntime = dimsizes(ninoseas)
  timeo = fspan(1871.125,1996.875,ntime)
  ninoseas&time = timeo

  ninomam = dim_avg_Wrap(ninoseas(0::4))
  ninojja = dim_avg_Wrap(ninoseas(1::4))
  ninoson = dim_avg_Wrap(ninoseas(2::4))
  ninodjf = dim_avg_Wrap(ninoseas(3::4))

  ninoseas(0::4) = ninoseas(0::4) - ninomam
  ninoseas(1::4) = ninoseas(1::4) - ninojja
  ninoseas(2::4) = ninoseas(2::4) - ninoson
  ninoseas(3::4) = ninoseas(3::4) - ninodjf

  time  = timeo
  N     = dimsizes(time)
;************************************
; compute wavelet
;************************************
  mother  = 0
  param   = 6.0
  dt      = 0.25    ;timesteps in units of years
  s0      = dt
  dj      = 0.25
  jtot    = 1+floattointeger(((log10(N*dt/s0))/dj)/log10(2.))
  npad    = N
  nadof   = 0
  noise   = 1
  siglvl  = .05
  isigtest= 0

  w = wavelet(ninoseas,mother,dt,param,s0,dj,jtot,npad,noise,isigtest,siglvl,nadof)
;************************************
; create coodinate arrays for plot
;************************************
  power            = onedtond(w@power,(/jtot,N/))
  power!0          = "period"                        ; Y axis
  power&period     = w@period                      ; convert period to units of years

  power!1          = "time"                          ; X axis
  power&time       = time

  power@long_name  = "Power Spectrum"
  power@units      = "1/unit-freq"

; compute significance ( >= 1 is significant)
  SIG              = power                            ; transfer meta data
  SIG              = power/conform (power,w@signif,0)
  SIG@long_name    = "Significance"
  SIG@units        = " "
;********************************************************************************
; initial resource settings
;********************************************************************************
  wks = gsn_open_wks("eps","wavelet_modify")
;  gsn_define_colormap(wks,"BlAqGrYeOrReVi200")    ; choose colormap
;  gsn_define_colormap(wks,"WhiteBlueGreenYellowRed")    ; choose colormap
  gsn_define_colormap(wks,"ncl_default")    ; choose colormap

  res                     = True                  ; plot mods desired
  res@gsnDraw             = False                 ; Do not draw plot
  res@gsnFrame            = False                 ; Do not advance frome
  res@cnFillOn            = True                  ; turn on color
;  res@cnFillMode          = "RasterFill"          ; turn on raster mode
;  res@cnRasterSmoothingOn = True                  ; turn on raster smoothing
  res@cnLinesOn           = False                 ; turn off contour lines
  res@cnLineLabelsOn      = False
  res@cnInfoLabelOn       = False
  res@trYReverse          = True                  ; reverse y-axis
;  res@gsnYAxisIrregular2Linear = True
  res@tmYLMode = "Explicit"
  res@tmYLValues = (/1,2,4,8,16,32,64,128/)
  res@tmYLLabels = (/"1","2","4","8","16","32","64","128"/)
  res@tmLabelAutoStride   = True
  res@vpHeightF           = .4                    ;
  res@vpWidthF            = .7
  res@cnLevelSelectionMode = "ExplicitLevels"       ; set manual contour levels
  res@cnLevels = (/0.5,1.,2.,4./)
  res@gsnRightString       = "Wavelet Power"
  res@gsnLeftString       = "NINO3: GISST"
  res@tiYAxisString       = "Period (year)"

  res2 = True                            ; res2 probability plots
  res2@trYReverse          = True
  res2@tmYLMode = "Explicit"
  res2@tmYLValues = (/1,2,4,8,16,32,64,128/)
  res2@tmYLLabels = (/"1","2","4","8","16","32","64","128"/)
  res2@gsnDraw             = False       ; Do not draw plot
  res2@gsnFrame            = False       ; Do not advance frome
  res2@cnLevelSelectionMode = "ManualLevels" ; set manual contour levels
  res2@cnMinLevelValF      = 0.00        ; set min contour level
  res2@cnMaxLevelValF      = 2.00        ; set max contour level
  res2@cnLevelSpacingF     = 1.00        ; set contour spacing
  res2@cnInfoLabelOn       = False
  res2@cnLinesOn           = False       ; do not draw contour lines
  res2@cnLineLabelsOn      = False       ; do not draw contour labels
  res2@cnFillScaleF        = 0.5          ; add extra density
  res2@gsnLeftString = ""
  res2@gsnRightString = ""

  plot = new(4,graphic)
  plot(0) = gsn_csm_contour(wks,power,res)
  plot(1) = gsn_csm_contour(wks,SIG,res2)
  plot(1) = ShadeGtContour(plot(1),1.,17)

  scale = w@scale
  Cdelta = w@cdelta
  powernorm = power
  powernorm = power/conform(power,scale,0)
  scaleavg = dj*dt/Cdelta*dim_sum_Wrap(powernorm(time|:,{period|2.:8.}))


  gws = w@gws
  resl = True
  resl@gsnFrame = False
  resl@gsnDraw = False
  resl@trYAxisType = "LogAxis"
  resl@trYReverse          = True                  ; reverse y-axis
  resl@tmYLMode = "Explicit"
  resl@tmYLValues = (/1,2,4,8,16,32,64,128/)
  resl@tmYLLabels = (/"1","2","4","8","16","32","64","128"/)
  plot(2) = gsn_csm_xy(wks,gws,power&period,resl)

  ress = True
  ress@xyDashPatterns = (/0,1/)
  ress@pmLegendDisplayMode = "Always"
  ress@pmLegendOrthogonalPosF = -1.1
  ress@pmLegendParallelPosF   =  0.2
  ress@pmLegendWidthF           =  0.15
  ress@pmLegendHeightF          =  0.1
  ress@lgPerimOn              = False                  ; turn off box around
  ress@gsnFrame = False
  ress@gsnDraw = False
;  ress@vpXF = 0.8
;  ress@vpYF = 0.2
  ress@vpHeightF           = .4
  ress@vpWidthF            = .8
  ress@xyExplicitLegendLabels = (/"2-8 yr"/)
  ress@tiYAxisString = "variance"
  plot(3) = gsn_csm_xy(wks,power&time,scaleavg,ress)

  pres = True
  pres@gsnMaximize = True
  pres@gsnPaperOrientation = "portrait"
  pres@gsnPanelYWhiteSpacePercent = 10
  gsn_panel(wks,plot,(/2,2/),pres)

end
