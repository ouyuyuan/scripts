
; Description: utility in PCOM calculation
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-13 14:29:12 BJT
; Last Change: 2015-06-22 09:41:53 BJT

; pcom_area_mean  - calculate area mean according to latitude factor

; cal. global mean func <<<1
undef("pcom_area_mean")
function pcom_area_mean(var:numeric)
;{{{
; assume lon is evenly spaced, only account cosine factor 
;    of latitude for weight
local lat, lon, rad, r, wgt, dlon, dx, dy, jat
begin
   lat = var&lat
   lon = var&lon
   torad = 3.14159265 / 180
   r = 6371220.0 ; meters
   dlon = abs(lon(2) - lon(1)) * torad * r
   dx = dlon*cos(lat*torad)

   jlat = dimsizes(lat)
   dy = new( jlat, typeof(dx) )
   dy(0) = abs(lat(2) - lat(1)) * torad * r
   dy(1:jlat-2)  = abs(lat(2:jlat-1)-lat(0:jlat-3))*0.5 * torad * r   
   dy(jlat-1)    = abs(lat(jlat-1)-lat(jlat-2)) * torad * r

   area = dx * dy
   ave = wgt_areaave_Wrap(var, area, 1.0, 1)

   return ave
;}}}
end

; cal. barotropic stream function (ref. licom_wfc.ncl)
;    UU = sum( u(x,y,z)*delta(z) ), definite integration from sea bottom to surface.
;    phi = int( UU(x,y) dy ), indefinte integration, from north to south.
undef("pcom_bsf")
function pcom_bsf(u)
; u is (z,lat,lon)
local phi, dy, dz, nz, nlat, lat, lon, z, UU, t
;{{{
begin

  z   = u&$u!0$
  lat = u&$u!1$
  lon = u&$u!2$

  ; cal. thickness of each layer
  ; assume velecity is on the center of each layer
  nz = dimsizes(z)
  dz = z*0
  dz(0) = z(0) * 2
  do i = 1, nz - 1
     dz(i) = (z(i) - sum(dz)) * 2
     if (dz(i) .lt. 0) then
        print("thickness of layer is not positive! stop.")
        return
     end if
  end do

  ; cal. latitude band for each grid, assume latitude is uniform
  dy = lat*0
  dy = ( lat(1) - lat(0) ) * 3.14159265 / 180.0 * 6371 * 10^3 ; unit: m^3/s

  ; barotropic UU: vertically integrate u
  UU = dim_sum_n_Wrap( u * conform(u,dz,0), 0)

  ; indefinite integration
  t = UU * conform(UU,dy,0)

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

  return phi
end
;}}}

; calculate ocean heat content in unit ocean column
;    sum up between a specified vertical range
;    ohc = rho cp int(T) dz, T in Kelvin
undef("pcom_unit_column_ohc")
function pcom_unit_column_ohc(dv, ds, temp, zt, zb)
; dv is(z, lat, lon), ds is (lat, lon), temp is (z, lat, lon), in Celcius degree
local z, nz, ohc3d, mydv, zc, dsc, ohc, rho, cp
;{{{
begin

  rho = 1029 ; kg/m^3, mean density of seawater
  cp = 3901 ; c_p, heat capability, J/kg/K

  z = dv&$dv!0$
  nz = dimsizes(z)

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

  return ohc
end
;}}}

; calculate ocean heat content in unit-area ocean column grid 
;    account for the effect of SSH
;    ohc = rho cp int(T) dz, T in Kelvin
undef("pcom_unit_column_ohc_b")
function pcom_unit_column_ohc_b(dv, ds, ssh, temp)
; dv is(z, lat, lon), ds is (lat, lon), temp is (z, lat, lon), in Celcius degree
local z, nz, ohc3d, mydv, zc, dsc, ohc, rho, cp
;{{{
begin

  rho = 1029 ; kg/m^3, mean density of seawater
  cp = 3901 ; c_p, heat capability, J/kg/K

  z = dv&$dv!0$
  nz = dimsizes(z)

  ohc3d = dv
  mydv = dv
  mydv(0,:,:) = dv(0,:,:) + ds*ssh

  dsC = conform(dv, ds, (/1,2/))
  mydv = mydv/dsC
  ohc3d = rho*cp*(temp+273.15)*mydv

  return ohc3d
end
;}}}

