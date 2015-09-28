
; Description: Wind stress evolving with time
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-11 19:31:11 BJT
; Last Change: 2015-04-21 19:35:05 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

img         = getenv("NCL_ARG_2")
ncDir       = "/home/ou/archive/data/"
nc_ws       = ncDir + "pcom/input/pcom_bcf_mn.nc"

nc_dtc_pcom = ncDir + "pcom/exp_spinup/post/calc_13_cn_dtc.nc"
nc_dtc_woa  = ncDir + "woa09/pcom_grid/post/calc_13_cn_dtc.nc"

nc_bsf_pcom = ncDir + "pcom/exp_spinup/post/calc_14_cn_bsf.nc"
nc_bsf_soda = ncDir + "soda/pcom_grid/post/calc_14_cn_bsf.nc"

nc_ohc_pcom = ncDir + "pcom/exp_spinup/post/calc_15_cn_ohc_0-700m.nc"
nc_ohc_woa  = ncDir + "woa09/pcom_grid/post/calc_15_cn_ohc_0-700m.nc"

; figure control
fontSize      = 0.02
arrowDistance = 0.025
plotWid       = 0.5
plotHei       = 0.3
cbTitleBsf    = "Sv"
cbTitleDtc    = "m"
cbTitleOhc    = "J/m~S~2"
dtcMinMaxInc   = (/0, 400, 20/)
ohcMinMaxInc   = (/7.8, 8.4, 0.025/)
unitVec       = 0.25
unitVecLen    = 0.045
yTitle        = "latitude"
xTitle        = "longitude"

autoTicks = False
;autoTicks = True

cmap = "ncl_default"
;cmap = "BlGrYeOrReVi200"
;  cmap = "testcmap"
;  cmap = "NCV_blu_red"
wks = gsn_open_wks("eps", img)
gsn_define_colormap(wks,cmap)

; get data
;{{{
function read_var(ncname, varname)
local var
begin
  f = addfile(ncname, "r")
  var = f->$varname$
  delete(f)
  return var
end 

taux     = read_var(nc_ws, "bcu")
tauy     = read_var(nc_ws, "bcv")
bsf_pcom = read_var(nc_bsf_pcom, "bsf")
bsf_soda = read_var(nc_bsf_soda, "bsf")
dtc_pcom = read_var(nc_dtc_pcom, "dtc")
dtc_woa  = read_var(nc_dtc_woa,  "dtc")
ohc_pcom = read_var(nc_ohc_pcom, "ohc")
ohc_woa  = read_var(nc_ohc_woa,  "ohc")

ohc_pcom = ohc_pcom * 1e-11
ohc_woa  = ohc_woa  * 1e-11
cbTitleOhc = "10~S~11~N~"+cbTitleOhc

taux = taux*0.1 ; change dyne/cm^2 to N/m^2 (1 dyne = 10^-5 N)
tauy = tauy*0.1
taux@units = "N/m^2"
tauy@units = "N/m^2"

vx = dim_avg_n_Wrap(taux,0)
vy = dim_avg_n_Wrap(tauy,0)
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
if (cmap.eq."BlGrYeOrReVi200") then
  res@gsnSpreadColorStart  = 35                 ; start at color 17
  ;   res@gsnSpreadColorEnd    = 240                ; end at color 200
  res@gsnSpreadColorEnd    = 180                ; end at color 200
end if
if (cmap.eq."ncl_default") then
;  res@gsnSpreadColorStart  = 35                 ; start at color 17
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
res@lbTitleOffsetF     = -0.03
res@lbTitleFontHeightF = fontSize*0.9
;res@lbBoxLinesOn       = False
res@lbLabelFontHeightF = fontSize*0.8
;res@lbLabelStride      = 2
;res@lbTitlePosition   = "Right"

res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
res@pmLabelBarWidthF = 0.1
res@pmLabelBarHeightF = plotHei*1.1
res@pmLabelBarOrthogonalPosF = 0.02
res@pmLabelBarParallelPosF = 0.55

res@mpShapeMode = "FreeAspect"
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
;  res_bsf@cnLevelSelectionMode = "ManualLevels"
;  res_bsf@cnMinLevelValF       = cnMinMaxInc(0)
;  res_bsf@cnMaxLevelValF       = cnMinMaxInc(1)
;  res_bsf@cnLevelSpacingF      = cnMinMaxInc(2)
   res_bsf@cnLevelSelectionMode = "ExplicitLevels"
   res_bsf@cnLevels =     (/ -60, -50, -40, -30, -20, -10, 0, \
     10, 20, 30,  40,  50,  60,  70,  80,  90, 100, 110, 120, 130, 140, 150/)
   res_bsf@cnFillColors = (/2,20,  40,  60,  90, 100, 110, 130, \
    140,145,150, 155, 160, 165, 170, 175, 180, 188, 195, 200, 210, 220, 235/)
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
res_ohc@lbTitleString      = cbTitleOhc
res_ohc@lbLabelStride      = 4
if .not.autoTicks
  res_ohc@cnLevelSelectionMode = "ManualLevels"
  res_ohc@cnMinLevelValF       = ohcMinMaxInc(0)
  res_ohc@cnMaxLevelValF       = ohcMinMaxInc(1)
  res_ohc@cnLevelSpacingF      = ohcMinMaxInc(2)
end if
;}}}

