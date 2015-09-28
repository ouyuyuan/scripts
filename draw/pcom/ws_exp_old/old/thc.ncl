
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-12 09:06:46 BJT
; Last Change: 2014-10-12 09:51:53 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  infile = getenv("NCL_ARG_1")
  outdir = getenv("NCL_ARG_2")

  f = addfile( infile, "r" )
  thc = f->thc(0,:,:)
  slopex = f->slopex(0,:,:)
  slopey = f->slopey(0,:,:)
  slope = f->slope(0,:,:)
  delete(f)

  outfile = outdir + "/thc.nc"
  system("rm -f " + outfile)
  f = addfile(outfile, "c")
  f->cn = thc
  f@data = "thc defined by the depth of 20 degC isothermal line"
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
  delete(f)

  outfile = outdir + "/thc_slope.nc"
  system("rm -f " + outfile)
  f = addfile(outfile, "c")
  f->vx = slopex
  f->vy = slopey
  f->sc = slope
  f@data = "thc defined by the depth of 20 degC isothermal line"
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
  delete(f)
  
end
