
; Description: zonal profile of MOC
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2015-06-24 09:35:27 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;img, dirs, and data files------------------------------{{{1
datDir    = "/home/ou/archive/data/pcom/"
img       = getenv("NCL_ARG_2")

refDir    = "exp_spinup/post/"
expDir1   = "exp71_heaving_b_Pac_20S-20N/post/"
expDir2   = "exp72_heaving_b_Pac_0N-40N/post/"
expDir3   = "exp73_heaving_b_Pac_20N-60N/post/"
expDir4   = "exp74_heaving_b_Pac_40N-80N/post/"

nc = "calc_001e_cn_depth_time_ohc.nc"

;get plotting data--------------------------------------{{{1

procedure get_profile(expDir, varName, line1, line2) ;{{{2
; write time mean of the first 60 years to line1, 
;   and last 60 years to line2
local cn, cnR
begin
  f = addfile(datDir + expDir + nc, "r")
  cn = f->$varName$
  delete(f)

  f = addfile(datDir + refDir + nc, "r")
  cnR = f->$varName$
  delete(f)

  cn = cn - cnR
  cn = dim_rmvmean_n_Wrap(cn, 0)
  cn&time = cn&time - 600
  cn = cn*1e-12
  cn@units = "10~S~12~N~"+cn@units

  line1 = dim_avg_n_Wrap(cn({1:60},:), 0)
  line2 = dim_avg_n_Wrap(cn({61:120},:), 0)

  delete(cn)
  delete(cnR)
end 

;get lines {{{2
procedure get_profiles(expDir, lines)
begin
  get_profile(expDir, "vhfGlo", lines(0,:), lines(5,:))
  get_profile(expDir, "vhfPac", lines(1,:), lines(6,:))
  get_profile(expDir, "vhfInd", lines(2,:), lines(7,:))
  get_profile(expDir, "vhfSou", lines(3,:), lines(8,:))
  get_profile(expDir, "vhfAtl", lines(4,:), lines(9,:))
  line = lines(0,:)
  lines@units = line@units
end

texts = (/\
"Global Ocean", "Pacific", "Indian Ocean", \
"Southern Ocean", "Atlantic"/)

f = addfile(datDir+expDir1+nc,"r")
z = f->z
delete(f)
nz = dimsizes(z)

lines1 = new( (/10,nz/), float )
get_profiles(expDir1, lines1)

lines2 = lines1
get_profiles(expDir2, lines2)

lines3 = lines1
get_profiles(expDir3, lines3)

;plotting parameters------------------------------------{{{1

fontSize = 0.02
yLabelSize = fontSize*0.8
xLabelSize = fontSize*0.8
plotWid = 0.2
plotHei = 0.4
lineColors = (/\
"transparent", "transparent", "transparent","transparent", "transparent",\
"black", "red", "blue","gold3", "green3"/)
;"black", "red", "blue","gold3", "green3"/)
linePatterns = (/\
14,14,14,14,14,\
0,0,0,0,0/)
lineThicks = (/\
1.5,1.5,1.5,1.5,1.5,\
2,2,2,2,2/)
;2,2,2,2,2/)

autoTicks = True
;autoTicks = False

wks = gsn_open_wks ("eps", img)

;resources attributes setting---------------------------{{{1
res = True
res@vpWidthF = plotWid
res@vpHeightF = plotHei
;res@vpXF = -0.01
;res@vpYF = 0.9

res@tiXAxisFontHeightF = xLabelSize
res@tiYAxisFontHeightF = yLabelSize
res@tiYAxisString = "depth (m)"
res@tiXAxisString = lines1@units

res@gsnDraw = False
res@gsnFrame = False
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
res@gsnStringFontHeightF = xLabelSize
res@gsnCenterStringOrthogonalPosF = 0.05
res@gsnLeftStringOrthogonalPosF = -1.15
res@gsnRightStringOrthogonalPosF = -0.14
res@gsnLeftStringParallelPosF = 0.02
res@gsnXRefLine = 0.

res@tmLabelAutoStride    = True
;res@tmXTOn = False
;res@tmYROn = False
res@tmYLTickSpacingF = 10
res@tmYLMinorOn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmYRLabelFontHeightF = yLabelSize 

res@tmXBLabelFontHeightF = xLabelSize
res@tmXBMinorOn = False

;res@trYMinF = -35
res@trYMaxF = 3000

if .not.autoTicks
  res@tmXBMode = "Manual"
  res@tmXBTickStartF   = 0
  res@tmXBTickSpacingF = 0.5
  res@tmXBTickEndF     = 1.0
  res@trXMinF = res@tmXBTickStartF
  res@trXMaxF = res@tmXBTickEndF
end if

res@xyLineThicknesses = lineThicks
res@xyDashPattern = 0
res@xyLineColors = lineColors
res@xyDashPatterns = linePatterns

res@trYReverse = True

;draw plots calling gsn functions-----------------------{{{1
plot = new(3, graphic)

res1 = res
res1@gsnCenterString = "(a) Exp. P-A"
plot(0) = gsn_csm_xy(wks, lines1, z, res1)

res2 = res
res2@gsnCenterString = "(b) Exp. P-B"
res2@tiYAxisString = ""
plot(1) = gsn_csm_xy(wks, lines2, z, res2)

res3 = res
res3@gsnCenterString = "(c) Exp. P-C"
res3@tiYAxisString = ""
plot(2) = gsn_csm_xy(wks, lines3, z, res3)

;put plots in a panel-----------------------------------{{{1
resP = True
resP@gsnFrame = False
;      resP@gsnPanelBottom = 0.05
resP@gsnPanelXWhiteSpacePercent = 5
resP@gsnPanelYWhiteSpacePercent = 5
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.6
resP@gsnPanelFigureStringsPerimOn = False
resP@gsnPanelFigureStringsBackgroundFillColor = "transparent"
resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.65
resP@amParallelPosF = -0.5
gsn_panel(wks, plot, (/3/), resP)

;color text as legends {{{1
txres               = True
txres@txFontHeightF = fontSize*0.6
txres@txJust = "CenterLeft"
txres@txBackgroundFillColor = "white"

dposx = 0.5
dposy = 0.02

posx = 0.22
posy = 0.42
do j = 0, 4 
  txres@txFontColor = lineColors(j+5)
  gsn_text_ndc(wks, texts(j), posx, posy, txres)
  posy = posy - dposy
end do

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
;-------------------------------------------------------{{{1
; vim:fdm=marker:fdl=0:
; vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
