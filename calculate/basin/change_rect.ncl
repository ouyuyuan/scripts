
; Description: change a rectangular range and output as basin_change_rect.txt 
;              required basin_hand.nc in the working dir.
;              this script usually run after basin_hand.txt and basin_hand.nc
;              created, and plotted, then you want to change some rectangular
;              range
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-04-12 09:00:12 BJT
; Last Change: 2014-04-13 17:23:57 BJT


load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   lat_sta = -60
   lat_end = 0
   lon_sta = 270
   lon_end = 300
   old_basin = 2
   new_basin = 0

   f = addfile("basin_hand.nc", "r")
   basin = f->basin
   delete(f)
   lat = basin&lat
   lon = basin&lon
   nlat = dimsizes(lat)
   nlon = dimsizes(lon)

   range = basin({lat_sta:lat_end},{lon_sta:lon_end})
   range = where(range .eq. old_basin, 0, range)
   basin({lat_sta:lat_end},{lon_sta:lon_end}) = range

   fileout = "basin_change_rect.nc"
   system( "rm -f " + fileout )
   f = addfile( fileout, "c" )

   basin@long_name = "basin"
   basin@units = ""
   
   globalAtt = True
   time = systemfunc("date +'%Y-%m-%d %H:%M:%S'")
   globalAtt@history = "Calculated by ouyuyuan at " + time
   globalAtt@script = getenv("NCL_ARG_0")
   fileattdef(f, globalAtt)
   f->basin = basin
   delete(f)

   txtout = "basin_change_rect.txt"
   opt = True
   opt@fout = txtout
   nlon = dimsizes(basin&lon)
   write_matrix( basin(::-1,:), nlon + "i2", opt )

end
