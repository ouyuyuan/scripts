
; Description: missing to fillvalue, change old pcom output
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-09 08:13:34 BJT
; Last Change: 2016-04-12 18:41:00 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; change missingvalue to fillvalue
procedure missing2fill (var:numeric)
begin
  var@_FillValue = default_fillvalue(typeof(var))
  var = where(var.gt.10e10, var@_FillValue, var)
  delete(var@missing_value)
end

infile = getenv("NCL_ARG_1")
outfile =getenv("NCL_ARG_2")
system("rm -f "+outfile)

fin = addfile(infile, "r")
fout =addfile(outfile,"c")

vars = (/"u","v","w","pt","sa","ssh"/)
do i = 0, dimsizes(vars)-1
  varName = vars(i)
  var = fin->$varName$
  missing2fill(var)
  fout->$varName$ = var
  delete(var)
end do
