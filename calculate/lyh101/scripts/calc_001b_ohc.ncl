
; Description: original is for calc. Ishii monthly data for Southern ocean, 0~1500m
;              ohc = rho cp int(T) dz, T in Kelvin
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-12-02 19:17:56 BJT
; Last Change: 2014-12-21 19:19:24 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir = getenv("NCL_ARG_1")
suffixa= getenv("NCL_ARG_2")
outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+suffixa+".nc"

;guess data
;{{{
isIshii = False
if isStrSubset(datDir, "Ishii") then
  isIshii = True
end if

isSoda = False
if isStrSubset(datDir, "soda") then
  isSoda = True
end if

isPcom = False
if isStrSubset(datDir,"pcom") .and. .not.isStrSubset(datDir,"pcom_grid") then
  isPcom = True
end if
;}}}

procedure cal_ohc(ohc4d, basin_mask, basin_ohc, year)
local bc, z
begin
  bc = conform(ohc4d, basin_mask, (/1,2/))
  basin_ohc({year},:) = dim_sum_n(ohc4d*bc, (/1,2/))
end

grid_info_file = datDir+"post/grid_info.nc"
basin_file = datDir+"post/basin.nc"
if isPcom
  grid_info_file = datDir+"../grid_info.nc"
  basin_file = datDir+"../basin.nc"
end if

rho = 1029 ; kg/m^3, mean density of seawater
cp = 3901 ; c_p, heat capability, J/kg/K

latS = -89.5
latN = -35.5
f = addfile(grid_info_file, "r")
dv  = f->dv(:,{latS:latN},:)
idx = f->idx
ds = f->ds
delete(f)
ds = where(idx(0,:,:).eq.1, ds, 0)

f = addfile(basin_file, "r")
basin = f->basin
delete(f)

latc = conform(basin, basin&lat, 0)
lonc = conform(basin, basin&lon, 1)
z = dv&$dv!0$
nz = dimsizes(z)

fname = datDir+"monthly/post/temp.nc"
;fname = datDir+"monthly/temp.1945.nc"
tempName = "var80"
f = addfile(fname, "r")
temp = f->$tempName$(:,:,{-89.5:-35.5},:)
delete(f)
mydv = conform(temp, dv, (/1,2,3/))
ohc = dim_sum_n_Wrap(rho*cp*(temp+273.15)*mydv, (/1,2,3/))
ohc@long_name = "0~1500m OHC in Southern Ocean"
ohc@units = "J"

system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)

f->ohc = ohc

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
