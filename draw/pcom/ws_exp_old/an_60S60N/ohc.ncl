
; Description: for comparison with NOAA result
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-11 10:54:25 BJT
; Last Change: 2014-11-12 21:29:43 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure draw_ohc(lines, year, inres, arg)
begin

  img = arg@img
  wks = gsn_open_wks ("eps", img)

  res = True

;  res@vpHeightF = 0.56
;  res@vpWidthF = 0.72

  res@tiXAxisString = "model year"

  res@gsnDraw = False
  res@gsnFrame = False
  res@gsnLeftString = ""
  res@gsnRightString = ""

  res@xyMonoLineColor = False
  res@xyDashPattern = 0 ; solid
  ;   res@xyMarkLineMode = "MarkLines"
  res@xyMarkLineMode = "Lines"
  ;   res@xyMarkers = (/6, 11, 16/)
;     res@xyMarkerColors = (/"blue", "red", "forestgreen"/)
;  res@xyMarkerColors = (/"black", "blue", "red"/)
;  res@xyLineColors = (/"magenta1", "cyan", "red", "blue", "forestgreen"/)
  res@xyLineThicknessF = 3
  res@xyDashPattern = 0

  res@lgPerimOn = False
  res@lgLabelFontHeightF = 0.02
  res@lgPerimFill = "SolidFill"
  res@lgPerimFillColor = "White"

  res@pmLegendDisplayMode = "Always"
  res@pmLegendSide = "Right"
;  res@pmLegendOrthogonalPosF = -0.45
  res@pmLegendWidthF = 0.1
;  res@pmLegendHeightF = 0.5

  res@tmLabelAutoStride = True
  
;  res@tmYROn = False
;  res@tmXTOn = False
  res@tmYMajorGrid = True
  res@tmYMajorGridLineDashPattern = 2
  res@tmYMajorGridThicknessF = 0.5
;  res@tmYLTickStartF   = -80
;  res@tmYLTickSpacingF = 20
;  res@tmYLTickEndF     = 80
  res@tmXMajorGridThicknessF = 0.5

;  res@tmXBMode = "Manual"
;  res@tmXBTickStartF   = 0
;  res@tmXBTickSpacingF = 50
;  res@tmXBTickEndF     = 500
  res@tmXMajorGrid = True
  res@tmXMajorGridLineDashPattern = 2

   res@trXMaxF = 50
   res@trXMinF = 10
  ;   res@trYReverse               = True   ; reverses y-axis

  copy_VarAtts(inres, res)
  plot = gsn_csm_xy(wks, year, lines, res)

;  if (isatt(arg, "plotwidth")) then
;    txres               = True
;    text = "aaaa "
;    gsn_text_ndc(wks, text, arg@plotwidth, 0.5, txres)
;  end if

  draw(plot)
  frame(wks)

  delete(wks)
  system("eps2png_trim " + arg@img)
end


img = getenv("NCL_ARG_2")

nc = getenv("NCL_ARG_1")
f = addfile( nc, "r" )
ctr_all = f->ctr_all
year = ctr_all&time
year = year - 500

arg = True

; ohc by depth
;==============
arg@img = img+"___depth"

lines= new( (/6, dimsizes(year)/), typeof(ctr_all) )
lines(0,:) = f->ctr_700
lines(1,:) = f->an_60S60N_700
lines(2,:) = f->ctr_2000
lines(3,:) = f->an_60S60N_2000
lines(4,:) = f->ctr_all
lines(5,:) = f->an_60S60N_all
lines = lines * 1.0e-24

res = True
res@tiMainString = "Ocean Heat Content"
res@tiYAxisString = "10~S~24~N~J"
res@xyLineColors = (/"blue", "blue", "red", "red", "black", "black"/)
res@xyExplicitLegendLabels = (/"0-700m, control run", "0-700m, exp_60S-60N",\
"0-2000m, control run", "0-2000m, exp_60S-60N", \
"all depth, control run", "all depth, exp_60S-60N"/)
res@xyDashPatterns = (/0,1,0,1,0,1/) ; 0: solid

