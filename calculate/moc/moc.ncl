
; Description: Meridional Overturning Circulation
;              VV = definite integrate v(x,y,z) from west to east
;              phi = indefinite integrate VV(y,z) from surface to bottom, minus sign
;       Usage: run_ncl this.ncl licom/pcom_n/pcom_r/soda basinname
;              or ./bsf.sh to cal. all models at one time.
;
;              Two places needed change when new model added in: 
;                  the paths of nc files and the variable names in nc files
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-03-31 09:10:53 BJT
; Last Change: 2015-03-20 10:41:55 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   ; dirs, files <<<1

   model = getenv("NCL_ARG_1")
   if (ismissing(model)) then
      model = "soda"
   end if
   basin = getenv("NCL_ARG_2")
   if (ismissing(basin)) then
      basin = "Global"
   end if

   if ( model .eq. "soda" ) then
      in_dir = "/home/ou/archive/data/soda/climate/"
      filename_in  = in_dir + "climate_1981-2000.nc"
   else if ( model .eq. "licom" ) then
      in_dir = "/home/ou/archive/data/licom/climate/unmodified/"
      filename_in  = in_dir + "climate_081-100_soda_level.nc"
   else if ( model .eq. "pcom_n" ) then
      in_dir = "/home/ou/archive/data/pcom/climate/fix_fkh/"
      filename_in  = in_dir + "year_mean_081-100_soda_level.nc"
   else if ( model .eq. "pcom_r" ) then
      in_dir = "/home/ou/archive/data/pcom/climate/res_s/"
      filename_in  = in_dir + "year_mean_081-100_soda_level.nc"
   else
      print("unkown model: " + model)
      return
   end if
   end if
   end if
   end if

   out_dir = in_dir + "calculated/"
   system("mkdir -p " + out_dir)
   filename_out = out_dir + "moc_" + basin + ".nc"

   f = addfile(filename_in, "r")
   f_basin = addfile("/home/ou/archive/data/licom/basin.nc", "r")
;   f_basin = addfile("/home/ou/archive/data/licom/basin_hand.nc", "r")

   ; field <<<1

   if ( model .eq. "soda" ) then
      v = f->v
      lev = v&depth
   else if ( model .eq. "licom" ) then
      v = f->vs(0, :, ::-1, 0:359)
      lev = v&lev
   else if ( model .eq. "pcom_n" .or. model .eq. "pcom_r") then
      v = f->v(0, :, :, :)
      lev = v&z
   else
      print("unkown model: " + model)
      return
   end if
   end if
   end if

   lat = v&lat
   lon = v&lon

   basin_field = f_basin->basin

   if ( basin .eq. "Atlantic" ) then  
      id = 2
   else if ( basin .eq. "Indian" ) then  
      id = 3
   else if ( basin .eq. "Pacific" ) then  
      id = 4
   end if
   end if
   end if

   if ( basin.eq."Atlantic" .or. basin.eq."Indian" .or. basin.eq."Pacific" ) then
      basin_field = where(basin_field .eq. id, 1, 0)
      lat_in = basin_field&lat
      lon_in = basin_field&lon
      if ( model.eq. "licom") then
         basin_mask = basin_field
      else
         basin_mask = linint2_Wrap(lon_in, lat_in, basin_field, True, lon, lat, 0)
      end if
      nlev = dimsizes(lev)
      do i=0,nlev-1
         v(i,:,:) = where(basin_mask .gt. 0.5, v(i,:,:), v@_FillValue)
      end do
   end if

   ; cal. zonal VV <<<1

   ; cal. longitude band for each grid
   nlon = dimsizes(lon)
   dlon = lon*0
   dlon(0) = ( lon(0) + lon(1) ) * 0.5 - lon(0) +  \
             ( lon(0) + 360 + lon(nlon-1) ) * 0.5 - lon(nlon-1)
   do i = 1, nlon - 2
;      dlon(i) = ( lon(i) + lon(i+1) ) * 0.5 - ( lon(i-1) + lon(i) ) * 0.5
      dlon(i) = ( lon(i+1) - lon(i-1) ) * 0.5
   end do
   dlon(nlon-1) = ( lon(0) + 360.0 - lon(nlon-2) ) * 0.5
;   print(dlon+0)

   ; definte integration from west to east
   t = dlon * 6.371 * 3.14159265 / 180.0 ; unit: Sv
   dx = conform_dims(dimsizes(v), t, 2)
   wgt = cos(lat*3.14159265/180.0)
   wgt_con = conform_dims(dimsizes(v), wgt, 1)
   delete(t)
   VV = dim_sum_n_Wrap( v*dx*wgt_con, 2)
;   printVarSummary(VV)

   ; cal. vertical indefinite integration <<<1

   ; cal. thickness of each layer
   ; assume velecity is on the center of each layer
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
   ; assume the last depth of the model is the sea bottom
   dlev(nlev-1) = 0.5*dlev(nlev-1)

   ; indefinite integration
   if (isdouble(dlev)) then
      dz = conform_dims(dimsizes(VV), doubletofloat(dlev), 0)
   else
      dz = conform_dims(dimsizes(VV), dlev, 0)
   end if
   t = VV
   t = VV * dz
   phi = VV*0
   do i = 0, nlev - 1
;      phi(i,:) = - dim_sum_n(t(0:i,:), 0)
      phi(i,:) = dim_sum_n(t(0:i,:), 0)
   end do
   delete(t)
   phi = where(ismissing(VV) .eq. "True", v@_FillValue, phi)
   phi = smth9_Wrap(phi, 0.5, 0.25, True)

   ; output <<<1

   phi!0 = "lev"
   phi!1 = "lat"
   phi&lev = lev 
   phi&lat = lat
   phi@long_name = basin + " meridional overturning circulation"
   phi@units = "Sv"

   system("rm -f " + filename_out)
   fout = addfile(filename_out, "c")
   fout->moc = phi(:,:)

end
