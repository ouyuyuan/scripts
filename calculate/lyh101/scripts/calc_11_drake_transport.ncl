
; Description: Drake passage transport trend
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-09 08:13:34 BJT
; Last Change: 2015-03-22 10:37:27 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir    = getenv("NCL_ARG_1")
yb = stringtoint(getenv("NCL_ARG_2"))
ye = stringtoint(getenv("NCL_ARG_3"))

isSoda = False
if isStrSubset(datDir, "soda/pcom_grid") then
  isSoda = True
end if

fileGrid  = datDir+"../grid_info.nc"
if isSoda then
  fileGrid  = datDir+"post/grid_info.nc"
end if
fileOut   = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"

lat1 = -68.5
lat2 = -54.5
lon = 292.5

f  = addfile(fileGrid, "r")
dy = f->dy({lat1:lat2},{lon})
dz = f->dz(:)
delete(f)

time = ispan(yb, ye, 1)
if (ye.gt.500) then
  time@units = "years since 0000-01-01"
else
  time@units = "years since 0500-01-01"
end if
if isSoda then
  time@units = "years since 0000-01-01"
end if

do yr = yb, ye
  fname = datDir+"yearly/"+sprinti( "year_%0.4i.nc", yr )
  if isSoda then
    fname = datDir+"yearly/u/"+sprinti( "year_%0.4i.nc", yr )
  end if
  print("Calculate " + fname)

  f = addfile( fname, "r")
  if isSoda then
    u = f->u(:,{lat1:lat2},{lon})
  else
    u = f->u(0,:,{lat1:lat2},{lon})
  end if
  delete(f)

  if (yr .eq. yb) then
    area = conform(u, dz, 0) * conform(u, dy, 1)
    area = where( ismissing(u), 0, area)
    tran = new( ye-yb+1, typeof(u) )
  end if

  tran(yr-yb) = sum(area * u * 1e-6)
end do

tran!0 = "time"
tran&time = time
tran@long_name = "Drake passage transport"
tran@units = "Sv"

system("rm -f " + fileOut)
f = addfile(fileOut, "c")
f->tran = tran
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
