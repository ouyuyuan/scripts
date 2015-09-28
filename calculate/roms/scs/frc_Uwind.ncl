
; Description: create atmospheric forcing field 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-08-31 20:49:44 BJT
; Last Change: 2014-09-01 10:37:32 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/home/ou/archive/scripts/utils/ncl.ncl"

; convert , say "pgbhnl.gdas.2006040100.grb2", to time value
undef("fname2time")
function fname2time(fname:string, units:string)
local y, m, d, h, mi, s, t
begin

y = tointeger(str_get_cols(fname,12,15))
m = tointeger(str_get_cols(fname,16,17))
d = tointeger(str_get_cols(fname,18,19))
h = tointeger(str_get_cols(fname,20,21))
mi = 0
s = 0

t = cd_inv_calendar(y, m, d, h, mi, s, units, 0)

return t
end

begin

  ncgen = True

  cfsr_dir = "/media/CFSR_2/CFSR/6hourly/pgbhnl/3d/2006/04/"
  out_dir = "/home/ou/archive/models/roms/roms_734/Apps/scs/in/"
  nc_grid = out_dir + "seagrid.nc"
  nc_out = out_dir + "frc_Uwind.nc"
  cdl = "frc_Uwind.cdl"

  cfsr_names = systemfunc("cd " + cfsr_dir + " ; ls pgbhnl.gdas.200604*.grb2 | sort")

  Llon=100.0 ; Left   corner longitude
  Rlon=125.0 ; Right  corner longitude
  Blat=-5.0  ; Bottom corner latitude
  Tlat=30.0  ; Top    corner latitude

  if (ncgen) then
    cmd = "ncgen -o " + nc_out + " " + cdl
    print(cmd+"")
    system(cmd)
  end if

  f = addfile( nc_out, "r")
  tunits = f->time@units
  delete(f)

  f = addfile(nc_grid, "r")
  lat2d = f->lat_rho
  lon2d = f->lon_rho
  delete(f)

  date_b = "2006-04-05 00:00:00"
  date_e = "2006-04-16 00:00:00"

  nrecs = dimsizes(cfsr_names)
  do i = 0, nrecs - 1
    cfsr_name = cfsr_names(i)
    nc_cfsr = cfsr_dir + cfsr_name

    print("Extract " + nc_cfsr + " ...")

    f = addfile( nc_cfsr, "r")
    lat = f->lat_0({Blat:Tlat})
    lon = f->lon_0({Llon:Rlon})
    tmp = f->UGRD_P0_L104_GLL0({Blat:Tlat},{Llon:Rlon})
    delete(f)

    if ( i .eq. 0 ) then
      dims = dimsizes(tmp)
      var_cfsr = new( (/nrecs,dims(0),dims(1)/), double )
      delete(dims)
      t_roms = new( (/nrecs/), double )
    end if

    var_cfsr(i,:,:) = 0.01*tmp    ; unit change: Pa to millibar
    t_roms(i) = fname2time(cfsr_name, tunits)
  end do
  delete(tmp)

  f = addfile( nc_out, "w")
  f->time@begin_date = date_b
  f->time@end_date = date_e
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")

  print( "Interpolate to roms grid ..." )
  lon = where( lon.gt.180.0, lon-360.0, lon )
  v_roms = rgrid2rcm( lat, lon, var_cfsr, lat2d, lon2d, 0)
  f->Uwind = (/v_roms/)
  f->time = (/t_roms/)
end