res@pmLegendOrthogonalPosF = -0.3
res@pmLegendParallelPosF = 0.5
res@pmLegendHeightF = 0.3

;draw_ohc(lines, year, res, arg)

; ohc above 20 degC, 3 basins
;==============================
arg@img = img+"___all_basin"

delete(lines)
lines= new( (/8, dimsizes(year)/), typeof(ctr_all) )
lines(0,:) = f->ctr_20deg_i
lines(1,:) = f->an_60S60N_20deg_i
lines(2,:) = f->ctr_20deg_a
lines(3,:) = f->an_60S60N_20deg_a
lines(4,:) = f->ctr_20deg_p
lines(5,:) = f->an_60S60N_20deg_p
lines(6,:) = f->ctr_20deg_g
lines(7,:) = f->an_60S60N_20deg_g
lines = lines * 1.0e-24

res@tiMainString = "Ocean Heat Content above 20 degC"
delete(res@xyLineColors)
res@xyLineColors = (/"forestgreen", "forestgreen", "blue", "blue", "red", "red", "black", "black"/)
delete(res@xyExplicitLegendLabels)
res@xyExplicitLegendLabels = (/"Indian, control run", "Indian, exp_60S-60N",\
"Atlantic, control run", "Atlantic, exp_60S-60N", \
"Pacific, control run", "Pacific, exp_60S-60N", \
"Global, control run", "Global, exp_60S-60N"/)
delete(res@xyDashPatterns)
res@xyDashPatterns = (/0,1,0,1,0,1,0,1/) ; 0: solid
res@pmLegendOrthogonalPosF = -0.3
res@pmLegendParallelPosF = 0.5
res@pmLegendHeightF = 0.3

;draw_ohc(lines, year, res, arg)

; ohc above 20 degC, Indian Ocean
;=================================
arg@img = img+"___Indian"

delete(lines)
lines= new( (/4, dimsizes(year)/), typeof(ctr_all) )
lines(0,:) = f->ctr_20deg_i_N
lines(1,:) = f->an_60S60N_20deg_i_N
lines(2,:) = f->ctr_20deg_i_S
lines(3,:) = f->an_60S60N_20deg_i_S
lines = lines * 1.0e-24

res@tiMainString = "Indian Ocean Heat Content above 20 degC"
delete(res@xyLineColors)
res@xyLineColors = (/"forestgreen", "forestgreen", "blue", "blue"/)
delete(res@xyExplicitLegendLabels)
res@xyExplicitLegendLabels = (/"north hemisphere, control run", "north hemisphere, exp_60S-60N",\
"south hemisphere, control run", "south hemisphere, exp_60S-60N"/)
delete(res@xyDashPatterns)
res@xyDashPatterns = (/0,1,0,1/)
res@pmLegendOrthogonalPosF = -0.9 ; move left, right
res@pmLegendParallelPosF = 0.4 ; up and down
res@pmLegendHeightF = 0.2

;draw_ohc(lines, year, res, arg)

; ohc above 20 degC, Pacific Ocean
;==================================
arg@img = img+"___Pacific"

delete(lines)
lines= new( (/6, dimsizes(year)/), typeof(ctr_all) )
lines(0,:) = f->ctr_20deg_p_nt
lines(1,:) = f->an_60S60N_20deg_p_nt
lines(2,:) = f->ctr_20deg_p_st
lines(3,:) = f->an_60S60N_20deg_p_st
lines(4,:) = f->ctr_20deg_p_t
lines(5,:) = f->an_60S60N_20deg_p_t
lines = lines * 1.0e-24

