
; Description: add geostrophic wind stress
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-31 20:28:00 BJT
; Last Change: 2014-11-01 10:50:07 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

function an_bcf(var)
local dims, nt, nlat, nlon, ny
begin
  dims = dimsizes(var)
  nt = dims(0)
  nlat = dims(1)
  nlon = dims(2)
  ny = nt/12

  an = var

  do month = 1, 12
    i = month-1
    month_avg = dim_avg_n(var(i::12,:,:), 0)
    an(i::12,:,:) = var(i::12,:,:) - conform_dims( (/ny,nlat,nlon/), month_avg, (/1,2/) )
  end do
  return an
end

reffile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn_re_cycle.nc"
geofile = "/home/ou/archive/data/pcom/input/geostrophic_wind.nc"
;outfile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn_re_cycle_an_geows_NS.nc"
;outfile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn_re_cycle_an_geows_N.nc"
  outfile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn_re_cycle_an_geows_S.nc"

f = addfile( geofile, "r" )
bcu_geo = f->bcu
bcv_geo = f->bcv
delete(f)

system("cp -f " + reffile + " " + outfile)
f = addfile( outfile, "w" )
bcu = f->bcu
bcv = f->bcv
lat_ori = f->lat

lat = conform(bcu, lat_ori, 1)
; add in both north and south
;bcu = where((abs(lat).ge.30).and.(abs(lat).le.60), bcu + an_bcf(bcu_geo), bcu)
;f@data = "add zonal geostrophic wind stress anomaly in 30N-60N and 60S-30S"
; add in 30N-60N
;bcu = where((lat.ge.30).and.(lat.le.60), bcu + an_bcf(bcu_geo), bcu)
;f@data = "add zonal geostrophic wind stress anomaly in 30N-60N"
; add in 60S-30S
bcu = where((lat.ge.-60).and.(lat.le.-30), bcu + an_bcf(bcu_geo), bcu)
f@data = "add zonal geostrophic wind stress anomaly in 60S-30S"
f->bcu = bcu

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
