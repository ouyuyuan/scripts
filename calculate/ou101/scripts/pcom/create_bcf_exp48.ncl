
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-12-30 19:33:18 BJT
; Last Change: 2015-01-14 17:43:46 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure mn2yr(fmn, fout, varName)
begin
  var = fmn->$varName$
  clm = dim_avg_n_Wrap(var,0)

  fout->$varName$ = (/clm/)
end

begin
  mnfile = "/snfs01/ou/data/pcom/pcom_bcf_mn.nc"
  yrfile = "/snfs01/ou/data/pcom/pcom_bcf_yr.nc"
  outfile = "/snfs01/ou/data/pcom/pcom_bcf_exp48.nc"

  system("cp -f "+yrfile+" "+outfile)

  fmn = addfile( mnfile, "r" )
  fout = addfile( outfile, "w" )
  mn2yr(fmn, fout, "bcu")
  mn2yr(fmn, fout, "bcv")
  mn2yr(fmn, fout, "bct")
  mn2yr(fmn, fout, "bcs")
  mn2yr(fmn, fout, "bcp")
  mn2yr(fmn, fout, "emp")
  mn2yr(fmn, fout, "ddd")

  fout@data = "clm of bcf_mn.nc"
  fout@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
end