res@tiMainString = "Pacific Ocean Heat Content above 20 degC"
delete(res@xyLineColors)
res@xyLineColors = (/"forestgreen", "forestgreen", "blue", "blue", "red", "red"/)
delete(res@xyExplicitLegendLabels)
res@xyExplicitLegendLabels = (/"north of 10N, control run", "north of 10N, exp_60S-60N",\
"south of 10S, control run", "south of 10S, exp_60S-60N",\
"10S-10N, control run", "10S-10N, exp_60S-60N"/)
delete(res@xyDashPatterns)
res@xyDashPatterns = (/0,1,0,1,0,1/)
res@pmLegendOrthogonalPosF = -0.9 ; move left, right
res@pmLegendParallelPosF = 0.7 ; up and down
res@pmLegendHeightF = 0.3

;draw_ohc(lines, year, res, arg)

; ohc above 20 degC, Atlantic Ocean
;===================================
arg@img = img+"___Atlantic"

delete(lines)
lines= new( (/6, dimsizes(year)/), typeof(ctr_all) )
lines(0,:) = f->ctr_20deg_a_nt
lines(1,:) = f->an_60S60N_20deg_a_nt
lines(2,:) = f->ctr_20deg_a_st
lines(3,:) = f->an_60S60N_20deg_a_st
lines(4,:) = f->ctr_20deg_a_t
lines(5,:) = f->an_60S60N_20deg_a_t
lines = lines * 1.0e-24

res@tiMainString = "Atlantic Ocean Heat Content above 20 degC"
delete(res@xyLineColors)
res@xyLineColors = (/"forestgreen", "forestgreen", "blue", "blue", "red", "red"/)
delete(res@xyExplicitLegendLabels)
res@xyExplicitLegendLabels = (/"north of 10N, control run", "north of 10N, exp_60S-60N",\
"south of 10S, control run", "south of 10S, exp_60S-60N",\
"10S-10N, control run", "10S-10N, exp_60S-60N"/)
delete(res@xyDashPatterns)
res@xyDashPatterns = (/0,1,0,1,0,1/)
res@pmLegendOrthogonalPosF = -0.9 ; move left, right
res@pmLegendParallelPosF = 0.6 ; up and down
res@pmLegendHeightF = 0.3

;draw_ohc(lines, year, res, arg)

; ohc above 20 degC, Atlantic Ocean, north of 10N
;=================================================
arg@img = img+"___Atlantic_n10N"

delete(lines)
lines= new( (/2, dimsizes(year)/), typeof(ctr_all) )
lines(0,:) = f->ctr_20deg_a_nt
lines(1,:) = f->an_60S60N_20deg_a_nt
lines = lines * 1.0e-24

res@tiMainString = "Atlantic Ocean Heat Content above 20 degC"
delete(res@xyLineColors)
res@xyLineColors = (/"forestgreen", "forestgreen"/)
delete(res@xyExplicitLegendLabels)
res@xyExplicitLegendLabels = (/"north of 10N, control run", "north of 10N, exp_60S-60N"/)
delete(res@xyDashPatterns)
res@xyDashPatterns = (/0,1/)
res@pmLegendOrthogonalPosF = -0.9 ; move left, right
res@pmLegendParallelPosF = 0.2 ; up and down
res@pmLegendHeightF = 0.1

;draw_ohc(lines, year, res, arg)

; ohc above 20 degC, Atlantic Ocean, south of 10N
;=================================================
arg@img = img+"___Atlantic_s10S"

delete(lines)
lines= new( (/2, dimsizes(year)/), typeof(ctr_all) )
lines(0,:) = f->ctr_20deg_a_st
lines(1,:) = f->an_60S60N_20deg_a_st
lines = lines * 1.0e-24

res@tiMainString = "Atlantic Ocean Heat Content above 20 degC"
delete(res@xyLineColors)
res@xyLineColors = (/"blue", "blue"/)
delete(res@xyExplicitLegendLabels)
res@xyExplicitLegendLabels = (/"south of 10S, control run", "south of 10S, exp_60S-60N"/)
delete(res@xyDashPatterns)
res@xyDashPatterns = (/0,1/)
res@pmLegendOrthogonalPosF = -0.9 ; move left, right
res@pmLegendParallelPosF = 0.6 ; up and down
res@pmLegendHeightF = 0.1

draw_ohc(lines, year, res, arg)

