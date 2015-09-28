
; Description: calculate ocean heat content in unit ocean grid
;              account for the effect of SSH, not account the effect of area
;              sum up between a specified vertical range
;              ohc = rho cp int(T) dz, T in Kelvin
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-19 16:12:06 BJT
; Last Change: 2015-06-12 19:00:14 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/snfs01/lyh/ou/scripts/pcom.ncl"

datDir = getenv("NCL_ARG_1")
yb = stringtoint(getenv("NCL_ARG_2"))
ye = stringtoint(getenv("NCL_ARG_3"))
zt = stringtoint(getenv("NCL_ARG_4"))
zb = stringtoint(getenv("NCL_ARG_5"))

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

outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+"_"+zt+"-"+zb+"m.nc"
gridfile = datDir+"post/grid_info.nc"
if isPcom
  gridfile = datDir+"../grid_info.nc"
end if

f = addfile(gridfile, "r")
dv  = f->dv
ds = f->ds
delete(f)

ny = ye-yb+1
time = ispan(yb,ye,1)
time@long_name = "time"
if (ye.gt.500) then
  time@units = "years since 0000-01-01"
else
  time@units = "years since 0500-01-01"
end if

do yr = yb, ye
  fname = datDir+"yearly/"+sprinti( "year_%0.4i.nc", yr )
  print("Processing "+fname+" ~ ~ ~ ~ ~ ~ ")
  f = addfile(fname, "r")
  pt = f->pt(0,:,:,:)
  ssh = f->ssh(0,:,:)
  delete(f)

  if (yr .eq. yb) then
    dims = dimsizes(pt)
    nlat = dims(1)
    nlon = dims(2)

    ohc = new((/ny, nlat, nlon/), float)
    ohc@units = "Sv"
    ohc@long_name = "barotropic stream fuction"
    ohc!0 = "time"
    ohc!1 = "lat"
    ohc!2 = "lon"
    ohc&time = time
    ohc&lat = pt&lat
    ohc&lon = pt&lon
  end if

  ohc({yr},:,:) = (/pcom_unit_grid_ohc(dv, ds, ssh, pt, zt, zb)/)
end do


system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)
f->ohc = ohc
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
