
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-12-30 19:33:18 BJT
; Last Change: 2015-01-17 07:36:24 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure rmSeasonCycle(fmn, fout, varName)
begin
  var = fmn->$varName$
  clm = dim_avg_n_Wrap(var,0)
  clmC = conform(var, clm, (/1,2/))

  fout->$varName$ = (/clmC/)
end

begin
  mnfile = "/snfs01/ou/data/pcom/pcom_bcf_mn.nc"
  outfile = "/snfs01/ou/data/pcom/pcom_bcf_exp49.nc"

  system("cp -f "+mnfile+" "+outfile)

  fmn = addfile( mnfile, "r" )
  fout = addfile( outfile, "w" )
  rmSeasonCycle(fmn, fout, "bcu")
  rmSeasonCycle(fmn, fout, "bcv")
  rmSeasonCycle(fmn, fout, "bct")
  rmSeasonCycle(fmn, fout, "bcs")
;  rmSeasonCycle(fmn, fout, "bcp")
  rmSeasonCycle(fmn, fout, "emp")
  rmSeasonCycle(fmn, fout, "ddd")

  fout@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
end
