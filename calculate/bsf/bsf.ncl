
; Description: cal. barotropic stream function
;              ref. licom_wfc.ncl
;              UU = sum( u(x,y,z)*delta(z) ), definite integration from 
;                   sea bottom to surface.
;              phi = int( UU(x,y) dy ), indefinte integration, 
;                    from north to south.
;
;       Usage: run_ncl this.ncl licom/pcom/pcom_r/soda
;              or ./bsf.sh to cal. all models at one time.
;
;              New model added in should change two place: nc file path and
;                variable field in nc files
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-03-29 11:20:52 BJT
; Last Change: 2014-04-14 15:19:09 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   ; dirs, files <<<1

   model = getenv("NCL_ARG_1")

   if ( model .eq. "soda" ) then
      in_dir = "/home/ou/archive/data/soda/climate/"
      filename_in  = in_dir + "climate_1981-2000.nc"
   else if ( model .eq. "licom" ) then
      in_dir = "/home/ou/archive/data/licom/climate/unmodified/"
      filename_in  = in_dir + "climate_081-100_soda_level.nc"
   else if ( model .eq. "pcom" ) then
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
   filename_out = out_dir + "bsf.nc"

   f = addfile(filename_in, "r")

   ; field <<<1

   if ( model .eq. "soda" ) then
      u = f->u
      lev = u&depth
   else if ( model .eq. "licom" ) then
      u = f->us(0, :, ::-1, 0:359)
      lev = u&lev
   else if ( model .eq. "pcom" .or. model .eq. "pcom_r") then
      u = f->u(0, :, :, :)
      lev = u&z
   else
      print("unkown model: " + model)
      return
   end if
   end if
   end if

   lat = u&lat
   lon = u&lon

   ; cal. barotropic UU <<<2

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

   ; barotropic UU: vertically integrate u
   t = conform_dims(dimsizes(u), dlev, 0)
   UU = dim_sum_n_Wrap( u*t, 0)
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
   dy = conform_dims(dimsizes(UU), dy_1d, 0)

   ; indefinite integration
   t = UU * dy
   phi = UU*0
   do i = 0, nlat - 1
      ; from north to south
      phi(i,:) = dim_sum_n(t(i:,:), 0)
      ; from sourth to north, wrong
;      phi(i,:) = dim_sum_n(t(:i,:), 0)
   end do
   delete(t)
   phi = where(ismissing(UU) .eq. "True", u@_FillValue, phi)
   phi = smth9_Wrap(phi, 0.50, 0.25, True)

   ; output <<<1

   phi!0 = "lat"
   phi!1 = "lon"
   phi&lat = lat
   phi&lon = lon
   phi@long_name = "barotropic stream function"
   phi@units = "Sv"

   system("rm -f " + filename_out)
   fout = addfile(filename_out, "c")
   fout->bsf = phi(:,:)

end
