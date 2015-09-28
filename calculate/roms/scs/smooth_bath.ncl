
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-23 08:28:47 BJT
; Last Change: 2014-09-09 08:51:59 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  nc_grid = "/home/ou/archive/data/seagrid/scs/seagrid_new.nc"

  f = addfile( nc_grid, "w" )
  m = f->mask_rho
  h = f->h
  h = h*m   ; may be hand-edit, so multiply to mask out h

  n = 2
  do i = 1, n
    print("Smooth " + i + "nd time...")
    h = smth9( h, 0.5, 0.25, False )
  end do
  f->h = h

end
