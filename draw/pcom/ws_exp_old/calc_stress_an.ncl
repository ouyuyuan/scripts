
; Description: zonal average wind stress (profile) (only account zonal wind)
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:43:19 BJT
; Last Change: 2014-11-08 10:42:17 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

function calc_mean_taux(nc:string)
local f, bcu
begin
  f = addfile( nc, "r" )
  bcu = f->bcu
  delete(f)

  taux = dim_avg_n_Wrap(bcu, 0)
  return taux
end

begin

  outfile = getenv("NCL_ARG_1")
  system("rm -f " + outfile)
  f = addfile(outfile, "c")

  indir = "/home/ou/archive/data/pcom/input/"

  infile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn.nc"
  control = calc_mean_taux(infile)
  f->control = control

  infile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn_an_sh.nc"
  sh = calc_mean_taux(infile)
  sh = sh - control
  sh@long_name = "anormaly to control run"
  f->sh = sh

  infile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn_an_sm.nc"
  sm = calc_mean_taux(infile)
  sm = sm - control
  sm@long_name = "anormaly to control run"
  f->sm = sm

  infile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn_an_eq.nc"
  eq = calc_mean_taux(infile)
  eq = eq - control
  eq@long_name = "anormaly to control run"
  f->eq = eq

  infile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn_an_nm.nc"
  nm = calc_mean_taux(infile)
  nm = nm - control
  nm@long_name = "anormaly to control run"
  f->nm = nm

  infile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn_an_nh.nc"
  nh = calc_mean_taux(infile)
  nh = nh - control
  nh@long_name = "anormaly to control run"
  f->nh = nh

  an = calc_mean_taux(indir+"pcom_bcf_mn_an_15S-15N.nc")
  an = an - control
  an@long_name = "anormaly to control run"
  f->an_15S15N = an

  an = calc_mean_taux(indir+"pcom_bcf_mn_an_60S-60N.nc")
  an = an - control
  an@long_name = "anormaly to control run"
  f->an_60S60N = an

  f@data = "profile of zonal wind stress"
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
  delete(f)

end
