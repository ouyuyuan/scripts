
; Description: calculate trend of global mean ssh
;
;       Usage: nclrun xxx.nxl soda/licom/pcom
;              or run xxx.sh to automatically execuate re-calculation on $sda
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-04-10 15:52:41 BJT
; Last Change: 2014-04-11 20:04:30 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; cal. global mean func <<<1
function cal_global_mean(var:numeric)
; assume lon is evenly spaced, only account cosine factor 
;    of latitude for weight
local lat, lon, rad, r, wgt, dlon, dx, dy, jat
begin
   lat = var&lat
   lon = var&lon
   torad = 3.14159265 / 180
   r = 6371220.0
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
end

begin

   ; check input option <<<1
   model = getenv("NCL_ARG_1")
   if (ismissing(model)) then
      print("Must provide a model name. Exit.")
      exit
   end if

   ; dirs., files <<<1
   indir = "monthly/"
   outdir = "post/"
   outfile = outdir + "ssh_trend.nc"

   ; time range <<<1
   yr_begin = 91
   yr_end = 100

   mon_begin = (yr_begin - 1)*12 + 1
   mon_end = yr_end*12

   nmon = mon_end - mon_begin + 1
   trend = new(nmon, float)

   ; process one file per time <<<1
   do month = mon_begin, mon_end
      ; determine filename for each loop <<<2
      if ( model.eq."pcom" ) then
         filename = sprinti("N%0.8i.nc", month)
      else if ( model.eq."licom" ) then
         y = floattointeger( (month-0.5)/12 + 1 )
         m = month - (y-1)*12
         ys = sprinti("%0.4i", y)
         ms = sprinti("%0.2i", m)
         filename = "MMEAN"+ys+"-"+ms+".nc"
         delete(y)
         delete(m)
         delete(ys)
         delete(ms)
      else if ( model.eq."soda" ) then
         y = floattointeger( (month-0.5)/12 + 1 )
         m = month - (y-1)*12
         y = y + 1900
         ys = sprinti("%0.4i", y)
         ms = sprinti("%0.2i", m)
         filename = "SODA_2.2.4_" + ys + ms + ".cdf"
         delete(y)
         delete(m)
         delete(ys)
         delete(ms)
      else
         print("unknow model: " + model +". Exit.")
         exit
      end if
      end if
      end if

      ; retrief ssh from file <<<2
      f = addfile(indir + filename, "r")
      if (model.eq."licom") then
         ssh = f->z0(0,::-1,0:359)
      else if (model.eq."soda") then
         ssh = f->ssh(:,:)
      else
         ssh = f->ssh(0,:,:)
      end if
      end if
      if ( model.eq."pcom" .and. isfloat(ssh) .and. isdouble(ssh@missing_value) ) then
         ssh@_FillValue = doubletofloat(ssh@missing_value)
      end if
      ; cal. global mean <<<2
      i = month - mon_begin
      trend(i) = cal_global_mean(ssh)
      delete(f)
   end do

   ; output result to file <<<1
   if (model .eq. "soda") then
      time = fspan(yr_begin + 1900, yr_end + 1 +1900, nmon)
      time@units = "year"
   else
      time = fspan(yr_begin, yr_end + 1, nmon)
      time@units = "model year"
   end if

   trend@units = "m"
   trend@long_name = "Global average sea surface height"
   trend!0 = "time"
   trend&time = time

   system("rm -f " + outfile)
   f = addfile(outfile, "c")
   f->ssh = trend

end
