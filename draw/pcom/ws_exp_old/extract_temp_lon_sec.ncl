
; Description: extract meridional sections of temperature from
;              initial field and several climatory files
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-25 20:45:06 BJT
; Last Change: 2014-11-12 20:47:39 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

function get_lon_sec(nc:string, var:string, lon:numeric)
local f, t1, t2 
begin
  f = addfile( nc, "r" )
  t = f->$var$(:,:,{lon})
  delete(f)
  return t
end

begin

  outfile = getenv("NCL_ARG_1")
  system("rm -f " + outfile)
  f = addfile(outfile, "c")

  ; 150.5 W
  lon = 360 - 150.5
  lon_p = 360 - 150.5 ; Pacific
  lon_a = 360 - 25.5  ; Alantic
  lon_i = 65.5 ; Indian
  infile = "/home/ou/archive/data/pcom/input/pcom_ini.nc"
  f->ini = get_lon_sec(infile, "ct", lon)
  infile = "/home/ou/archive/data/pcom/zy_ex_3g/climate_y51-y60.nc"
  f->zy = get_lon_sec(infile, "pt", lon)
  infile = "/home/ou/archive/data/pcom/climate/moc_re_s/climate_y491-y500.nc"
  f->spinup = get_lon_sec(infile, "pt", lon)
  infile = "/home/ou/archive/data/pcom/exp07_fkh0/climate_y541-y550.nc"
  f->fkh0 = get_lon_sec(infile, "pt", lon)
  infile = "/home/ou/archive/data/pcom/exp08_fkh1/climate_y541-y550.nc"
  f->fkh1 = get_lon_sec(infile, "pt", lon)
  f->control = get_lon_sec(infile, "pt", lon)
  f->control_p = get_lon_sec(infile, "pt", lon_p)
  f->control_a = get_lon_sec(infile, "pt", lon_a)
  f->control_i = get_lon_sec(infile, "pt", lon_i)

  infile = "/home/ou/archive/data/pcom/exp09_fkh2/climate_y541-y550.nc"
  f->fkh2 = get_lon_sec(infile, "pt", lon)

  infile = "/home/ou/archive/data/pcom/exp10_ws_sh/climate_y541-y550.nc"
  f->exp_sh = get_lon_sec(infile, "pt", lon)
  infile = "/home/ou/archive/data/pcom/exp11_ws_nh/climate_y541-y550.nc"
  f->exp_nh = get_lon_sec(infile, "pt", lon)
  infile = "/home/ou/archive/data/pcom/exp12_ws_sm/climate_y541-y550.nc"
  f->exp_sm = get_lon_sec(infile, "pt", lon)
  infile = "/home/ou/archive/data/pcom/exp13_ws_nm/climate_y541-y550.nc"
  f->exp_nm = get_lon_sec(infile, "pt", lon)
  infile = "/home/ou/archive/data/pcom/exp14_ws_eq/climate_y541-y550.nc"
  f->exp_eq = get_lon_sec(infile, "pt", lon)

  indir = "/home/ou/archive/data/pcom/"
  clm = "climate_y541-y550.nc"

  infile = indir+"exp16_ws_15S-15N/"+clm
  f->ex_15S15N_p = get_lon_sec(infile, "pt", lon_p)
  f->ex_15S15N_a = get_lon_sec(infile, "pt", lon_a)
  f->ex_15S15N_i = get_lon_sec(infile, "pt", lon_i)

  infile = indir+"exp15_ws_60S-60N/"+clm
  f->ex_60S60N_p = get_lon_sec(infile, "pt", lon_p)
  f->ex_60S60N_a = get_lon_sec(infile, "pt", lon_a)
  f->ex_60S60N_i = get_lon_sec(infile, "pt", lon_i)

  f@data = "Sections of potential temperature at longitude 150.5W"
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
  delete(f)

end
