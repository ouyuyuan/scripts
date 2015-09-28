
; Description: zonal mean wind stress evolving with time
;              (account both zonal and meridional wind)
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-04-12 19:08:29 BJT
; Last Change: 2015-04-25 09:02:18 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir = "/snfs01/lyh/ou/data/soda/"
yb = 1871
;ye = 1873
ye = 2008
ny = ye-yb+1

outfile = datDir+"post/wind_stress_lat_time.nc"

time = ispan(yb,ye,1)
time@long_name = "time"

do yr = yb, ye
  ;{{{
  fname = datDir+"yearly/"+sprinti( "year_%0.4i.nc", yr )
  print("processing "+fname+" ~ ~ ~ ~ ~ ~")

  f = addfile(fname, "r")
  tauxYr = f->taux
  tauyYr = f->tauy
  delete(f)

  if (yr.eq.yb) then
    nlat = dimsizes(tauxYr&lat)
    taux = new((/ny,nlat/), float)
    tauy = new((/ny,nlat/), float)
    taux!0 = "time"
    tauy!0 = "time"
    taux&time = time
    tauy&time = time
  end if

  taux({yr},:) = dim_avg_n_Wrap(tauxYr, 1)
  tauy({yr},:) = dim_avg_n_Wrap(tauyYr, 1)
end do
;}}}

system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)

f->taux = taux
f->tauy = tauy

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
