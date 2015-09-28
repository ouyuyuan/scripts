
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-09-02 08:22:24 BJT
; Last Change: 2014-09-04 14:38:37 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/home/ou/archive/scripts/utils/roms.ncl"

; 'short' type variable with add_offset and scale_factor attribute to 'double'
undef("short2double")
function short2double( var:numeric )
begin
  rt = new(dimsizes(var), double)
  rt = var*var@scale_factor + var@add_offset
  return rt
end

; vertically interpolate 3d variable to roms s-coordinate
undef("interp_vert")
function interp_vert( vin, lev, z )
local dims
begin
  dims = dimsizes(z)
  vout = new( dimsizes(z), double )

  do i = 0, dims(1) - 1
  do j = 0, dims(2) - 1
    vout(:,i,j) = linint1( lev, vin(:,i,j), False, z(:,i,j), 0 );
   end do
  end do

  return vout
end

; get the depths of the rho points 
undef("get_z")
function get_z(f, zeta)
local h, hc, Cs_r, Sc_r, lat_rho, vtransform, dims, \
Lp, N, Mp, hinv, cff, cffr
begin
  h = f->h
  hc = f->hc
  Cs_r = f->Cs_r
  Sc_r = f->s_rho
  lat2d = f->lat_rho
  vtransform = f->Vtransform

  dims = dimsizes(h)
  Mp = dims(0)
  Lp = dims(1)
  N = dimsizes(Sc_r)
  z = new( (/N,Mp,Lp/), double )
  delete(dims)

  zeta_m = where(ismissing(zeta),0,zeta)
  hinv = 1./h

  if (vtransform.eq.2)
  do k=0,N-1
    cff = 1./(hc + h);
    cffr = hc*Sc_r(k) + h*Cs_r(k);
    z(k,:,:) = (zeta_m + ( zeta_m + h )*cffr*cff)
  end do
  end if

  if (vtransform.eq.1)
  do k=0,N-1
    cffr = hc*(Sc_r(k) - Cs_r(k))
    z(k,:,:)=cffr+Cs_r(k)*h + zeta_m*(1 + (cffr+Cs_r(k)*h)*hinv)
  end do
  end if

  return z
end

; interpolate 2d variable to roms grid
undef("interp_2d")
function interp_2d( vin, lat, lon, f )
local mylon
begin
  mylon = where( lon.gt.180.0, lon-360.0, lon ) ; roms lon is -180 ~ 180

  lat2d = f->lat_rho
  lon2d = f->lon_rho
  vout = rgrid2rcm( lat, mylon, vin, lat2d, lon2d, 0)

  return vout
end

; interpolate 3d variable to roms grid
undef("interp_3d")
function interp_3d( vin, lev, lat, lon, f, zeta )
; need to explicit specify zeta because f is usually not close after 
; assign zeta to it, so it cannot get zeta from file handle f
; the dims of vin should be lev X lat X lon
local mylev, finp
begin
    finp = interp_2d( vin, lat, lon, f )
  ; roms depth is negative, and the first index is sea bottom
  if ( abs(lev(0)) .lt. abs(lev(1)) ) then
    mylev = -abs(lev(::-1)) 
    finp = finp(::-1,:,:)
  else
    mylev = -abs(lev) 
  end if
  vout = interp_vert( finp, mylev, get_z(f, zeta) )
  return vout
end

; interpolate hycom 4d variable to roms initial file
undef("hycom4d2roms")
procedure hycom4d2roms( var_hycom, lev, lat, lon, f, var_roms_name, zeta )
local tmp, v_roms
begin
  print( "Interpolating " + var_roms_name + " to roms grid ..." )
  tmp = short2double(var_hycom)
  v_roms = interp_3d( tmp(0,:,:,:), lev, lat, lon, f, zeta )
;  v_roms = smth9( v_roms, 0.5, 0.25, False )
  f->$var_roms_name$(0,:,:,:) = (/v_roms/)
end

; interpolate hycom current to roms initial file
; only interp. to rho grid
undef("hycomuv2roms")
procedure hycomuv2roms( u_c, v_c, lev, lat, lon, f, u_r_name, v_r_name, angle, zeta )
local dims, ang, u_r, v_r, tmp, u, v
begin
  print( "Interpolating u,v to roms grid ..." )

  tmp = short2double(u_c)
  u_r = interp_3d( tmp(0,:,:,:), lev, lat, lon, f, zeta )
  delete(tmp)

  tmp = short2double(v_c)
  v_r = interp_3d( tmp(0,:,:,:), lev, lat, lon, f, zeta )
  delete(tmp)

  ; rotate vector from North/East to roms grid
  ang = conform( u_r, angle, (/1,2/) )
  u_r =   u_r * cos(ang) + v_r * sin(ang)
  v_r = - u_r * sin(ang) + v_r * cos(ang)

  ; interpolate from rho-points to u-/v- points
  dims = dimsizes(u_r)
  L = dims(2) - 1
  M = dims(1) - 1

  u = 0.5*( u_r(:,:,:L-1) + u_r(:,:,1:L) )
  v = 0.5*( v_r(:,:M-1,:) + v_r(:,1:M,:) )
  f->$u_r_name$(0,:,:,:) = (/u/)
  f->$v_r_name$(0,:,:,:) = (/v/)
end

begin

  nc_src = "/home/ou/archive/data/roms/scs/hycom_init.nc"
  app_dir = "/home/ou/archive/models/roms/roms_734/Apps/scs/in/"
  nc_init = app_dir + "init.nc"
  nc_init_soda = app_dir + "init_soda.nc"
  nc_grid = app_dir + "seagrid.nc"

  system("cp -f " + nc_init_soda + " " + nc_init)

  f = addfile( nc_src, "r" )
  lev = f->depth
  lat = f->lat
  lon = f->lon
  surf_el = f->surf_el
  water_temp = f->water_temp
  salinity = f->salinity
  water_u = f->water_u
  water_v = f->water_v
  delete(f)

  f = addfile( nc_grid, "r" )
  angle = f->angle
  delete(f)

  f = addfile( nc_init, "w" )

  print( "Interpolating zeta to roms grid ..." )
  tmp = short2double(surf_el)
  zeta = interp_2d( tmp(0,:,:), lat, lon, f )
  delete(tmp)
;  f->zeta(0,:,:) = (/zeta/)

;  hycom4d2roms( water_temp, lev, lat, lon, f, "temp", zeta )
  hycom4d2roms( salinity,   lev, lat, lon, f, "salt", zeta )
;  hycomuv2roms( water_u, water_v, lev, lat, lon, f, "u", "v", angle, zeta ) 

end
