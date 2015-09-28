
; Description: cal. weighted level mean 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-11-17 09:45:37 CST
; Last Change: 2013-11-18 08:17:02 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
   
   in_file = "../climate_031-050.nc"
   out_file = "../level_mean_031-050.nc"

   system("/bin/rm -f " + out_file)

   fin = addfile(in_file, "r")
   fout = addfile(out_file, "c")

   t = fin->pt
   s = fin->sa

   ; cal. thickness of layers
   ;
   lev = fin->z
   n = dimsizes(lev)
   lay = new(n, float)
   lay = 0

;   printVarSummary(lev)
;   printVarSummary(lay)
   ; the first level is at the surface
   lay(0) = (lev(0) + lev(1)) / 2.0

   do i = 1, n-1
      lay(i) = (lev(i)-sum(lay)) * 2.0
      if ( lay(i) .le. 0 ) then
         print("Layer thickness less then zero. Stop.")
         return
      end if
   end do

;   do i = 1, n-2
;      lay(i) = (lev(i) + lev(i+1)) / 2.0 - sum(lay)
;   end do

;   lay(n-1) = lev(n-1) - (lev(n-2) + lev(n-1)) / 2.0
;   lay(n-1) = lay(n-1)*2.0
   
;   print(lay)

   t_mean = dim_avg_wgt_n_Wrap(t, lay, 1, 1)
   s_mean = dim_avg_wgt_n_Wrap(s, lay, 1, 1)
   
   fout->pt = t_mean
   fout->sa = s_mean
;  printVarSummary(t)

end
