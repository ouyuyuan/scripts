
; Description: zonal profile of MOC
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2015-07-22 17:16:13 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;img, dirs, and data files------------------------------{{{1
datDir    = "/home/ou/archive/data/pcom/"
img       = getenv("NCL_ARG_2")

refDir    = "exp_spinup/post/"

expDirP1   = "exp71_heaving_b_Pac_20S-20N/post/"
expDirP2   = "exp72_heaving_b_Pac_0N-40N/post/"
expDirP3   = "exp75_heaving_b_Pac_0S-40S/post/"

expDirA1   = "exp78_heaving_b_Atl_20S-20N/post/"
expDirA2   = "exp79_heaving_b_Atl_0N-40N/post/"
expDirA3   = "exp89_heaving_b_Atl_0S-40S/post/"

nc = "calc_001e_cn_depth_time_ohc.nc"

;get plotting data--------------------------------------{{{1

procedure get_profile(expDir, varName, yb, ye, line) ;{{{2
local cn 
begin
  f = addfile(datDir + expDir + nc, "r")
  cn = f->$varName$({601:720},:)
  delete(f)
;  cn = dim_rmvmean_n_Wrap(cn, 0)

  cn&time = cn&time - 600
  cn = cn*1e-19
  cn@units = "10~S~19~N~J/m"

  line = dim_avg_n_Wrap(cn({yb:ye},:), 0)

  delete(cn)
end 

;get lines {{{2
procedure get_profiles(expDir, varName1, varName2, lines) ;{{{3
local line
begin
  yb = 81
  ye = 100
  get_profile(expDir, varName1, yb, ye, lines(0,:))
  line = lines(0,:)
  get_profile(refDir, varName1, yb, ye, line)
  lines(0,:) = lines(0,:) - line

  get_profile(expDir, varName2, yb, ye, lines(1,:))
  get_profile(refDir, varName2, yb, ye, line)
  lines(1,:) = lines(1,:) - line

  yb = 21
  ye = 40
  get_profile(expDir, varName1, yb, ye, lines(2,:))
  get_profile(refDir, varName1, yb, ye, line)
  lines(2,:) = lines(2,:) - line

  get_profile(expDir, varName2, yb, ye, lines(3,:))
  get_profile(refDir, varName2, yb, ye, line)
  lines(3,:) = lines(3,:) - line

  line = lines(0,:)
  lines@units = line@units
end
 ;{{{3
f = addfile(datDir+expDirP1+nc,"r")
z = f->z
delete(f)
nz = dimsizes(z)

linesP1 = new( (/4,nz/), float )
linesP2 = linesP1
linesP3 = linesP1
linesA1 = linesP1
linesA2 = linesP1
linesA3 = linesP1

get_profiles(expDirP1, "ohcGlo", "ohcPac", linesP1)
get_profiles(expDirP2, "ohcGlo", "ohcPac", linesP2)
get_profiles(expDirP3, "ohcGlo", "ohcPac", linesP3)

get_profiles(expDirA1, "ohcGlo", "ohcAtl", linesA1)
get_profiles(expDirA2, "ohcGlo", "ohcAtl", linesA2)
get_profiles(expDirA3, "ohcGlo", "ohcAtl", linesA3)

;plotting parameters------------------------------------{{{1

fontSize = 0.02
yLabelSize = fontSize*0.8
xLabelSize = fontSize*0.8
plotWid = 0.2
plotHei = 0.3
colorsPac = (/"black", "blue", "black", "blue"/)
colorsAtl = (/"black", "red", "black", "red"/)
linePatterns = (/0,0,14,14/)
lineThicks = (/2,2,1.5,1.5/)

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
res@tiXAxisString = linesP1@units

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
;res@tmYLMinorOn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmYRLabelFontHeightF = yLabelSize 

res@tmXBLabelFontHeightF = xLabelSize
res@tmXBMinorOn = False

;res@trYMinF = -35
res@trYMaxF = 1500

if .not.autoTicks
  res@tmXBMode = "Manual"
end if

res@xyLineThicknesses = lineThicks
res@xyDashPattern = 0
res@xyDashPatterns = linePatterns

res@trYReverse = True

;draw plots calling gsn functions-----------------------{{{1
plot = new(6, graphic)

res1 = res
res1@gsnCenterString = "(a) EXP_PACa"
res1@tiXAxisString = ""
res1@xyLineColors = colorsPac
if .not.autoTicks
  res1@tmXBTickStartF   = -12
  res1@tmXBTickSpacingF = 4
  res1@tmXBTickEndF     = 12
  res1@trXMinF = res1@tmXBTickStartF
  res1@trXMaxF = res1@tmXBTickEndF
end if

plot(0) = gsn_csm_xy(wks, linesP1, z, res1)

res2 = res
res2@xyLineColors = colorsPac
res2@gsnCenterString = "(b) EXP_PACb"
res2@tiYAxisString = ""
res2@tiXAxisString = ""
if .not.autoTicks
  res2@tmXBTickStartF   = -3
  res2@tmXBTickSpacingF = 1
  res2@tmXBTickEndF     = 3
  res2@trXMinF = res2@tmXBTickStartF
  res2@trXMaxF = res2@tmXBTickEndF
end if
plot(1) = gsn_csm_xy(wks, linesP2, z, res2)

res3 = res
res3@xyLineColors = colorsPac
res3@gsnCenterString = "(c) EXP_PACc"
res3@tiYAxisString = ""
res3@tiXAxisString = ""
if .not.autoTicks
  res3@tmXBTickStartF   = -3
  res3@tmXBTickSpacingF = 1
  res3@tmXBTickEndF     = 3
  res3@trXMinF = res3@tmXBTickStartF
  res3@trXMaxF = res3@tmXBTickEndF
end if
plot(2) = gsn_csm_xy(wks, linesP3, z, res3)

res4 = res
res4@xyLineColors = colorsAtl
res4@gsnCenterString = "(d) EXP_ATLa"
if .not.autoTicks
  res4@tmXBTickStartF   = -12
  res4@tmXBTickSpacingF = 4
  res4@tmXBTickEndF     = 12
  res4@trXMinF = res4@tmXBTickStartF
  res4@trXMaxF = res4@tmXBTickEndF
end if
plot(3) = gsn_csm_xy(wks, linesA1, z, res4)

res5 = res
res5@xyLineColors = colorsAtl
res5@gsnCenterString = "(e) EXP_ATLb"
res5@tiYAxisString = ""
if .not.autoTicks
  res5@tmXBTickStartF   = -3
  res5@tmXBTickSpacingF = 1
  res5@tmXBTickEndF     = 3
  res5@trXMinF = res5@tmXBTickStartF
  res5@trXMaxF = res5@tmXBTickEndF
end if
plot(4) = gsn_csm_xy(wks, linesA2, z, res5)

res6 = res
res6@xyLineColors = colorsAtl
res6@gsnCenterString = "(f) EXP_ATLc"
res6@tiYAxisString = ""
if .not.autoTicks
  res6@tmXBTickStartF   = -3
  res6@tmXBTickSpacingF = 1
  res6@tmXBTickEndF     = 3
  res6@trXMinF = res6@tmXBTickStartF
  res6@trXMaxF = res6@tmXBTickEndF
end if
plot(5) = gsn_csm_xy(wks, linesA3, z, res6)

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
txres@txFontHeightF = fontSize*0.7
txres@txJust = "CenterLeft"
txres@txBackgroundFillColor = "white"

dposx = 0.5
dposy = 0.025

posx = 0.22
posy = 0.62
texts = (/"Global Ocean", "Pacific"/)
do j = 0, 1 
  txres@txFontColor = colorsPac(j)
  gsn_text_ndc(wks, texts(j), posx, posy, txres)
  posy = posy - dposy
end do

posx = 0.23
posy = 0.19
texts = (/"Global Ocean", "Atlantic"/)
do j = 0, 1 
  txres@txFontColor = colorsAtl(j)
  gsn_text_ndc(wks, texts(j), posx, posy, txres)
  posy = posy - dposy
end do

frame(wks) ;{{{1
delete(wks) ;{{{1
system("eps2png_trim "+img) ;{{{1
;-------------------------------------------------------{{{1
; vim:fdm=marker:fdl=0:
; vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
