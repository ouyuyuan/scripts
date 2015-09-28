
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-09-04 20:10:18 BJT
; Last Change: 2014-09-09 09:33:47 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  data_dir = "/home/ou/archive/models/roms/roms_734/Apps/scs/in/"
  nc_init = data_dir + "init.nc"
  nc_grid = data_dir + "seagrid.nc"

  f = addfile( nc_grid, "r" )
  mask_rho = f->mask_rho
  mask_u   = f->mask_u
  mask_v   = f->mask_v
  delete(f)

  fv = default_fillvalue(typeof(mask_rho))
  mask_rho@_FillValue = fv
  mask_u@_FillValue = fv
  mask_v@_FillValue = fv

  mask_rho = where(mask_rho.eq.0, fv, mask_rho)
  mask_u = where(mask_u.eq.0, fv, mask_u)
  mask_v = where(mask_v.eq.0, fv, mask_v)

  f = addfile( nc_init, "w" )

  var = f->zeta(0,:,:)
  var = var * mask_rho
  var = smth9( var, 0.5, 0.25, False )
  f->zeta(0,:,:) = (/var/)
  delete(var)

  var = f->ubar(0,:,:)
  var = var * mask_u
  var = smth9( var, 0.5, 0.25, False )
  f->ubar(0,:,:) = (/var/)
  delete(var)

  var = f->vbar(0,:,:)
  var = var * mask_v
  var = smth9( var, 0.5, 0.25, False )
  f->vbar(0,:,:) = (/var/)
  delete(var)

  var = f->temp(0,:,:,:)
  var = var * conform(var, mask_rho, (/1,2/))
  var = smth9( var, 0.5, 0.25, False )
  f->temp(0,:,:,:) = (/var/)
  delete(var)

  var = f->salt(0,:,:,:)
  var = var * conform(var, mask_rho, (/1,2/))
  var = smth9( var, 0.5, 0.25, False )
  f->salt(0,:,:,:) = (/var/)
  delete(var)

  var = f->u(0,:,:,:)
  var = var * conform(var, mask_u, (/1,2/))
  var = smth9( var, 0.5, 0.25, False )
  f->u(0,:,:,:) = (/var/)
  delete(var)

  var = f->v(0,:,:,:)
  var = var * conform(var, mask_v, (/1,2/))
  var = smth9( var, 0.5, 0.25, False )
  f->v(0,:,:,:) = (/var/)
  delete(var)

end
