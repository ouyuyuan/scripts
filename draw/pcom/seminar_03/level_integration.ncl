
; Description: cal. level integration
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-11-17 09:45:37 CST
; Last Change: 2013-11-18 13:17:44 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
   
   in_file = "../climate_031-050.nc"
   out_file = "../level_integration_031-050.nc"

   system("/bin/rm -f " + out_file)

   fin = addfile(in_file, "r")
   fout = addfile(out_file, "c")

   u = fin->u
   v = fin->v

   ; cal. thickness of layers
   ;
   lev = fin->z
   nz = dimsizes(lev)
   nx = dimsizes(fin->lon)
   ny = dimsizes(fin->lat)

   lay = new(nz, float)
   lay = 0

;   printVarSummary(lev)
;   printVarSummary(lay)
   ; the first level is at the surface
   lay(0) = (lev(0) + lev(1)) / 2.0

   do i = 1, nz-1
      lay(i) = (lev(i)-sum(lay)) * 2.0
      if ( lay(i) .le. 0 ) then
         print("Layer thickness less then zero. Stop.")
         return
      end if
   end do

;   print(lay)

   u_int = new((/ny,nx/), float)
   v_int = new((/ny,nx/), float)

   do j = 0, ny-1
      do i = 0, nx-1
         u_int(j,i) = sum(u(0,:,j,i)*lay)
         v_int(j,i) = sum(v(0,:,j,i)*lay)
      end do
   end do

   u_int!0 = "lat"
   u_int!1 = "lon"
   u_int&lat = u&lat
   u_int&lon = u&lon
   u_int@long_name = "u_int"
   u_int@units = "m^2/s"

   v_int!0 = "lat"
   v_int!1 = "lon"
   v_int&lat = v&lat
   v_int&lon = v&lon
   v_int@long_name = "v_int"
   v_int@units = "m^2/s"

   fout->u_int = u_int
   fout->v_int = v_int

;  printVarSummary(t)

end
