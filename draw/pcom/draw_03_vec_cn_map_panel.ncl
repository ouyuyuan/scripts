
; Description: draw topography and grid of Southern Ocean, for AOSL paper
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-05 19:53:51 BJT
; Last Change: 2015-01-06 17:13:26 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir = getenv("NCL_ARG_1")
img = getenv("NCL_ARG_2")

function isImg(suffix)
;{{{
local is
begin
is = False
if isStrSubset(img, suffix) then
  is = True
end if
return is
end
;}}}

f = addfile("/home/ou/archive/data/pcom/basin/basin.nc","r")
basin = f->basin({-90:-30},:)
delete(f)

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
yb = 1949
ye = 2008
tb = (yb - 1948) * 12
te = (ye - 1948 + 1) * 12 - 1
f = addfile(datDir+"pcom_bcf_mn_re.nc", "r")
bcu = f->bcu(:,{-90:-30},:)
bcv = f->bcv(:,{-90:-30},:)
bct = f->bct(:,{-90:-30},:)
t = f->t
delete(f)
lat = bcu&lat
lon = bcu&lon
nlat = dimsizes(lat)
nlon = dimsizes(lon)

anBcu = calcMonAnomTLL(bcu, clmMonTLL(bcu))
anBcv = calcMonAnomTLL(bcv, clmMonTLL(bcv))
anBct = calcMonAnomTLL(bct, clmMonTLL(bct))

lat = anBct&lat
lon = anBct&lon

; trends of forcing field
; 6 decades between 1949-2008
function create_trend(var)
;{{{
begin
  tr = new((/6,nlat,nlon/),typeof(var), var@_FillValue)
  tr@units = var@units+"(10yr)~S~-1"
  lat = var&lat
  lon = var&lon
  tr!1 = "lat"
  tr&lat = lat
  tr!2 = "lon"
  tr&lon = lon
  return tr
end
;}}}

trBcu = create_trend(bcu)
trBcv = create_trend(bcv)
trBct = create_trend(bct)

procedure sig_mask(rc)
; mask out rc value no significant at 5% level
;{{{
begin
  tval = onedtond(rc@tval, dimsizes(rc))
  b = 1.98 ; table-look up, 120 points, 0.05
  rc = where(tval.gt.b, rc, rc@_FillValue)
end
;}}}

do i = 1, 6
  if i.eq.1 then
    yb = 1949
  else
    yb = yb+10
  end if
  ye = yb + 10
  tb = (yb - 1948) * 12
  te = (ye - 1948 + 1) * 12 - 1

  tp = t(tb:te)

  yp = anBct(tb:te,:,:)
  rc = regCoef(tp, yp(lat|:,lon|:,t|:))
  sig_mask(rc)
  trBct(i-1,:,:) = rc*120

  yp = anBcu(tb:te,:,:)
  rc = regCoef(tp, yp(lat|:,lon|:,t|:))
  sig_mask(rc)
  trBcu(i-1,:,:) = rc*120

  yp = anBcv(tb:te,:,:)
  rc = regCoef(tp, yp(lat|:,lon|:,t|:))
  sig_mask(rc)
  trBcv(i-1,:,:) = rc*120
end do

bc = conform(trBct, basin, (/1,2/))
bc = where(bc.eq.1, bc, bc@_FillValue) ; mask out Southern Ocean
trBct = trBct*bc
trBcu = trBcu*bc
trBcv = trBcv*bc

cn1 = trBct(0,:,:)
cn2 = trBct(1,:,:)
cn3 = trBct(2,:,:)
cn4 = trBct(3,:,:)
cn5 = trBct(4,:,:)
cn6 = trBct(5,:,:)

vecU1 = trBcu(0,:,:)
vecU2 = trBcu(1,:,:)
vecU3 = trBcu(2,:,:)
vecU4 = trBcu(3,:,:)
vecU5 = trBcu(4,:,:)
vecU6 = trBcu(5,:,:)

vecV1 = trBcv(0,:,:)
vecV2 = trBcv(1,:,:)
vecV3 = trBcv(2,:,:)
vecV4 = trBcv(3,:,:)
vecV5 = trBcv(4,:,:)
vecV6 = trBcv(5,:,:)
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; plot model 
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

;cmap = "NCL_default"
;  cmap = "GMT_jet"
;  cmap = "WhiteBlueGreenYellowRed"
cmap = "NCV_blu_red"

fontSize = 0.03
plotWid = 0.7
plotHei = 0.5
cbTitle = cn1@units
cnMinMaxInc = (/-2., 2., 0.1/)
;autoTicks = False
autoTicks = True
if isImg("___Sou_force")
  autoTicks = False
end if

wks = gsn_open_wks ("eps", img)
gsn_define_colormap(wks,cmap)

