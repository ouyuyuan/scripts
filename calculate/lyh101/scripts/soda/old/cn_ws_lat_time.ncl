
; Description: zonal average wind stress (profile) evolving with time(year)
;              (account both zonal and meridional wind)
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:43:19 BJT
; Last Change: 2015-04-25 08:40:48 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

outfile = "/snfs01/lyh/ou/data/soda/post/ws_lat_time.nc"
yb = 1949
ye = 2008

infile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn_re.nc"
f = addfile( infile, "r" )
t = f->t
lat = f->lat
bcu = f->bcu
delete(f)

nlat = dimsizes(lat)
nm = dimsizes(t)
ny = (nm-1)/12 ; the first month is 1947-12, not use it

mean = new((/nlat,ny/), float)
year = new(ny, integer)

do y = 1, ny
  year(y-1) = 1947 + y
  mb = (y-1)*12 + 2
  me = y*12 + 1
  taux = dim_avg_n_Wrap(bcu(mb:me,:,:), 0)
  mean(:,y-1) = dim_avg_n_Wrap(taux, 1)
end do

mean@long_name = "zonal mean wind stress evolving with time"
mean!1 = "year"
mean&year = year

system("rm -f " + outfile)
f = addfile(outfile, "c")
f->cn = mean
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
