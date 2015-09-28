
; Description: create basin from a template basin file
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-04-12 09:00:12 BJT
; Last Change: 2014-04-13 15:24:47 BJT


load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; interpolate from licom Atlantic <<<1

undef("inter_from_template")
function inter_from_template( template[*][*]: integer, filename: string )
local f, lat, lon, lat_in, lon_in
begin
   f = addfile(filename, "r")
   lat = f->lat
   lon = f->lon
   delete(f)

   lat_in = template&lat
   lon_in = template&lon
   t = linint2(lon_in, lat_in, template, True, lon, lat, 0)
   basin = floattointeger(t)
   delete(t)

   basin = where(ismissing(basin), 0, basin)

   basin@long_name = "basin"
   basin@units = ""
   basin!0 = "lat"
   basin!1 = "lon"
   basin&lat = lat
   basin&lon = lon

   return basin
end

; output nc and txt basin <<<1

undef("output_nc_txt")
procedure output_nc_txt( basin[*][*]: integer, dir: string )
local nlon, txtout, opt
begin
   filename = dir + "basin_interp.nc"
   system("rm -f " + filename)
   f = addfile(filename, "c")
   globalAtt = True
   time = systemfunc("date +'%Y-%m-%d %H:%M:%S'")
   globalAtt@history = "Calculated by ouyuyuan at " + time
   globalAtt@script = getenv("NCL_ARG_0")
   fileattdef(f, globalAtt)
   f->basin = basin 
   delete(f)

   txtout = dir + "basin_interp.txt"
   opt = True
   opt@fout = txtout
   nlon = dimsizes(basin&lon)
   write_matrix( basin(::-1,:), nlon + "i2", opt )
end

; main <<<1
begin

   data_dir = "/home/ou/archive/data/"

   ; 0: land
   ; 1: Artic Ocean
   ; 2; Atlantic    5: South Atlantic
   ; 3: Indian      6: South Indian
   ; 4: Pacific     7: South Pacific

   filename = data_dir + "licom/basin.nc"
   f = addfile(filename, "r")
   template = f->basin
   delete(f)

   filename = data_dir + "soda/climate/climate_1981-2000.nc"
   basin = inter_from_template( template, filename )
   dir = data_dir + "soda/"
   output_nc_txt( basin, dir )
   delete(basin)

   filename = data_dir + "pcom/climate/fix_fkh/year_mean_081-100.nc"
   basin = inter_from_template( template, filename )
   dir = data_dir + "pcom/"
   output_nc_txt( basin, dir )
   delete(basin)

end
