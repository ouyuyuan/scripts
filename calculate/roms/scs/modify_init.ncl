
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-09-02 08:22:24 BJT
; Last Change: 2014-09-09 15:17:49 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  data_dir = "/home/ou/archive/models/roms/roms_734/Apps/scs/in/"
  fname_ori = data_dir + "init_ori.nc"
  fname_new = data_dir + "init.nc"

  cmd = "cp -f " + fname_ori + " " + fname_new
  print(cmd + "")
  system(cmd)

  f = addfile( fname_new, "w" )
  print("modify zeta ...")
  var = f->zeta(0,:,:)
  var = 0
  f->zeta(0,:,:) = (/var/)
  delete(var)
  print("modify ubar ...")
  var = f->ubar(0,:,:)
  var = 0
  f->ubar(0,:,:) = (/var/)
  delete(var)
  print("modify vbar ...")
  var = f->vbar(0,:,:)
  var = 0
  f->vbar(0,:,:) = (/var/)
  delete(var)
  print("modify u ...")
  var = f->u(0,:,:,:)
  var = 0
  f->u(0,:,:,:) = (/var/)
  delete(var)
  print("modify v ...")
  var = f->v(0,:,:,:)
  var = 0
  f->v(0,:,:,:) = (/var/)
  delete(var)
  print("modify temp ...")
  var = f->temp(0,:,:,:)
  var = 0
  f->temp(0,:,:,:) = (/var/)
  delete(var)
  print("modify salt ...")
  var = f->salt(0,:,:,:)
  var = 0
  f->salt(0,:,:,:) = (/var/)
  delete(var)

end
