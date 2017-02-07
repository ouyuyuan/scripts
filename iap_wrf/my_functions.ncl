
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-08-21 07:05:35 BJT
; Last Change: 2015-08-21 10:49:11 BJT

; my_string2time  - convert , say "2014-09-06 00:00:00", to time value
; my_string2ti    - convert , say "2014-09-06 00:00:00", to time index
; my_str2t        - convert , say "(/2014-09-06 00:00:00, 2015-10-10 03:00:00/)", 
;                   to time indexes
; my_t2string     - convert t series to string like "2014-09-06 00:00:00"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; convert , say "2014-09-06 00:00:00", to time value
undef("my_string2time")
function my_string2time(str:string, units:string)
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
undef("my_string2ti")
function my_string2ti(str:string, t[*]:numeric)
local tval
begin

if (.not. isatt(t, "units"))
  print("my_string2ti: input value t doesnot have 'units' attribute")
  exit
end if

tval = my_string2time(str, t@units)
ti = ind(t.eq.tval)

if (ismissing(ti))
  print("my_string2ti: input string '" + str + "' cannot be found in the input time series")
  exit
end if

return ti
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; same as my_string2ti, but for arrays
undef("my_str2t")
function my_str2t(str[*]:string, t[*]:numeric)
local n, ids, i
begin

n = dimsizes(str)
ids = new(n, integer)

do i = 0, n-1
  ids(i) = my_string2ti(str(i), t)
end do

return ids
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; convert time index to, say "2014-09-06 00:00:00"
undef("my_t2string")
function my_t2string(t:numeric)
local str, fmt
begin
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"

fmt = "%Y-%N-%D %H:%M:%S"
;str = new(dimsizes(t), string)
str = cd_string(t,fmt)

return str
end
