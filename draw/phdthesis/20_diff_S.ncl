
; Description:
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-11 19:31:11 BJT
; Last Change: 2016-05-26 10:47:12 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

img   = "/home/ou/archive/drawing/phdthesis/" + getenv("NCL_ARG_0_base")
ncDir     = "/home/ou/archive/data/pcom/"
datDir    = ncDir +"exp75_heaving_b_Pac_0S-40S/post/"
datDirRef = ncDir + "exp_spinup/post/"
ncBsf     = "calc_006c_bsf.nc"
ncSsh     = "calc_004b_merge_ssh.nc"
ncDtc     = "calc_006b_dtc.nc"
ncOhc     = "calc_006d_ohc_0-700m.nc"

; figure control
fontSize      = 0.018
plotWid       = 0.4
plotHei       = 0.2
cbTitleBsf    = "Sv"
cbTitleDtc    = "m"
cbTitleOhc    = "10~S~19~N~J/m~S~2"
cbTitleSsh    = "cm"
bsfMinMaxInc  = (/-4, 4, 0.4/)
sshMinMaxInc  = (/-5.0, 5.0, 0.5/)
dtcMinMaxInc  = (/-16, 16, 1/)
ohcMinMaxInc  = (/-1.3, 1.3, 0.1/)
yTitle        = "latitude"
xTitle        = "longitude"

autoTicks = False
;autoTicks = True

;cmap = "ncl_default"
;cmap = "BlGrYeOrReVi200"
;  cmap = "testcmap"
cmap = "NCV_blu_red"
wks = gsn_open_wks("eps", img)
gsn_define_colormap(wks,cmap)

; get data
;{{{
function get_mean_change(ncname, varname, yb, ye)
local var, cn1, cn2
begin
  f = addfile(datDir + ncname, "r")
  var = f->$varname$({yb:ye},:,:)
  delete(f)
  cn1 = dim_avg_n_Wrap(var,0)

  f = addfile(datDirRef + ncname, "r")
  var = f->$varname$({yb:ye},:,:)
  delete(f)
  cn2 = dim_avg_n_Wrap(var,0)

  cn = cn1
  cn = cn1 - cn2
  return cn
end 

ybP = 681
yeP = 700
ybM = 621
yeM = 640
cn1 = get_mean_change(ncBsf, "bsf", ybP, yeP)
cn2 = get_mean_change(ncBsf, "bsf", ybM, yeM)
cn3 = get_mean_change(ncSsh, "ssh", ybP, yeP)
cn4 = get_mean_change(ncSsh, "ssh", ybM, yeM)
cn3 = cn3*1e2
cn4 = cn4*1e2
cn5 = get_mean_change(ncDtc, "dtc", ybP, yeP)
cn6 = get_mean_change(ncDtc, "dtc", ybM, yeM)
cn7 = get_mean_change(ncOhc, "ohc", ybP, yeP)
cn8 = get_mean_change(ncOhc, "ohc", ybM, yeM)
cn7 = cn7*1e-19
cn8 = cn8*1e-19
;}}}

