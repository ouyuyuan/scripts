
; Description: calc. OHC per unit vertical layer, sum up horizontally
;              ohc = rho cp int(T) dz, T in Kelvin
;              and calc. vertical heat flux: VHF = int_z^0 (ohc(y)-ohc(y-1)) dz
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.ohc>
;     Created: 2014-12-02 19:17:56 BJT
; Last Change: 2015-07-08 08:08:14 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

load "/snfs01/lyh/ou/scripts/ishii/head.ncl"

yb = 1945
ye = 2012
outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"

rho = 1029 ; kg/m^3, mean density of seawater
cp = 3901 ; c_p, heat capability, J/kg/K

ny = ye-yb+1

f = addfile(gridFile, "r")
dv  = f->dv
dz = f->dz
idx = f->idx
delete(f)

f = addfile(basinFile, "r")
basin = f->basin
delete(f)
AtlId = 6 ; 6 represents Atlantic in the basin file
SouId = 1
PacId = 2
IndId = 3

basinGlo = basin
basinGlo = where(idx(0,:,:).eq.1, 1, basinGlo@_FillValue)

basinAtl = where(basin.eq.AtlId, basinGlo, basinGlo@_FillValue)
basinPac = where(basin.eq.PacId, basinGlo, basinGlo@_FillValue)
basinInd = where(basin.eq.IndId, basinGlo, basinGlo@_FillValue)
basinSou = where(basin.eq.SouId, basinGlo, basinGlo@_FillValue)

time = ispan(yb,ye,1)
time@long_name = "time"
if (ye.gt.500) then
  time@units = "years since 0000-01-01"
else
  time@units = "years since 0500-01-01"
end if

z = dv&z
nz = dimsizes(z)
ohcGlo = new((/ny,nz/), float)
ohcGlo!0 = "time"
ohcGlo!1 = "z"
ohcGlo&time = time
ohcGlo&z = z
ohcGlo@units = "J/m"
ohcGlo@long_name = "ocean heat content per vertical meter layer"

ohcPac = ohcGlo
ohcAtl = ohcGlo
ohcInd = ohcGlo
ohcSou = ohcGlo

vhfGlo = ohcGlo
vhfGlo@units = "W"
vhfGlo@long_name = "vertical heat flux"
vhfGlo({yb},:) = 0 ; the first year set to 0

vhfPac = vhfGlo
vhfAtl = vhfGlo
vhfInd = vhfGlo
vhfSou = vhfGlo

do yr = yb, ye
  fname = datDir+"yearly/"+sprinti( "temp.%0.4i.nc", yr )
  print("processing "+fname+" ~ ~ ~ ~ ~ ~")
  f = addfile(fname, "r")
  temp = f->wtmp(0,:,:,:)
  delete(f)

  ohc3d = rho*cp*(temp+273.15)*dv
  ohcGlo({yr},:) = dim_sum_n( ohc3d*conform(ohc3d,basinGlo,(/1,2/)), (/1,2/)) / dz
  ohcPac({yr},:) = dim_sum_n( ohc3d*conform(ohc3d,basinPac,(/1,2/)), (/1,2/)) / dz
  ohcAtl({yr},:) = dim_sum_n( ohc3d*conform(ohc3d,basinAtl,(/1,2/)), (/1,2/)) / dz
  ohcInd({yr},:) = dim_sum_n( ohc3d*conform(ohc3d,basinInd,(/1,2/)), (/1,2/)) / dz
  ohcSou({yr},:) = dim_sum_n( ohc3d*conform(ohc3d,basinSou,(/1,2/)), (/1,2/)) / dz

  if (yr.gt.yb) then
    nsec = 12*30*24*3600
    dohcGlo = (ohcGlo({yr},:) - ohcGlo({yr-1},:)) / nsec ; d(ohc)/dt
    dohcPac = (ohcPac({yr},:) - ohcPac({yr-1},:)) / nsec
    dohcAtl = (ohcAtl({yr},:) - ohcAtl({yr-1},:)) / nsec
    dohcInd = (ohcInd({yr},:) - ohcInd({yr-1},:)) / nsec
    dohcSou = (ohcSou({yr},:) - ohcSou({yr-1},:)) / nsec
;    print(dohcGlo+0)
;    exit

    do i = 0, nz-1
      vhfGlo({yr},i) = - dim_sum_n( dohcGlo(:i)*dz(:i), 0 ) ; upward is positive
      vhfPac({yr},i) = - dim_sum_n( dohcPac(:i)*dz(:i), 0 )
      vhfAtl({yr},i) = - dim_sum_n( dohcAtl(:i)*dz(:i), 0 )
      vhfInd({yr},i) = - dim_sum_n( dohcInd(:i)*dz(:i), 0 )
      vhfSou({yr},i) = - dim_sum_n( dohcSou(:i)*dz(:i), 0 )
    end do
  end if

end do

system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)

f->ohcGlo = ohcGlo
f->ohcPac = ohcPac
f->ohcAtl = ohcAtl
f->ohcInd = ohcInd
f->ohcSou = ohcSou

f->vhfGlo = vhfGlo
f->vhfPac = vhfPac
f->vhfAtl = vhfAtl
f->vhfInd = vhfInd
f->vhfSou = vhfSou

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
