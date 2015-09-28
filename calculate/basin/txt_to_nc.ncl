
; Description: create basin_hand.nc from basin_hand.txt
;              required basin.nc in the working dir.
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-04-12 09:00:12 BJT
; Last Change: 2015-01-17 20:09:36 BJT


load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   f = addfile("basin_interp.nc", "r")
   lat = f->lat
   lon = f->lon
   delete(f)
   nlat = dimsizes(lat)
   nlon = dimsizes(lon)

   txt =  "basin_hand.txt"
   basin = asciiread( txt, (/nlat, nlon/), "integer" )

   basin = basin(::-1,:) ; change south-north
   basin!0 = "lat"
   basin!1 = "lon"
   basin&lat = lat
   basin&lon = lon

   fileout = "basin_hand.nc"
   system( "rm -f " + fileout )
   f = addfile( fileout, "c" )

   basin@long_name = "basin"
   basin@units = ""
   
   f->basin = basin
   f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
   ", " + systemfunc("date")
   delete(f)

end
