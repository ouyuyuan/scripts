
; Description: calculate tempature time-depth diagram, in different basins
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-13 10:23:27 BJT
; Last Change: 2015-01-13 17:26:03 BJT

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

procedure cal_temp(temp, basin_mask, basin_temp, dv, year)
;{{{
local bc, wgt
begin
  bc = conform(temp, basin_mask, (/1,2/))
  wgt = bc*dv
  wgt = where(ismissing(temp), 0, wgt)
  wgtSum = dim_sum_n(wgt, (/1,2/)) ; volume weighted averged for each layer
  wgtSumC = conform(wgt, wgtSum, 0)
  wgt = wgt/wgtSumC
  delete(wgtSum)
  delete(wgtSumC)
  basin_temp({year},:) = dim_sum_n(temp*wgt, (/1,2/))
end
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
temp_glo = new((/ny,nz/), float)
temp_glo@units = "degC"
temp_glo@long_name = "potential temperature"
temp_glo!0 = "time"
temp_glo!1 = "z"
temp_glo&time = time
temp_glo&z = z
temp_glo = 0

mask_Pac = where(basin.eq.2, mask_glo, 0)
temp_Pac = temp_glo

mask_Pac_N = where(latc.ge.20, mask_Pac, 0)
temp_Pac_N = temp_glo

mask_Pac_T = where(latc.gt.-20 .and. latc.lt.20, mask_Pac, 0)
temp_Pac_T = temp_glo
mask_Pac_T_W = where(lonc.le.210, mask_Pac_T, 0)
temp_Pac_T_W = temp_glo
mask_Pac_T_E = where(lonc.gt.210, mask_Pac_T, 0)
temp_Pac_T_E = temp_glo

mask_nino12 = where(latc.gt.-10 .and. latc.lt.0 \
              .and. lonc.gt.(360-90) .and. lonc.lt.(360-80), mask_Pac, 0)
temp_nino12  = temp_glo
mask_nino3 = where(latc.gt.-5 .and. latc.lt.5 \
              .and. lonc.gt.(360-150) .and. lonc.lt.(360-90), mask_Pac, 0)
temp_nino3  = temp_glo
mask_nino34 = where(latc.gt.-5 .and. latc.lt.5 \
              .and. lonc.gt.(360-170) .and. lonc.lt.(360-120), mask_Pac, 0)
temp_nino34  = temp_glo
mask_nino4 = where(latc.gt.-5 .and. latc.lt.5 \
              .and. lonc.gt.160 .and. lonc.lt.(360-150), mask_Pac, 0)
temp_nino4  = temp_glo

mask_Pac_S = where(latc.le.-20, mask_Pac, 0)
temp_Pac_S = temp_glo

mask_Atl = where(basin.eq.6, mask_glo, 0)
temp_Atl = temp_glo
mask_Ind = where(basin.eq.3, mask_glo, 0)
temp_Ind = temp_glo
mask_Sou = where(basin.eq.1, mask_glo, 0)
temp_Sou = temp_glo
;}}}

; cal. temp for desired basins per yeaer
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
    mydv(0,:,:) = mydv(0,:,:)+ds*ssh ; account ssh change to the upper volume
  end if
  cal_temp(temp, mask_glo, temp_glo, mydv, yr)

  cal_temp(temp, mask_Pac, temp_Pac, mydv, yr)
  cal_temp(temp, mask_Pac_S, temp_Pac_S, mydv, yr)
  cal_temp(temp, mask_Pac_T, temp_Pac_T, mydv, yr)
  cal_temp(temp, mask_Pac_T_W, temp_Pac_T_W, mydv, yr)
  cal_temp(temp, mask_Pac_T_E, temp_Pac_T_E, mydv, yr)
  cal_temp(temp, mask_Pac_N, temp_Pac_N, mydv, yr)

  cal_temp(temp, mask_nino12, temp_nino12, mydv, yr)
  cal_temp(temp, mask_nino3, temp_nino3, mydv, yr)
  cal_temp(temp, mask_nino34, temp_nino34, mydv, yr)
  cal_temp(temp, mask_nino4, temp_nino4, mydv, yr)

  cal_temp(temp, mask_Atl, temp_Atl, mydv, yr)
  cal_temp(temp, mask_Ind, temp_Ind, mydv, yr)
  cal_temp(temp, mask_Sou, temp_Sou, mydv, yr)
end do
;}}}

system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)

procedure write_data(name, basin_mask, temp_zt)
begin
f->$name$ = temp_zt
end

write_data("glo", mask_glo, temp_glo)

write_data("Pac", mask_Pac, temp_Pac)
write_data("Pac_N", mask_Pac_N, temp_Pac_N)
write_data("Pac_T", mask_Pac_T, temp_Pac_T)
write_data("Pac_T_W", mask_Pac_T_W, temp_Pac_T_W)
write_data("Pac_T_E", mask_Pac_T_E, temp_Pac_T_E)
write_data("Pac_S", mask_Pac_S, temp_Pac_S)

write_data("nino12", mask_nino12, temp_nino12)
write_data("nino3", mask_nino3, temp_nino3)
write_data("nino34", mask_nino34, temp_nino34)
write_data("nino4", mask_nino4, temp_nino4)

write_data("Atl", mask_Atl, temp_Atl)
write_data("Ind", mask_Ind, temp_Ind)
write_data("Sou", mask_Sou, temp_Sou)

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)

if (.not. ismissing(createOrMerge) .and. createOrMerge.eq."merge") then
  ohcfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
  oldfile = datDir+"post/"+getenv("NCL_ARG_0_base")+"_old.nc"
  system("mv -f "+ohcfile+" "+oldfile)
  system("cdo mergetime "+oldfile+" "+outfile+" "+ohcfile)
end if
