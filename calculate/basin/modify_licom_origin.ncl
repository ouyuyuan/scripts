
begin
   f1 = addfile("/home/ou/archive/data/licom/BASIN_362X196.nc", "r")
   f2 = addfile("/home/ou/archive/data/licom/climate/unmodified/climate_081-100.nc", "r")

   lat = f2->lat(::-1)
   lon = f2->lon(0:359)

   basin = f1->ind(::-1,0:359)

   basin!0 = "lat"
   basin!1 = "lon"
   basin&lat = lat
   basin&lon = lon

   basin@long_name = "Basin field, from 0 to 7, represent land and different basins" 
   basin@units = ""
   
   fout = "/home/ou/archive/data/licom/basin_lat_lon.nc"
   system("rm -f " + fout)

   f3 = addfile(fout, "c")
   globalAtt = True
   time = systemfunc("date +'%Y-%m-%d %H:%M:%S'")
   globalAtt@history = "Calculated from BASIN_362x196.nc by ouyuyuan at " + time
   fileattdef(f3, globalAtt)
   f3->basin = basin
end

