
; Description: create atmospheric forcing field 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-23 08:28:47 BJT
; Last Change: 2014-08-23 07:30:46 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/home/ou/archive/scripts/utils/ncl.ncl"

begin

;  ncgen = True
  ncgen = False

  nc_cfsr = "/home/ou/archive/data/roms/latte/cfsr/sec2_2006_01hr_strblk_box.nc"
  out_dir = "/home/ou/archive/models/roms/roms_734/Apps/latte/in/"
  nc_grid = out_dir + "roms_latte_grid_4b.nc"
  cdl = "frc_uvstress.cdl"
  nc_out = out_dir + "frc_uvstress.nc"

  f = addfile(nc_grid, "r")
  lat2d = f->lat_u
  lon2d = f->lon_u
  lat2d2 = f->lat_v
  lon2d2 = f->lon_v
  delete(f)

  date_b = "2006-04-05 00:00:00"
  date_e = "2006-04-30 23:00:00"

  f = addfile( nc_cfsr, "r")
  lat = f->Latitude(:)
  lon = f->Longitude(:)
  t_cfsr = f->time(:)

  tsta = ou_timestring2i(date_b, t_cfsr)
  tend = ou_timestring2i(date_e, t_cfsr)
  tmp = f->tauewd(tsta:tend,:,:)
  tmp2 = f->taunwd(tsta:tend,:,:)
  delete(f)

  var_cfsr = new(dimsizes(tmp), double)
  var_cfsr2 = new(dimsizes(tmp2), double)
  var_cfsr = tmp*tmp@scale_factor + tmp@add_offset
  var_cfsr2 = tmp2*tmp2@scale_factor + tmp2@add_offset
  delete(tmp)
  delete(tmp2)

  if (ncgen) then
    cmd = "ncgen -o " + nc_out + " " + cdl
    print(cmd+"")
    system(cmd)
  end if

  f = addfile( nc_out, "r")
  tunits = f->time@units
  delete(f)
  t_roms = cd_convert( t_cfsr, tunits )

  f = addfile( nc_out, "w")
  f->time@begin_date = date_b
  f->time@end_date = date_e
  f@source = "create by " + getenv("NCL_ARG_0") + " from NCEP_CFSR dataset, " + \
  systemfunc("date")

  lon = where( lon.gt.180.0, lon-360.0, lon )
  v_roms = rgrid2rcm( lat, lon, var_cfsr, lat2d, lon2d, 0)
  v_roms2 = rgrid2rcm( lat, lon, var_cfsr2, lat2d2, lon2d2, 0)

  scale = f->sustr@scale_factor
  f->sustr = doubletoshort( v_roms / scale )
  scale = f->svstr@scale_factor
  f->svstr = doubletoshort( v_roms2 / scale )
  f->time = (/t_roms(tsta:tend)/)
end