; resources
;{{{
res = True

res@vpHeightF = plotHei
res@vpWidthF  = plotWid
;res@vpXF = 0.2
;  res@vpYF = 0.9

;res@tiXAxisString      = xTitle
;res@tiYAxisString      = yTitle
res@tiXAxisOffsetYF    = -0.05
res@tiYAxisOffsetXF    = -0.05
res@tiXAxisFontHeightF = fontSize*0.8
res@tiYAxisFontHeightF = fontSize*0.8

res@gsnDraw = False
res@gsnFrame = False
res@gsnStringFontHeightF = fontSize
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
res@gsnCenterStringOrthogonalPosF = 0.09
;if (cmap.eq."BlGrYeOrReVi200") then
;  res@gsnSpreadColorStart  = 35                 ; start at color 17
  ;   res@gsnSpreadColorEnd    = 240                ; end at color 200
;  res@gsnSpreadColorEnd    = 180                ; end at color 200
;end if
if (cmap.eq."ncl_default") then
  res@gsnSpreadColorStart  = 27                 ; start at color 17
  res@gsnSpreadColorEnd    = 230                ; end at color 200
end if

res@cnFillOn             = True               ; turn on color for contours
res@cnLinesOn            = False              ; turn off contour lines
res@cnLineThicknessF     = 0.1
res@cnLineLabelsOn       = False              ; turn off contour line labels
res@cnInfoLabelOn        = False      ; turns off contour info label
;res@cnMissingValFillColor = "gray60"

res@lbPerimOn      = False             ; no box around it
;res@lbLabelBarOn      = False
res@lbOrientation      = "vertical"
res@lbTitleOffsetF     = 0.03
res@lbTitleFontHeightF = fontSize*0.7
res@lbBoxLinesOn       = False
res@lbLabelFontHeightF = fontSize*0.7
;res@lbLabelStride      = 2
;res@lbTitlePosition   = "Right"

;res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
res@pmLabelBarWidthF = 0.06
res@pmLabelBarHeightF = plotHei*1.1
res@pmLabelBarOrthogonalPosF = 0.02
res@pmLabelBarParallelPosF = 0.55

res@mpShapeMode = "FreeAspect"
res@mpOutlineOn = True
res@mpLandFillColor          = "gray"            ; set land to be gray
;resmpMinLonF = 0
;res@mpMaxLonF = 360
res@mpMinLatF = -70
res@mpMaxLatF = 70
res@mpCenterLonF = 200

; tick mark  <<<2

res@tmLabelAutoStride    = True
res@tmYROn               = False
res@tmXTOn               = False
res@tmYLMinorOn          = False
res@tmXBMinorOn          = False
res@tmYLLabelFontHeightF = fontSize*0.8
res@tmXBLabelFontHeightF = fontSize*0.8
;}}}

res_bsf = res
;{{{
res_bsf@tiXAxisOn = False
res_bsf@lbTitleString      = cbTitleBsf
res_bsf@tmXBOn             = False

if .not.autoTicks
  res_bsf@cnLevelSelectionMode = "ManualLevels"
  res_bsf@cnMinLevelValF       = bsfMinMaxInc(0)
  res_bsf@cnMaxLevelValF       = bsfMinMaxInc(1)
  res_bsf@cnLevelSpacingF      = bsfMinMaxInc(2)
;   res_bsf@cnLevelSelectionMode = "ExplicitLevels"
;   res_bsf@cnLevels =     (/ -60, -50, -40, -30, -20, -10, 0, \
;     10, 20, 30,  40,  50,  60,  70,  80,  90, 100, 110, 120, 130, 140, 150/)
;   res_bsf@cnFillColors = (/2,20,  40,  60,  90, 100, 110, 130, \
;    140,145,150, 155, 160, 165, 170, 175, 180, 188, 195, 200, 210, 220, 235/)
end if
;}}}

res_dtc = res
;{{{
res_dtc@tmXBOn             = False
res_dtc@tiXAxisOn = False
;res_dtc@vpHeightF = plotHei*0.5
;res_dtc@mpMinLatF = -40
;res_dtc@mpMaxLatF = 40
res_dtc@lbTitleString      = cbTitleDtc
if .not.autoTicks
  res_dtc@cnLevelSelectionMode = "ManualLevels"
  res_dtc@cnMinLevelValF       = dtcMinMaxInc(0)
  res_dtc@cnMaxLevelValF       = dtcMinMaxInc(1)
  res_dtc@cnLevelSpacingF      = dtcMinMaxInc(2)
end if
;}}}

