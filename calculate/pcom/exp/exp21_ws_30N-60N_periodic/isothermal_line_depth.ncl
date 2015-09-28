
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-19 16:12:06 BJT
; Last Change: 2014-11-27 19:34:23 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  datDir = getenv("NCL_ARG_1")+"../yearly/"
  ofname = getenv("NCL_ARG_1")+getenv("NCL_ARG_0_base")+".nc"

  yb = 1
  ye = 120
  ny = ye-yb+1
  time = new(ny, integer)
  time@units = "years since 0500-01-01 00:00:00"
  time@long_name = "time"

  do yr = yb, ye
    ifname = datDir + sprinti( "year_%0.4i.nc", yr )
    print("Processing "+ifname+" ~ ~ ~ ~ ~ ~ ")
    nc = addfile(ifname, "r")
    pt = nc->pt(0,:,:,:)
    z = nc->z
    delete(nc)
    time(yr-yb) = yr

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
      isot@long_name = "depth of isothermal line"
      isot!0 = "time"
      isot!1 = "tlev"
      isot!2 = "lat"
      isot!3 = "lon"
      isot&tlev = tlev
      isot&lat = pt&lat
      isot&lon = pt&lon
    end if

    depth = conform(pt, z, 0)
    copy_VarCoords(pt, depth)
    isot(yr-yb,:,:,:) = int2p_n_Wrap(pt, depth, tlev, 0, 0)
  end do

  isot&time = time
  system("rm -f " + ofname)
  f = addfile(ofname, "c")
  filedimdef(f, "time", -1, True)
  f->isot = isot
  f@data = "isothermal line depth, use potential temperature as a dimension"
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")

end
