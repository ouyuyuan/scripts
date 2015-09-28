
; Description: calc. Poleward Heat Transport
;              pht = rho cp int(v*T) dz dx, T in Kelvin
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-12-02 19:17:56 BJT
; Last Change: 2015-05-03 08:42:40 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir = getenv("NCL_ARG_1")
yb = stringtoint(getenv("NCL_ARG_2"))
ye = stringtoint(getenv("NCL_ARG_3"))
outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"

gridFile = datDir+"../grid_info.nc"
basinFile = datDir+"../basin.nc"

rho = 1029 ; kg/m^3, mean density of seawater
cp = 3901 ; c_p, heat capability, J/kg/K

ny = ye-yb+1

f = addfile(gridFile, "r")
dv  = f->dv
dz = f->dz ; 1D
dx = f->dx ; 2D
idx = f->idx ; 2D
delete(f)
dxC = conform(dv,dx,(/1,2/))
dxC = where(idx.eq.0, 0, dxC)
dzC = conform(dv,dz,0)
dzC = where(idx.eq.0, 0, dzC)

f = addfile(basinFile, "r")
basin = f->basin
delete(f)

time = ispan(yb,ye,1)
time@long_name = "time"
if (ye.gt.500) then
  time@units = "years since 0000-01-01"
else
  time@units = "years since 0500-01-01"
end if

; basin masks
maskGlo = idx(0,:,:) ; only preserve water grid
maskGlo@_FillValue = 0
lat = dv&lat
nlat = dimsizes(lat)
phtGlo = new((/ny,nlat/), float)
phtGlo!0 = "time"
phtGlo!1 = "lat"
phtGlo&time = time
phtGlo&lat = lat
phtGlo@units = "W"
phtGlo@long_name = "poleward heat transport"

maskPac = where(basin.eq.2, 1, 0)
maskPac@_FillValue = 0
phtPac = phtGlo

maskAtl = where(basin.eq.6, 1, 0)
maskAtl@_FillValue = 0
phtAtl = phtGlo

maskInd = where(basin.eq.3, 1, 0)
maskInd@_FillValue = 0
phtInd = phtGlo

maskSou = where(basin.eq.1, 1, 0)
maskSou@_FillValue = 0
phtSou = phtGlo

do yr = yb, ye
  fname = datDir+"yearly/"+sprinti( "year_%0.4i.nc", yr )
  print("processing "+fname+" ~ ~ ~ ~ ~ ~")
  f = addfile(fname, "r")
  t = f->pt(0,:,:,:)
  v = f->v(0,:,:,:)
  delete(f)

  pht3d = rho*cp*(t+273.15)*v*dzC*dxC

  ; integrated in the z direction, then the x direction
  phtGlo({yr},:) = dim_sum_n( dim_sum_n(pht3d,0)*maskGlo, 1 )
  phtPac({yr},:) = dim_sum_n( dim_sum_n(pht3d,0)*maskPac, 1 )
  phtAtl({yr},:) = dim_sum_n( dim_sum_n(pht3d,0)*maskAtl, 1 )
  phtInd({yr},:) = dim_sum_n( dim_sum_n(pht3d,0)*maskInd, 1 )
  phtSou({yr},:) = dim_sum_n( dim_sum_n(pht3d,0)*maskSou, 1 )
end do

system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)

f->phtGlo = phtGlo
f->phtPac = phtPac
f->phtAtl = phtAtl
f->phtInd = phtInd
f->phtSou = phtSou

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
