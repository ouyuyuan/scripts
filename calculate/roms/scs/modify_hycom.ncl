
; Description: modify hycom's initial data to use with create_init.m
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-09-02 08:22:24 BJT
; Last Change: 2014-09-04 16:17:42 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  data_dir = "/home/ou/archive/data/roms/scs/"
  fname_o = data_dir + "hycom_init.nc"
  fname_n = data_dir + "hycom_init_modified.nc"
srcname = '/home/ou/archive/data/roms/scs/hycom_init.nc';
  fname_ori = data_dir + "init_soda.nc"
  fname_new = data_dir + "init.nc"

  fo = addfile( fname_ori, "r" )
  fn = addfile( fname_new, "w" )
;  fn->zeta = fo->zeta
;  fn->ubar = fo->ubar
;  fn->vbar = fo->vbar
;  fn->u = fo->u
;  fn->v = fo->v
;  fn->temp = fo->temp
  fn->salt = fo->salt

end
