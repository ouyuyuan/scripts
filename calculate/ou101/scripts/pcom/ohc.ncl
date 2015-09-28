
; Description: calculate ocean heat content
;              ohc = rho cp int(T) dz, T in Kelvin
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-12-02 19:17:56 BJT
; Last Change: 2014-12-07 19:57:34 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure write_ohc(f, ohc4d, mymask, varName)
local ohc
begin
  ohc = new(dimsizes(ohc4d&time), float)
  ohc@long_name = "ocean heat content"
  ohc@units = "J"
  ohc!0 = "time"
  ohc&time = ohc4d&time

  print("calculating "+varName+" ~ ~ ~ ~ ~ ~")
  ohc = dim_sum_n(ohc4d*mymask, (/1,2,3/))
  f->$varName$ = ohc
end

procedure ohc_depths(f, ohc4d, zc, mymask, prefix)
begin
write_ohc(f, ohc4d, mymask, prefix)
write_ohc(f, ohc4d, where(zc.le.300, mymask, 0), prefix+"_300")
write_ohc(f, ohc4d, where(zc.le.400, mymask, 0), prefix+"_400")
write_ohc(f, ohc4d, where(zc.le.500, mymask, 0), prefix+"_500")
write_ohc(f, ohc4d, where(zc.le.600, mymask, 0), prefix+"_600")
write_ohc(f, ohc4d, where(zc.le.700, mymask, 0), prefix+"_700")
write_ohc(f, ohc4d, where(zc.le.800, mymask, 0), prefix+"_800")
write_ohc(f, ohc4d, where(zc.le.900, mymask, 0), prefix+"_900")
write_ohc(f, ohc4d, where(zc.le.1000, mymask, 0), prefix+"_1000")
write_ohc(f, ohc4d, where(zc.le.1100, mymask, 0), prefix+"_1100")
write_ohc(f, ohc4d, where(zc.le.1200, mymask, 0), prefix+"_1200")
write_ohc(f, ohc4d, where(zc.le.1300, mymask, 0), prefix+"_1300")
write_ohc(f, ohc4d, where(zc.le.1400, mymask, 0), prefix+"_1400")
write_ohc(f, ohc4d, where(zc.le.1500, mymask, 0), prefix+"_1500")
end

datDir = getenv("NCL_ARG_1")
createOrAppend = getenv("NCL_ARG_4")
if (createOrAppend.eq."create") then
  outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
else
  outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+"_new_years.nc"
end if

rho = 1029 ; kg/m^3, mean density of seawater
cp = 3901 ; c_p, heat capability, J/kg/K

yb = stringtoint(getenv("NCL_ARG_2"))
ye = stringtoint(getenv("NCL_ARG_3"))
ny = ye-yb+1

infile = "/snfs01/ou/data/pcom/grid_info.nc"
nc = addfile(infile, "r")
dv  = nc->dv
idx = nc->idx
ds = nc->ds
delete(nc)
ds = where(idx(0,:,:).eq.1, ds, 0)

infile = "/snfs01/ou/data/pcom/basin.nc"
nc = addfile(infile, "r")
basin = nc->basin
delete(nc)

time = new(ny, integer)
time@long_name = "time"
if (ye.gt.500) then
  time@units = "years since 0000-01-01"
else
  time@units = "years since 0500-01-01"
end if

dims = dimsizes(dv)
ohc4d = new((/ny, dims(0), dims(1), dims(2)/), float)
ohc4d@long_name = "ocean heat content"
ohc4d@units = "J"

do yr = yb, ye
  fname = datDir+"yearly/"+sprinti( "year_%0.4i.nc", yr )
  if (.not.isfilepresent(fname)) then
    fname = datDir+"output/"+sprinti( "year_%0.4i.nc", yr )
  end if
  print("processing "+fname+" ~ ~ ~ ~ ~ ~")

  nc = addfile(fname, "r")
  pt = nc->pt(0,:,:,:)
  ssh = nc->ssh(0,:,:)
  delete(nc)
  time(yr-yb) = yr

  mydv = dv
  mydv(0,:,:) = mydv(0,:,:)+ds*ssh ; account ssh change to the upper volume
  ohc4d(yr-yb,:,:,:) = rho*cp*(pt+273.15)*mydv
end do
ohc4d!0 = "time"
ohc4d&time = time

zc   = conform(ohc4d, dv&z, 1)
latc = conform(ohc4d, dv&lat, 2)
lonc = conform(ohc4d, dv&lon, 3)
bc   = conform(ohc4d, basin, (/2,3/))
idxc = conform(ohc4d, idx, (/1,2,3/))

system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)

mask_glo = where(idxc.eq.1, 1, 0) ; only preserve water grid

mask_Pac = where(bc.eq.2, mask_glo, 0)
mask_Pac_N = where(latc.ge.10, mask_Pac, 0)
mask_Pac_T = where(latc.gt.-10 .and. latc.lt.10, mask_Pac, 0)
mask_Pac_S = where(latc.le.-10, mask_Pac, 0)
mask_Pac_W = where(lonc.le.210, mask_Pac, 0)
mask_Pac_E = where(lonc.gt.210, mask_Pac, 0)

mask_Atl = where(bc.eq.6, mask_glo, 0)
mask_Ind = where(bc.eq.3, mask_glo, 0)
mask_Sou = where(bc.eq.1, mask_glo, 0)

ohc_depths(f, ohc4d, zc, mask_glo, "ohc_glo")

ohc_depths(f, ohc4d, zc, mask_Pac, "ohc_Pac")
ohc_depths(f, ohc4d, zc, mask_Pac_N, "ohc_Pac_N")
ohc_depths(f, ohc4d, zc, mask_Pac_T, "ohc_Pac_T")
ohc_depths(f, ohc4d, zc, mask_Pac_S, "ohc_Pac_S")
ohc_depths(f, ohc4d, zc, mask_Pac_W, "ohc_Pac_W")
ohc_depths(f, ohc4d, zc, mask_Pac_E, "ohc_Pac_E")

ohc_depths(f, ohc4d, zc, mask_Atl, "ohc_Atl")
ohc_depths(f, ohc4d, zc, mask_Ind, "ohc_Ind")
ohc_depths(f, ohc4d, zc, mask_Sou, "ohc_Sou")

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)

if (createOrAppend.eq."append") then
  ohcfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
  oldfile = datDir+"post/"+getenv("NCL_ARG_0_base")+"_old.nc"
  system("mv -f "+ohcfile+" "+oldfile)
  system("cdo mergetime "+oldfile+" "+outfile+" "+ohcfile)
end if
