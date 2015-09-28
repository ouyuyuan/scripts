
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-04-05 18:03:06 BJT
; Last Change: 2014-04-05 18:14:25 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   ; dirs, files <<<1

   model = getenv("NCL_ARG_1")
   basin = getenv("NCL_ARG_2")

   if ( model .eq. "soda" ) then
      in_dir = "/home/ou/archive/data/soda/climate/"
      filename_in  = in_dir + "climate_1981-2000.nc"
   else if ( model .eq. "licom" ) then
      in_dir = "/home/ou/archive/data/licom/climate/unmodified/"
      filename_in  = in_dir + "climate_081-100.nc"
   else if ( model .eq. "pcom" ) then
      in_dir = "/home/ou/archive/data/pcom/climate/fix_fkh/"
      filename_in  = in_dir + "year_mean_081-100.nc"
   else if ( model .eq. "pcom_r" ) then
      in_dir = "/home/ou/archive/data/pcom/climate/res_s/"
      filename_in  = in_dir + "year_mean_081-100.nc"
   else
      print("unkown model: " + model)
      return
   end if
   end if
   end if
   end if

   out_dir = in_dir + "calculated/"
   system("mkdir -p " + out_dir)
;   filename_out = out_dir + "moc_" + basin + ".nc"
   filename_out = out_dir + "test.nc"

   f = addfile(filename_in, "r")

   ; field <<<1

   if ( model .eq. "soda" ) then
      v = f->v
      lev = v&depth
   else if ( model .eq. "licom" ) then
      v = f->vs(0, :, ::-1, 0:359)
      lev = v&lev * (-1)
   else if ( model .eq. "pcom" .or. model .eq. "pcom_r") then
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

   ; fill out data not belong to the required basin
   ; Atlantic: 75W -- 20E
   ; Atlantic: 60W -- 20E
   ; Indian: 30E -- 115E
   ; Pacific: 120E -- 70W

   if ( basin .eq. "Atlantic" ) then  
      v(:,:,{20:285}) = v@_FillValue
   else if ( basin .eq. "Indian" ) then  
      v(:,:,{150:360}) = v@_FillValue
      v(:,:,{0:30}) = v@_FillValue
   else if ( basin .eq. "Pacific" ) then  
      v(:,:,{280:360}) = v@_FillValue
      v(:,:,{0:120}) = v@_FillValue
   end if
   end if
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
   delete(t)
   VV = dim_sum_n_Wrap( v*dx, 2)

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
   dz = conform_dims(dimsizes(VV), dlev, 0)
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

   phi = VV
   phi!0 = "lev"
   phi!1 = "lat"
   phi&lev = lev 
   phi&lat = lat
;   phi@long_name = basin + " meridional overturning circulation"
;   phi@units = "Sv"

   system("rm -f " + filename_out)
   fout = addfile(filename_out, "c")
   fout->moc = phi(:,:)

end
