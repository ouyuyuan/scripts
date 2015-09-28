
; Description: for comparison with NOAA result
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-11 10:54:25 BJT
; Last Change: 2014-11-18 10:50:22 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure draw_ohc(lines, year, inres, arg)
begin

  fontheight = 0.03
  img = arg@img
  wks = gsn_open_wks ("eps", img)

  res = True

  res@vpHeightF = 0.4
  res@vpWidthF = 0.8

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
  res@lgLabelFontHeightF = 0.025
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
;  res@tmYLMode = "Explicit"
;  res@tmYLValues = (/7.3,7.4,7.5,7.6/)
;  res@tmYLLabels = res@tmYLValues
;  res@tmYLMinorValues =  ispan(0,350,50)
  res@tmYLLabelFontHeightF = fontheight

  res@tmXMajorGridThicknessF = 0.5

  res@tmXBMode = "Manual"
  res@tmXBTickStartF   = 10
  res@tmXBTickSpacingF = 10
  res@tmXBTickEndF     = 60
  res@tmXMajorGrid = True
  res@tmXMajorGridLineDashPattern = 2

;   res@trXMaxF = 50
;   res@trXMinF = 10
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
ctr64_all = f->ctr64_all
year = ctr64_all&time
;year = year - 500
;year = year + 500

arg = True

; ohc by depth
;==============
arg@img = img+"___depth"

lines= new( (/6, dimsizes(year)/), typeof(ctr64_all) )
lines(0,:) = f->ctr64_700
lines(1,:) = f->an_30N60N_p_700
lines(2,:) = f->ctr64_2000
lines(3,:) = f->an_30N60N_p_2000
lines(4,:) = f->ctr64_all
lines(5,:) = f->an_30N60N_p_all
lines = lines * 1.0e-24

res = True
res@tiMainString = "Ocean Heat Content"
res@tiYAxisString = "10~S~23~N~J"
res@xyLineColors = (/"blue", "blue", "red", "red", "black", "black"/)
res@xyExplicitLegendLabels = (/"0-700m, control run", "0-700m, exp_30N-60N_periodic",\
"0-2000m, control run", "0-2000m, exp_30N-60N_periodic", \
"all depth, control run", "all depth, exp_30N-60N_periodic"/)
res@xyDashPatterns = (/0,1,0,1,0,1/) ; 0: solid

res@pmLegendOrthogonalPosF = -0.3
res@pmLegendParallelPosF = 0.5
res@pmLegendHeightF = 0.3

;draw_ohc(lines, year, res, arg)

; ohc above 20 degC, 3 basins
;==============================
arg@img = img+"___all_basin"

delete(lines)
lines= new( (/8, dimsizes(year)/), typeof(ctr64_all) )
lines(0,:) = f->ctr64_20deg_i
lines(1,:) = f->an_30N60N_p_20deg_i
lines(2,:) = f->ctr64_20deg_a
lines(3,:) = f->an_30N60N_p_20deg_a
lines(4,:) = f->ctr64_20deg_p
lines(5,:) = f->an_30N60N_p_20deg_p
lines(6,:) = f->ctr64_20deg_g
lines(7,:) = f->an_30N60N_p_20deg_g
lines = lines * 1.0e-24

res@tiMainString = "Ocean Heat Content above 20 degC"
delete(res@xyLineColors)
res@xyLineColors = (/"forestgreen", "forestgreen", "blue", "blue", "red", "red", "black", "black"/)
delete(res@xyExplicitLegendLabels)
res@xyExplicitLegendLabels = (/"Indian, control run", "Indian, exp_30N-60N_periodic",\
"Atlantic, control run", "Atlantic, exp_30N-60N_periodic", \
"Pacific, control run", "Pacific, exp_30N-60N_periodic", \
"Global, control run", "Global, exp_30N-60N_periodic"/)
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
lines= new( (/4, dimsizes(year)/), typeof(ctr64_all) )
lines(0,:) = f->ctr64_20deg_i_N
lines(1,:) = f->an_30N60N_p_20deg_i_N
lines(2,:) = f->ctr64_20deg_i_S
lines(3,:) = f->an_30N60N_p_20deg_i_S
lines = lines * 1.0e-24

