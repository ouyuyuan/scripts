
; Description: Global and Atlantic Meridional Overturning Circulation
;              VV = definite integrate v(x,y,z) from west to east
;              phi = indefinite integrate VV(y,z) from surface to bottom, 
;                    minus sign if needed
;
;              Two places needed change when new model added in: 
;                  the paths of nc files and the variable names in nc files
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-03-31 09:10:53 BJT
; Last Change: 2015-03-21 21:27:10 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; get data
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

datDir    = getenv("NCL_ARG_1")
fileBasin = datDir+"../basin.nc"
fileGrid  = datDir+"../grid_info.nc"
fileIn    = datDir + "post/climate_791-800.nc"
fileOut   = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"

f   = addfile(fileIn, "r")
v   = f->v(0, :, :, :)
delete(f)

f     = addfile(fileBasin, "r")
basin = f->basin
delete(f)
basinC = conform(v, basin, (/1,2/))
Atlantic_id = 6 ; 6 represents Atlantic in the basin file

basinAtl = where(basinC.eq.Atlantic_id, basinC, basinC@_FillValue)
basinGlo = basinC

f  = addfile(fileGrid, "r")
dx = f->dx(:,:)
dz = f->dz(:)
delete(f)
dxC = conform(v, dx, (/1,2/))

;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; integration <<<1
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

function calc_moc(mybasin)
;{{{
local dzC, VV, phi, myv
begin
   myv = v
   myv = where(.not.ismissing(mybasin), v, v@_FillValue)
   lev = v&z
   lat = v&lat
   nlev = dimsizes(lev)

   ; west to east integration of VV
   VV = dim_sum_n_Wrap( myv*dxC, 2)

   ; vertical indefinite integration
   ;
   if (isdouble(dz)) then
      dzC = conform_dims(dimsizes(VV), doubletofloat(dz), 0)
   else
      dzC = conform_dims(dimsizes(VV), dz, 0)
   end if

   t = VV * dzC
   phi = VV ; get coordinates
   phi = 0
   do i = 0, nlev - 1
   ;  phi(i,:) = - dim_sum_n(t(0:i,:), 0) ; if the sign of the result is not correct
      phi(i,:) = dim_sum_n(t(0:i,:), 0)
   end do
   delete(t)
   phi = where(ismissing(VV) .eq. "True", myv@_FillValue, phi)
   phi = smth9_Wrap(phi, 0.5, 0.25, True)
   phi = phi*10^-6 ; Sv

   phi!0 = "lev"
   phi!1 = "lat"
   phi&lev = lev 
   phi&lat = lat
   phi@units = "Sv"
   phi@long_name = "meridional overturning circulation"

   return phi
end
;}}}

system("rm -f " + fileOut)
f = addfile(fileOut, "c")
f->moc_Atl = calc_moc(basinAtl)
f->moc_Glo = calc_moc(basinGlo)
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
