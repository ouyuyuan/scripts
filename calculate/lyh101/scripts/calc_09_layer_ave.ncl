
; Description: Global average of each layers
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-10 09:19:53 BJT
; Last Change: 2015-03-08 09:26:10 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir = getenv("NCL_ARG_1")
nyear = stringtoint(getenv("NCL_ARG_2"))
outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"

grid_info_file = datDir+"../grid_info.nc"
f = addfile(grid_info_file, "r")
ds = f->ds
delete(f)

; cal. area mean
undef("cal_area_mean")
function cal_area_mean(var:numeric)
;{{{
local wgt, ave
begin
  wgt = ds
  wgt = where( ismissing(var), 0, wgt)
  wgt = wgt / sum(wgt)

  ave = sum(wgt * var)
 return ave
end
;}}}

; initial field
f = addfile( "/snfs01/lyh/ou/data/pcom/pcom_ini.nc", "r" )
print("Calculate initial file pcom_ini.nc")
t = f->ct(:,:,:)
s = f->sa(:,:,:)
z = f->z(:)
delete(f)

nlev = dimsizes(z)
pt = new( (/nyear+1, nlev/), typeof(t) )
sa = new( (/nyear+1, nlev/), typeof(s) )

do lev = 0, nlev - 1
  pt(0, lev) = cal_area_mean( t(lev, :, :) )
  sa(0, lev) = cal_area_mean( s(lev, :, :) )
end do

do yr = 1, nyear
  fname = datDir+"yearly/"+sprinti( "year_%0.4i.nc", yr )
  print("Calculate " + fname)
  f = addfile( fname, "r")
  t = f->pt(0,:,:,:)
  s = f->sa(0,:,:,:)
  delete(f)
  do lev = 0, nlev - 1
    pt(yr, lev) = cal_area_mean( t(lev, :, :) )
    sa(yr, lev) = cal_area_mean( s(lev, :, :) )
  end do
end do

time = ispan(0, nyear, 1)
time@units = "years since 0000-01-01"
pt!0 = "time"
pt&time = time
sa!0 = "time"
sa&time = time

pt!1 = "z"
pt&z = z
sa!1 = "z"
sa&z = z

system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef( f, "time", -1, True )
f->pt = pt
f->sa = sa
