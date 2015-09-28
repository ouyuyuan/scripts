
; Description: Global and Atlantic Meridional Overturning Circulation
;              VV = definite integrate v(x,y,z) from west to east
;              phi = indefinite integrate VV(y,z) from surface to bottom, 
;                    minus sign if needed
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-03-31 09:10:53 BJT
; Last Change: 2015-05-29 06:58:41 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;load "/snfs01/lyh/ou/scripts/pcom.ncl"
load "pcom.ncl"

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

datDir    = getenv("NCL_ARG_1")
yb = stringtoint(getenv("NCL_ARG_2"))
ye = stringtoint(getenv("NCL_ARG_3"))

fileBasin = datDir+"../basin.nc"
fileGrid  = datDir+"../grid_info.nc"
fileOut   = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"

f  = addfile(fileGrid, "r")
dv = f->dv
idx = f->idx
delete(f)

f     = addfile(fileBasin, "r")
basin = f->basin
delete(f)
AtlId = 6 ; 6 represents Atlantic in the basin file
SouId = 1
PacId = 2
IndId = 3

basinGlo = basin
basinGlo = where(idx(0,:,:).eq.1, 1, basinGlo@_FillValue)

basinAtl = where(basin.eq.AtlId, basinGlo, basinGlo@_FillValue)
basinPac = where(basin.eq.PacId, basinGlo, basinGlo@_FillValue)
basinInd = where(basin.eq.IndId, basinGlo, basinGlo@_FillValue)
basinSou = where(basin.eq.SouId, basinGlo, basinGlo@_FillValue)

ny = ye-yb+1

time = ispan(yb,ye,1)
time@long_name = "time"
if (ye.gt.500) then
  time@units = "years since 0000-01-01"
else
  time@units = "years since 0500-01-01"
end if

z = dv&z
lat = dv&lat
nz = dimsizes(z)
nlat = dimsizes(lat)
mocGlo = new((/ny,nz,nlat/), float)
mocGlo!0 = "time"
mocGlo!1 = "z"
mocGlo!2 = "lat"
mocGlo&time = time
mocGlo&z = z
mocGlo&lat = lat
mocGlo@units = "Sv"
mocGlo@long_name = "meridional overturning circulation"

mocAtl = mocGlo
mocPac = mocGlo
mocInd = mocGlo
mocSou = mocGlo

do yr = yb, ye
  fname = datDir+"yearly/"+sprinti( "year_%0.4i.nc", yr )
  print("processing "+fname+" ~ ~ ~ ~ ~ ~")

  mocGlo({yr},:,:) = pcom_moc_b(fname, fileGrid, basinGlo)
  mocPac({yr},:,:) = pcom_moc_b(fname, fileGrid, basinPac)
  mocAtl({yr},:,:) = pcom_moc_b(fname, fileGrid, basinAtl)
  mocInd({yr},:,:) = pcom_moc_b(fname, fileGrid, basinInd)
  mocSou({yr},:,:) = pcom_moc_b(fname, fileGrid, basinSou)
end do

system("rm -f " + fileOut)
f = addfile(fileOut, "c")
f->mocGlo = mocGlo
f->mocAtl = mocAtl
f->mocPac = mocPac
f->mocInd = mocInd
f->mocSou = mocSou
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
