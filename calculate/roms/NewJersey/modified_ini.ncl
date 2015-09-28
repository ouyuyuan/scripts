
; Description: modified variable hc in initial data for using Vtransform=2
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-12-28 09:29:26 BJT
; Last Change: 2014-09-02 08:20:24 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
   data_dir = "/home/ou/archive/data/roms/latte/in"

   nc = addfile(data_dir + "/lattec_ini_94_modified.nc", "w")
   nc->hc = 50;

end
