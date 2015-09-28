
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-08 09:14:01 BJT
; Last Change: 2014-10-08 09:22:15 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  data_dir = "/home/ou/archive/data/pcom/moc_re_s/post"
  fname    = data_dir + "/climate_mean_0491-0500.nc"
  outfile  ="/home/ou/archive/data/pcom/plot/core/" + getenv("NCL_ARG_0_base") + ".nc"

  lon = 292.5
  f = addfile( fname, "r" )
  u = f->u(0,:,:,{lon})
  delete(f)

  system("rm -f " + outfile)
  f = addfile(outfile, "c")
  f->cn = u
  f@data = "climatory u at Drake passage slice, at " + lon  + " degree longitude"
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")

end
