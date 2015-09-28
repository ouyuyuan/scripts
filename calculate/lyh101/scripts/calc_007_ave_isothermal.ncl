
; Description: calculate time-depth diagram for isothermal lines
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-13 10:23:27 BJT
; Last Change: 2015-01-15 10:25:13 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir = getenv("NCL_ARG_1")

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

procedure cal_ave(depth, basin_mask, basin_depth, ds, year)
; calc. horizontal average depth
;{{{
local dsC, wgt
begin
  bsC = conform(depth, basin_mask, (/1,2/))
  dsC = conform(depth, ds, (/1,2/))
  wgt = dsC*bsC
  wgt = where(ismissing(depth), 0, wgt)
  wgtSum = dim_sum_n(wgt, (/1,2/)) ; area weighted averged for each iso
  wgtSumC = conform(wgt, wgtSum, 0)
  wgtSumC@_FillValue = default_fillvalue(typeof(wgtSumC))
  wgtSumC = where(wgtSumC.eq.0, wgtSumC@_FillValue, wgtSumC)
  wgt = wgt/wgtSumC
  delete(wgtSum)
  delete(wgtSumC)
  basin_depth({year},:) = dim_sum_n(depth*wgt, (/1,2/))
end
;}}}

outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
grid_info_file = datDir+"post/grid_info.nc"
basin_file = datDir+"post/basin.nc"
if isPcom
  grid_info_file = datDir+"../grid_info.nc"
  basin_file = datDir+"../basin.nc"
end if

f = addfile(grid_info_file, "r")
idx = f->idx
ds = f->ds
delete(f)
ds = where(idx(0,:,:).eq.1, ds, 0)

f = addfile(basin_file, "r")
basin = f->basin
delete(f)
latc = conform(basin, basin&lat, 0)
lonc = conform(basin, basin&lon, 1)

f = addfile(datDir+"post/calc_006_isothermal_depth.nc", "r")
time = f->time
tlev = f->tlev
isot = f->isot(0,:,:,:)

nlev = dimsizes(tlev)
nt = dimsizes(time)
yb = time(0)
ye = time(nt-1)
;ye = 503
ny = nt

; basin masks
mask_glo = idx(0,:,:) ; only preserve water grid
;{{{
depth_glo = new((/ny,nlev/), float)
depth_glo@units = isot@units
depth_glo@long_name = isot@long_name
depth_glo!0 = "time"
depth_glo!1 = "tlev"
depth_glo&time = time
depth_glo&tlev = tlev
depth_glo = 0

mask_Pac = where(basin.eq.2, mask_glo, 0)
depth_Pac = depth_glo

mask_Pac_N = where(latc.ge.20, mask_Pac, 0)
depth_Pac_N = depth_glo

mask_Pac_T = where(latc.gt.-20 .and. latc.lt.20, mask_Pac, 0)
depth_Pac_T = depth_glo
mask_Pac_T_W = where(lonc.le.210, mask_Pac_T, 0)
depth_Pac_T_W = depth_glo
mask_Pac_T_E = where(lonc.gt.210, mask_Pac_T, 0)
depth_Pac_T_E = depth_glo

mask_nino12 = where(latc.gt.-10 .and. latc.lt.0 \
              .and. lonc.gt.(360-90) .and. lonc.lt.(360-80), mask_Pac, 0)
depth_nino12  = depth_glo
mask_nino3 = where(latc.gt.-5 .and. latc.lt.5 \
              .and. lonc.gt.(360-150) .and. lonc.lt.(360-90), mask_Pac, 0)
depth_nino3  = depth_glo
mask_nino34 = where(latc.gt.-5 .and. latc.lt.5 \
              .and. lonc.gt.(360-170) .and. lonc.lt.(360-120), mask_Pac, 0)
depth_nino34  = depth_glo
mask_nino4 = where(latc.gt.-5 .and. latc.lt.5 \
              .and. lonc.gt.160 .and. lonc.lt.(360-150), mask_Pac, 0)
depth_nino4  = depth_glo

mask_Pac_S = where(latc.le.-20, mask_Pac, 0)
depth_Pac_S = depth_glo

mask_Atl = where(basin.eq.6, mask_glo, 0)
depth_Atl = depth_glo
mask_Ind = where(basin.eq.3, mask_glo, 0)
depth_Ind = depth_glo
mask_Sou = where(basin.eq.1, mask_glo, 0)
depth_Sou = depth_glo
;}}}

; cal. ave depth for desired basins per yeaer
do yr = yb, ye
  ;{{{
  print("processing year of "+yr+" ~ ~ ~ ~ ~ ~")

  depth = f->isot({yr},:,:,:)
  cal_ave(depth, mask_glo, depth_glo, ds, yr)

  cal_ave(depth, mask_Pac, depth_Pac, ds, yr)
  cal_ave(depth, mask_Pac_S, depth_Pac_S, ds, yr)
  cal_ave(depth, mask_Pac_T, depth_Pac_T, ds, yr)
  cal_ave(depth, mask_Pac_T_W, depth_Pac_T_W, ds, yr)
  cal_ave(depth, mask_Pac_T_E, depth_Pac_T_E, ds, yr)
  cal_ave(depth, mask_Pac_N, depth_Pac_N, ds, yr)

  cal_ave(depth, mask_nino12, depth_nino12, ds, yr)
  cal_ave(depth, mask_nino3, depth_nino3, ds, yr)
  cal_ave(depth, mask_nino34, depth_nino34, ds, yr)
  cal_ave(depth, mask_nino4, depth_nino4, ds, yr)

  cal_ave(depth, mask_Atl, depth_Atl, ds, yr)
  cal_ave(depth, mask_Ind, depth_Ind, ds, yr)
  cal_ave(depth, mask_Sou, depth_Sou, ds, yr)
end do
;}}}

system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)

procedure write_data(name, basin_mask, depth)
begin
f->$name$ = depth
end

write_data("glo", mask_glo, depth_glo)

write_data("Pac", mask_Pac, depth_Pac)
write_data("Pac_N", mask_Pac_N, depth_Pac_N)
write_data("Pac_T", mask_Pac_T, depth_Pac_T)
write_data("Pac_T_W", mask_Pac_T_W, depth_Pac_T_W)
write_data("Pac_T_E", mask_Pac_T_E, depth_Pac_T_E)
write_data("Pac_S", mask_Pac_S, depth_Pac_S)

write_data("nino12", mask_nino12, depth_nino12)
write_data("nino3", mask_nino3, depth_nino3)
write_data("nino34", mask_nino34, depth_nino34)
write_data("nino4", mask_nino4, depth_nino4)

write_data("Atl", mask_Atl, depth_Atl)
write_data("Ind", mask_Ind, depth_Ind)
write_data("Sou", mask_Sou, depth_Sou)

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
