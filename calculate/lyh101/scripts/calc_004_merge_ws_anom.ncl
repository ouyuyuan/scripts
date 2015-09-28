
; Description: merge windstress anomalies from from individual files
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-01-11 09:38:11 BJT
; Last Change: 2015-01-11 10:11:45 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir = getenv("NCL_ARG_1")
yb = stringtoint(getenv("NCL_ARG_2"))
ye = stringtoint(getenv("NCL_ARG_3"))
ny = ye-yb+1
createOrMerge = getenv("NCL_ARG_4")
outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
if (.not. ismissing(createOrMerge) .and. createOrMerge.eq."merge") then
  outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+"_new_years.nc"
end if

time = ispan(yb,ye,1)
time@long_name = "time"
if (ye.le.500) then
  ; for those expriments which the year-counter has been reset to 0 
  time@units = "years since 0500-01-01"
else
  time@units = "years since 0000-01-01"
end if

function create_var2d(var2d0)
;{{{
begin
  dims = dimsizes(var2d0)
  nlat = dims(0)
  nlon = dims(1)
  var2d = new((/ny, nlat, nlon/), typeof(var2d0))
  copy_VarAtts(var2d0, var2d)

  var2d!0 = "time"
  var2d!1 = "lat"
  var2d!2 = "lon"
  var2d&time = time
  var2d&lat = var2d0&lat
  var2d&lon = var2d0&lon
  return var2d
end
;}}}

do yr = yb, ye
  fname = datDir+"yearly/"+sprinti( "year_%0.4i.nc", yr )
  print("processing "+fname+" ~ ~ ~ ~ ~ ~")
  f = addfile(fname, "r")
  bcu_an0 = f->bcu_an(0,:,:)
  bcv_an0 = f->bcv_an(0,:,:)
  delete(f)

  if (yr .eq. yb) then
    bcu_an = create_var2d(bcu_an0)
    bcv_an = create_var2d(bcv_an0)
  end if
  bcu_an({yr},:,:) = bcu_an0
  bcv_an({yr},:,:) = bcv_an0
end do

system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)
f->bcu_an = bcu_an
f->bcv_an = bcv_an
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)

if (.not. ismissing(createOrMerge) .and. createOrMerge.eq."merge") then
  uvAnomFile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
  oldfile = datDir+"post/"+getenv("NCL_ARG_0_base")+"_old.nc"
  system("mv -f "+uvAnomFile+" "+oldfile)
  system("cdo mergetime "+oldfile+" "+outfile+" "+uvAnomFile)
end if
