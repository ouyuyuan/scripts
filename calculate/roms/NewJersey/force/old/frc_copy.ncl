
; Description: create atmospheric forcing field by copy the original data
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-23 08:28:47 BJT
; Last Change: 2014-08-16 09:06:15 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  data_dir = "/home/ou/archive/models/roms/roms_734/Apps/latte/in/"

  vars = (/"Uwind", "Vwind", "Swrf", "Lwrf", "Tair", "Pair", "Qair"/)
  do i = 0, dimsizes(vars) - 1
    cdl = "frc_bulk_" + vars(i) + ".cdl"
    nc_old = data_dir + "frc_latte_wrf_" + vars(i) + ".nc"
    nc_new = data_dir + "frc_bulk_" + vars(i) + ".nc"

    cmd = "ncgen -o " + nc_new + " " + cdl
    print(cmd+"")
    system(cmd)

    fo = addfile( nc_old, "r")
    fn = addfile( nc_new, "w")
    fn->$vars(i)$ = (/fo->$vars(i)$/)
    fn->time = (/fo->ncep_time/)
    delete(fo)
    delete(fn)
  end do

end
