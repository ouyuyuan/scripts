
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

; ref ~/archive/scripts/draw/sketch/boxes.ncl
dlat = 5
dlon = 5
latBoxC = 35
lonBoxC = 147
mask_box1 = where(latc.ge.(latBoxC-dlat) .and. latc.le.(latBoxC+dlat) \
              .and. lonc.ge.(lonBoxC-dlon) .and. lonc.le.(lonBoxC+dlon), mask_glo, 0)
sst_box1 = sst_glo
latBoxC = -5
lonBoxC = 360-85
mask_box2 = where(latc.ge.(latBoxC-dlat) .and. latc.le.(latBoxC+dlat) \
              .and. lonc.ge.(lonBoxC-dlon) .and. lonc.le.(lonBoxC+dlon), mask_glo, 0)
sst_box2 = sst_glo
latBoxC = -60
lonBoxC = 360-50
mask_box3 = where(latc.ge.(latBoxC-dlat) .and. latc.le.(latBoxC+dlat) \
              .and. lonc.ge.(lonBoxC-dlon) .and. lonc.le.(lonBoxC+dlon), mask_glo, 0)
sst_box3 = sst_glo
latBoxC = -5
lonBoxC = 5
mask_box4 = where(latc.ge.(latBoxC-dlat) .and. latc.le.(latBoxC+dlat) \
              .and. lonc.ge.(lonBoxC-dlon) .and. lonc.le.(lonBoxC+dlon), mask_glo, 0)
sst_box4 = sst_glo
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

  cal_sst(temp, ds*mask_box1, sst_box1, yr)
  cal_sst(temp, ds*mask_box2, sst_box2, yr)
  cal_sst(temp, ds*mask_box3, sst_box3, yr)
  cal_sst(temp, ds*mask_box4, sst_box4, yr)
end do

system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)

f->box1 = sst_box1
f->box2 = sst_box2
f->box3 = sst_box3
f->box4 = sst_box4

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
