
; Description: modify the initial file, change ny=162 to 160,
;                and set new fillvalues
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-09-18 08:40:16 BJT
; Last Change: 2015-09-18 10:58:38 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; change missingvalue to fillvalue
procedure missing2fill (var:numeric)
begin
  if ( typeof(var).eq."integer" ) then
    var@_FillValue = -999
  end if
  if ( typeof(var).eq."float" ) then
    var@_FillValue = -9.99999e30
  end if
  var = where(var.gt.10e10, var@_FillValue, var)
  delete(var@missing_value)
end

data_dir = "/media/wd/pcom/input/"
infile = data_dir + "pcom_ini.nc"
outfile  = data_dir+"pcom_ini_mod.nc"

system("rm -f "+outfile)

fin = addfile(infile, "r")
fout =addfile(outfile,"c")

vars = (/"ct","sa","idx","itn","depth","t30","s30"/)
do i = 0, dimsizes(vars)-1
  varName = vars(i)
  var = fin->$varName$
  missing2fill(var)

  if (varName.eq."ct" .or. \
      varName.eq."sa" .or. \
      varName.eq."idx") then
    temp = var(:,{-80:80},:)
    newVar = temp(z|:,lon|:,lat|:)
    delete(temp)
  else if (varName.eq."depth" .or. varName.eq."itn") then
    temp = var({-80:80},:)
    newVar = temp(lon|:,lat|:)
    delete(temp)
  else
    newVar = var
  end if
  end if

  fout->$varName$ = newVar
  delete(var)
  delete(newVar)
end do

fout@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(fout)
