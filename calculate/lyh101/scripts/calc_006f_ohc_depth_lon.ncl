
; Description: calc. OHC, integrated meridionally
;              ohc = rho cp int(T) dz, T in Kelvin
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-19 16:12:06 BJT
; Last Change: 2015-07-20 10:47:42 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/snfs01/lyh/ou/scripts/pcom.ncl"

datDir = getenv("NCL_ARG_1")
yb = stringtoint(getenv("NCL_ARG_2"))
ye = stringtoint(getenv("NCL_ARG_3"))
createOrMerge = getenv("NCL_ARG_4")

outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
if (.not. ismissing(createOrMerge) .and. createOrMerge.eq."merge") then
  outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+"_new_years.nc"
end if

gridFile = datDir+"../grid_info.nc"
basinFile = datDir+"../basin_b.nc"

rho = 1029 ; kg/m^3, mean density of seawater
cp = 3901 ; c_p, heat capability, J/kg/K

ny = ye-yb+1

f = addfile(gridFile, "r")
dv  = f->dv
dz = f->dz
ds = f->ds
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

basinPac = where(basin.eq.PacId, basinGlo, basinGlo@_FillValue)
basinAtl = where(basin.eq.AtlId, basinGlo, basinGlo@_FillValue)
basinInd = where(basin.eq.IndId, basinGlo, basinGlo@_FillValue)

time = ispan(yb,ye,1)
time@long_name = "time"
if (ye.gt.500) then
  time@units = "years since 0000-01-01"
else
  time@units = "years since 0500-01-01"
end if

z = dv&z
lon = dv&lon
nz = dimsizes(z)
nlon = dimsizes(lon)

ohcGlo = new((/ny,nz,nlon/), float)
ohcGlo!0 = "time"
ohcGlo!1 = "z"
ohcGlo!2 = "lon"
ohcGlo&time = time
ohcGlo&z = z
ohcGlo&lon = lon
ohcGlo@units = "J/m"
ohcGlo@long_name = "ocean heat content per vertical meter layer per longitude"

ohcPac = ohcGlo
ohcAtl = ohcGlo
ohcInd = ohcGlo

do yr = yb, ye
  fname = datDir+"yearly/"+sprinti( "year_%0.4i.nc", yr )
  print("Processing "+fname+" ~ ~ ~ ~ ~ ~ ")
  f = addfile(fname, "r")
  temp = f->pt(0,:,:,:)
  delete(f)

  ohc3d = rho*cp*(temp+273.15)*dv

  ohc3d_Glo = ohc3d * conform(ohc3d, basinGlo, (/1,2/))
  ohc3d_Glo = ohc3d_Glo / conform(ohc3d_Glo, dz, (/0/))
  ohcGlo({yr},:,:) = dim_sum_n( ohc3d_Glo, (/1/))

  ohc3d_Pac = ohc3d * conform(ohc3d, basinPac, (/1,2/))
  ohc3d_Pac = ohc3d_Pac / conform(ohc3d_Pac, dz, (/0/))
  ohcPac({yr},:,:) = dim_sum_n( ohc3d_Pac, (/1/))

  ohc3d_Atl = ohc3d * conform(ohc3d, basinAtl, (/1,2/))
  ohc3d_Atl = ohc3d_Atl / conform(ohc3d_Atl, dz, (/0/))
  ohcAtl({yr},:,:) = dim_sum_n( ohc3d_Atl, (/1/))

  ohc3d_Ind = ohc3d * conform(ohc3d, basinInd, (/1,2/))
  ohc3d_Ind = ohc3d_Ind / conform(ohc3d_Ind, dz, (/0/))
  ohcInd({yr},:,:) = dim_sum_n( ohc3d_Ind, (/1/))

end do

system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)
f->ohcGlo = ohcGlo
f->ohcPac = ohcPac
f->ohcAtl = ohcAtl
f->ohcInd = ohcInd
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)

if (.not. ismissing(createOrMerge) .and. createOrMerge.eq."merge") then
  destfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
  oldfile = datDir+"post/"+getenv("NCL_ARG_0_base")+"_old.nc"
  system("mv -f "+destfile+" "+oldfile)
  system("cdo mergetime "+oldfile+" "+outfile+" "+destfile)
end if
