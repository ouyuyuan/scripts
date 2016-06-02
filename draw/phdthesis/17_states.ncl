
; Description:
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-11 19:31:11 BJT
; Last Change: 2016-05-25 14:55:20 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

img   = "/home/ou/archive/drawing/phdthesis/" + getenv("NCL_ARG_0_base")
ncDir = "/home/ou/archive/data/"
nc_ws = ncDir + "pcom/input/pcom_bcf_mn.nc"

nc_dtc_pcom = ncDir + "pcom/exp_spinup/post/calc_13_cn_dtc.nc"
nc_dtc_woa  = ncDir + "woa09/pcom_grid/post/calc_13_cn_dtc.nc"

nc_bsf_pcom = ncDir + "pcom/exp_spinup/post/calc_14_cn_bsf.nc"
nc_bsf_soda = ncDir + "soda/pcom_grid/post/calc_14_cn_bsf.nc"

nc_ohc_pcom = ncDir + "pcom/exp_spinup/post/calc_15_cn_ohc_0-700m.nc"
nc_ohc_woa  = ncDir + "woa09/pcom_grid/post/calc_15_cn_ohc_0-700m.nc"

nc_clm_pcom = ncDir + "pcom/exp_spinup/post/climate_y0591-y0600.nc"
nc_clm_soda = ncDir + "soda/pcom_grid/post/climate_y1961-y1990.nc"

; figure control
fontSize      = 0.018
arrowDistance = 0.025
plotWid       = 0.4
plotHei       = 0.2
cbTitleBsf    = "Sv"
cbTitleDtc    = "m"
cbTitleOhc    = "J/m~S~2"
cbTitleSsh    = "m"
dtcMinMaxInc   = (/0, 400, 20/)
ohcMinMaxInc   = (/7.8, 8.4, 0.05/)
sshMinMaxInc   = (/-2.0, 2.0, 0.2/)
unitVec       = 0.25
unitVecLen    = 0.045
yTitle        = "latitude"
xTitle        = "longitude"

autoTicks = False
;autoTicks = True

;cmap = "ncl_default"
;cmap = "BlGrYeOrReVi200"
;  cmap = "testcmap"
;  cmap = "NCV_blu_red"
wks = gsn_open_wks("eps", img)
;gsn_define_colormap(wks,cmap)

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
ssh_soda = read_var(nc_clm_soda, "ssh")
ssh_pcom = read_var(nc_clm_pcom, "ssh")

ohc_pcom = ohc_pcom * 1e-11
ohc_woa  = ohc_woa  * 1e-11
cbTitleOhc = "10~S~11~N~"+cbTitleOhc

taux = taux*0.1 ; change dyne/cm^2 to N/m^2 (1 dyne = 10^-5 N)
tauy = tauy*0.1
taux@units = "N/m^2"
tauy@units = "N/m^2"

vx = dim_avg_n_Wrap(taux,0)
vy = dim_avg_n_Wrap(tauy,0)

cn1 = bsf_pcom
cn2 = bsf_soda
cn3 = ssh_pcom(0,:,:)
cn4 = ssh_soda
cn5 = dtc_pcom
cn6 = dtc_woa
cn7 = ohc_pcom
cn8 = ohc_woa
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
;if (cmap.eq."ncl_default") then
;  res@gsnSpreadColorStart  = 35                 ; start at color 17
;  res@gsnSpreadColorEnd    = 230                ; end at color 200
;end if

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
;res@lbBoxLinesOn       = False
res@lbLabelFontHeightF = fontSize*0.7
;res@lbLabelStride      = 2
;res@lbTitlePosition   = "Right"

;res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
res@pmLabelBarWidthF = 0.08
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

res_bsf@cnFillPalette      = "ncl_default"
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
res_dtc@cnFillPalette      = "BlGrYeOrReVi200"
if (res_dtc@cnFillPalette.eq."BlGrYeOrReVi200") then
;  res_dtc@gsnSpreadColorStart  = 35
  res_dtc@gsnSpreadColorEnd    = 180
end if
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
res_ohc@cnFillPalette      = "BlGrYeOrReVi200"
if (res_ohc@cnFillPalette.eq."BlGrYeOrReVi200") then
;  res_ohc@gsnSpreadColorStart  = 35
  res_ohc@gsnSpreadColorEnd    = 180
end if
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
;res_ssh@cnFillPalette      = "NCV_blu_red"
res_ssh@cnFillPalette      = "ncl_default"
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
;{{{
res1@lbLabelBarOn      = False
;   res1@vcLevelSelectionMode = "ManualLevels"
res1@gsnScalarContour     = True               ; contours desired
res1@vcRefMagnitudeF          = unitVec
res1@vcRefLengthF             = unitVecLen
res1@vcMinDistanceF           = arrowDistance

res1@vcRefAnnoOn = True
res1@vcRefAnnoFontHeightF = fontSize*0.9
res1@vcRefAnnoSide = "Top"
res1@vcRefAnnoOrthogonalPosF  = -0.35            ; move ref vector
res1@vcRefAnnoParallelPosF    = 0.2            ; move ref vector
;   res1@vcMonoLineArrowColor = False                ; vec's colored by their mag_p_n
res1@vcRefAnnoPerimOn         = False
res1@vcRefAnnoString1         = res1@vcRefMagnitudeF
res1@vcRefAnnoString2On       = True
res1@vcRefAnnoString2         = "N/m~S~2~N~"

res1@vcRefAnnoArrowLineColor   = "black"         ; change ref vector color
res1@vcRefAnnoArrowUseVecColor = False           ; don't use vec color for ref
res1@vcGlyphStyle          = "CurlyVector"        ; turn on curly vectors
;   res1@vcLineArrowThicknessF   = 0.5               ; change vector thickness
res1@vcLineArrowHeadMaxSizeF = 0.012
res1@vcLineArrowHeadMinSizeF = 0.005  
res1@vcVectorDrawOrder       = "PostDraw"        ; draw vectors last
res1@vcLineArrowColor        = "black"           ; change vector color
;}}}
plot(0) = gsn_csm_vector_scalar_map(wks, vx, vy, cn1, res1)

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
resP@gsnPanelFigureStrings = (/"a) BSF, simulated","b) BSF, reanalyzed (SODA)","",\
   "c) SSH, simulated","d) SSH, reanalyzed (SODA)", "",\
   "e) DTC, simulated", "f) DTC, observed (WOA09)", "",\
   "g) OHC, simulated", "h) OHC, observed (WOA09)", ""/)
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
