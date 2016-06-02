
; Description: create simple initial field for model debug,
;                like checking swap boundary routine in
;                the prallel module
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2015-09-29 20:07:14 BJT
; Last Change: 2015-10-20 14:34:37 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

data_dir = "/media/wd/pcom/input/"
infile = data_dir + "pcom_ini_mod.nc"
outfile  = data_dir+"pcom_ini_simple.nc"

system("rm -f "+outfile)

fin = addfile(infile, "r")
fout =addfile(outfile,"c")

vars = (/"pt","sa","idx","itn","depth","tmn","smn"/)
do i = 0, dimsizes(vars)-1
  varName = vars(i)
  var = fin->$varName$

  if (varName.eq."pt" .or. \
      varName.eq."sa" .or. \
      varName.eq."idx") then
    newVar = var(::10, ::10, ::10)
  else if (varName.eq."depth" .or. varName.eq."itn") then
    newVar = var(::10, ::10)
  else
    newVar = var(::10)
  end if
  end if

  newVar = where(ismissing(newVar), 0, newVar)

  fout->$varName$ = newVar
  delete(var)
  delete(newVar)
end do

fout@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(fout)
