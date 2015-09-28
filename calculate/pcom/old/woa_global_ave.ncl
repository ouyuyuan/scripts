
; Description: trend of global average properties, e.g. potential temperature
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-10 09:19:53 BJT
; Last Change: 2014-09-25 15:32:05 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

undef("cal_ver_mean")
function cal_ver_mean(var:numeric)
;{{{
local nlev, dlev, weight, wgt_con, midlev
begin

   lev = var&$var!0$
   nlev = dimsizes(lev)

   midlev = lev*0
   dlev = lev*0

   midlev(0:nlev-2) = ( lev(0:nlev-2) + lev(1:nlev-1) ) / 2.0
   midlev(nlev-1) = (6000 + 5500) / 2 ; extrapolation, check the trend of depth in WOA

   dlev(0) = 5 ; lev(0) is 0 m in WOA
   dlev(1:nlev-1) = midlev(1:nlev-1) - midlev(0:nlev-2)
   print(dlev+0)

   if ( isdouble(dlev) ) then
      weight = doubletofloat(dlev/sum(dlev))
   else
      weight = dlev/sum(dlev)
   end if

   wgt_con = conform_dims(dimsizes(var), weight, 0)

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
undef("cal_hor_mean")
function cal_hor_mean(var:numeric)
;{{{
; assume lon is evenly spaced, only account cosine factor 
;    of latitude for weight
local lat, lon, rad, r, wgt, dlon, dx, dy, jat
begin
   torad = 3.14159265 / 180

   lat = var&lat * torad
   lon = var&lon * torad
;   r = 6371220.0 ; meters
;   dlon = abs(lon(2) - lon(1)) * torad * r
   dlon = abs(lon(2) - lon(1))
;   dx = dlon*cos(lat*torad)
   dx = lat*0
   dx = dlon

   jlat = dimsizes(lat)
   dy = new( jlat, typeof(dx) )
;   dy(0) = abs(lat(2) - lat(1)) * torad * r
;   dy(1:jlat-2)  = abs(lat(2:jlat-1)-lat(0:jlat-3))*0.5 * torad * r   
;   dy(jlat-1)    = abs(lat(jlat-1)-lat(jlat-2)) * torad * r
  
   dy(0) = sin(lat(2)) - sin(lat(1))
   do i = 1, jlat - 2
     dy(i) = sin( (lat(i) + lat(i+1))*0.5 ) - sin( (lat(i-1) + lat(i))*0.5 )
   end do
   dy(jlat-1) = sin(lat(jlat-1)) - sin(lat(jlat-2))

   area = dx * dy
   ave = wgt_areaave_Wrap(var, area, 1.0, 1)

   return ave
;}}}
end

begin
  data_dir = "/home/ou/archive/data/woa09/"
  inp = data_dir + "salinity_annual_1deg.nc"

   torad = 3.14159265 / 180
  f = addfile( inp, "r" )
  s_an = f->s_an(0,:,:,:)
  s_mn = f->s_mn(0,:,:,:)
  lat_bnds = f->lat_bnds * torad
  lon_bnds = f->lon_bnds * torad
  delete(f)
  lat = s_an&lat * torad
  lon = s_an&lon * torad
  s_an_ver = cal_ver_mean(s_an)
  area = new(dimsizes(lat), float)
;  area = conform(area, lon_bnds(:,1) - lon_bnds(:,0), 1) * \
;         conform(area, lat_bnds(:,1) - lat_bnds(:,0), 0) * \
;         conform(area, cos(lat), 0)
  area = (lat_bnds(:,1) - lat_bnds(:,0)) * cos(lon(2)-lon(1))
   s_an_ave = wgt_areaave_Wrap(s_an_ver, area, 1.0, 1)
;  s_an_ave = cal_hor_mean( cal_ver_mean(s_an) )
;  s_mn_ave = cal_hor_mean( cal_ver_mean(s_mn) )

  print(s_an_ave+0)
;  print(s_mn_ave+0)
end