; calculate ocean heat content in unit ocean grid above a apecific depth
;    account for the effect of SSH
;    ohc = rho cp int(T) dz, T in Kelvin
undef("pcom_unit_grid_ohc")
function pcom_unit_grid_ohc(dv, ds, ssh, temp, zt, zb)
; dv is(z, lat, lon), ds is (lat, lon), temp is (z, lat, lon), in Celcius degree
local z, nz, ohc3d, mydv, zc, dsc, ohc, rho, cp
;{{{
begin

  rho = 1029 ; kg/m^3, mean density of seawater
  cp = 3901 ; c_p, heat capability, J/kg/K

  z = dv&$dv!0$
  nz = dimsizes(z)

  ohc3d = dv
  mydv = dv
  if (zt.eq.0) then
    mydv(0,:,:) = dv(0,:,:) + ds*ssh
  end if
  ohc3d = rho*cp*(temp+273.15)*mydv

  zc = conform(dv, z, 0)
  ohc3d = where(ismissing(temp), 0, ohc3d)
  ohc3d = where(zc.ge.zt .and. zc.le.zb, ohc3d, 0)

  ohc = dim_sum_n_Wrap(ohc3d, 0)
  ohc = where(ismissing(temp(0,:,:)), ohc@_FillValue, ohc)

  return ohc
end
;}}}

; Meridional Overturning Circulation of a specific basin
;    VV = definite integrate v(x,y,z) from west to east
;   phi = indefinite integrate VV(y,z) from specific depth to the top
function pcom_moc(fileIn, fileGrid, basin)
; basin(lat, lon): 1: sea, _FillValue: outside of the basin
;{{{
local f, v, basinC, dx, dxC, dz, dzC, phi, z, lat, nlev, nlat, t
begin
  f   = addfile(fileIn, "r")
  v   = f->v(0, :, :, :)
  delete(f)

  basinC = conform(v, basin, (/1,2/))

  f  = addfile(fileGrid, "r")
  dx = f->dx(:,:)
  dz = f->dz(:)
  delete(f)
  dxC = conform(v, dx, (/1,2/))

  v = v*basinC
  z= v&z
  lat = v&lat
  nz = dimsizes(z)

  ; west to east integration of VV
  VV = dim_sum_n_Wrap( v*dxC, 2)

  ; vertical indefinite integration
  dzC = conform_dims(dimsizes(VV), dz, 0)

  t = VV * dzC
  phi = VV ; get coordinates
  phi = 0
  do i = 0, nz - 1
  ;  phi(i,:) = - dim_sum_n(t(0:i,:), 0) ; if the sign of the result is not correct
    phi(i,:) = dim_sum_n(t(0:i,:), 0)
  end do
  delete(t)

  phi = where(ismissing(VV), v@_FillValue, phi)
  phi = smth9_Wrap(phi, 0.5, 0.25, True)
  phi = phi*10^-6 ; Sv

  phi!0 = "z"
  phi!1 = "lat"
  phi&z = z
  phi&lat = lat
  phi@units = "Sv"
  phi@long_name = "meridional overturning circulation"

  return phi
end
;}}}

; Meridional Overturning Circulation of a specific basin
; account for the effects of SSH
;   VV = indefinite integrate v(x, y,z) from specific depth to the top
;   phi = definite integrate VV(x,y,z) from west to east
function pcom_moc_b(fileIn, fileGrid, basin)
; basin(lat, lon): 1: sea, _FillValue: outside of the basin
;{{{
local f, v, basinC, dx, dxC, dz, dzC, phi, z, lat, nlev, nlat, t
begin
  f   = addfile(fileIn, "r")
  v   = f->v(0, :, :, :)
  ssh = f->ssh(0, :, :)
  delete(f)

  basinC = conform(v, basin, (/1,2/))

  f  = addfile(fileGrid, "r")
  dx = f->dx(:,:)
  dz = f->dz(:)
  delete(f)
  dxC = conform(v, dx, (/1,2/))
  dzC = conform(v, dz, 0)
  dzC(0,:,:) = dzC(0,:,:) + ssh

  v = v*basinC
  z = v&z
  lat = v&lat
  nz = dimsizes(z)

  ; vertical indefinite integration
  t = v * dzC
  VV = v ; get coordinates
  VV = 0
  do i = 0, nz - 1
    VV(i,:,:) = dim_sum_n(t(0:i,:,:), 0)
  end do
  delete(t)

  ; west to east integration
  phi = dim_sum_n_Wrap( VV*dxC, 2)

  phi = where(ismissing(phi), v@_FillValue, phi)
  phi = smth9_Wrap(phi, 0.5, 0.25, True)
  phi = phi*10^-6 ; Sv

  phi!0 = "z"
  phi!1 = "lat"
  phi&z = z
  phi&lat = lat
  phi@units = "Sv"
  phi@long_name = "meridional overturning circulation"

  return phi
end
;}}}

