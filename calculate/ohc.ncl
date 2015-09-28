
; Description: calculate ocean heat content in each ocean layer
;              the horizontal have been sum up
;              ohc = rho cp int(T) dz, T in Kelvin
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-12-02 19:17:56 BJT
; Last Change: 2014-12-12 16:10:01 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure cal_ohc(ohc3d, basin_mask, basin_ohc, year)
local bc, z
begin
  bc = conform(ohc3d, basin_mask, (/1,2/))
  basin_ohc({year},:) = dim_sum_n(ohc3d*bc, (/1,2/))
end

datDir = getenv("NCL_ARG_1")
outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
grid_info_file = "/home/ou/archive/data/Ishii/post/grid_info.nc"
basin_file = "/home/ou/archive/data/Ishii/post/basin.nc"

rho = 1029 ; kg/m^3, mean density of seawater
cp = 3901 ; c_p, heat capability, J/kg/K

yb = stringtoint(getenv("NCL_ARG_2"))
ye = stringtoint(getenv("NCL_ARG_3"))
ny = ye-yb+1

f = addfile(grid_info_file, "r")
dv  = f->dv
idx = f->idx
ds = f->ds
delete(f)
ds = where(idx(0,:,:).eq.1, ds, 0)

f = addfile(basin_file, "r")
basin = f->basin
delete(f)

time = ispan(yb,ye,1)
time@long_name = "time"
if (ye.gt.500) then
  time@units = "years since 0000-01-01"
else
  time@units = "years since 0500-01-01"
end if

latc = conform(basin, basin&lat, 0)
lonc = conform(basin, basin&lon, 1)
z = dv&$dv!0$
nz = dimsizes(z)

; basin masks
mask_glo = idx(0,:,:) ; only preserve water grid
;{{{
ohc_glo = new((/ny,nz/), float)
ohc_glo@units = "J"
ohc_glo@long_name = "Ocean heat content"
ohc_glo!0 = "time"
ohc_glo!1 = "z"
ohc_glo&time = time
ohc_glo&z = z
ohc_glo = 0

mask_Pac = where(basin.eq.2, mask_glo, 0)
ohc_Pac = ohc_glo

mask_Pac_N = where(latc.ge.20, mask_Pac, 0)
ohc_Pac_N = ohc_glo

mask_Pac_T = where(latc.gt.-20 .and. latc.lt.20, mask_Pac, 0)
ohc_Pac_T = ohc_glo
mask_Pac_T_W = where(lonc.le.210, mask_Pac_T, 0)
ohc_Pac_T_W = ohc_glo
mask_Pac_T_E = where(lonc.gt.210, mask_Pac_T, 0)
ohc_Pac_T_E = ohc_glo

mask_Pac_S = where(latc.le.-20, mask_Pac, 0)
ohc_Pac_S = ohc_glo

mask_Atl = where(basin.eq.6, mask_glo, 0)
ohc_Atl = ohc_glo
mask_Ind = where(basin.eq.3, mask_glo, 0)
ohc_Ind = ohc_glo
mask_Sou = where(basin.eq.1, mask_glo, 0)
ohc_Sou = ohc_glo
;}}}

do yr = yb, ye
  fname = datDir+"yearly/"+sprinti( "temp.%0.4i.nc", yr )
  print("processing "+fname+" ~ ~ ~ ~ ~ ~")

  f = addfile(fname, "r")
  temp = f->wtmp(0,:,:,:)
  delete(f)
  ohc3d = dv
  ohc3d = rho*cp*(temp+273.15)*dv
  cal_ohc(ohc3d, mask_glo, ohc_glo, yr)
  cal_ohc(ohc3d, mask_Pac, ohc_Pac, yr)
  cal_ohc(ohc3d, mask_Pac_S, ohc_Pac_S, yr)
  cal_ohc(ohc3d, mask_Pac_T, ohc_Pac_T, yr)
  cal_ohc(ohc3d, mask_Pac_T_W, ohc_Pac_T_W, yr)
  cal_ohc(ohc3d, mask_Pac_T_E, ohc_Pac_T_E, yr)
  cal_ohc(ohc3d, mask_Pac_N, ohc_Pac_N, yr)
  cal_ohc(ohc3d, mask_Atl, ohc_Atl, yr)
  cal_ohc(ohc3d, mask_Ind, ohc_Ind, yr)
  cal_ohc(ohc3d, mask_Sou, ohc_Sou, yr)
end do

system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)

f->glo = ohc_glo

f->Pac = ohc_Pac
f->Pac_N = ohc_Pac_N
f->Pac_T = ohc_Pac_T
f->Pac_T_W = ohc_Pac_T_W
f->Pac_T_E = ohc_Pac_T_E
f->Pac_S = ohc_Pac_S

f->Atl = ohc_Atl
f->Ind = ohc_Ind
f->Sou = ohc_Sou

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
