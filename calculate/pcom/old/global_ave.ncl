
; Description: trend of global average properties, e.g. potential temperature
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-10 09:19:53 BJT
; Last Change: 2014-09-25 16:49:31 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; cal. vertical mean <<<1
; assume value is on the center of each layer, 
;  and the dimensions are {depth, lat, lon}
undef("cal_ver_mean")
function cal_ver_mean(var:numeric)
;{{{
local nlev, dlev, weight, wgt_con
begin

   lev = var&$var!0$
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
   mean&lon = var&lon

   return mean

;}}}
end

; cal. global mean func <<<1
undef("cal_global_mean")
function cal_global_mean(var:numeric)
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

begin

  data_dir = "/home/ou/archive/data/pcom/moc_re_s"
  draw_dir = "/home/ou/archive/drawing/pcom/core"
  outfile  = data_dir + "/post/global_ave.nc"

  nyear  = 500
;  nyear  = 5

  ; initial field
  f = addfile( "/home/ou/archive/data/pcom/input/pcom_ini.nc", "r" )
  t = f->ct(:,:,:)
  s = f->sa(:,:,:)
  delete(f)
  pt = new( nyear+1, typeof(t) )
  sa = new( nyear+1, typeof(s) )
  print("Calculate initial file pcom_ini.nc")
  pt(0) = cal_global_mean( cal_ver_mean(t) )
  sa(0) = cal_global_mean( cal_ver_mean(s) )

  do yr = 1, nyear
   fname = sprinti( "year_%0.4i.nc", yr )
   f = addfile( data_dir + "/" + fname, "r")
   t = f->pt(0,:,:,:)
   s = f->sa(0,:,:,:)
   delete(f)
   print("Calculate " + fname)
   pt(yr) = cal_global_mean( cal_ver_mean(t) )
   sa(yr) = cal_global_mean( cal_ver_mean(s) )
  end do

;  time = fspan(0, nyear, nyear+1)
  time = ispan(0, nyear, 1)
  time@units = "years since model initial run"
  pt!0 = "time"
  pt&time = time
  sa!0 = "time"
  sa&time = time

  system("rm -f " + outfile)
  f = addfile(outfile, "c")
  filedimdef( f, "time", -1, True )
  f->pt = pt
  f->sa = sa

end
