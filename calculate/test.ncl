
; Description: calculate yearly basin average sst
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-12-02 19:17:56 BJT
; Last Change: 2014-12-08 08:03:28 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure write_sst(f, sst_glo, myds, varName)
local sst
begin
  sst = new(dimsizes(sst_glo&time), float)
  copy_VarAtts(sst_glo, sst)
  sst!0 = "time"
  sst&time = sst_glo&time

  print("calculating "+varName+" ~ ~ ~ ~ ~ ~")
  area = sum(myds)
  dsc = conform(sst_glo, myds, (/1,2/))
  wgt = dsc/area
  sst = dim_sum_n(sst_glo*wgt, (/1,2/))
  f->$varName$ = sst
end

datDir = getenv("NCL_ARG_1")
createOrAppend = getenv("NCL_ARG_4")
if (createOrAppend.eq."create") then
  outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
else
  outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+"_new_years.nc"
end if

yb = stringtoint(getenv("NCL_ARG_2"))
ye = stringtoint(getenv("NCL_ARG_3"))
ny = ye-yb+1

infile = "/snfs01/ou/data/pcom/grid_info.nc"
nc = addfile(infile, "r")
idx = nc->idx
ds = nc->ds
delete(nc)
ds_glo = where(idx(0,:,:).eq.1, ds, 0)

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

dims = dimsizes(ds)
sst_glo = new((/ny, dims(0), dims(1)/), float)
sst_glo@long_name = "Sea Surface Temperature"
sst_glo@units = "degC"

do yr = yb, ye
  fname = datDir+"yearly/"+sprinti( "year_%0.4i.nc", yr )
  print("processing "+fname+" ~ ~ ~ ~ ~ ~")

  nc = addfile(fname, "r")
  pt = nc->pt(0,0,:,:)
  delete(nc)
  time(yr-yb) = yr

  sst_glo(yr-yb,:,:) = pt
end do
sst_glo!0 = "time"
sst_glo&time = time

latc = conform(ds, ds&lat, 0)
lonc = conform(ds, ds&lon, 1)
idxc = idx(0,:,:)
bc = basin

system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)

ds_glo = where(idxc.eq.1, 1, 0) ; only preserve water grid
ds_Pac = where(bc.eq.2, ds_glo, 0)
ds_Pac_N = where(latc.ge.10, ds_Pac, 0)
ds_Pac_T = where(latc.gt.-10 .and. latc.lt.10, ds_Pac, 0)
ds_Pac_S = where(latc.le.-10, ds_Pac, 0)
ds_Pac_W = where(lonc.le.210, ds_Pac, 0)
ds_Pac_E = where(lonc.gt.210, ds_Pac, 0)
ds_Pac_T_W = where(lonc.le.210, ds_Pac_T, 0)
ds_Pac_T_E = where(lonc.gt.210, ds_Pac_T, 0)
ds_Atl = where(bc.eq.6, ds_glo, 0)
ds_Ind = where(bc.eq.3, ds_glo, 0)
ds_Sou = where(bc.eq.1, ds_glo, 0)

write_sst(f, sst_glo, ds_glo, "sst_glo")

write_sst(f, sst_glo, ds_Pac, "sst_Pac")
write_sst(f, sst_glo, ds_Pac_N, "sst_Pac_N")
write_sst(f, sst_glo, ds_Pac_T, "sst_Pac_T")
write_sst(f, sst_glo, ds_Pac_S, "sst_Pac_S")
write_sst(f, sst_glo, ds_Pac_W, "sst_Pac_W")
write_sst(f, sst_glo, ds_Pac_E, "sst_Pac_E")
write_sst(f, sst_glo, ds_Pac_T_W, "sst_Pac_T_W")
write_sst(f, sst_glo, ds_Pac_T_E, "sst_Pac_T_E")

write_sst(f, sst_glo, ds_Atl, "sst_Atl")
write_sst(f, sst_glo, ds_Ind, "sst_Ind")
write_sst(f, sst_glo, ds_Sou, "sst_Sou")

f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)

if (createOrAppend.eq."append") then
  ohcfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
  oldfile = datDir+"post/"+getenv("NCL_ARG_0_base")+"_old.nc"
  system("mv -f "+ohcfile+" "+oldfile)
  system("cdo mergetime "+oldfile+" "+outfile+" "+ohcfile)
end if
