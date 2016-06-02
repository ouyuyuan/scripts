
; Description: modify the initial file, change ny=162 to 160,
;                and set new fillvalues
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-09-18 08:40:16 BJT
; Last Change: 2015-11-11 08:54:37 BJT

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

data_dir = "/home/ou/archive/data/pcom/input/"
infile = data_dir + "pcom_bcf_mn.nc"
outfile  = data_dir+"forcing.nc"

system("rm -f "+outfile)

fin = addfile(infile, "r")
fout =addfile(outfile,"c")

vars = (/"bcu","bcv","bct","bcs","bcp","emp"/)
do i = 0, dimsizes(vars)-1
  varName = vars(i)
  var = fin->$varName$
  missing2fill(var)

  newVar = var

  if (varName.eq."bcu") then
    newVar@units = "N/m^2"
    newVar = newVar * 0.1
    fout->taux = newVar
  else if (varName.eq."bcv") then
    newVar@units = "N/m^2"
    newVar = newVar * 0.1
    fout->tauy = newVar
  else if (varName.eq."bcp") then
    newVar@units = "N/m^2"
    newVar = newVar * 0.1
    fout->pa = newVar
  else if (varName.eq."emp") then
    newVar@units = "m/s"
    newVar = newVar * 0.01
    fout->fw = newVar
  else if (varName.eq."bct") then
    newVar@units = "degrees Celcius"
    fout->bct = newVar
  else if (varName.eq."bcs") then
    fout->bcs = newVar
  end if
  end if
  end if
  end if
  end if
  end if
  delete(var)
  delete(newVar)
end do

fout@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(fout)
