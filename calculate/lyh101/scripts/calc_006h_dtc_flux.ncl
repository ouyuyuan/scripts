
; Description: calc. meridional flux above the thermocline
;              flux = v*dz*dx
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-19 16:12:06 BJT
; Last Change: 2015-06-14 19:20:05 BJT

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

f = addfile(gridFile, "r")
dv = f->dv
dz = f->dz
dx = f->dx
delete(f)
dzC = conform(dv, dz, (/0/))
dxC = conform(dv, dx, (/1,2/))
dsC = dzC*dxC

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
  v = f->v(0,:,:,:)
  pt = f->pt(0,:,:,:)
  delete(f)

  v = where(.not.ismissing(pt) .and. pt.lt.20.0, v@_FillValue, v)
  flux3d = v*dsC 

  if (yr .eq. yb) then
    dims = dimsizes(v)
    nlat = dims(1)
    nlon = dims(2)

    flux = new((/ny, nlat, nlon/), float)
    flux@units = "m^3/s"
    flux@long_name = "meridional flux above thermocline"
    flux!0 = "time"
    flux!1 = "lat"
    flux!2 = "lon"
    flux&time = time
    flux&lat = v&lat
    flux&lon = v&lon
  end if

  flux({yr},:,:) = dim_sum_n(flux3d, 0)
end do


system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)
f->flux = flux
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)

if (.not. ismissing(createOrMerge) .and. createOrMerge.eq."merge") then
  destfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
  oldfile = datDir+"post/"+getenv("NCL_ARG_0_base")+"_old.nc"
  system("mv -f "+destfile+" "+oldfile)
  system("cdo mergetime "+oldfile+" "+outfile+" "+destfile)
end if
