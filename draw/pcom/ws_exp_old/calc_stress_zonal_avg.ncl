
; Description: zonal average wind stress (profile) (only account zonal wind)
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:43:19 BJT
; Last Change: 2014-10-30 10:03:13 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

function calc_ue(profile, lats, latn)
local lat, dlat
begin
  pi  = 3.141592653589793
  torad = pi/180.0
  omega  = pi/43082.0 ; angular velocity of the earth
  r = 6371e3 ; radius of the earth
  rho = 1.3 ; kg/m^3

  lat = profile&lat
  f = 2*omega*sin(lat*torad)

  dlat = lat(1) - lat(0)
  dy = r*dlat*torad

  nlat = dimsizes(lat)
  ue = new((/nlat/), float)
;  ue = profile*0.1 / (rho*f) 
  ; 0.1 change dyne/cm^2 to N/m^2 
  ; for symetry, I use both DDF and DDB
  is = ind(lat.eq.lats)
  in = ind(lat.eq.latn)
  do i = is, in
    if ( lat(i) .lt. -2 ) then
      ue(i) = -( profile(i+1)/(rho*f(i+1)) - profile(i)/(rho*f(i)) ) / dy * 0.1
    else if ( lat(i) .gt. 2 ) then
      ue(i) = -( profile(i)/(rho*f(i)) - profile(i-1)/(rho*f(i-1)) ) / dy * 0.1
    else
      ue(i) = ue@_FillValue
    end if
    end if
  end do
;  ue(0:nlat-2) = -( ue(1:nlat-1) - ue(0:nlat-2) ) / dy
  ue = ue
  ue@units = "m/s"
  ue@long_name = "Ekman pumping velocity"

  return ue
end

function calc_profile(nc:string, description:string)
local f, bcu, taux
begin
  f = addfile( nc, "r" )
  bcu = f->bcu
  delete(f)

  taux = dim_avg_n_Wrap(bcu, 0)
  profile = dim_avg_n_Wrap(taux, 1)
  profile@long_name = description
  return profile
end

dir = "/home/ou/archive/data/pcom/input/"
outfile = getenv("NCL_ARG_1")
system("rm -f " + outfile)
f = addfile(outfile, "c")

f->control   = calc_profile(dir+"pcom_bcf_mn.nc", "control run")

p = calc_profile(dir+"pcom_bcf_mn_an_sh.nc", "add anomaly in 70S~30S")
f->an_70S30S = p
f->ue_70S30S = calc_ue(p, -70.5, -29.5)

p = calc_profile(dir+"pcom_bcf_mn_an_sm.nc", "add anomaly in 40S~10S")
f->an_40S10S = p
f->ue_40S10S = calc_ue(p, -40.5, -9.5)

p = calc_profile(dir+"pcom_bcf_mn_an_eq.nc", "add anomaly in 10S~20N")
f->an_10S20N = p
f->ue_10S20N = calc_ue(p, -10.5, 20.5)

p = calc_profile(dir+"pcom_bcf_mn_an_nm.nc", "add anomaly in EQ~30N")
f->an_EQ30N  = p
f->ue_EQ30N  = calc_ue(p, 0.5, 30.5)

p = calc_profile(dir+"pcom_bcf_mn_an_nh.nc", "add anomaly in 30N~60N")
f->an_30N60N = p
f->ue_30N60N = calc_ue(p, 30.5, 60.5)

p = calc_profile(dir+"pcom_bcf_mn_an_15S-15N.nc", "add anomaly in 15S~15N")
f->an_15S15N = p
f->ue_15S15N = calc_ue(p, -15.5, 15.5)

p = calc_profile(dir+"pcom_bcf_mn_an_60S-60N.nc", "add anomaly in 60S~60N")
f->an_60S60N = p
f->ue_60S60N = calc_ue(p, -60.5, 60.5)

f@data = "profile of zonal wind stress"
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
