
; Description: Drake passage transport trend
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-09 08:13:34 BJT
; Last Change: 2014-12-01 10:47:09 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; assume value is on the center of each layer, 
; and the dimensions are {depth, lon}
; lat is which latitude the section at
undef("cal_sec_tran")
function cal_sec_tran(var:numeric, lat)
;{{{
local nlev, dlev, tran, lon, nlon, torad, lev
begin

  r = 6371220.0 ; meters
  torad = 3.14159265 / 180

  lev = var&$var!0$
  lon = var&$var!1$

  nlev = dimsizes(lev)

  if (lev(0)-0 .lt. 1e-6) then
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

  nlon = dimsizes(lon)
  dx = lon * 0
  dx = (lon(1)-lon(0)) * torad * r

  area = conform(var, dlev, 0) * conform(var, dx, 1)
  area = where( ismissing(var), 0, area)

  tran = sum(area * var * 1e-6)

 return tran
;}}}
end

begin

  datDir = getenv("NCL_ARG_1")

  yb = 1
  ye = 120
  ny = ye-yb+1

  lonW = 110.5
  lonE = 290.5
  lat = 10.5

  time = new(ny, integer)
  time@units = "years since 0500-01-01"
  time@long_name = "time"
  do yr = yb, ye
    time(yr-yb) = yr
    fname = datDir+"../yearly/"+sprinti( "year_%0.4i.nc", yr )
    f = addfile( fname, "r")
    v = f->v(0,:,{lat},{lonW:lonE})
    delete(f)
    if (yr .eq. yb) then
      tran = new( ny, typeof(v) )
    end if
    print("Calculate " + fname)
    tran(yr-yb) = cal_sec_tran( v, lat )
  end do

  tran@units = "Sv"
  tran@long_name = "v transport across "+lat
  tran!0 = "time"
  tran&time = time

  outfile = datDir+getenv("NCL_ARG_0_base")+".nc"
  system("rm -f " + outfile)
  f = addfile(outfile, "c")
  f->tran_10N = tran
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")

end
