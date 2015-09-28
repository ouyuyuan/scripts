
; Description: create climatory monthly mean 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-06 20:37:58 BJT
; Last Change: 2014-12-23 09:31:33 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
  yb = 1989
  ye = 2008

  dir = "/snfs01/ou/data/pcom/"
  outfile = dir+"pcom_bcf_mn_exp39.nc"
  refile = dir+"pcom_bcf_mn_re.nc"
  mnfile = dir+"pcom_bcf_mn.nc"

  tb = (yb - 1948) * 12
  te = (ye - 1948 + 1) * 12 - 1
  f = addfile( refile, "r" )
  bct_re = f->bct(tb:te,:,:)
  ddd_re = f->ddd(tb:te,:,:)
  delete(f)

  system("cp -f " + mnfile+" "+outfile)
  f = addfile( outfile, "w" )
  f->bct = (/clmMonTLL(bct_re)/)
  f->ddd = (/clmMonTLL(ddd_re)/)

  f@data = "monthly mean boundary conditon data"
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
  delete(f)
end
