
; Description: zonal profile of MOC
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2015-07-08 09:21:39 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;img, dirs, and data files------------------------------{{{1
load "$HOME/archive/scripts/draw/ishii/head.ncl"
nc = "calc_001e_cn_depth_time_ohc.nc"

;get plotting data--------------------------------------{{{1

procedure get_profile(varName, yb, ye, line) ;{{{2
local cn
begin
  f = addfile(datDir + nc, "r")
  cn = f->$varName$
  delete(f)

  cn = dim_rmvmean_n_Wrap(cn, 0)
  cn = cn*1e-19
  cn@units = "10~S~19~N~J/m"

  line = dim_avg_n_Wrap(cn({yb:ye},:), 0)

  delete(cn)
end 

;get lines {{{2
procedure get_profiles(yb, ye, lines)
local line
begin
  get_profile("ohcGlo", yb, ye, lines(0,:))
  get_profile("ohcPac", yb, ye, lines(1,:))
  get_profile("ohcInd", yb, ye, lines(2,:))
  get_profile("ohcSou", yb, ye, lines(3,:))
  get_profile("ohcAtl", yb, ye, lines(4,:))
  line = lines(0,:)
  lines@units = line@units
end

texts = (/\
"Global Ocean", "Pacific", "Indian Ocean", \
"Southern Ocean", "Atlantic"/)

f = addfile(datDir+nc,"r")
z = f->z
delete(f)
nz = dimsizes(z)

lines1 = new( (/5,nz/), float )
get_profiles(1953, 1962, lines1)

lines2 = lines1
get_profiles(1963, 1972, lines2)

lines3 = lines1
get_profiles(1973, 1982, lines3)

lines4 = lines1
get_profiles(1983, 1992, lines4)

lines5 = lines1
get_profiles(1993, 2002, lines5)

lines6 = lines1
get_profiles(2003, 2012, lines6)

;plotting parameters------------------------------------{{{1

fontSize = 0.02
yLabelSize = fontSize*0.8
xLabelSize = fontSize*0.8
plotWid = 0.2
plotHei = 0.4
lineColors = (/ "black", "red", "blue","gold3", "green3" /)
linePatterns = (/0,0,0,0,0/)
lineThicks = (/2,2,2,2,2/)

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
plot = new(6, graphic)

res1 = res
res1@gsnCenterString = "(a) 1953-1962"
plot(0) = gsn_csm_xy(wks, lines1, z, res1)

res2 = res
res2@gsnCenterString = "(b) 1963-1972"
res2@tiYAxisString = ""
plot(1) = gsn_csm_xy(wks, lines2, z, res2)

res3 = res
res3@gsnCenterString = "(c) 1973-1982"
res3@tiYAxisString = ""
plot(2) = gsn_csm_xy(wks, lines3, z, res3)

res4 = res
res4@gsnCenterString = "(d) 1983-1992"
res4@tiYAxisString = ""
plot(3) = gsn_csm_xy(wks, lines4, z, res4)

res5 = res
res5@gsnCenterString = "(e) 1993-2002"
res5@tiYAxisString = ""
plot(4) = gsn_csm_xy(wks, lines5, z, res5)

res6 = res
res6@gsnCenterString = "(f) 2003-2012"
res6@tiYAxisString = ""
plot(5) = gsn_csm_xy(wks, lines6, z, res6)

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
gsn_panel(wks, plot, (/3,3/), resP)

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
  txres@txFontColor = lineColors(j)
;  gsn_text_ndc(wks, texts(j), posx, posy, txres)
  posy = posy - dposy
end do

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
;-------------------------------------------------------{{{1
; vim:fdm=marker:fdl=0:
; vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
