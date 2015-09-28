
; Description: utility in PCOM calculation
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-13 14:29:12 BJT
; Last Change: 2015-06-25 09:31:44 BJT

; pcom_area_mean  - calculate area mean according to latitude factor

; cal. global mean func <<<1
undef("pcom_area_mean")
function pcom_area_mean(var:numeric)
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

; EOF of a variable, return the first two patterns (pat) and the time series (ts)
undef("pcom_eof")
procedure pcom_eof(var, eof, ts)
; var(time, :,:)
begin
  an = var
  an = var - conform(var, dim_avg_n(var,0), (/1,2/))
  ;an = where(ismissing(an),0,an)

  ; EOF
  neof   = 2
  optEOF = True       
  optETS = False
  if (var!1.eq."lat" .and. var!2.eq."lon") then
    ran    = an(lat|:,lon|:,time|:)    ; convenience, cleaner code
  else if (var!1.eq."z" .and. var!2.eq."lat") then
    ran    = an(z|:,lat|:,time|:)
  else
    print("unknow dimension in pcom_eof input parameter 'var'")
  end if
  end if
  eof    = eofunc_Wrap(ran, neof, optEOF)      
;  eof = -eof
  ts = eofunc_ts_Wrap (ran, eof, optETS)
  tsStd = dim_stddev_n(ts, 1)
  eof = eof*conform(eof, tsStd, (/0/))
  ts = dim_standardize_n( ts, 0, 1)      ; normalize
end

; check whether is a specific expriment
; mainly for customize ploting
undef("pcom_isExp")
function pcom_isExp(datDir, expName)
begin
  isPcom = False
  if isStrSubset(datDir,"pcom") .and. .not.isStrSubset(datDir,"pcom_grid") then
    isPcom = True
  end if

  Exp = False
  if isPcom .and. isStrSubset(datDir, expName) then
    Exp = True
  end if

  return Exp
end
