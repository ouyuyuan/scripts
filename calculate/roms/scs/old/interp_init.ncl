
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-09-02 08:22:24 BJT
; Last Change: 2014-09-04 07:20:34 BJT

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
function get_z(f, zeta, type)
local h, hc, Cs_r, Sc_r, lat_rho, vtransform, dims, \
L, N, M, hinv, cff, cffr
begin
  h = f->h
  hc = f->hc
  Cs_r = f->Cs_r
  Sc_r = f->s_rho
  vtransform = f->Vtransform

  dims = dimsizes(h)
  M = dims(0) - 1
  L = dims(1) - 1
  N = dimsizes(Sc_r)
  delete(dims)

  if (type.eq."rho") then
    lat2d = f->lat_rho
    zeta_m = zeta
    h_m = h
    z = new( (/N,M+1,L+1/), double )
  else if (type.eq."u") then
    lat2d = f->lat_u
    zeta_m = 0.5*( zeta(:,:L-1) + zeta(:,1:L) )
    h_m = 0.5*( h(:,:L-1) + h(:,1:L) )
    z = new( (/N,M+1,L/), double )
  else if (type.eq."v") then
    lat2d = f->lat_v
    zeta_m = 0.5*( zeta(:M-1,:) + zeta(1:M,:) )
    h_m = 0.5*( h(:M-1,:) + h(1:M,:) )
    z = new( (/N,M,L+1/), double )
  end if
  end if
  end if
  zeta_m = where(ismissing(zeta_m),0,zeta_m)

  hinv=1./h

  if (vtransform.eq.2)
  do k=0,N-1
    cff = 1./(hc + h_m);
    cffr = hc*Sc_r(k) + h_m*Cs_r(k);
    z(k,:,:) = (zeta_m + ( zeta_m + h_m )*cffr*cff)
  end do
  end if

  if (vtransform.eq.1)
  do k=0,N-1
    cffr = hc*(Sc_r(k) - Cs_r(k))
    z(k,:,:)=cffr+Cs_r(k)*h_m + zeta_m*(1 + (cffr+Cs_r(k)*h_m)*hinv)
  end do
  end if

  return z
end

; interpolate 2d variable to roms grid
undef("interp_2d")
function interp_2d( vin, lat, lon, f, type)
local mylon
begin
  mylon = where( lon.gt.180.0, lon-360.0, lon ) ; roms lon is -180 ~ 180

  if (type.eq."rho") then
    lat2d = f->lat_rho
    lon2d = f->lon_rho
  else if (type.eq."u") then
    lat2d = f->lat_u
    lon2d = f->lon_u
  else if (type.eq."v") then
    lat2d = f->lat_v
    lon2d = f->lon_v
  end if
  end if
  end if

  vout = rgrid2rcm( lat, mylon, vin, lat2d, lon2d, 0)
  return vout
end

; interpolate 3d variable to roms grid
undef("interp_3d")
function interp_3d( vin, lev, lat, lon, f, zeta, type )
; need to explicit specify zeta because f is usually not close after 
; assign zeta to it, so it cannot get zeta from file handle f
; the dims of vin should be lev X lat X lon
local mylev, finp
begin
    finp = interp_2d( vin, lat, lon, f, type )
  ; roms depth is negative, and the first index is sea bottom
  if ( abs(lev(0)) .lt. abs(lev(1)) ) then
    mylev = -abs(lev(::-1)) 
    finp = finp(::-1,:,:)
  else
    mylev = -abs(lev) 
  end if
  vout = interp_vert( finp, mylev, get_z(f, zeta, type) )
  return vout
end

; interpolate cfsr 4d variable to roms initial file
undef("cfsr4d2roms")
procedure cfsr4d2roms( var_cfsr, lev, lat, lon, f, var_roms_name, zeta, type )
local tmp, v_roms
begin
  print( "Interpolating " + var_roms_name + " to roms grid ..." )
  tmp = short2double(var_cfsr)
  v_roms = interp_3d( tmp(0,:,:,:), lev, lat, lon, f, zeta, type )
  f->$var_roms_name$(0,:,:,:) = (/v_roms/)
end

; interpolate cfsr current to roms initial file
; only interp. to rho grid
undef("cfsruv2roms")
procedure cfsruv2roms( u_c, v_c, lev, lat, lon, f, u_r_name, v_r_name, angle, zeta )
local dims, ang, u_r, v_r, tmp
begin
  print( "Interpolating u,v to roms grid ..." )

  tmp = short2double(u_c)
  u_r = interp_3d( tmp(0,:,:,:), lev, lat, lon, f, zeta, "u" )
  delete(tmp)

  tmp = short2double(v_c)
  v_r = interp_3d( tmp(0,:,:,:), lev, lat, lon, f, zeta, "v" )
  delete(tmp)

  ; rotate vector from North/East to roms grid
  dims = dimsizes(u_r)
  printVarSummary(angle)
  printVarSummary(u_r)
  exit
  ang = conform( u_r, angle, (/1,2/) )
  u_r =   u_r * cos(ang) + v_r * sin(ang)
  v_r = - u_r * sin(ang) + v_r * cos(ang)
  f->$u_r_name$(0,:,:,:) = (/u_r/)
  f->$v_r_name$(0,:,:,:) = (/v_r/)
end

begin

  nc_src = "/home/ou/archive/data/roms/scs/hycom_init.nc"
  app_dir = "/home/ou/archive/models/roms/roms_734/Apps/scs/in/"
  nc_init = app_dir + "init.nc"
  nc_grid = app_dir + "seagrid.nc"

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
  zeta = interp_2d( tmp(0,:,:), lat, lon, f, "rho" )
  delete(tmp)
;  f->zeta(0,:,:) = (/zeta/)

;  cfsr4d2roms( water_temp, lev, lat, lon, f, "temp", zeta, "rho" ) 
;  cfsr4d2roms( salinity,   lev, lat, lon, f, "salt", zeta, "rho" ) 
  cfsruv2roms( water_u, water_v, lev, lat, lon, f, "u", "v", angle, zeta ) 

end
