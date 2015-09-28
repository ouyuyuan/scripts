
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-23 08:28:47 BJT
; Last Change: 2014-07-24 06:47:24 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  fname_ori = "/home/ou/archive/data/seagrid/NewJersey/seagrid_manual_mask.nc"
  fname_new = "/home/ou/archive/data/seagrid/NewJersey/seagrid.nc"

  fo = addfile( fname_ori, "r" )
  fn = addfile( fname_new, "w" )
  fn->mask_rho = fo->mask_rho
  fn->mask_psi = fo->mask_psi
  fn->mask_u = fo->mask_u
  fn->mask_v = fo->mask_v

end
