
; Description: calc. volume anomaly per latitude band (1 degree)
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.dvol>
;     Created: 2015-01-11 09:38:11 BJT
; Last Change: 2015-06-10 19:53:43 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir = getenv("NCL_ARG_1")
yb = stringtoint(getenv("NCL_ARG_2"))
ye = stringtoint(getenv("NCL_ARG_3"))
ny = ye-yb+1
outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"

gridFile = datDir+"../grid_info.nc"
basinFile = datDir+"../basin.nc"

f = addfile(gridFile, "r")
idx = f->idx
ds = f->ds
delete(f)
ds = where(idx(0,:,:).eq.1, ds, 0)

f = addfile(basinFile, "r")
basin = f->basin
delete(f)

time = ispan(yb,ye,1)
time@long_name = "time"
if (ye.le.500) then
  ; for those expriments which the year-counter has been reset to 0 
  time@units = "years since 0500-01-01"
else
  time@units = "years since 0000-01-01"
end if

; basin masks
maskGlo = idx(0,:,:) ; only preserve water grid
maskGlo@_FillValue = 0
lat = ds&lat
nlat = dimsizes(lat)
dvolGlo = new((/ny,nlat/), float)
dvolGlo!0 = "time"
dvolGlo!1 = "lat"
dvolGlo&time = time
dvolGlo&lat = lat
dvolGlo@units = "m^3/deg"
dvolGlo@long_name = "volume anomaly per latitude band"

maskPac = where(basin.eq.2, 1, 0)
maskPac@_FillValue = 0
dvolPac = dvolGlo

maskAtl = where(basin.eq.6, 1, 0)
maskAtl@_FillValue = 0
dvolAtl = dvolGlo

maskInd = where(basin.eq.3, 1, 0)
maskInd@_FillValue = 0
dvolInd = dvolGlo

maskSou = where(basin.eq.1, 1, 0)
maskSou@_FillValue = 0
dvolSou = dvolGlo

do yr = yb, ye
  fname = datDir+"yearly/"+sprinti( "year_%0.4i.nc", yr )
  print("processing "+fname+" ~ ~ ~ ~ ~ ~")
  f = addfile(fname, "r")
  ssh = f->ssh(0,:,:)
  delete(f)

  dvolGlo({yr},:) = (/dim_sum_n(ds*ssh*maskGlo, 1)/)
  dvolPac({yr},:) = (/dim_sum_n(ds*ssh*maskPac, 1)/)
  dvolAtl({yr},:) = (/dim_sum_n(ds*ssh*maskAtl, 1)/)
  dvolInd({yr},:) = (/dim_sum_n(ds*ssh*maskInd, 1)/)
  dvolSou({yr},:) = (/dim_sum_n(ds*ssh*maskSou, 1)/)
end do

system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)
f->dvolGlo = dvolGlo
f->dvolPac = dvolPac
f->dvolAtl = dvolAtl
f->dvolInd = dvolInd
f->dvolSou = dvolSou
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
