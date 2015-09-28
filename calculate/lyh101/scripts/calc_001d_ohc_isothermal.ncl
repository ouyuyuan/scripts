
; Description: calculate volume integrated ocean heat content above each isothermal lines
;              ohc = rho cp int(T) dz, T in Kelvin
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-17 10:27:10 BJT
; Last Change: 2015-01-17 17:14:39 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir = getenv("NCL_ARG_1")
yb = stringtoint(getenv("NCL_ARG_2"))
ye = stringtoint(getenv("NCL_ARG_3"))
createOrMerge = getenv("NCL_ARG_4")

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

outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
if (.not. ismissing(createOrMerge) .and. createOrMerge.eq."merge") then
  outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+"_new_years.nc"
end if
grid_info_file = datDir+"post/grid_info.nc"
basin_file = datDir+"post/basin.nc"
if isPcom
  grid_info_file = datDir+"../grid_info.nc"
  basin_file = datDir+"../basin.nc"
end if

rho = 1029 ; kg/m^3, mean density of seawater
cp = 3901 ; c_p, heat capability, J/kg/K

procedure cal_ohc(temp, basin_mask, basin_ohc, basin_vol, mydv, year)
;{{{
local bc, basin_dv, bc, temp_dv, tlev, ntlev
begin
  basin_dv = mydv
  bc = conform(mydv, basin_mask, (/1,2/))
  basin_dv = bc*basin_dv
  basin_dv = where(ismissing(temp), 0, basin_dv)
  tlev = basin_ohc&$basin_ohc!1$
  ntlev = dimsizes(tlev)
  do i = 0, ntlev - 1
    temp_dv = where(temp.ge.tlev(i), basin_dv, 0)
    basin_vol({year},i) = sum(temp_dv)
    basin_ohc({year},i) = sum(rho*cp*(temp+273.15)*temp_dv)
  end do
end
;}}}

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

tlev = ispan(0,28,1)
tlev = tlev(::-1)
tlev@long_name = "temperature"
tlev@units = "Celcius degree"
ntlev = dimsizes(tlev)

latc = conform(basin, basin&lat, 0)
lonc = conform(basin, basin&lon, 1)
z = dv&$dv!0$
nz = dimsizes(z)

; basin masks
mask_glo = idx(0,:,:) ; only preserve water grid
;{{{
ohc_glo = new((/ny,ntlev/), float)
ohc_glo@units = "J"
ohc_glo@long_name = "Ocean heat content"
ohc_glo!0 = "time"
ohc_glo!1 = "tlev"
ohc_glo&time = time
ohc_glo&tlev = tlev
ohc_glo = 0

vol_glo = ohc_glo
vol_glo@units = "m^3"
vol_glo@long_name = "water volmume"

mask_Pac = where(basin.eq.2, mask_glo, 0)
ohc_Pac = ohc_glo
vol_Pac = vol_glo

mask_Pac_N = where(latc.ge.20, mask_Pac, 0)
ohc_Pac_N = ohc_glo
vol_Pac_N = vol_glo

mask_Pac_T = where(latc.gt.-20 .and. latc.lt.20, mask_Pac, 0)
ohc_Pac_T = ohc_glo
vol_Pac_T = vol_glo
mask_Pac_T_W = where(lonc.le.210, mask_Pac_T, 0)
ohc_Pac_T_W = ohc_glo
vol_Pac_T_W = vol_glo
mask_Pac_T_E = where(lonc.gt.210, mask_Pac_T, 0)
ohc_Pac_T_E = ohc_glo
vol_Pac_T_E = vol_glo

mask_nino12 = where(latc.gt.-10 .and. latc.lt.0 \
              .and. lonc.gt.(360-90) .and. lonc.lt.(360-80), mask_Pac, 0)
ohc_nino12  = ohc_glo
vol_nino12  = vol_glo
mask_nino3 = where(latc.gt.-5 .and. latc.lt.5 \
              .and. lonc.gt.(360-150) .and. lonc.lt.(360-90), mask_Pac, 0)
ohc_nino3  = ohc_glo
vol_nino3  = vol_glo
mask_nino34 = where(latc.gt.-5 .and. latc.lt.5 \
              .and. lonc.gt.(360-170) .and. lonc.lt.(360-120), mask_Pac, 0)
ohc_nino34  = ohc_glo
vol_nino34  = vol_glo
mask_nino4 = where(latc.gt.-5 .and. latc.lt.5 \
              .and. lonc.gt.160 .and. lonc.lt.(360-150), mask_Pac, 0)
ohc_nino4  = ohc_glo
vol_nino4  = vol_glo

mask_Pac_S = where(latc.le.-20, mask_Pac, 0)
ohc_Pac_S = ohc_glo
vol_Pac_S = vol_glo

mask_Atl = where(basin.eq.6, mask_glo, 0)
ohc_Atl = ohc_glo
vol_Atl = vol_glo
mask_Ind = where(basin.eq.3, mask_glo, 0)
ohc_Ind = ohc_glo
vol_Ind = vol_glo
mask_Sou = where(basin.eq.1, mask_glo, 0)
ohc_Sou = ohc_glo
vol_Sou = vol_glo
;}}}