res@tiMainString = "Indian Ocean Heat Content above 20 degC"
delete(res@xyLineColors)
res@xyLineColors = (/"forestgreen", "forestgreen", "blue", "blue"/)
delete(res@xyExplicitLegendLabels)
res@xyExplicitLegendLabels = (/"north hemisphere, control run", "north hemisphere, exp_30N-60N_periodic",\
"south hemisphere, control run", "south hemisphere, exp_30N-60N_periodic"/)
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
lines= new( (/6, dimsizes(year)/), typeof(ctr64_all) )
lines(0,:) = f->ctr64_20deg_p_nt
lines(1,:) = f->an_30N60N_p_20deg_p_nt
lines(2,:) = f->ctr64_20deg_p_st
lines(3,:) = f->an_30N60N_p_20deg_p_st
lines(4,:) = f->ctr64_20deg_p_t
lines(5,:) = f->an_30N60N_p_20deg_p_t
lines = lines * 1.0e-24

res@tiMainString = "Pacific Ocean Heat Content above 20 degC"
delete(res@xyLineColors)
res@xyLineColors = (/"forestgreen", "forestgreen", "blue", "blue", "red", "red"/)
delete(res@xyExplicitLegendLabels)
res@xyExplicitLegendLabels = (/"north of 10N, control run", "north of 10N, exp_30N-60N_periodic",\
"south of 10S, control run", "south of 10S, exp_30N-60N_periodic",\
"10S-10N, control run", "10S-10N, exp_30N-60N_periodic"/)
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
lines= new( (/6, dimsizes(year)/), typeof(ctr64_all) )
lines(0,:) = f->ctr64_20deg_a_nt
lines(1,:) = f->an_30N60N_p_20deg_a_nt
lines(2,:) = f->ctr64_20deg_a_st
lines(3,:) = f->an_30N60N_p_20deg_a_st
lines(4,:) = f->ctr64_20deg_a_t
lines(5,:) = f->an_30N60N_p_20deg_a_t
lines = lines * 1.0e-24

res@tiMainString = "Atlantic Ocean Heat Content above 20 degC"
delete(res@xyLineColors)
res@xyLineColors = (/"forestgreen", "forestgreen", "blue", "blue", "red", "red"/)
delete(res@xyExplicitLegendLabels)
res@xyExplicitLegendLabels = (/"north of 10N, control run", "north of 10N, exp_30N-60N_periodic",\
"south of 10S, control run", "south of 10S, exp_30N-60N_periodic",\
"10S-10N, control run", "10S-10N, exp_30N-60N_periodic"/)
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
lines= new( (/2, dimsizes(year)/), typeof(ctr64_all) )
lines(0,:) = f->ctr64_20deg_a_nt
lines(1,:) = f->an_30N60N_p_20deg_a_nt
lines = lines * 1.0e-24

res@tiMainString = "Atlantic Ocean Heat Content above 20 degC"
delete(res@xyLineColors)
res@xyLineColors = (/"forestgreen", "forestgreen"/)
delete(res@xyExplicitLegendLabels)
res@xyExplicitLegendLabels = (/"north of 10N, control run", "north of 10N, exp_30N-60N_periodic"/)
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
lines= new( (/2, dimsizes(year)/), typeof(ctr64_all) )
lines(0,:) = f->ctr64_20deg_a_st
lines(1,:) = f->an_30N60N_p_20deg_a_st
lines = lines * 1.0e-24

res@tiMainString = "Atlantic Ocean Heat Content above 20 degC"
delete(res@xyLineColors)
res@xyLineColors = (/"blue", "blue"/)
delete(res@xyExplicitLegendLabels)
res@xyExplicitLegendLabels = (/"south of 10S, control run", "south of 10S, exp_30N-60N_periodic"/)
delete(res@xyDashPatterns)
res@xyDashPatterns = (/0,1/)
res@pmLegendOrthogonalPosF = -0.9 ; move left, right
res@pmLegendParallelPosF = 0.6 ; up and down
res@pmLegendHeightF = 0.1

;draw_ohc(lines, year, res, arg)

; ohc above 20 degC, Pacific Ocean, south of 10N
;=================================================
arg@img = img+"___Pac_s10S"

delete(lines)
lines= new( (/2, dimsizes(year)/), typeof(ctr64_all) )
lines(0,:) = f->ctr64_20deg_p_st
lines(1,:) = f->an_30N60N_p_20deg_p_st
lines = lines * 1.0e-23

