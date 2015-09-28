
; Description: Global volume weighted average of 3D variable, such as T, S
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-10 09:19:53 BJT
; Last Change: 2015-03-07 09:05:03 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir = getenv("NCL_ARG_1")
nyear = stringtoint(getenv("NCL_ARG_2"))
varName = getenv("NCL_ARG_3")

; cal. volume mean <<<1
; assume value is on the center of each layer, 
;  and the dimensions are {depth, lat, lon}
undef("cal_vol_mean")
function cal_vol_mean(var:numeric)
;{{{
local nlev, dlev, wgt, ave, lat, torad, lev
begin

  torad = 3.14159265 / 180

   lev = var&$var!0$
   lat = var&$var!1$ * torad

   nlev = dimsizes(lev)

  if (lev(0)-0 .lt. 10e-6) then
     print("the first layer is zero, stop.")
     return
  end if

   dlev = lev*0
   dlev(0) = lev(0) * 2
   do i = 1, nlev - 1
      dlev(i) = (lev(i) - sum(dlev)) * 2
      if (dlev(i) .lt. 0) then
         print("thickness of layer is not positive! stop.")
         return
      end if
   end do
;   print(dlev+0)

  wgt = conform(var, dlev, 0) * conform(var, cos(lat), 1)
  wgt = where( ismissing(var), 0, wgt)
  wgt = wgt / sum(wgt)

  ave = sum(wgt * var)

 return ave

;}}}
end

outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+"_"+varName+".nc"

; initial field
f = addfile( "/snfs01/lyh/ou/data/pcom/pcom_ini.nc", "r" )
if (varName.eq."pt") then
  t = f->ct(:,:,:)
end if
if (varName.eq."sa") then
  t = f->sa(:,:,:)
end if
delete(f)
ts = new( nyear+1, typeof(t) )
print("Calculate initial file pcom_ini.nc")
ts(0) = cal_vol_mean( t )

do yr = 1, nyear
 fname = datDir+"yearly/"+sprinti( "year_%0.4i.nc", yr )
 f = addfile( fname, "r")
 t = f->$varName$(0,:,:,:)
 delete(f)
 print("Calculate " + fname)
 ts(yr) = cal_vol_mean( t )
end do
time = ispan(0,nyear,1)
time@units = "years since PCOM initial run"
ts!0 = "time"
ts&time = time
if (varName.eq."pt") then
  ts@long_name = "potential temperature"
  ts@units = "degC"
end if
if (varName.eq."sa") then
  ts@long_name = "absolute salinity"
  ts@units = "g/kg"
end if

system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef( f, "time", -1, True )
f->$varName$ = ts
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