plot = new(6, graphic)

res_bsf_pcom = res_bsf
;{{{
;   res_bsf_pcom@vcLevelSelectionMode = "ManualLevels"
res_bsf_pcom@gsnScalarContour     = True               ; contours desired
res_bsf_pcom@vcRefMagnitudeF          = unitVec
res_bsf_pcom@vcRefLengthF             = unitVecLen
res_bsf_pcom@vcMinDistanceF           = arrowDistance

res_bsf_pcom@vcRefAnnoOn = True
res_bsf_pcom@vcRefAnnoSide = "Top"
res_bsf_pcom@vcRefAnnoOrthogonalPosF  = -0.35            ; move ref vector
res_bsf_pcom@vcRefAnnoParallelPosF    = 0.2            ; move ref vector
;   res_bsf_pcom@vcMonoLineArrowColor = False                ; vec's colored by their mag_p_n
res_bsf_pcom@vcRefAnnoPerimOn         = False
res_bsf_pcom@vcRefAnnoString1         = res_bsf_pcom@vcRefMagnitudeF
res_bsf_pcom@vcRefAnnoString2On       = True
res_bsf_pcom@vcRefAnnoString2         = "N/m~S~2~N~"

res_bsf_pcom@vcRefAnnoArrowLineColor   = "black"         ; change ref vector color
res_bsf_pcom@vcRefAnnoArrowUseVecColor = False           ; don't use vec color for ref
res_bsf_pcom@vcGlyphStyle          = "CurlyVector"        ; turn on curly vectors
;   res_bsf_pcom@vcLineArrowThicknessF   = 0.5               ; change vector thickness
res_bsf_pcom@vcLineArrowHeadMaxSizeF = 0.012
res_bsf_pcom@vcLineArrowHeadMinSizeF = 0.005  
res_bsf_pcom@vcVectorDrawOrder       = "PostDraw"        ; draw vectors last
res_bsf_pcom@vcLineArrowColor        = "black"           ; change vector color
;}}}
;res_bsf_pcom@lbLabelBarOn      = False
plot(0) = gsn_csm_vector_scalar_map(wks, vx, vy, bsf_pcom, res_bsf_pcom)

res_bsf_soda = res_bsf
res_bsf_soda@tiYAxisOn = False
res_bsf_soda@tmYLOn    = False
res_bsf_soda@vpXF      = -0.1
plot(1) = gsn_csm_contour_map(wks, bsf_soda, res_bsf_soda)

res_dtc_pcom = res_dtc
;res_dtc_pcom@lbLabelBarOn      = False
plot(2) = gsn_csm_contour_map(wks, dtc_pcom, res_dtc_pcom)

res_dtc_woa = res_dtc
res_dtc_woa@tiYAxisOn = False
res_dtc_woa@tmYLOn    = False
plot(3) = gsn_csm_contour_map(wks, dtc_woa, res_dtc_woa)

res_ohc_pcom = res_ohc
;res_ohc_pcom@lbLabelBarOn      = False
plot(4) = gsn_csm_contour_map(wks, ohc_pcom,res_ohc_pcom)

res_ohc_woa  = res_ohc
res_ohc_woa@tiYAxisOn = False
res_ohc_woa@tmYLOn    = False
plot(5) = gsn_csm_contour_map(wks, ohc_woa, res_ohc_woa)

resP = True
resP@gsnFrame = False
;resP@gsnPanelLabelBar = True
resP@gsnPanelXWhiteSpacePercent = 0
resP@gsnPanelYWhiteSpacePercent = 5
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStrings = (/"(a) BSF, PCOM","(b) BSF, SODA",\
   "(c) DTC, PCOM","(d) DTC, WOA09", "(e) OHC, PCOM", "(f) OHC, WOA09"/)
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.6
resP@gsnPanelFigureStringsPerimOn = False

;resP@amJust = "Top"
resP@amOrthogonalPosF = -0.5
resP@amParallelPosF = 0.15

resP@pmLabelBarWidthF = 0.7
resP@pmLabelBarHeightF = 0.05
resP@pmLabelBarOrthogonalPosF = 0.08
resP@pmLabelBarParallelPosF = -0.05

resP@lbLabelFontHeightF = fontSize*0.6
resP@lbTitleFontHeightF = fontSize*0.6
resP@lbTitleString = cbTitleBsf
resP@lbBoxLinesOn = False
;   resP@lbLabelFontHeightF = 0.007

gsn_panel(wks, plot, (/2,2,2/), resP)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
