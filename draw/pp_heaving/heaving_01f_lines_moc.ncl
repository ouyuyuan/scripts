
; Description: zonal profile of MOC
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2015-06-24 09:49:31 BJT

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

nc = "calc_10b_moc_years.nc"

;get plotting data--------------------------------------{{{1

procedure get_flux(expDir, nlayer, line1, line2) ;{{{2
; write zonal mean of the first 60 years to line1, 
;   and last 60 years to line2
begin
  f = addfile(datDir + expDir + nc, "r")
  cn = f->mocPac(:,nlayer-1,:)
  delete(f)

  cn = dim_rmvmean_n_Wrap(cn, 0)
  cn&time = cn&time - 600

  line1 = dim_avg_n_Wrap(cn({1:60},:), 0)
  line2 = dim_avg_n_Wrap(cn({61:120},:), 0)

  delete(cn)
end 

;get lines {{{2
procedure get_profiles(nlayer, lines)
begin
  get_flux(expDir1, nlayer, lines(0,:), lines(3,:))
  get_flux(expDir2, nlayer, lines(1,:), lines(4,:))
  get_flux(expDir3, nlayer, lines(2,:), lines(5,:))
  line = lines(0,:)
  lines@units = line@units
end

f = addfile(datDir+expDir1+nc,"r")
lat = f->lat
delete(f)
nlat = dimsizes(lat)

top = new( (/6,nlat/), float )
get_profiles(1, top)

bot = new( (/6,nlat/), float )
get_profiles(60, bot)

;plotting parameters------------------------------------{{{1

fontSize = 0.02
yLabelSize = fontSize*0.8
xLabelSize = fontSize*0.8
plotWid = 0.3
plotHei = 0.4
lineColors = (/\
"red", "blue","green3",\
"red", "blue","green3"/)
linePatterns = (/\
14,14,14,\
0,0,0/)
;0,0,0,0/)

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
res@tiYAxisString = "latitude"

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

res@trYMinF = -35
res@trYMaxF = 60

if .not.autoTicks
  res@tmXBMode = "Manual"
  res@tmXBTickStartF   = 0
  res@tmXBTickSpacingF = 0.5
  res@tmXBTickEndF     = 1.0
  res@trXMinF = res@tmXBTickStartF
  res@trXMaxF = res@tmXBTickEndF
end if

res@xyLineThicknessF = 2
res@xyDashPattern = 0
res@xyLineColors = lineColors
res@xyDashPatterns = linePatterns

;draw plots calling gsn functions-----------------------{{{1
plot = new(2, graphic)

res1 = res
res1@gsnCenterString = "(a)"
res1@tiXAxisString = top@units
plot(0) = gsn_csm_xy(wks, top, lat, res1)

res2 = res
res2@gsnCenterString = "(b)"
res2@tiXAxisString = bot@units
res2@tiYAxisString = ""
plot(1) = gsn_csm_xy(wks, bot, lat, res2)

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
txres@txFontHeightF = fontSize*0.6
texts = (/"Exp. P-A", "Exp. P-B", "Exp. P-C"/)

dposx = 0.5
dposy = 0.02

; plot 1
posx = 0.4
posy = 0.7
do j = 0, 2 
  txres@txFontColor = lineColors(j)
  gsn_text_ndc(wks, texts(j), posx, posy, txres)
  posy = posy - dposy
end do

; plot 2
posx = posx + dposx
posy = 0.7
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
