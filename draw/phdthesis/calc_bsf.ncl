
; Description: cal. barotropic stream function
;              ref. licom_wfc.ncl
;              UU = sum( u(x,y,z)*delta(z) ), definite integration from 
;                   sea bottom to surface.
;              phi = int( UU(x,y) dy ), indefinte integration, 
;                    from north to south.
;
;       Usage: run_ncl this.ncl
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-03-29 11:20:52 BJT
; Last Change: 2016-05-23 10:35:53 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; dirs, files <<<1

datDir   = "/home/ou/archive/data/"
inPcom   = datDir+"pcom/exp_spinup/post/climate_791-800.nc"
inSoda   = datDir+"soda/pcom_grid/post/climate_y1961-y1990.nc"
outfile  = datDir+"pcom/phd/"+getenv("NCL_ARG_0_base")+".nc"
gridinfo = datDir+"pcom/grid_info.nc"

undef ("calc")
function calc(infile:string) ;{{{1
local isSoda, isPcom, lev, u, lat, lon, dz, dy, UU, nlat 
begin
  ;guess data ;{{{2
  isSoda = False
  if isStrSubset(infile, "soda") then
    isSoda = True
  end if

  isPcom = False
  if isStrSubset(infile, "pcom") .and. \
    .not.isStrSubset(datDir,"pcom_grid") then
    isPcom = True
  end if

  ; field  ;{{{2
  f   = addfile(infile, "r")
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

  ; calculate ;{{{2
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

  phi!0 = "lat"
  phi!1 = "lon"
  phi&lat = lat
  phi&lon = lon
  phi@long_name = "barotropic stream function"
  phi@units = "Sv"

  return phi ;{{{2
end

; output ;{{{1
system("rm -f " + outfile)
f        = addfile(outfile, "c")
f->pcom  = calc(inPcom)
f->soda  = calc(inSoda)
f@source = "create by " + systemfunc("pwd") + "/" + \
  getenv("NCL_ARG_0") + ", " + systemfunc("date")
delete(f)
