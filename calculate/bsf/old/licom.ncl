load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   ; dirs, files <<<1

   in_dir = "/home/ou/archive/data/licom/climate/unmodified/"
   out_dir = in_dir + "calculated/"

   filename_in  = in_dir + "climate_081-100.nc"
   filename_out = out_dir + "bsf.nc"

   f = addfile(filename_in, "r")

   ; field <<<1

   u = f->us(0, :, ::-1, 0:359)

   lev = u&lev * (-1)
   lat = u&lat
   lon = u&lon

   ; cal. barotropic U <<<2

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

   ; barotropic U: vertically integrate u
   t = conform_dims(dimsizes(u), dlev, 0)
   U = dim_sum_n_Wrap( u*t, 0)
   delete(t)

   ; indefinite integrate Udy <<<2

   ; cal. latitude band for each grid, since latitude is quasi-uniform, we can
   ;   use a simple method to cal. dlat, unlike cal. dlev
   nlat = dimsizes(lat)
   dlat = lat*0
   dlat(0) = ( lat(0) + lat(1) ) * 0.5 - lat(0)
   do i = 1, nlat - 2
;      dlat(i) = ( lat(i) + lat(i+1) ) * 0.5 - ( lat(i-1) + lat(i) ) * 0.5
      dlat(i) = ( lat(i+1) - lat(i-1) ) * 0.5
   end do
   dlat(nlat-1) = lat(nlat-1) - (lat(nlat-1) + lat(nlat-2))*0.5
   
   dy_1d = dlat * 6.371 * 3.14159265 / 180.0 ; unit: Sv
   dy = conform_dims(dimsizes(U), dy_1d, 0)

   ; indefinite integration
   t = U * dy
   phi = U*0
   do i = 0, nlat - 1
      phi(i,:) = dim_sum_n(t(i:,:), 0)
   end do
   delete(t)
   phi = where(ismissing(U) .eq. "True", u@_FillValue, phi)

   ; output <<<1

   phi!0 = "lat"
   phi!1 = "lon"
   phi&lat = lat
   phi&lon = lon
   phi@long_name = "barotropic stream function"
   phi@units = "Sv"

   system("rm " + filename_out)
   fout = addfile(filename_out, "c")
   fout->bsf = phi(:,:)

end
