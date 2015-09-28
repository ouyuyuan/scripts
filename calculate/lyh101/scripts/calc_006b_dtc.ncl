
; Description: calc. isothermal depths for a range of temperatures and years
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-19 16:12:06 BJT
; Last Change: 2015-06-14 19:00:50 BJT

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
    isot = new((/nlev, nlat, nlon/), float)
    isot@units = "m"
    isot@long_name = "isothermal depth"
    isot!0 = "tlev"
    isot!1 = "lat"
    isot!2 = "lon"
    isot&tlev = tlev
    isot&lat = pt&lat
    isot&lon = pt&lon

    dtc = new((/ny, nlat, nlon/), float)
    dtc@units = "m"
    dtc@long_name = "depth of thermocline"
    dtc!0 = "time"
    dtc!1 = "lat"
    dtc!2 = "lon"
    dtc&time = time
    dtc&lat = pt&lat
    dtc&lon = pt&lon
  end if

  depth = conform(pt, z, 0)
  copy_VarCoords(pt, depth)
  isot(:,:,:) = int2p_n_Wrap(pt, depth, tlev, 0, 0)
  dtc({yr},:,:) = (/isot({20},:,:)/) ; 20 isothermal 
  dtc({yr},:,:) = smth9_Wrap(dtc({yr},:,:), 0.50, 0.25, True)
end do


system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)
f->dtc = dtc
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)

if (.not. ismissing(createOrMerge) .and. createOrMerge.eq."merge") then
  destfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
  oldfile = datDir+"post/"+getenv("NCL_ARG_0_base")+"_old.nc"
  system("mv -f "+destfile+" "+oldfile)
  system("cdo mergetime "+oldfile+" "+outfile+" "+destfile)
end if
