
; Description: cal. barotropic stream function
;              ref. licom_wfc.ncl
;              UU = sum( u(x,y,z)*delta(z) ), definite integration from 
;                   sea bottom to surface.
;              phi = int( UU(x,y) dy ), indefinte integration, 
;                    from north to south.
;
;       Usage: run_ncl this.ncl licom/pcom/pcom_r/soda
;              or ./bsf.sh to cal. all models at one time.
;
;              New model added in should change two place: nc file path and
;                variable field in nc files
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-03-29 11:20:52 BJT
; Last Change: 2015-04-27 18:44:59 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; dirs, files <<<1

datDir   = getenv("NCL_ARG_1")
nc       = getenv("NCL_ARG_2")
fname    = datDir+nc
outfile  = datDir+"post/"+getenv("NCL_ARG_0_base")+".nc"
gridinfo = datDir+"post/grid_info.nc"

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

isPcom = False
if isStrSubset(datDir,"pcom") .and. .not.isStrSubset(datDir,"pcom_grid") then
  isPcom = True
end if
;}}}

if isPcom
  gridinfo = datDir+"../grid_info.nc"
end if

; field <<<1
f   = addfile(fname, "r")
if isSoda
  u = f->u(:, :, :)
else
  u = f->u(0, :, :, :)
end if
delete(f)

if isSoda then
  lev = u&Z
else
  lev = u&z
end if
lat = u&lat
lon = u&lon

f = addfile(gridinfo, "r")
dz  = f->dz ; 1d
dy  = f->dy ; 2d
delete(f)

; barotropic UU: vertically integrate u
UU = dim_sum_n_Wrap( u * conform(u,dz,0), 0)

; indefinite integration
t = UU * dy
phi = UU*0
nlat = dimsizes(lat)
do i = 0, nlat - 1
  ; from north to south
  phi(i,:) = dim_sum_n(t(i:,:), 0)
  ; wrong if from sourth to north
;      phi(i,:) = dim_sum_n(t(:i,:), 0)
end do
delete(t)
phi = where(ismissing(UU) .eq. "True", u@_FillValue, phi)
phi = smth9_Wrap(phi, 0.50, 0.25, True)
phi = phi*1e-6 ; m^3/s to Sv

; output <<<1

phi!0 = "lat"
phi!1 = "lon"
phi&lat = lat
phi&lon = lon
phi@long_name = "barotropic stream function"
phi@units = "Sv"

system("rm -f " + outfile)
f = addfile(outfile, "c")
f->bsf = phi(:,:)
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
