
; Description: calc. the depth of thermocline (20 isothermal)
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-19 16:12:06 BJT
; Last Change: 2015-04-18 15:26:16 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir  = getenv("NCL_ARG_1")
nc      = getenv("NCL_ARG_2")
fname   = datDir+nc
outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"

;guess data
;{{{
isIshii = False
if isStrSubset(datDir, "Ishii") then
  isIshii = True
end if

isSoda = False
if isStrSubset(datDir, "soda") then
  isSoda = True
end if

isWoa09 = False
if isStrSubset(datDir, "woa09") then
  isWoa09 = True
end if

isPcom = False
if isStrSubset(datDir,"pcom") .and. .not.isStrSubset(datDir,"pcom_grid") then
  isPcom = True
end if
;}}}

f = addfile(fname, "r")
if isSoda then
  pt = f->temp(:,:,:)
  z = f->Z
else if isWoa09 then
  pt = f->t_an(0,:,:,:)
  z = f->Z
else
  pt = f->pt(0,:,:,:)
  z = f->z
end if
end if
delete(f)

; for interpolate with int2p
pt = where(ismissing(pt), 0., pt)
tlev = fspan(14,25,12)
tlev@units = pt@units
tlev!0 = "tlev"

nlev = dimsizes(tlev)
dims = dimsizes(pt)
nlat = dims(1)
nlon = dims(2)
isot = new((/nlev, nlat, nlon/), float)
isot@units = "m"
isot@long_name = "isothermal depth"
isot!0 = "tlev"
isot!1 = "lat"
isot!2 = "lon"
isot&tlev = tlev
isot&lat = pt&lat
isot&lon = pt&lon

depth = conform(pt, z, 0)
copy_VarCoords(pt, depth)
isot(:,:,:) = int2p_n_Wrap(pt, depth, tlev, 0, 0)

dtc = isot({20},:,:)
dtc = smth9_Wrap(dtc, 0.50, 0.25, True)

system("rm -f " + outfile)
f = addfile(outfile, "c")
f->dtc = dtc
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