res = True
; {{{
;res@vpWidthF = plotWid
res@vpHeightF = plotHei
;res@vpXF = -0.01
;  res@vpYF = 0.9

res@gsnDraw = False
res@gsnFrame = False
res@gsnScalarContour     = True               ; contours desired
res@gsnStringFontHeightF = fontSize
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnCenterString = ""
res@gsnStringFontHeightF = fontSize
res@gsnCenterStringOrthogonalPosF = 0.03

res@gsnPolar = "SH"
res@gsnPolarLabelFontHeightF = fontSize*0.8

res@cnFillOn             = True               ; turn on color for contours
res@cnLinesOn            = False              ; turn off contour lines
;   res@cnLineThicknessF = 0.5
res@cnLineLabelsOn       = False              ; turn off contour line labels
res@cnInfoLabelOn        = False      ; turns off contour info label
if .not.autoTicks
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       = cnMinMaxInc(0)
  res@cnMaxLevelValF       = cnMinMaxInc(1)
  res@cnLevelSpacingF      = cnMinMaxInc(2)
end if
;res@cnMissingValFillColor = "gray60"
;   res@cnFillMode = "RasterFill"

if .not.autoTicks
  res@lbLabelBarOn = False
end if
res@lbOrientation = "vertical"
res@lbTitleString = cbTitle
res@lbTitleFontHeightF = fontSize*0.8
res@lbBoxLinesOn = False
res@lbLabelFontHeightF = fontSize*0.8
res@lbLabelStride = 2
;res@lbTitlePosition = "Right"

;res@vcLevelSelectionMode = "ManualLevels"
;res@vcRefMagnitudeF       = 1.0                  ; add a reference vector
;res@vcRefLengthF          = 0.08                ; what the ref length is
res@vcMinDistanceF          = 0.01            ; thin out vectors
res@vcRefAnnoOrthogonalPosF   = -1.0            ; move ref vector
;   res@vcMonoLineArrowColor  = False                ; vec's colored by their mag_p_n
res@vcRefAnnoArrowLineColor   = "black"         ; change ref vector color
res@vcRefAnnoArrowUseVecColor = False           ; don't use vec color for ref
;   res@vcGlyphStyle          = "CurlyVector"        ; turn on curly vectors
res@vcLineArrowThicknessF   = 0.5               ; change vector thickness
res@vcVectorDrawOrder       = "PostDraw"        ; draw vectors last
res@vcLineArrowColor        = "black"           ; change vector color

res@pmLabelBarWidthF = 0.08
res@pmLabelBarHeightF = plotHei
res@pmLabelBarOrthogonalPosF = 0.2

res@mpGridAndLimbOn = True
res@mpPerimOn = False
res@mpGridLineColor = "transparent"
res@mpLandFillColor = "black"

res@mpMaxLatF = -20
;res@mpCenterLonF = 30
;res@mpCenterLatF = -90
res@mpGreatCircleLinesOn = True
;}}}

decades = (/\
"1949-1958",\
"1959-1968",\
"1969-1978",\
"1979-1988",\
"1989-1998",\
"1999-2008"/)
plot = new(6, graphic)
res@gsnCenterString = decades(0)
plot(0) = gsn_csm_vector_scalar_map_polar(wks, vecU1, vecV1, cn1, res)
res@gsnCenterString = decades(1)
plot(1) = gsn_csm_vector_scalar_map_polar(wks, vecU2, vecV2, cn2, res)
res@gsnCenterString = decades(2)
plot(2) = gsn_csm_vector_scalar_map_polar(wks, vecU3, vecV3, cn3, res)
res@gsnCenterString = decades(3)
plot(3) = gsn_csm_vector_scalar_map_polar(wks, vecU4, vecV4, cn4, res)
res@gsnCenterString = decades(4)
plot(4) = gsn_csm_vector_scalar_map_polar(wks, vecU5, vecV5, cn5, res)
res@gsnCenterString = decades(5)
plot(5) = gsn_csm_vector_scalar_map_polar(wks, vecU6, vecV6, cn6, res)

resP = True
resP@gsnFrame = False
resP@gsnPanelLabelBar = True
resP@gsnPanelXWhiteSpacePercent = 5
resP@gsnPanelYWhiteSpacePercent = 10
resP@gsnPanelRowSpec = True
resP@gsnPanelFigureStrings = (/"a)","b)","c)","d)","e)","f)"/)
resP@gsnPanelFigureStringsFontHeightF = fontSize*0.6
resP@gsnPanelFigureStringsPerimOn = False
resP@amJust = "TopLeft"
resP@amOrthogonalPosF = -0.7

resP@pmLabelBarWidthF = 0.5
resP@pmLabelBarHeightF = 0.05
resP@pmLabelBarOrthogonalPosF = -0.01 ; let label bar a bit far

resP@lbLabelFontHeightF = fontSize*0.6
resP@lbTitleFontHeightF = fontSize*0.6
resP@lbTitleString = cbTitle
resP@lbBoxLinesOn = False
;   resP@lbLabelFontHeightF = 0.007

;   resP@txString = "Sea surface horizontal currents"

gsn_panel(wks, plot, (/3,3/), resP)

frame(wks)
delete(wks)
system("eps2png_trim "+img)
