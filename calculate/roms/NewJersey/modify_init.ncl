
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-23 08:28:47 BJT
; Last Change: 2014-08-02 20:27:50 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  fname_ori = "/home/ou/archive/data/roms/latte/in/lattec_ini_94_modified.nc"
  fname_new = "/home/ou/archive/data/roms/latte/in/init.nc"

  fo = addfile( fname_ori, "r" )
  fn = addfile( fname_new, "w" )
  fn->temp = fo->temp
  fn->salt = fo->salt
  fn->u = fo->u
  fn->v = fo->v
  fn->ubar = fo->ubar
  fn->vbar = fo->vbar
  fn->zeta = fo->zeta

end
