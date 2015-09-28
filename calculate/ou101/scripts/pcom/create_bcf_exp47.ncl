
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-12-30 19:33:18 BJT
; Last Change: 2015-01-02 10:24:59 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure change_clm(fan, fmn, fout, varName)
begin
  var = fan->$varName$
  clm = fmn->$varName$
  varNew = var

  dims = dimsizes(var)
  nt = dims(0)
  nlat = dims(1)
  nlon = dims(2)
  ny = nt/12

  ; use clm in bcf_mn.nc to sub. bcf_mn_re.nc
  if varName.eq."bct" .or. \
     varName.eq."bcs" .or. \
     varName.eq."emp" .or. \
     varName.eq."ddd"
    do month = 1, 12
      i = month-1
      mon_c_mn = conform_dims( (/ny,nlat,nlon/), clm(i,:,:), (/1,2/) )
      varNew(i::12,:,:) = (/mon_c_mn/)
    end do
  end if

  fout->$varName$ = (/varNew/)
end

begin
  anfile = "/snfs01/ou/data/pcom/pcom_bcf_mn_re.nc"
  mnfile = "/snfs01/ou/data/pcom/pcom_bcf_mn.nc"
  outfile = "/snfs01/ou/data/pcom/pcom_bcf_exp47.nc"

  system("cp -f "+anfile+" "+outfile)

  fan = addfile( anfile, "r" )
  fmn = addfile( mnfile, "r" )
  fout = addfile( outfile, "w" )
  change_clm(fan, fmn, fout, "bcu")
  change_clm(fan, fmn, fout, "bcv")
  change_clm(fan, fmn, fout, "bct")
  change_clm(fan, fmn, fout, "bcs")
  change_clm(fan, fmn, fout, "bcp")
  change_clm(fan, fmn, fout, "emp")
  change_clm(fan, fmn, fout, "ddd")

  fout@data = "clm of bcf_mn.nc sub. values of bcf_mn_re.nc"
  fout@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
end
