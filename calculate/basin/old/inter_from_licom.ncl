
; Description: Calculate basin
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-04-12 09:00:12 BJT
; Last Change: 2014-04-12 10:25:32 BJT


load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   ; dirs, files <<<1

   model = getenv("NCL_ARG_1")
   if (ismissing(model)) then
      print("Usage: nclrun xxx.ncl soda/licom/pcom")
      exit
   end if

   if ( model .eq. "soda" ) then
      filein = "/home/ou/archive/data/soda/climate/climate_1981-2000.nc"
      fileout= "/home/ou/archive/data/soda/basin.nc"
   else if ( model .eq. "pcom" ) then
      filein = "/home/ou/archive/data/pcom/climate/fix_fkh/year_mean_081-100.nc"
      fileout= "/home/ou/archive/data/pcom/basin.nc"
   else if ( model .eq. "licom" ) then
      filein = "/home/ou/archive/data/licom/climate/unmodified/climate_081-100.nc"
      fileout= "/home/ou/archive/data/licom/basin.nc"
   else
      print("unkown model: " + model)
      exit 
   end if
   end if
   end if

   f = addfile(filein, "r")
   f_basin = addfile("/home/ou/archive/data/licom/basin_lat_lon.nc", "r")

   ; field <<<1

   if ( model .eq. "soda" ) then
      cn = f->v(0,:,:)
   else if ( model .eq. "pcom" ) then
      cn = f->v(0, 0, :, :)
   else if ( model .eq. "licom" ) then
      cn = f->vs(0, :, ::-1, 0:359)
   else
      print("unkown model: " + model)
      exit
   end if
   end if
   end if

   lat = cn&lat
   lon = cn&lon

   ; in template (from licom):
   ; 0: land
   ; 1: Artic Ocean
   ; 2; Atlantic    5: South Atlantic
   ; 3: Indian      6: South Indian
   ; 4: Pacific     7: South Pacific
   template = f_basin->basin

   if ( model.eq."licom" ) then
      basin = template
   else
      lat_in = template&lat
      lon_in = template&lon
      t = linint2(lon_in, lat_in, template, True, lon, lat, 0)
      basin = floattointeger(t)
   end if

   ; output <<<1

   basin!0 = "lat"
   basin!1 = "lon"
   basin&lat = lat
   basin&lon = lon
   basin@long_name = "Basin field"
   basin@units = ""
   
   system("rm -f " + fileout)
   fout = addfile(fileout, "c")
   globalAtt = True
   time = systemfunc("date +'%Y-%m-%d %H:%M:%S'")
   globalAtt@history = "Calculated by ouyuyuan at " + time
   fileattdef(fout, globalAtt)
   fout->basin = basin

end
