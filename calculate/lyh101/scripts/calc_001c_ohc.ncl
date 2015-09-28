
; Description: calculate ocean heat content in each grid volume
;              not sum up in horizontal as calc_001_ohc.ncl does
;              ohc = rho cp int(T) dz, T in Kelvin
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-12-30 10:52:29 BJT
; Last Change: 2015-01-16 20:36:33 BJT

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
if isPcom
  grid_info_file = datDir+"../grid_info.nc"
end if

rho = 1029 ; kg/m^3, mean density of seawater
cp = 3901 ; c_p, heat capability, J/kg/K

ny = ye-yb+1
f = addfile(grid_info_file, "r")
dv  = f->dv
idx = f->idx
ds = f->ds
delete(f)
ds = where(idx(0,:,:).eq.1, ds, 0)

time = ispan(yb,ye,1)
time@long_name = "time"
if (ye.gt.500) then
  time@units = "years since 0000-01-01"
else
  time@units = "years since 0500-01-01"
end if

; cal. ohc for all basin per yeaer
do yr = yb, ye
  ;{{{
  fname = datDir+"yearly/"+sprinti( "temp.%0.4i.nc", yr )
  temName = "wtmp"
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

  if yr.eq.yb
    dims = dimsizes(temp)
    z = temp&$temp!0$
    lat = temp&$temp!1$
    lon = temp&$temp!2$

    ohc = new((/ny,dims(0),dims(1),dims(2)/), float)
    ohc@units = "J"
    ohc@long_name = "Ocean heat content"
    ohc!0 = "time"
    ohc&time = time
    ohc!1 = "z"
    ohc&z = z
    ohc!2 = "lat"
    ohc&lat = lat
    ohc!3 = "lon"
    ohc&lon = lon
    ohc = 0
  end if

  ohc3d = dv
  mydv = dv
  if isPcom
    mydv(0,:,:) = mydv(0,:,:)+ds*ssh ; account ssh change to the upper volume
  end if
  ohc(yr-yb,:,:,:) = rho*cp*(temp+273.15)*mydv
end do
;}}}

system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)

f->ohc = ohc

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)

if (.not. ismissing(createOrMerge) .and. createOrMerge.eq."merge") then
  ohcfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
  oldfile = datDir+"post/"+getenv("NCL_ARG_0_base")+"_old.nc"
  system("mv -f "+ohcfile+" "+oldfile)
  system("cdo mergetime "+oldfile+" "+outfile+" "+ohcfile)
end if
