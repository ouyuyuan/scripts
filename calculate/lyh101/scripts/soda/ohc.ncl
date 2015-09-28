
; Description: calculate ocean heat content
;              ohc = rho cp int(T) dz, T in Kelvin
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-12-02 19:17:56 BJT
; Last Change: 2014-12-05 14:37:58 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir = getenv("NCL_ARG_1")

rho = 1029 ; kg/m^3, mean density of seawater
cp = 3901 ; c_p, heat capability, J/kg/K

yb = 1871
ye = 2008
ny = ye-yb+1

infile = datDir+"post/grid_info.nc"
nc = addfile(infile, "r")
dv_ori = nc->dv
idx = nc->idx
delete(nc)
dv_glo = where(idx.eq.1, dv_ori, 0) ; only preserve water grid

time = new(ny, integer)
time@long_name = "time"
time@units = "years since 0000-01-01"

ohc_glo = new(ny, float)
ohc_glo@long_name = "global ocean heat content"
ohc_glo@units = "J"

do yr = yb, ye
  fname = datDir+"yearly/"+sprinti( "year_%0.4i.nc", yr )
  print("processing "+fname+" ~ ~ ~ ~ ~ ~")
  nc = addfile(fname, "r")
  pt = nc->temp(:,:,:)
  delete(nc)
  time(yr-yb) = yr
  ohc_glo(yr-yb) = rho*cp*sum((pt+273.15)*dv_glo)
end do

ohc_glo!0 = "time"
ohc_glo&time = time

outfile = datDir+"post/ohc.nc"
system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)
f->ohc_glo = ohc_glo
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
