
; Description: use the 500 years running result as the initial field
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-09 15:14:45 BJT
; Last Change: 2014-10-09 15:36:53 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  data_dir = "/home/ou/archive/data/pcom/input/"
  infile = data_dir + "pcom_ini.nc"
  clmfile = "home/ou/archive/data/pcom/moc_re_s/post/climate_mean_0491-0500.nc"
  outfile  = data_dir + "pcom_ini_500yr.nc"

  system("cp -f " + infile + " " + outfile)
  f = addfile( outfile, "w" )
  fc = addfile( clmfile, "r" )
  f->ct = fc->pt(0,:,:,:)
  f->sa = fc->sa(0,:,:,:)
  f->
end
