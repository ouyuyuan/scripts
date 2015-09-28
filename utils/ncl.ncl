
; Description: common functions
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-09-06 18:00:04 BJT
; Last Change: 2014-09-24 06:54:58 BJT

; ou_add_2d       - add lat2d, lon2d to variable input
; ou_string2time  - convert , say "2014-09-06 00:00:00", to time value
; ou_string2ti    - convert , say "2014-09-06 00:00:00", to time index
; ou_t2string     - convert t series to string like "2014-09-06 00:00:00"
; ou_short2double - convert 'short' type variable with add_offset and 
;                   scale_factor attribute to 'double'
; ou_rgrid2rcm    - rectangular lat/lon grid to rcm grid with 2d lat/lon
; ou_cal_ver_mean - calculate vertical mean
; ou_cal_hor_mean - calculate horizontal mean


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
undef("ou_add_2d")
procedure ou_add_2d( x:numeric, lat2d[*][*]:numeric, lon2d[*][*]:numeric)
;*************************************************************************
; attach 2d lat and lon arrays
;*************************************************************************
begin
  x@lat2d = lat2d  
  x@lon2d = lon2d  
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; convert , say "2014-09-06 00:00:00", to time value
undef("ou_string2time")
function ou_string2time(str:string, units:string)
local y, m, d, h, mi, s, t
begin

y = tointeger(str_get_cols(str,0,3))
m = tointeger(str_get_cols(str,5,6))
d = tointeger(str_get_cols(str,8,9))
h = tointeger(str_get_cols(str,11,12))
mi= tointeger(str_get_cols(str,14,15))
s = tointeger(str_get_cols(str,17,18))

t = cd_inv_calendar(y, m, d, h, mi, s, units, 0)

return t
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; convert , say "2014-09-06 00:00:00", to time index
undef("ou_string2ti")
function ou_string2ti(str:string, t[*]:numeric)
local tval
begin

if (.not. isatt(t, "units"))
  print("ou_string2ti: input value t doesnot have 'units' attribute")
  exit
end if

tval = ou_string2time(str, t@units)
ti = ind(t.eq.tval)

if (ismissing(ti))
  print("ou_string2ti: input string '" + str + "' cannot be found in the input time series")
  exit
end if

return ti
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; convert time index to, say "2014-09-06 00:00:00"
undef("ou_t2string")
function ou_t2string(t:numeric)
local str, fmt
begin
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"

fmt = "%Y-%N-%D %H:%M:%S"
;str = new(dimsizes(t), string)
str = cd_string(t,fmt)

return str
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; 'short' type variable with add_offset and scale_factor attribute to 'double'
undef("ou_short2double")
function ou_short2double( var:numeric )
begin
  rt = new(dimsizes(var), double)
  rt = var*var@scale_factor + var@add_offset

  return rt
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; rectangular lat/lon grid to 2d lat/lon grid
; the argument of var is the same require as rgrid2rcm of ncl function
undef("ou_rgrid2rcm")
function ou_rgrid2rcm( lat, lon, var:numeric, lat2d, lon2d )
local nd, mylon2d, rt 
begin

  nd = dimsizes( dimsizes(var) )

  ; change longitude to -180 to 180
  mylon = where(lon.lt.180, lon - 360, lon)
  mylon2d = where(lon2d.lt.180, lon2d - 360, lon2d)

;  rt = rgrid2rcm_Wrap( lat, mylon, var, lat2d, mylon2d, 0 )
  rt = rgrid2rcm( lat, mylon, var, lat2d, mylon2d, 0 )
  ou_add_2d( rt, lat2d, lon2d )

  return rt

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; cal. vertical mean <<<1
; assume value is on the center of each layer, 
;  and the dimensions are {depth, lat, lon}
undef("ou_cal_ver_mean")
function ou_cal_ver_mean(var:numeric)
;{{{
local nlev, dlev, weight, wgt_con
begin

   lev = var&$var!0$
   nlev = dimsizes(lev)
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
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
   dlon = abs(lon(2) - lon(1)) * torad * r
   dx = dlon*cos(lat*torad)

   jlat = dimsizes(lat)
   dy = new( jlat, typeof(dx) )
   dy(0) = abs(lat(2) - lat(1)) * torad * r
   dy(1:jlat-2)  = abs(lat(2:jlat-1)-lat(0:jlat-3))*0.5 * torad * r   
   dy(jlat-1)    = abs(lat(jlat-1)-lat(jlat-2)) * torad * r

   area = dx * dy
   ave = wgt_areaave_Wrap(var, area, 1.0, 1)

   return ave
;}}}
end
