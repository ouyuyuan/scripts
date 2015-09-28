
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-30 20:51:56 BJT
; Last Change: 2014-11-13 09:27:36 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

function get_ssh(filename)
local f
begin
  f = addfile( filename, "r" )
  ssh = f->ssh
  delete(f)
  return ssh
end

outfile = getenv("NCL_ARG_1")
system("rm -f " + outfile)
f = addfile(outfile, "c")

dir = "/home/ou/archive/data/pcom/"
clm = "climate_y541-y550.nc"

f->control   = get_ssh(dir+"exp08_fkh1/"+clm)
f->an_70S30S = get_ssh(dir+"exp10_ws_sh/"+clm)
f->an_30N60N = get_ssh(dir+"exp11_ws_nh/"+clm)
f->an_40S10S = get_ssh(dir+"exp12_ws_sm/"+clm)
f->an_EQ30N  = get_ssh(dir+"exp13_ws_nm/"+clm)
f->an_10S20N = get_ssh(dir+"exp14_ws_eq/"+clm)
f->an_15S15N = get_ssh(dir+"exp16_ws_15S-15N/"+clm)
f->an_60S60N = get_ssh(dir+"exp15_ws_60S-60N/"+clm)

clm = "climate_y0055-y0064.nc"
f->ctr64 = get_ssh(dir+"exp17_ws_control_cycle_re/"+clm)
f->an_ao = get_ssh(dir+"exp18_ws_an_ao/"+clm)

f@data = "Sea surface height"
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
