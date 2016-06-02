
; Description: zonal profile of MOC
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2016-04-14 15:46:38 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;img, dirs, and data files------------------------------{{{1
datDir = "/home/ou/archive/data/pcom/"
img = "/home/ou/archive/drawing/phdthesis/" + getenv("NCL_ARG_0_base")

refDir    = "exp_spinup/post/"

expDirP1   = "exp71_heaving_b_Pac_20S-20N/post/"
expDirP2   = "exp72_heaving_b_Pac_0N-40N/post/"
expDirP3   = "exp75_heaving_b_Pac_0S-40S/post/"
;expDirP1   = "exp92_heaving_c_Pac_20S-20N/post/"
;expDirP2   = "exp93_heaving_c_Pac_0N-40N/post/"
;expDirP3   = "exp94_heaving_c_Pac_0S-40S/post/"

nc = "calc_001e_cn_depth_time_ohc.nc"

;get plotting data--------------------------------------{{{1

f = addfile(datDir + expDirP1 + nc, "r")
z = f->z
delete(f)
nz = dimsizes(z)

procedure get_profile(expDir, varName, yb, ye, line, opt) ;{{{2
local cn, zC, tmp
begin
  f = addfile(datDir + expDir + nc, "r")
  cn = f->$varName$({601:720},:)
  z = f->z
  delete(f)
  nz = dimsizes(z)

  if (opt.eq."int") then
    zC = conform(cn, z, (/1/))
    tmp = zC*cn
    do i = 0, nz-1
      cn(:,i) = dim_sum_n(tmp(:,0:i), 1)
    end do 
  end if

;  cn = dim_rmvmean_n_Wrap(cn, 0)

  cn&time = cn&time - 600
  if (opt.eq."int") then
    cn = cn*1e-23
    cn@units = "10~S~23~N~J"
  else
    cn = cn*1e-20
    cn@units = "10~S~20~N~J"
  end if

  line = dim_avg_n_Wrap(cn({yb:ye},:), 0)

  delete(cn)
end 

;get lines {{{2
procedure get_profiles(expDir, lines, opt) ;{{{3
local line
begin
  yb = 81
  ye = 100

  get_profile(expDir, "ohcGlo", yb, ye, lines(0,:), opt)
  line = lines(0,:)
  get_profile(refDir, "ohcGlo", yb, ye, line, opt)
  lines(0,:) = lines(0,:) - line

  get_profile(expDir, "ohcPac", yb, ye, lines(1,:), opt)
  get_profile(refDir, "ohcPac", yb, ye, line, opt)
  lines(1,:) = lines(1,:) - line

  get_profile(expDir, "ohcInd", yb, ye, lines(2,:), opt)
  get_profile(refDir, "ohcInd", yb, ye, line, opt)
  lines(2,:) = lines(2,:) - line

  yb = 21
  ye = 40
  get_profile(expDir, "ohcGlo", yb, ye, lines(3,:), opt)
  get_profile(refDir, "ohcGlo", yb, ye, line, opt)
  lines(3,:) = lines(3,:) - line

  get_profile(expDir, "ohcPac", yb, ye, lines(4,:), opt)
  get_profile(refDir, "ohcPac", yb, ye, line, opt)
  lines(4,:) = lines(4,:) - line

  get_profile(expDir, "ohcInd", yb, ye, lines(5,:), opt)
  get_profile(refDir, "ohcInd", yb, ye, line, opt)
  lines(5,:) = lines(5,:) - line
end
 ;{{{3

linesP1 = new( (/6,nz/), float )
linesP2 = linesP1
linesP3 = linesP1
linesI1 = linesP1
linesI2 = linesP1
linesI3 = linesP1

get_profiles(expDirP1, linesP1, "")
get_profiles(expDirP2, linesP2, "")
get_profiles(expDirP3, linesP3, "")

get_profiles(expDirP1, linesI1, "int")
get_profiles(expDirP2, linesI2, "int")
get_profiles(expDirP3, linesI3, "int")

;plotting parameters------------------------------------{{{1

fontSize = 0.02
yLabelSize = fontSize*0.8
xLabelSize = fontSize*0.8
plotWid = 0.2
plotHei = 0.3
lineColors = (/"black", "blue", "red", "black", "blue", "red"/)
linePatterns = (/0,0,0,14,14,14/)
lineThicks = (/2,2,1.5,1.5,1.5/)

;autoTicks = True
autoTicks = False

wks = gsn_open_wks ("eps", img)

;resources attributes setting---------------------------{{{1
res = True
res@vpWidthF = plotWid
res@vpHeightF = plotHei
;res@vpXF = -0.01
;res@vpYF = 0.9

res@tiXAxisFontHeightF = xLabelSize
res@tiYAxisFontHeightF = yLabelSize
res@tiYAxisString = "Depth (m)"

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
res@trYMaxF = 700

if .not.autoTicks
  res@tmXBMode = "Manual"
end if

res@xyLineThicknesses = lineThicks
res@xyDashPattern = 0
res@xyDashPatterns = linePatterns
res@xyLineColors = (/"transparent", "blue", "transparent", "transparent",\
"blue", "transparent"/)

res@trYReverse = True

;draw plots calling gsn functions-----------------------{{{1
plot = new(6, graphic)

res1 = res
res1@gsnCenterString = "(a) EXP_EQ"
res1@tiXAxisString = linesP1@units
res1@xyLineColors = lineColors
;res1@tmXBPrecision = 2
if .not.autoTicks
  res1@tmXBTickStartF   = -2
  res1@tmXBTickSpacingF = 0.5
  res1@tmXBTickEndF     = 2
  res1@trXMinF = res1@tmXBTickStartF
  res1@trXMaxF = res1@tmXBTickEndF
end if

plot(0) = gsn_csm_xy(wks, linesP1, z, res1)

res2 = res
res2@gsnCenterString = "(b) EXP_N"
res2@tiYAxisString = ""
res2@tiXAxisString = linesP2@units
;res2@tmXBPrecision = 1
if .not.autoTicks
  res2@tmXBTickStartF   = -0.5
  res2@tmXBTickSpacingF = 0.25
  res2@tmXBTickEndF     = 0.5
  res2@trXMinF = res2@tmXBTickStartF
  res2@trXMaxF = res2@tmXBTickEndF
end if
plot(1) = gsn_csm_xy(wks, linesP2, z, res2)

res3 = res
res3@gsnCenterString = "(c) EXP_S"
res3@tiYAxisString = ""
res3@tiXAxisString = linesP3@units
;res3@tmXBPrecision = 1
if .not.autoTicks
  res3@tmXBTickStartF   = res2@tmXBTickStartF
  res3@tmXBTickSpacingF = res2@tmXBTickSpacingF
  res3@tmXBTickEndF     = res2@tmXBTickEndF
  res3@trXMinF = res3@tmXBTickStartF
  res3@trXMaxF = res3@tmXBTickEndF
end if
plot(2) = gsn_csm_xy(wks, linesP3, z, res3)

res4 = res
res4@gsnCenterString = "(d) EXP_EQ"
res4@tiXAxisString = linesI1@units
res4@xyLineColors = lineColors
;res4@tmXBPrecision = 1
if .not.autoTicks
  res4@tmXBTickStartF   = -4
  res4@tmXBTickSpacingF = 1
  res4@tmXBTickEndF     = 4
  res4@trXMinF = res4@tmXBTickStartF
  res4@trXMaxF = res4@tmXBTickEndF
end if
plot(3) = gsn_csm_xy(wks, linesI1, z, res4)

res5 = res
res5@gsnCenterString = "(e) EXP_N"
res5@tiYAxisString = ""
res5@tiXAxisString = linesI2@units
;res5@tmXBPrecision = 2
if .not.autoTicks
  res5@tmXBTickStartF   = -0.8
  res5@tmXBTickSpacingF = 0.4
  res5@tmXBTickEndF     = 0.8
  res5@trXMinF = res5@tmXBTickStartF
  res5@trXMaxF = res5@tmXBTickEndF
end if
plot(4) = gsn_csm_xy(wks, linesI2, z, res5)

res6 = res
;res6@tmXBPrecision = 2
res6@gsnCenterString = "(f) EXP_S"
res6@tiYAxisString = ""
res6@tiXAxisString = linesI3@units
if .not.autoTicks
  res6@tmXBTickStartF   = -1.5
  res6@tmXBTickSpacingF = 0.5
  res6@tmXBTickEndF     = 1.5
  res6@trXMinF = res6@tmXBTickStartF
  res6@trXMaxF = res6@tmXBTickEndF
end if
plot(5) = gsn_csm_xy(wks, linesI3, z, res6)

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
txres@txFontHeightF = fontSize*0.8
txres@txJust = "CenterLeft"
txres@txBackgroundFillColor = "white"

dposx = 0.5
dposy = 0.03

posx = 0.25
posy = 0.7
texts = (/"Glo.", "Pac.", "Ind."/)
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