res_ohc = res
;{{{
;res_ohc@vpHeightF = plotHei*0.5
;res_ohc@mpMinLatF = -40
;res_ohc@mpMaxLatF = 40
;res_ohc@tmXBOn    = False
;res_ohc@tiXAxisOn = False
res_ohc@lbTitleString      = cbTitleOhc
;res_ohc@lbLabelStride      = 4
if .not.autoTicks
  res_ohc@cnLevelSelectionMode = "ManualLevels"
  res_ohc@cnMinLevelValF       = ohcMinMaxInc(0)
  res_ohc@cnMaxLevelValF       = ohcMinMaxInc(1)
  res_ohc@cnLevelSpacingF      = ohcMinMaxInc(2)
end if
;}}}

res_ssh = res
;{{{
;res_ssh@vpHeightF = plotHei*0.5
;res_ssh@mpMinLatF = -40
;res_ssh@mpMaxLatF = 40
res_ssh@tmXBOn    = False
res_ssh@tiXAxisOn = False
res_ssh@lbTitleString      = cbTitleSsh
;res_ssh@lbLabelStride      = 4
if .not.autoTicks
  res_ssh@cnLevelSelectionMode = "ManualLevels"
  res_ssh@cnMinLevelValF       = sshMinMaxInc(0)
  res_ssh@cnMaxLevelValF       = sshMinMaxInc(1)
  res_ssh@cnLevelSpacingF      = sshMinMaxInc(2)
;   res_ssh@cnLevelSelectionMode = "ExplicitLevels"
;   res_ssh@cnLevels = (/-2.0, -1.8, -1.6, -1.4, -1.2, -1.0, -0.8, -0.6, -0.4, -0.2, 0, \
;     0.2, 0.4, 0.6, 0.8, 1.0/)
;res_ssh@cnFillColors = (/2,20,  30,   40,   50,   60,   70,   80,   90,  100,  110, 120,\
;     130, 140, 170, 200, 230/)
end if
;}}}

; the rightmost column is left empty, fix the bug of not displayingn vertical
; label bar completely
plot = new(12, graphic)

res1 = res_bsf
res1@lbLabelBarOn      = False
plot(0) = gsn_csm_contour_map(wks, cn1, res1)

res2 = res_bsf
res2@tiYAxisOn = False
res2@tmYLOn    = False
res2@vpXF      = -0.1
plot(1) = gsn_csm_contour_map(wks, cn2, res2)

res3 = res_ssh
res3@lbLabelBarOn      = False
plot(3) = gsn_csm_contour_map(wks, cn3, res3)

res4 = res_ssh
res4@tiYAxisOn = False
res4@tmYLOn    = False
plot(4) = gsn_csm_contour_map(wks, cn4, res4)

res5 = res_dtc
res5@lbLabelBarOn      = False
plot(6) = gsn_csm_contour_map(wks, cn5, res5)

res6  = res_dtc
res6@tiYAxisOn = False
res6@tmYLOn    = False
plot(7) = gsn_csm_contour_map(wks, cn6, res6)

res7 = res_ohc
res7@lbLabelBarOn      = False
plot(9) = gsn_csm_contour_map(wks, cn7,res7)

res8  = res_ohc
res8@tiYAxisOn = False
res8@tmYLOn    = False
plot(10) = gsn_csm_contour_map(wks, cn8, res8)

resP = True
;{{{
resP@gsnFrame = False
;resP@gsnPanelLabelBar = True
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 15
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStrings = (/"a) BSF, trade wind enhanced","b) BSF, trade wind descrease","",\
   "c) SSH, trade wind enhanced","d) SSH, trade wind descrease", "",\
   "e) DTC, trade wind enhanced", "f) DTC, trade wind descrease", "",\
   "g) OHC, trade wind enhanced", "h) OHC, trade wind descrease",""/)
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.6
resP@gsnPanelFigureStringsPerimOn = False
;resP@gsnMaximize = True

;resP@amJust = "Top"
resP@amOrthogonalPosF = -0.5
resP@amParallelPosF = 0.15

;}}}

gsn_panel(wks, plot, (/3,3,3,3/), resP)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
