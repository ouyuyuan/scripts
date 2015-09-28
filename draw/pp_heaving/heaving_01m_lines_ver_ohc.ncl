
; Description: zonal profile of MOC
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2015-07-17 09:10:18 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;img, dirs, and data files------------------------------{{{1
datDir    = "/home/ou/archive/data/pcom/"
img       = getenv("NCL_ARG_2")

refDir    = "exp_spinup/post/"
expDir1   = "exp77_heaving_b_40S-80S/post/"

nc = "calc_001e_cn_depth_time_ohc.nc"

f = addfile(datDir + expDir1 + nc, "r")
z = f->z
delete(f)
nz = dimsizes(z)

;get plotting data--------------------------------------{{{1
procedure get_profile_int(expDir, varName, yb, ye, line) ;{{{2
local cn, line, zC, tmp
begin
  f = addfile(datDir + expDir + nc, "r")
  tmp = f->$varName$({601:840},:)
  delete(f)
  zC = conform(tmp, z, (/1/))

  tmp = zC*tmp
  cn = tmp
  do i = 0, nz-1
    cn(:,i) = dim_sum_n(tmp(:,0:i), 1)
  end do 

  cn = dim_rmvmean_n_Wrap(cn, 0)
  cn&time = cn&time - 600
  cn = cn*1e-23
  cn@units = "10~S~23~N~J"

  line = dim_avg_n_Wrap(cn({yb:ye},:), 0)

  delete(cn)
end 

procedure get_profiles_int(expDir, yb, ye, lines)
local line
begin
  get_profile_int(expDir, "ohcGlo", yb, ye, lines(0,:))
  line = lines(0,:)
  get_profile_int(refDir, "ohcGlo", yb, ye, line)
  lines(0,:) = lines(0,:) - line

  get_profile_int(expDir, "ohcPac", yb, ye, lines(1,:))
  get_profile_int(refDir, "ohcPac", yb, ye, line)
  lines(1,:) = lines(1,:) - line

  get_profile_int(expDir, "ohcInd", yb, ye, lines(2,:))
  get_profile_int(refDir, "ohcInd", yb, ye, line)
  lines(2,:) = lines(2,:) - line

  get_profile_int(expDir, "ohcAtl", yb, ye, lines(3,:))
  get_profile_int(refDir, "ohcAtl", yb, ye, line)
  lines(3,:) = lines(3,:) - line

  lines@units = line@units
end

procedure get_profile(expDir, varName, yb, ye, line) ;{{{2
local cn, line
begin
  f = addfile(datDir + expDir + nc, "r")
  cn = f->$varName$({601:840},:)
  delete(f)

  cn = dim_rmvmean_n_Wrap(cn, 0)
  cn&time = cn&time - 600
  cn = cn*1e-19
  cn@units = "10~S~19~N~J/m"

  line = dim_avg_n_Wrap(cn({yb:ye},:), 0)

  delete(cn)
end 

procedure get_profiles(expDir, yb, ye, lines)
local line
begin
  get_profile(expDir, "ohcGlo", yb, ye, lines(0,:))
  line = lines(0,:)
  get_profile(refDir, "ohcGlo", yb, ye, line)
  lines(0,:) = lines(0,:) - line

  get_profile(expDir, "ohcPac", yb, ye, lines(1,:))
  get_profile(refDir, "ohcPac", yb, ye, line)
  lines(1,:) = lines(1,:) - line

  get_profile(expDir, "ohcInd", yb, ye, lines(2,:))
  get_profile(refDir, "ohcInd", yb, ye, line)
  lines(2,:) = lines(2,:) - line

  get_profile(expDir, "ohcAtl", yb, ye, lines(3,:))
  get_profile(refDir, "ohcAtl", yb, ye, line)
  lines(3,:) = lines(3,:) - line

  line = lines(0,:)
  lines@units = line@units
end

;get lines {{{2
texts = (/"Global Ocean", "Pacific", "Indian Ocean", "Atlantic"/)

yb = 21
ye = 100
lines1 = new( (/4,nz/), float )
get_profiles(expDir1, yb, ye, lines1)

lines2 = new( (/4,nz/), float )
get_profiles_int(expDir1, yb, ye, lines2)

;plotting parameters------------------------------------{{{1

fontSize = 0.02
yLabelSize = fontSize*0.8
xLabelSize = fontSize*0.8
plotWid = 0.2
plotHei = 0.4
lineColors = (/"black", "red", "blue", "green4"/)
linePatterns = (/0,0,0,0/)
lineThicks = (/2,1.5,1,2/)

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
res@trYMaxF = 3000

if .not.autoTicks
  res@tmXBMode = "Manual"
end if

res@xyLineThicknesses = lineThicks
res@xyDashPattern = 0
res@xyLineColors = lineColors
res@xyDashPatterns = linePatterns

res@trYReverse = True

;draw plots calling gsn functions-----------------------{{{1
plot = new(2, graphic)

res1 = res
res1@gsnCenterString = "(a)"
res1@tiXAxisString = lines1@units
if .not.autoTicks
  res1@tmXBTickStartF   = -12
  res1@tmXBTickSpacingF = 4
  res1@tmXBTickEndF     = 12
  res1@trXMinF = res1@tmXBTickStartF
  res1@trXMaxF = res1@tmXBTickEndF
end if

plot(0) = gsn_csm_xy(wks, lines1, z, res1)

res2 = res
res2@gsnCenterString = "(b)"
res2@tiYAxisString = ""
res2@tiXAxisString = lines2@units
if .not.autoTicks
  res2@tmXBTickStartF   = -0.5
  res2@tmXBTickSpacingF = 5
  res2@tmXBTickEndF     = 30
  res2@trXMinF = res2@tmXBTickStartF
  res2@trXMaxF = res2@tmXBTickEndF
end if
plot(1) = gsn_csm_xy(wks, lines2, z, res2)

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
gsn_panel(wks, plot, (/2/), resP)

;color text as legends {{{1
txres               = True
txres@txFontHeightF = fontSize*0.8
txres@txJust = "CenterLeft"
txres@txBackgroundFillColor = "white"

dposx = 0.5
dposy = 0.03

posx = 0.3
posy = 0.42
do j = 0, 3 
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
