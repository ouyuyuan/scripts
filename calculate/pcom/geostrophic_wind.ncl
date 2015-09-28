
; Description: need calc_bcp_gradient.jnl first
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-31 16:16:34 BJT
; Last Change: 2014-11-01 10:28:51 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure add_dims(var, t, lat, lon)
begin
  var!0 = "t"
  var!1 = "lat"
  var!2 = "lon"
  var&t = t
  var&lat = lat
  var&lon = lon
end

nc_gradient = "/home/ou/archive/data/plot/pcom/ws_exp/bcp_gradient_float.nc"
nc = addfile(nc_gradient, "r")
px = nc->px
py = nc->py
lat = nc->lat
lon = nc->lon
t   = nc->t
delete(nc)

pi  = 3.141592653589793
torad = pi/180.0
omega  = pi/43082.0 ; angular velocity of the earth
r = 6371e3 ; radius of the earth
rho = 1.3 ; kg/m^3, density of air
f = 2*omega*sin(lat*torad)
; only mid-latitude 
f@_FillValue = default_fillvalue("float")
f = where( (abs(lat).gt.60) .or. (abs(lat).lt.30), f@_FillValue, f)
f_con = conform(py, f, 1)
delete(f)

ug = py
vg = px
ug = -py/(rho*f_con)
vg =  px/(rho*f_con)
ug@long_name = "zonal component of geostrophic wind"
vg@long_name = "meridional component of geostrophic wind"
ug@units = "m/s"
vg@units = "m/s"

; tau = rho cd u10^2 = rho * ustar^2, follows Large and Yeager 2008, eq 10
a1 = 0.00270
a2 = 0.000142
a3 = 0.0000764
; 10: change N/m^2 to dyne/cm^2
bcu = 10 * rho * (a1*ug + a2*ug^2 + a3*ug^3)
bcu@long_name = "zonal wind stress of geostrophic wind"
bcu@units = "dyne/cm^2"
add_dims(bcu, t, lat, lon)

bcv = 10 * rho * (a1*vg + a2*vg^2 + a3*vg^3)
bcv@long_name = "meridional wind stress of geostrohic wind"
bcv@units = "dyne/cm^2"
add_dims(bcv, t, lat, lon)

outfile = "/home/ou/archive/data/pcom/input/geostrophic_wind.nc"
system("rm -f " + outfile)
f = addfile(outfile, "c")

f->ug = ug
f->vg = vg
f->bcu = bcu
f->bcv = bcv

f@data = "geostrophic wind at mid-latitude"
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
