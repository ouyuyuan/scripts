
; Description: extract sections of equatior temperature from several 
;              initial field and several climatory files
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-25 16:24:15 BJT
; Last Change: 2014-10-27 13:26:43 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

function get_eq_filed(nc:string, var:string)
local f, t1, t2 
begin
  f = addfile( nc, "r" )
  t1 = f->$var$(:,{-0.5},:)
  t2 = f->$var$(:,{0.5},:)
  delete(f)

  t = t1
  t = ( t1 + t2 ) * 0.5
  return t
end

begin

  outfile = getenv("NCL_ARG_1")
  system("rm -f " + outfile)
  f = addfile(outfile, "c")

  infile = "/home/ou/archive/data/pcom/input/pcom_ini.nc"
  f->ini = get_eq_filed(infile, "ct")
  infile = "/home/ou/archive/data/pcom/climate/zy_ex_3g/climate_y51-y60.nc"
  f->zy = get_eq_filed(infile, "pt")
  infile = "/home/ou/archive/data/pcom/climate/moc_re_s/climate_y491-y500.nc"
  f->spinup = get_eq_filed(infile, "pt")
  infile = "/home/ou/archive/data/pcom/exp07_fkh0/climate_y541-y550.nc"
  f->fkh0 = get_eq_filed(infile, "pt")
  infile = "/home/ou/archive/data/pcom/exp08_fkh1/climate_y541-y550.nc"
  f->fkh1 = get_eq_filed(infile, "pt")
  f->control = get_eq_filed(infile, "pt")
  infile = "/home/ou/archive/data/pcom/exp09_fkh2/climate_y541-y550.nc"
  f->fkh2 = get_eq_filed(infile, "pt")
  infile = "/home/ou/archive/data/pcom/exp10_ws_sh/climate_y541-y550.nc"
  f->exp_sh = get_eq_filed(infile, "pt")
  infile = "/home/ou/archive/data/pcom/exp11_ws_nh/climate_y541-y550.nc"
  f->exp_nh = get_eq_filed(infile, "pt")
  infile = "/home/ou/archive/data/pcom/exp12_ws_sm/climate_y541-y550.nc"
  f->exp_sm = get_eq_filed(infile, "pt")
  infile = "/home/ou/archive/data/pcom/exp13_ws_nm/climate_y541-y550.nc"
  f->exp_nm = get_eq_filed(infile, "pt")
  infile = "/home/ou/archive/data/pcom/exp14_ws_eq/climate_y541-y550.nc"
  f->exp_eq = get_eq_filed(infile, "pt")

  f@data = "Sections of potential temperature at equator"
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
  delete(f)

end
