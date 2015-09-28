
; Description: calc. isothermal depths for a range of temperatures and years
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-19 16:12:06 BJT
; Last Change: 2015-01-14 10:15:28 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir = getenv("NCL_ARG_1")
yb = stringtoint(getenv("NCL_ARG_2"))
ye = stringtoint(getenv("NCL_ARG_3"))
createOrMerge = getenv("NCL_ARG_4")

outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
if (.not. ismissing(createOrMerge) .and. createOrMerge.eq."merge") then
  outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+"_new_years.nc"
end if

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
  z = f->z
  delete(f)

  ; for interpolate with int2p
  pt = where(ismissing(pt), 0., pt)
  tlev = fspan(14,25,12)
  tlev@units = pt@units
  tlev!0 = "tlev"

  if (yr .eq. yb) then
    nlev = dimsizes(tlev)
    dims = dimsizes(pt)
    nlat = dims(1)
    nlon = dims(2)
    isot = new((/ny, nlev, nlat, nlon/), float)
    isot@units = "m"
    isot@long_name = "isothermal depth"
    isot!0 = "time"
    isot!1 = "tlev"
    isot!2 = "lat"
    isot!3 = "lon"
    isot&time = time
    isot&tlev = tlev
    isot&lat = pt&lat
    isot&lon = pt&lon
  end if

  depth = conform(pt, z, 0)
  copy_VarCoords(pt, depth)
  isot({yr},:,:,:) = int2p_n_Wrap(pt, depth, tlev, 0, 0)
end do

system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)
f->isot = isot
f@data = "isothermal line depth, use potential temperature as a dimension"
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)

if (.not. ismissing(createOrMerge) .and. createOrMerge.eq."merge") then
  destfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
  oldfile = datDir+"post/"+getenv("NCL_ARG_0_base")+"_old.nc"
  system("mv -f "+destfile+" "+oldfile)
  system("cdo mergetime "+oldfile+" "+outfile+" "+destfile)
end if
