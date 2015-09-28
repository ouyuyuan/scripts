
; Description: calc. meridional mean
;              ohc = rho cp int(T) dz, T in Kelvin
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-19 16:12:06 BJT
; Last Change: 2015-06-13 15:12:17 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/snfs01/lyh/ou/scripts/pcom.ncl"

datDir = getenv("NCL_ARG_1")
yb = stringtoint(getenv("NCL_ARG_2"))
ye = stringtoint(getenv("NCL_ARG_3"))
createOrMerge = getenv("NCL_ARG_4")

outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
if (.not. ismissing(createOrMerge) .and. createOrMerge.eq."merge") then
  outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+"_new_years.nc"
end if

gridFile = datDir+"../grid_info.nc"
basinFile = datDir+"../basin.nc"

rho = 1029 ; kg/m^3, mean density of seawater
cp = 3901 ; c_p, heat capability, J/kg/K

ny = ye-yb+1

f = addfile(gridFile, "r")
dv  = f->dv
dz = f->dz
ds = f->ds
idx = f->idx
delete(f)

f = addfile(basinFile, "r")
basin = f->basin
delete(f)
AtlId = 6 ; 6 represents Atlantic in the basin file
SouId = 1
PacId = 2
IndId = 3

basinGlo = basin
basinGlo = where(idx(0,:,:).eq.1, 1, basinGlo@_FillValue)

basinPac = where(basin.eq.PacId, basinGlo, basinGlo@_FillValue)

time = ispan(yb,ye,1)
time@long_name = "time"
if (ye.gt.500) then
  time@units = "years since 0000-01-01"
else
  time@units = "years since 0500-01-01"
end if

z = dv&z
lon = dv&lon
nz = dimsizes(z)
nlon = dimsizes(lon)

ohcPac = new((/ny,nz,nlon/), float)
ohcPac!0 = "time"
ohcPac!1 = "z"
ohcPac!2 = "lon"
ohcPac&time = time
ohcPac&z = z
ohcPac&lon = lon
ohcPac@units = "J/m"
ohcPac@long_name = "ocean heat content per vertical meter layer per longitude"

do yr = yb, ye
  fname = datDir+"yearly/"+sprinti( "year_%0.4i.nc", yr )
  print("Processing "+fname+" ~ ~ ~ ~ ~ ~ ")
  f = addfile(fname, "r")
  temp = f->pt(0,:,:,:)
  delete(f)

  ohc3d = rho*cp*(temp+273.15)*dv
  ohc3d = ohc3d * conform(ohc3d, basinPac, (/1,2/))
  ohc3d = ohc3d / conform(ohc3d, dz, (/0/))
  ohcPac({yr},:,:) = dim_sum_n( ohc3d, (/1/))
end do


system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)
f->ohcPac = ohcPac
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)

if (.not. ismissing(createOrMerge) .and. createOrMerge.eq."merge") then
  destfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
  oldfile = datDir+"post/"+getenv("NCL_ARG_0_base")+"_old.nc"
  system("mv -f "+destfile+" "+oldfile)
  system("cdo mergetime "+oldfile+" "+outfile+" "+destfile)
end if
