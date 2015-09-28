
; Description: calculate area average SST for varies basins/regions
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-12-02 19:17:56 BJT
; Last Change: 2014-12-14 16:52:39 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir = getenv("NCL_ARG_1")
yb = stringtoint(getenv("NCL_ARG_2"))
ye = stringtoint(getenv("NCL_ARG_3"))

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

procedure cal_sst(sst_glo, basin_ds, basin_sst, year)
local area, wgt
begin
  area = sum(basin_ds)
  wgt = basin_ds/area
  basin_sst({year}) = sum(sst_glo*wgt)
end

outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
grid_info_file = datDir+"post/grid_info.nc"
basin_file = datDir+"post/basin.nc"
basin_file = datDir+"post/basin.nc"
if isStrSubset(datDir,"pcom") .and. .not. isStrSubset(datDir,"pcom_grid") then
  grid_info_file = datDir+"../grid_info.nc"
  basin_file = datDir+"../basin.nc"
end if

ny = ye-yb+1

f = addfile(grid_info_file, "r")
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

; basin masks
mask_glo = idx(0,:,:) ; only preserve water grid
;{{{
sst_glo = new(ny, float)
sst_glo@units = "degC"
sst_glo@long_name = "sea surface temperature"
sst_glo!0 = "time"
sst_glo&time = time
sst_glo = 0

mask_Pac = where(basin.eq.2, mask_glo, 0)
sst_Pac = sst_glo

mask_Pac_N = where(latc.ge.20, mask_Pac, 0)
sst_Pac_N = sst_glo

mask_Pac_T = where(latc.gt.-20 .and. latc.lt.20, mask_Pac, 0)
sst_Pac_T = sst_glo
mask_Pac_T_W = where(lonc.le.210, mask_Pac_T, 0)
sst_Pac_T_W = sst_glo
mask_Pac_T_E = where(lonc.gt.210, mask_Pac_T, 0)
sst_Pac_T_E = sst_glo

mask_Pac_S = where(latc.le.-20, mask_Pac, 0)
sst_Pac_S = sst_glo

mask_nino12 = where(latc.gt.-10 .and. latc.lt.0 \
              .and. lonc.gt.(360-90) .and. lonc.lt.(360-80), mask_Pac, 0)
sst_nino12  = sst_glo
mask_nino3 = where(latc.gt.-5 .and. latc.lt.5 \
              .and. lonc.gt.(360-150) .and. lonc.lt.(360-90), mask_Pac, 0)
sst_nino3  = sst_glo
mask_nino34 = where(latc.gt.-5 .and. latc.lt.5 \
              .and. lonc.gt.(360-170) .and. lonc.lt.(360-120), mask_Pac, 0)
sst_nino34  = sst_glo
mask_nino4 = where(latc.gt.-5 .and. latc.lt.5 \
              .and. lonc.gt.160 .and. lonc.lt.(360-150), mask_Pac, 0)
sst_nino4  = sst_glo

mask_Atl = where(basin.eq.6, mask_glo, 0)
sst_Atl = sst_glo
mask_Ind = where(basin.eq.3, mask_glo, 0)
sst_Ind = sst_glo
mask_Sou = where(basin.eq.1, mask_glo, 0)
sst_Sou = sst_glo
;}}}

do yr = yb, ye
  fname = datDir+"yearly/"+sprinti( "temp.%0.4i.nc", yr )
  tempName = "wtmp"
  if isStrSubset(datDir,"pcom") .and. .not. isStrSubset(datDir,"pcom_grid") then
    fname = datDir+"yearly/"+sprinti( "year_%0.4i.nc", yr )
    tempName = "pt"
  end if
  if isStrSubset(datDir,"soda") then
    fname = datDir+"yearly/"+sprinti( "year_%0.4i.nc", yr )
    tempName = "temp"
  end if
  print("processing "+fname+" ~ ~ ~ ~ ~ ~")

  f = addfile(fname, "r")
  if isStrSubset(datDir,"soda") then
    temp = f->$tempName$(0,:,:)
  else
    temp = f->$tempName$(0,0,:,:)
  end if
  delete(f)
  cal_sst(temp, ds*mask_glo, sst_glo, yr)

  cal_sst(temp, ds*mask_Pac, sst_Pac, yr)
  cal_sst(temp, ds*mask_Pac_N, sst_Pac_N, yr)
  cal_sst(temp, ds*mask_Pac_T, sst_Pac_T, yr)
  cal_sst(temp, ds*mask_Pac_T_W, sst_Pac_T_W, yr)
  cal_sst(temp, ds*mask_Pac_T_E, sst_Pac_T_E, yr)
  cal_sst(temp, ds*mask_Pac_S, sst_Pac_S, yr)

  cal_sst(temp, ds*mask_nino12, sst_nino12, yr)
  cal_sst(temp, ds*mask_nino3, sst_nino3, yr)
  cal_sst(temp, ds*mask_nino34, sst_nino34, yr)
  cal_sst(temp, ds*mask_nino4, sst_nino4, yr)

  cal_sst(temp, ds*mask_Atl, sst_Atl, yr)
  cal_sst(temp, ds*mask_Ind, sst_Ind, yr)
  cal_sst(temp, ds*mask_Sou, sst_Sou, yr)
end do

system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)

f->glo = sst_glo

f->Pac = sst_Pac
f->Pac_S = sst_Pac_S
f->Pac_T = sst_Pac_T
f->Pac_T_W = sst_Pac_T_W
f->Pac_T_E = sst_Pac_T_E
f->Pac_N = sst_Pac_N

f->nino12 = sst_nino12
f->nino3 = sst_nino3
f->nino34 = sst_nino34
f->nino4 = sst_nino4

f->Atl = sst_Atl
f->Ind = sst_Ind
f->Sou = sst_Sou

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
