
; Description: zonal profile of MOC
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2015-07-13 21:19:38 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;img, dirs, and data files------------------------------{{{1
datDir    = "/home/ou/archive/data/pcom/"
img       = getenv("NCL_ARG_2")

refDir    = "exp_spinup/post/"
expDir1   = "exp71_heaving_b_Pac_20S-20N/post/"
expDir2   = "exp72_heaving_b_Pac_0N-40N/post/"
expDir3   = "exp75_heaving_b_Pac_0S-40S/post/"

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
  cnR = f->$varName$({601:720},:)
  delete(f)
  mean = dim_avg_n_Wrap(cnR, 0)
  meanC = conform(cnR, mean, (/1/))

  cn = cn - cnR
;  cn = cn - meanC
;  cn = dim_rmvmean_n_Wrap(cn, 0)
;  cn = dtrend_n(cn, 0, 0)
  cn&time = cn&time - 600
  cn = cn*1e-19
  cn@units = "10~S~19~N~J/m"

  line1 = dim_avg_n_Wrap(cn({1:60},:), 0)
  line2 = dim_avg_n_Wrap(cn({61:120},:), 0)

  delete(cn)
  delete(cnR)
end 

;get lines {{{2
procedure get_profiles(varName, lines)
begin
  get_profile(expDir1, varName, lines(0,:), lines(3,:))
  get_profile(expDir2, varName, lines(1,:), lines(4,:))
  get_profile(expDir3, varName, lines(2,:), lines(5,:))
  line = lines(0,:)
  lines@units = line@units
end

texts = (/"Exp. P-A", "Exp. P-B", "Exp. P-C"/)

f = addfile(datDir+expDir1+nc,"r")
z = f->z
delete(f)
nz = dimsizes(z)

lines1 = new( (/6,nz/), float )
get_profiles("ohcPac", lines1)

lines2 = lines1
get_profiles("ohcInd", lines2)

lines3 = lines1
get_profiles("ohcGlo", lines3)

;plotting parameters------------------------------------{{{1

fontSize = 0.02
yLabelSize = fontSize*0.8
xLabelSize = fontSize*0.8
plotWid = 0.2
plotHei = 0.4
lineColors = (/\
"red", "blue", "green3",\
"red", "blue", "green3"/)
linePatterns = (/\
14,14,14,\
0,0,0/)
lineThicks = (/\
1.5,1.5,1.5,\
2,2,2/)

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
;res@tmYLMode = "Manual"
res@tmYLTickSpacingF = 100
;res@tmYLMinorOn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmYRLabelFontHeightF = yLabelSize 

res@tmXBLabelFontHeightF = xLabelSize
res@tmXBMinorOn = False

;res@trYMinF = -35
res@trYMaxF = 1500

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
res1@gsnCenterString = "(a) Pacific Ocean"
plot(0) = gsn_csm_xy(wks, lines1, z, res1)

res2 = res
res2@gsnCenterString = "(b) Indian Ocean"
res2@tiYAxisString = ""
plot(1) = gsn_csm_xy(wks, lines2, z, res2)

res3 = res
res3@gsnCenterString = "(c) Global Ocean"
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
do j = 0, 2 
  txres@txFontColor = lineColors(j)
  gsn_text_ndc(wks, texts(j), posx, posy, txres)
  posy = posy - dposy
end do

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
;-------------------------------------------------------{{{1
; vim:fdm=marker:fdl=0:
; vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
