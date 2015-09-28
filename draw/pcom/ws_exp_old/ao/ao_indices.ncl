
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-15 16:10:24 BJT
; Last Change: 2014-11-17 10:51:52 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl" 

procedure draw_line(img, inres, arg)
begin

  nc = getenv("NCL_ARG_1")

  ; the last 3 year is climatory
  f = addfile(nc, "r")
  time = f->time(0:731)
  line = f->$arg@lineName$(0:731)
  eof_regres = f->eof_regres
  delete(f)

  nrun = arg@nrun
  endopt    = 1
  ii = ind(.not.ismissing(line))
  line(ii) = runave_n_Wrap (line(ii), nrun, endopt, 0)

  yyyymm = cd_calendar(time, -1)      ; ALL dates assciated with X

  yrfrac = yyyymm_to_yyyyfrac(yyyymm, 0.0)

  wks = gsn_open_wks("eps", img)

  res                  = True       
  res@tiMainFontHeightF = 0.03
  res@gsnDraw          = False       
  res@gsnFrame         = False     
  res@vpHeightF        = 0.4            ; change aspect ratio of plot
  res@vpWidthF         = 0.9            
  res@vpXF             = 0.1            ; start plot at x ndc coord 
  res@gsnYRefLine      = 0.0            ; create a reference line 
  res@gsnAboveYRefLineColor = "red"              ; above ref line fill red
  res@gsnBelowYRefLineColor = "blue"             ; below ref line fill blue
  res@gsnLeftString  = "EOF 1"
  res@gsnRightString = sprintf("%5.1f", eof_regres@pcvar) +"%"
  
  res@trYMinF          = -3.0           ; min value on y-axis
  res@trYMaxF          =  3.0           ; max value on y-axis
  res@tiXAxisString = "year"

  res@tmXBMode = "Manual"
  res@tmXBTickStartF   = 1950
  res@tmXBTickSpacingF = 10
  res@tmXBTickEndF     = 2010

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
;years = "1948-2008: Base 1971-2000"
years = "1948-2008"

; AO indices
;====================================
arg@shade = False
arg@lineName = "ts_sd"
arg@nrun = 3 ; months of  running mean
res@tiMainString = "AO indices: "+years+", "+arg@nrun+" months runing mean"
res@tiYAxisString = ""
draw_line(img, res, arg)

arg@shade = True
;draw_line(img+"___oni_shade", res, arg)
