
; Description: extract var2d from yearly files
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:43:19 BJT
; Last Change: 2014-12-05 19:55:17 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir = "/snfs01/ou/models/pcom_1.0/exp/exp24_taux_an_40y_N/output"
yb = 501
ye = 625
ny = ye-yb+1

time = new(ny, integer)
time@units = "years since 0500-01-01"
time@long_name = "time"

varName = "bcv_an"

do yr = yb, ye
  ifname = datDir+sprinti( "year_%0.4i.nc", yr )
  nc = addfile(ifname, "r")
  var2d0 = nc->$varName$(0,:,:)
  var2d0@_FillValue = default_fillvalue(typeof(var2d0))
  var2d0 = where(var2d0.gt.10e10, var2d0@_FillValue, var2d0)
  delete(var2d0@missing_value)
  delete(nc)
  time(yr-yb) = yr

  if (yr .eq. yb) then
    dims = dimsizes(var2d0)
    nlat = dims(0)
    nlon = dims(1)
    var2d = new((/ny, nlat, nlon/), float)
    copy_VarAtts(var2d0, var2d)
    var2d!1 = "lat"
    var2d!2 = "lon"
    var2d&lat = var2d0&lat
    var2d&lon = var2d0&lon
  end if
  var2d(yr-yb,:,:) = var2d0
end do

var2d!0 = "time"
var2d&time = time

outfile = datDir+varName+".nc"
system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)
f->$varName$ = var2d
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
