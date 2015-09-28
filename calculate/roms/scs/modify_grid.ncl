
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-23 08:28:47 BJT
; Last Change: 2014-09-09 15:08:34 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  nc_grid = "/home/ou/archive/models/roms/roms_734/Apps/scs/in/seagrid.nc"

  f = addfile( nc_grid, "w" )
;  fn->mask_rho = fo->mask_rho
;  fn->mask_psi = fo->mask_psi
;  fn->mask_u = fo->mask_u
;  fn->mask_v = fo->mask_v
;  fn->h = fo->h
  h = f->h

;  n = 2
;  do i = 1, n
;    print("Smooth " + i + "nd time...")
;    h = smth9( h, 0.5, 0.25, False )
;  end do
  h = 50
  f->h = (/h/)

end
