
; Description: modify zhangyu's vmix.nc
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-12 09:06:46 BJT
; Last Change: 2014-10-21 07:38:11 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  nc = "/home/ou/archive/data/pcom/input/vmix.nc"
  f = addfile( nc, "r" )
  vmix = f->vmix
  delete(f)

  kmin = 0.1
  kmax = 200

  vmix = where(ismissing(vmix), kmin, vmix)
  vmix = where(vmix.lt.kmin, kmin, vmix)
  vmix = where(vmix.gt.kmax, kmax, vmix)
  vmix = smth9( vmix, 0.5, 0.25, False )

  vmix@long_name = "vertical coefficient"
  vmix@units = ""

  nc = "/home/ou/archive/data/pcom/input/vmix_zy_modified.nc"
  system("rm -f " + nc)
  f = addfile( nc, "c" )
  f->vmix = vmix
  f@data = "vertical mixing coefficient, modified ZY's version"
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")

end
