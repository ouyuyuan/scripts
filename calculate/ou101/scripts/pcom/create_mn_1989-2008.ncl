
; Description: create climatory monthly mean 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-06 20:37:58 BJT
; Last Change: 2014-12-23 07:58:26 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
  yb = 1989
  ye = 2008

  dir = "/snfs01/ou/data/pcom/"
  outfile = dir+"pcom_bcf_mn_1989-2008.nc"
  refile = dir+"pcom_bcf_mn_re.nc"
  mnfile = dir+"pcom_bcf_mn.nc"

  tb = (yb - 1948) * 12
  te = (ye - 1948 + 1) * 12 - 1
  f = addfile( refile, "r" )
  bct_re = f->bct(tb:te,:,:)
  bcu_re = f->bcu(tb:te,:,:)
  bcv_re = f->bcv(tb:te,:,:)
  bcp_re = f->bcp(tb:te,:,:)
  bcs_re = f->bcs(tb:te,:,:)
  emp_re = f->emp(tb:te,:,:)
  ddd_re = f->ddd(tb:te,:,:)
  delete(f)

  system("cp -f " + mnfile+" "+outfile)
  f = addfile( outfile, "w" )
  f->bct = (/clmMonTLL(bct_re)/)
  f->bcu = (/clmMonTLL(bcu_re)/)
  f->bcv = (/clmMonTLL(bcv_re)/)
  f->bcs = (/clmMonTLL(bcs_re)/)
  f->bcp = (/clmMonTLL(bcp_re)/)
  f->emp = (/clmMonTLL(emp_re)/)
  f->ddd = (/clmMonTLL(ddd_re)/)

  f@data = "monthly mean boundary conditon data"
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
  delete(f)
end
