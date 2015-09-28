
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-15 16:10:24 BJT
; Last Change: 2014-11-15 20:50:31 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl" 

procedure draw_nino(img, inres, arg)
begin

  nc = getenv("NCL_ARG_1")

  f = addfile(nc, "r")
  yyyymm = f->yyyymm
  line = f->$arg@lineName$
  delete(f)

  yrfrac = yyyymm_to_yyyyfrac(yyyymm, 0.0)

  wks = gsn_open_wks("eps", img)

  res                  = True       
  res@gsnDraw          = False       
  res@gsnFrame         = False     
  res@vpHeightF        = 0.4            ; change aspect ratio of plot
  res@vpWidthF         = 0.8            
  res@vpXF             = 0.1            ; start plot at x ndc coord 
  res@gsnYRefLine      = 0.0            ; create a reference line 
  res@gsnAboveYRefLineColor = "red"              ; above ref line fill red
  res@gsnBelowYRefLineColor = "blue"             ; below ref line fill blue
  
  res@trYMinF          = -3.0           ; min value on y-axis
  res@trYMaxF          =  3.0           ; max value on y-axis
  res@tiXAxisString = "year"

  copy_VarAtts(inres, res)

  if (arg@shade .eq. False) then
    plot = gsn_csm_xy (wks,yrfrac,line,res)
  else
    res@gsnDraw = True
    res@gsnScale = True
    res@gsnYRefLine           = 0.5     ; create a reference line   
    res@gsnAboveYRefLineColor = "red"
    res@gsnBelowYRefLineColor = "transparent"
    plot = gsn_csm_xy (wks,yrfrac, line, res)

    res@gsnYRefLine           = -0.5   ; create a reference line   
    res@gsnAboveYRefLineColor = "transparent"
    res@gsnBelowYRefLineColor = "blue"
    plot = gsn_csm_xy (wks,yrfrac, line, res)
    
    gsLine             = True            
    gsLine@gsLineColor = "Foreground"      ; Set polyline color
    gsLine@gsLineDashPattern = 0           ; solid
    gsLine@gsLineThicknessF  = 1.          ; default 1.0                                 
    zero = new ( dimsizes(yrfrac) , float)
    zero = 0.0
    gsn_polyline(wks,plot,yrfrac,zero,gsLine) 
  end if

  draw(plot)
  frame(wks)
  delete(wks)
  system("eps2png_trim "+img)
end

res = True
arg = True
img = getenv("NCL_ARG_2")
years = "1948-2008: Base 1971-2000"

; sst anomaly to 1950-1979
;==========================
res@tiMainString = "SST anomalies: "+years
res@tiYAxisString = "SST anomalies (~S~o~N~C)"    ; y-axis label      
arg@lineName = "sst_anom_oni"
arg@shade = False
;draw_nino(img+"___sst_anom", res, arg)

; Ocena Nino Indices defined by NOAA
;====================================
res@tiMainString = "ONI: "+years
res@tiYAxisString = ""
arg@lineName = "oni"
;draw_nino(img+"___oni", res, arg)

arg@shade = True
draw_nino(img+"___oni_shade", res, arg)
