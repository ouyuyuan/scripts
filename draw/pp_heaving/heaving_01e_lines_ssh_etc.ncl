
; Description: zonal profile of SSH and other variables anomaly
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 15:08:56 BJT
; Last Change: 2015-06-24 09:45:09 BJT

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

ncSsh  = "calc_004b_merge_ssh.nc"
ncDvol = "calc_006e_dvol.nc"
ncDtc  = "calc_006b_dtc.nc"
ncOhc  = "calc_006d_ohc_0-700m.nc"

;get plotting data--------------------------------------{{{1

; get zonal mean anomaly {{{2
procedure get_an(expDir, ncName, varName, line1, line2) ;{{{3
; write zonal mean of the first 60 years to line1, 
;   and last 60 years to line2
begin
  f = addfile(datDir + refDir + ncName, "r")
  cn3d = f->$varName$
  delete(f)
  if (varName.eq."ssh" .or. varName.eq."dtc") then
    cnR = dim_avg_n_Wrap(cn3d,2)
  end if
  if (varName.eq."dvol" .or. varName.eq."ohc") then
    cnR = dim_sum_n_Wrap(cn3d,2)
  end if

  f = addfile(datDir + expDir + ncName, "r")
  cn3d = f->$varName$
  delete(f)
  if (varName.eq."ssh" .or. varName.eq."dtc") then
    cn  = dim_avg_n_Wrap(cn3d,2)
  end if
  if (varName.eq."dvol" .or. varName.eq."ohc") then
    cn  = dim_sum_n_Wrap(cn3d,2)
  end if

  cn = cn - cnR
  ; it seems that detrend introduce artificial oscillations
  ;  cn = dtrend_n(cn, False, 0) 
  cn = dim_rmvmean_n_Wrap(cn, 0)
  cn&time = cn&time - 600

  if (varName.eq."ssh") then
    cn = cn*100 
    cn@units = "cm"
  end if
  if (varName.eq."dvol") then
    cn = cn*1e-10
    cn@units = "10~S~10~N~m~S~3~N~/1~S~o"
  end if
  if (varName.eq."ohc") then
    cn = cn*1e-21
    cn@units = "10~S~21~N~J/1~S~o"
  end if

  line1 = dim_avg_n_Wrap(cn({1:60},:), 0)
  line2 = dim_avg_n_Wrap(cn({61:120},:), 0)

  delete(cn)
  delete(cnR)
  delete(cn3d)
end 

;get lines {{{3
procedure get_profiles(ncName, varName, lines)
begin
  get_an(expDir1, ncName, varName, lines(0,:), lines(3,:))
  get_an(expDir2, ncName, varName, lines(1,:), lines(4,:))
  get_an(expDir3, ncName, varName, lines(2,:), lines(5,:))
  line = lines(0,:)
  lines@units = line@units
end

f = addfile(datDir+refDir+ncSsh,"r")
lat = f->lat
delete(f)
nlat = dimsizes(lat)

ssh = new( (/6,nlat/), float )
get_profiles(ncSsh, "ssh", ssh)

dvol = new( (/6,nlat/), float )
get_profiles(ncDvol, "dvol", dvol)

dtc = new( (/6,nlat/), float )
get_profiles(ncDtc, "dtc", dtc)

; beyond 30 degree, dtc seems stochastic and over large
latC = conform(dtc, lat, (/1/))
dtc = where(abs(latC).gt.40, dtc@_FillValue, dtc)

ohc = new( (/6,nlat/), float )
get_profiles(ncOhc, "ohc", ohc)

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
res@tmYLTickSpacingF = 20
res@tmYLMinorOn = False
res@tmYLLabelFontHeightF = yLabelSize 
res@tmYRLabelFontHeightF = yLabelSize 

res@tmXBLabelFontHeightF = xLabelSize
res@tmXBMinorOn = False

res@trYMinF = -80
res@trYMaxF = 80

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
plot = new(4, graphic)

res1 = res
res1@gsnCenterString = "(a) Zonal-mean SSH"
res1@tiXAxisString = ssh@units
plot(0) = gsn_csm_xy(wks, ssh, lat, res1)

res2 = res
res2@gsnCenterString = "(b) Zonal-integrated volume" 
res2@tiXAxisString = dvol@units
res2@tiYAxisString = ""
plot(1) = gsn_csm_xy(wks, dvol, lat, res2)

res3 = res
res3@gsnCenterString = "(c) Zonal-mean DTC"
res3@tiXAxisString = dtc@units
;res3@tiYAxisString = ""
plot(2) = gsn_csm_xy(wks, dtc, lat, res3)

res4 = res
res4@gsnCenterString = "(d) Zonal-integrated OHC"
res4@tiXAxisString = ohc@units
res4@tiYAxisString = ""
plot(3) = gsn_csm_xy(wks, ohc, lat, res4)

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
gsn_panel(wks, plot, (/2,2/), resP)

; color text as legends {{{1
txres               = True
txres@txFontHeightF = fontSize*0.6
texts = (/"Exp. P-A", "Exp. P-B", "Exp. P-C"/)

dposx = 0.4
dposy = 0.02

; plot 1
posx = 0.426
posy = 0.92
do j = 0, 2 
  txres@txFontColor = lineColors(j)
  gsn_text_ndc(wks, texts(j), posx, posy, txres)
  posy = posy - dposy
end do

; plot 2
posx = posx + dposx
posy = 0.92
do j = 0, 2 
  txres@txFontColor = lineColors(j)
  gsn_text_ndc(wks, texts(j), posx, posy, txres)
  posy = posy - dposy
end do

; plot 3
posx = posx - dposx
posy = 0.41
do j = 0, 2 
  txres@txFontColor = lineColors(j)
  gsn_text_ndc(wks, texts(j), posx, posy, txres)
  posy = posy - dposy
end do

; plot 4
posx = posx + dposx
posy = 0.41
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
