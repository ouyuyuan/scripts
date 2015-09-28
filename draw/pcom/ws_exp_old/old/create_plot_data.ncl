
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-14 08:49:08 BJT
; Last Change: 2014-10-14 09:06:04 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  datadir = "/home/ou/archive/data/pcom/plot/ws_exp/"

  infile = datadir + "control_thc_0541-0550_ferret.nc"
  f = addfile( infile, "r" )
  gt_c = f->dtdz_f(0,:,:,:)
  delete(f)
  gt_c@long_name = "control run"

  infile = datadir + "an-eq_thc_0541-0550_ferret.nc"
  f = addfile( infile, "r" )
  gt_a = f->dtdz_f(0,:,:,:)
  delete(f)
  gt_a@long_name = "add wind stress anormally at equator"

  gt_d = gt_c
  gt_d = gt_a - gt_c
  gt_d@long_name = "anormaly run - control run"

  outfile = datadir + "/thc_0541-0550.nc"
  system("rm -f " + outfile)
  f = addfile(outfile, "c")
  f->gt_c = gt_c
  f->gt_a = gt_a
  f->gt_d = gt_d
  f@data = "temperature gradient in vertical direction"
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
  delete(f)

end
