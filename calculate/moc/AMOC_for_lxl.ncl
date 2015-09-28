
; Description: Meridional Overturning Circulation
;              VV = definite integrate v(x,y,z) from west to east
;              phi = indefinite integrate VV(x,z) from surface to bottom, minus sign
;       Usage: run_ncl this.ncl licom/pcom_n/pcom_r/soda basinname
;              or ./bsf.sh to cal. all models at one time.
;
;              New model added in should change two place: nc file path and
;                variable field in nc files
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-03-31 09:10:53 BJT
; Last Change: 2015-03-19 08:01:30 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   ; dirs, files <<<1

   in_dir = "/home/ou/archive/data/licom/climate/unmodified/"
   filename_in  = in_dir + "climate_081-100_soda_level.nc"

   filename_out = "AMOC_for_lxl.nc" 

   f = addfile(filename_in, "r")
   f_basin = addfile("/home/ou/archive/data/licom/basin.nc", "r")

   ; field <<<1

   v = f->vs(0, :, ::-1, 0:359)
   lev = v&lev

   lat = v&lat
   lon = v&lon

   basin = f_basin->basin

   id = 2

   basin = where(basin .eq. id, 1, 0)
   nlev = dimsizes(lev)
   do i=0,nlev-1
      v(i,:,:) = where(basin .gt. 0.5, v(i,:,:), v@_FillValue)
   end do

   ; cal. zonal VV <<<1

   ; cal. longitude band for each grid
   nlon = dimsizes(lon)
   dlon = lon*0
   dlon = lon(2) - lon(1)

   ; definte integration from west to east
   t = dlon * 6.371 * 3.14159265 / 180.0 ; unit: Sv
   dx = conform_dims(dimsizes(v), t, 2)
   wgt = cos(lat*3.14159265/180.0)
   wgt_con = conform_dims(dimsizes(v), wgt, 1)
   delete(t)
   VV = dim_sum_n_Wrap( v*dx*wgt_con, 2)

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
   phi@long_name = "Atlantic meridional overturning circulation"
   phi@units = "Sv"

   system("rm -f " + filename_out)
   fout = addfile(filename_out, "c")
   fout->moc = phi(:,:)

end
