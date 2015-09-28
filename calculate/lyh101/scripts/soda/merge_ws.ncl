
; Description: merge windstress from from individual files
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 09:38:11 BJT
; Last Change: 2015-07-21 20:09:25 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir = "/snfs01/lyh/ou/data/soda/pcom_grid/"
yb = 1871
;ye = 1873
ye = 2008
ny = ye-yb+1
outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"

time = ispan(yb,ye,1)
time@long_name = "time"
time@units = "years since 0000-01-01"

function create_var2d(var2d0)
;{{{
begin
  dims = dimsizes(var2d0)
  nlat = dims(0)
  nlon = dims(1)
  var2d = new((/ny, nlat, nlon/), typeof(var2d0))
  copy_VarAtts(var2d0, var2d)

  var2d!0 = "time"
  var2d!1 = "lat"
  var2d!2 = "lon"
  var2d&time = time
  var2d&lat = var2d0&lat
  var2d&lon = var2d0&lon
  return var2d
end
;}}}

do yr = yb, ye
  fname = datDir+"yearly/"+sprinti( "year_%0.4i.nc", yr )
  print("processing "+fname+" ~ ~ ~ ~ ~ ~")
  f = addfile(fname, "r")
  taux0 = f->taux
  tauy0 = f->tauy
  delete(f)

  if (yr .eq. yb) then
    taux = create_var2d(taux0)
    tauy = create_var2d(tauy0)
  end if
  taux({yr},:,:) = taux0
  tauy({yr},:,:) = tauy0
end do

system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)
f->taux = taux
f->tauy = tauy
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