; cal. ohc for all basin per yeaer
do yr = yb, ye
  ;{{{
  fname = datDir+"yearly/"+sprinti( "temp.%0.4i.nc", yr )
  tempName = "wtmp"
  if isPcom
    fname = datDir+"yearly/"+sprinti( "year_%0.4i.nc", yr )
    tempName = "pt"
  end if
  if isSoda
    fname = datDir+"yearly/"+sprinti( "year_%0.4i.nc", yr )
    tempName = "temp"
  end if
  print("processing "+fname+" ~ ~ ~ ~ ~ ~")

  f = addfile(fname, "r")
  if isSoda
    temp = f->$tempName$(:,:,:)
  else
    temp = f->$tempName$(0,:,:,:)
  end if
  if isPcom
    ssh = f->ssh(0,:,:)
  end if
  delete(f)
  mydv = dv
  if isPcom
    mydv(0,:,:) = dv(0,:,:)+ds*ssh ; account ssh change to the upper volume
  end if
;  cal_ohc(temp, mask_glo, ohc_glo, vol_glo, mydv, yr)

;  cal_ohc(temp, mask_Pac, ohc_Pac, vol_Pac, mydv, yr)
;  cal_ohc(temp, mask_Pac_S, ohc_Pac_S, vol_Pac_S, mydv, yr)
  cal_ohc(temp, mask_Pac_T, ohc_Pac_T, vol_Pac_T, mydv, yr)
;  cal_ohc(temp, mask_Pac_T_W, ohc_Pac_T_W, vol_Pac_T_W, mydv, yr)
;  cal_ohc(temp, mask_Pac_T_E, ohc_Pac_T_E, vol_Pac_T_E, mydv, yr)
;  cal_ohc(temp, mask_Pac_N, ohc_Pac_N, vol_Pac_N, mydv, yr)

;  cal_ohc(temp, mask_nino12, ohc_nino12, vol_nino12, mydv, yr)
;  cal_ohc(temp, mask_nino3, ohc_nino3, vol_nino3, mydv, yr)
  cal_ohc(temp, mask_nino34, ohc_nino34, vol_nino34, mydv, yr)
;  cal_ohc(temp, mask_nino4, ohc_nino4, vol_nino4, mydv, yr)

;  cal_ohc(temp, mask_Atl, ohc_Atl, vol_Atl, mydv, yr)
;  cal_ohc(temp, mask_Ind, ohc_Ind, vol_Ind, mydv, yr)
;  cal_ohc(temp, mask_Sou, ohc_Sou, vol_Sou, mydv, yr)
end do
;}}}

system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)

procedure write_data(name, basin_mask, ohc, vol)
local ohcName
begin
ohcName = "ohc_"+name
volName = "vol_"+name
f->$ohcName$ = ohc
f->$volName$ = vol
end

;write_data("glo", mask_glo, ohc_glo, vol_glo)

;write_data("Pac", mask_Pac, ohc_Pac, vol_Pac)
;write_data("Pac_N", mask_Pac_N, ohc_Pac_N, vol_Pac_N)
write_data("Pac_T", mask_Pac_T, ohc_Pac_T, vol_Pac_T)
;write_data("Pac_T_W", mask_Pac_T_W, ohc_Pac_T_W, vol_Pac_T_W)
;write_data("Pac_T_E", mask_Pac_T_E, ohc_Pac_T_E, vol_Pac_T_E)
;write_data("Pac_S", mask_Pac_S, ohc_Pac_S, vol_Pac_S)

;write_data("nino12", mask_nino12, ohc_nino12, vol_nino12)
;write_data("nino3", mask_nino3, ohc_nino3, vol_nino3)
write_data("nino34", mask_nino34, ohc_nino34, vol_nino34)
;write_data("nino4", mask_nino4, ohc_nino4, vol_nino4)

;write_data("Atl", mask_Atl, ohc_Atl, vol_Atl)
;write_data("Ind", mask_Ind, ohc_Ind, vol_Ind)
;write_data("Sou", mask_Sou, ohc_Sou, vol_Sou)

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)

if (.not. ismissing(createOrMerge) .and. createOrMerge.eq."merge") then
  ohcfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
  oldfile = datDir+"post/"+getenv("NCL_ARG_0_base")+"_old.nc"
  system("mv -f "+ohcfile+" "+oldfile)
  system("cdo mergetime "+oldfile+" "+outfile+" "+ohcfile)
end if
