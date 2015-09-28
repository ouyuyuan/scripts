
; Description: zonal average wind stress anomaly (profile) evolving with time(year)
;              (only account zonal wind)
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:43:19 BJT
; Last Change: 2014-11-09 11:00:28 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

function cal_evolve(arg)
begin

  indir = arg@indir
  infile = indir+"pcom_bcf_mn_re_cycle.nc"
  f = addfile( infile, "r" )
  t = f->t
  lat = f->lat
  bcu_old = f->bcu
  delete(f)

  infile = arg@infile
  f = addfile( infile, "r" )
  bcu_new = f->bcu
  delete(f)

  an = bcu_new
  an = bcu_new - bcu_old

  ny = dimsizes(t)/12
  dims = dimsizes(an)
  nlat = dims(1)
  nlon = dims(2)
  mean = new((/nlat,ny/),typeof(an))
  year = new(ny, integer)

  do y = 1, ny
    year(y-1) = y
    mb = (y-1)*12 + 1
    me = y*12
    taux = dim_avg_n_Wrap(an(mb-1:me-1,:,:), 0)
    mean(:,y-1) = dim_avg_n_Wrap(taux, 1)
  end do

  mean@long_name = "zonal mean wind stress anomaly evolving with time"
  mean!1 = "year"
  mean&year = year

  return mean
end

arg = True
arg@indir = "/home/ou/archive/data/pcom/input/"
outfile = getenv("NCL_ARG_1")
system("rm -f " + outfile)
f = addfile(outfile, "c")

arg@infile = arg@indir+"pcom_bcf_mn_re_cycle_60S-30S_periodic.nc"
f->cn_60S30S_periodic = cal_evolve(arg)

arg@infile = arg@indir+"pcom_bcf_mn_re_cycle_30N-60N_periodic.nc"
f->cn_30N60N_periodic = cal_evolve(arg)

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)