res@tiMainString = "Pacific Ocean Heat Content"
delete(res@xyLineColors)
res@xyLineColors = (/"black", "red"/)
delete(res@xyExplicitLegendLabels)
res@xyExplicitLegendLabels = (/"35S-10S, control", "35S-10S, exp"/)
delete(res@xyDashPatterns)
res@xyDashPatterns = (/0,0/)
res@pmLegendOrthogonalPosF = -0.6 ; move left, right
res@pmLegendParallelPosF = 0.2 ; up and down
res@pmLegendHeightF = 0.1
;res@trYMaxF = 7.5

;draw_ohc(lines, year, res, arg)

; ohc above 20 degC, Pacific Ocean, north of 10S
;=================================================
arg@img = img+"___Pac_n10N"

delete(lines)
lines= new( (/2, dimsizes(year)/), typeof(ctr64_all) )
lines(0,:) = f->ctr64_20deg_p_nt
lines(1,:) = f->an_30N60N_p_20deg_p_nt
lines = lines * 1.0e-23

delete(res@xyLineColors)
res@xyLineColors = (/"black", "red"/)
delete(res@xyExplicitLegendLabels)
res@xyExplicitLegendLabels = (/"10N-35N, control", "10N-35N, exp"/)
delete(res@xyDashPatterns)
res@xyDashPatterns = (/0,0/)
res@pmLegendOrthogonalPosF = -0.6 ; move left, right
res@pmLegendParallelPosF = 0.2 ; up and down
res@pmLegendHeightF = 0.1

res@trYMaxF = 7.4
;delete(tmYLValues)
res@tmYLValues = (/6.8,7.0,7.2,7.4/)
;delete(tmYLLabels)
res@tmYLLabels = res@tmYLValues

;draw_ohc(lines, year, res, arg)

; ohc above 20 degC, Pacific Ocean, 10S-10N
;=================================================
arg@img = img+"___Pac_10S10N"

delete(lines)
lines= new( (/2, dimsizes(year)/), typeof(ctr64_all) )
lines(0,:) = f->ctr64_20deg_p_t
lines(1,:) = f->an_30N60N_p_20deg_p_t
lines = lines * 1.0e-23

delete(res@xyLineColors)
res@xyLineColors = (/"black", "red"/)
delete(res@xyExplicitLegendLabels)
res@xyExplicitLegendLabels = (/"10S-10N, control", "10S-10N, exp"/)
delete(res@xyDashPatterns)
res@xyDashPatterns = (/0,0/)
res@pmLegendOrthogonalPosF = -0.6 ; move left, right
res@pmLegendParallelPosF = 0.6 ; up and down
res@pmLegendHeightF = 0.1

res@trYMaxF = 7.9
res@trYMinF = 7.1
;delete(tmYLValues)
res@tmYLValues = (/7.1,7.3,7.5,7.7/)
;delete(tmYLLabels)
res@tmYLLabels = res@tmYLValues

;draw_ohc(lines, year, res, arg)

; ohc above 20 degC, Pacific Ocean, diff
;=================================================
arg@img = img+"___Pac_diff"

ctr_t = f->ctr64_20deg_p_t
ex_t  = f->an_30N60N_p_20deg_p_t
ctr_nt = f->ctr64_20deg_p_nt
ex_nt  = f->an_30N60N_p_20deg_p_nt
ctr_st = f->ctr64_20deg_p_st
ex_st  = f->an_30N60N_p_20deg_p_st

delete(lines)
lines= new( (/3, dimsizes(year)/), typeof(ctr64_all) )
lines(0,:) = ex_st - ctr_st
lines(1,:) = ex_t - ctr_t
lines(2,:) = ex_nt - ctr_nt
lines = lines * 1.0e-23

delete(res@xyLineColors)
res@xyLineColors = (/"blue", "red", "forestgreen"/)
delete(res@xyExplicitLegendLabels)
res@xyExplicitLegendLabels = (/"35S-10S", "10S-10N", "10N-35N"/)
delete(res@xyDashPatterns)
res@xyDashPatterns = (/0,0,0/)
res@pmLegendOrthogonalPosF = -0.3 ; move left, right
res@pmLegendParallelPosF = 0.15 ; up and down
res@pmLegendHeightF = 0.15

res@trYMaxF = 0.2
res@trYMinF = -0.2
;delete(tmYLValues)
;res@tmYLValues = (/-1., -0.5, 0., 0.5, 1./)
;delete(tmYLLabels)
;res@tmYLLabels = res@tmYLValues

draw_ohc(lines, year, res, arg)

