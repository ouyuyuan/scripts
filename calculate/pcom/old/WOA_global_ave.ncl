
; Description: trend of global average properties, e.g. potential temperature
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-10 09:19:53 BJT
; Last Change: 2014-09-25 17:07:16 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

undef("ou_cal_ver_mean")
function ou_cal_ver_mean(var:numeric)
;{{{
local nlev, dlev, weight, wgt_con
begin

   lev = var&$var!0$
   nlev = dimsizes(lev)

  midlev = lev * 0
  midlev(0:nlev-2) = ( lev(0:nlev-2) + lev(1:nlev-1) ) / 2.0
  midlev(nlev-1) = (6000 + 5500) / 2 ; extrapolation, check the trend of lev in WOA

  dlev = lev * 0
  dlev(0) = 5 ; lev(0) is 0 m in WOA
  dlev(1:nlev-1) = midlev(1:nlev-1) - midlev(0:nlev-2)

  weight = dlev/sum(dlev)

   wgt_con = conform_dims(dimsizes(var), weight, 0)
   wgt_con = where( ismissing(var), 0, wgt_con )

   mean = dim_sum_n( var*wgt_con, 0 )

   mean!0 = "lat"
   mean!1 = "lon"
   mean&lat = var&lat
;   lev = var&$var!0$
   mean&lon = var&lon

   return mean

;}}}
end

; cal. global mean func <<<1
undef("ou_cal_hor_mean")
function ou_cal_hor_mean(var:numeric)
;{{{
; assume lon is evenly spaced, only account cosine factor 
;    of latitude for weight
local lat, lon, rad, r, wgt, dlon, dx, dy, jat
begin
   lat = var&lat
   lon = var&lon
   torad = 3.14159265 / 180
   r = 6371220.0 ; meters
;   dlon = abs(lon(2) - lon(1)) * torad * r
;   dx = dlon*cos(lat*torad)

;   jlat = dimsizes(lat)
;   dy = new( jlat, typeof(dx) )
;   dy(0) = abs(lat(2) - lat(1)) * torad * r
;   dy(1:jlat-2)  = abs(lat(2:jlat-1)-lat(0:jlat-3))*0.5 * torad * r   
;   dy(jlat-1)    = abs(lat(jlat-1)-lat(jlat-2)) * torad * r

;   area = dx * dy
;   ave = wgt_areaave_Wrap(var, area, 1.0, 1)
  wgt = conform(var, cos(lat*torad), 0) 
  wgt = where( ismissing(var), 0, wgt )
  wgt = wgt / sum(wgt)
  ave = sum(var*wgt)

   return ave
;}}}
end

begin
  data_dir = "/home/ou/archive/data/woa09/"
  inp = data_dir + "salinity_annual_1deg.nc"

  f = addfile( inp, "r" )
  s_an = f->s_an(0,:,:,:)
  s_mn = f->s_mn(0,:,:,:)
  delete(f)
  s_an_ave = ou_cal_hor_mean( ou_cal_ver_mean(s_an) )
  s_mn_ave = ou_cal_hor_mean( ou_cal_ver_mean(s_mn) )

  print(s_an_ave+0)
  print(s_mn_ave+0)
end
