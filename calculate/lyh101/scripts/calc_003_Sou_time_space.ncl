
; Description: time and space structure of Southern Ocean
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-12-16 10:12:55 BJT
; Last Change: 2014-12-17 10:27:01 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir = getenv("NCL_ARG_1")
yb = stringtoint(getenv("NCL_ARG_2"))
ye = stringtoint(getenv("NCL_ARG_3"))
createOrMerge = getenv("NCL_ARG_4")
rho = 1029 ; kg/m^3, mean density of seawater
cp = 3901 ; c_p, heat capability, J/kg/K
latBnd = -35 ; where ACC dominates
ny = ye-yb+1

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

f = addfile(grid_info_file, "r")
dv  = f->dv
idx = f->idx
ds = f->ds
dx = f->dx
delete(f)
ds = where(idx(0,:,:).eq.1, ds, 0)

time = ispan(yb,ye,1)
time@long_name = "time"
if (ye.gt.500) then
  time@units = "years since 0000-01-01"
else
  time@units = "years since 0500-01-01"
end if

latc = conform(ds, ds&lat, 0)
lonc = conform(ds, ds&lon, 1)
z = dv&$dv!0$
lat = dv&$dv!1$
lon = dv&$dv!2$
dims = dimsizes(dv)
nz = dims(0)
nlat = dims(1)
nlon = dims(2)

; basin masks, containers
mask_Sou = where(latc.le.latBnd, idx(0,:,:), 0)
;{{{
maskc = conform(dv, mask_Sou, (/1,2/))
basin_dx = where(mask_Sou.eq.1, dx, 0)
sumdx = dim_sum_n(basin_dx, 0)
dx_wgt = basin_dx/conform(basin_dx, sumdx, 1)

sst_lon = new((/ny,nlon/), float)
sst_lon@units = "degC"
sst_lon@long_name = "zonal average SST"
sst_lon!0 = "time"
sst_lon!1 = "lon"
sst_lon&time = time
sst_lon&lon = lon

ohc_lon = new((/ny,nz,nlon/), float)
ohc_lon@units = "degC"
ohc_lon@long_name = "volume integrated OHC"
ohc_lon!0 = "time"
ohc_lon&time = time
ohc_lon!1 = "z"
ohc_lon&z = z
ohc_lon!2 = "lon"
ohc_lon&lon = lon
;}}}

; cal. basin area for each vertical level
function cal_basin_area(basin_mask)
local area, dsc, mc
begin
area = z
area!0 = "z"
area&z = z
area@units = "m^2"
area@long_name = "level area of water"
dsc = conform(dv, ds, (/1,2/))
mc = conform(dv, basin_mask, (/1,2/))
area = dim_sum_n(idx*dsc*mc, (/1,2/))
return area
end

; calculation for all basin per yeaer
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
  ohc3d = dv
  mydv = dv
  if isPcom
    mydv(0,:,:) = mydv(0,:,:)+ds*ssh ; account ssh change to the upper volume
  end if
  ohc3d = rho*cp*(temp+273.15)*mydv

  ohc_lon({yr},:,:) = dim_sum_n(ohc3d*maskc, 1)
  sst_lon({yr},:) = dim_sum_n(temp(0,:,:)*dx_wgt, 0)
end do
;}}}

system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)

procedure write_data(name, basin_mask, ohc)
local ohcName
begin
f->$name$ = ohc
areaName = name+"_area"
f->$areaName$ = cal_basin_area(basin_mask)
end

f->ohc_lon = ohc_lon
f->sst_lon = sst_lon
f->area = cal_basin_area(mask_Sou)

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)

if (.not. ismissing(createOrMerge) .and. createOrMerge.eq."merge") then
  ohcfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
  oldfile = datDir+"post/"+getenv("NCL_ARG_0_base")+"_old.nc"
  system("mv -f "+ohcfile+" "+oldfile)
  system("cdo mergetime "+oldfile+" "+outfile+" "+ohcfile)
end if
