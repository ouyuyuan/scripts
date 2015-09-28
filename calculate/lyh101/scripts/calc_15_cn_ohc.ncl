
; Description: calculate ocean heat content in unit ocean column
;              sum up between a specified vertical range
;              ohc = rho cp int(T) dz, T in Kelvin
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-12-02 19:17:56 BJT
; Last Change: 2015-04-28 16:06:28 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir = getenv("NCL_ARG_1")
nc = datDir + getenv("NCL_ARG_2")
zt = stringtoint(getenv("NCL_ARG_3"))
zb = stringtoint(getenv("NCL_ARG_4"))

;guess data
;{{{
isIshii = False
if isStrSubset(datDir, "Ishii") then
  isIshii = True
end if

isSoda = False
if isStrSubset(datDir, "soda") then
  isSoda = True
end if

isWoa09 = False
if isStrSubset(datDir, "woa09") then
  isWoa09 = True
end if

isPcom = False
if isStrSubset(datDir,"pcom") .and. .not.isStrSubset(datDir,"pcom_grid") then
  isPcom = True
end if
;}}}

outfile = datDir+"post/"+getenv("NCL_ARG_0_base")+"_"+zt+"-"+zb+"m.nc"
gridfile = datDir+"post/grid_info.nc"
if isPcom
  gridfile = datDir+"../grid_info.nc"
end if

rho = 1029 ; kg/m^3, mean density of seawater
cp = 3901 ; c_p, heat capability, J/kg/K

f = addfile(gridfile, "r")
dv  = f->dv
ds = f->ds
delete(f)

z = dv&$dv!0$
nz = dimsizes(z)

; cal. ohc for unit area water column
f = addfile(nc, "r")
if isSoda
  temp = f->temp(:,:,:)
else if isWoa09
  temp = f->t_an(0,:,:,:)
else
  temp = f->pt(0,:,:,:)
end if
end if
delete(f)

ohc3d = dv
mydv = dv
ohc3d = rho*cp*(temp+273.15)*mydv

zc = conform(dv, z, 0)
ohc3d = where(ismissing(temp), 0, ohc3d)
ohc3d = where(zc.ge.zt .and. zc.le.zb, ohc3d, 0)

dsc = conform(dv, ds, (/1,2/))
ohc3d = ohc3d/dsc
ohc = dim_sum_n_Wrap(ohc3d, 0)
ohc = where(ismissing(temp(0,:,:)), ohc@_FillValue, ohc)

system("rm -f " + outfile)
f = addfile(outfile, "c")
f->ohc = ohc
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
