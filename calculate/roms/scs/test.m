
% Description: Driver script to create a ROMS initial conditions
%              Modified from Arango's version of d_mercator2roms.m
%
%      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
%     Created: 2014-07-28 20:26:35 BJT
% Last Change: 2014-09-04 16:01:47 BJT

% Set file names.

srcname = '/home/ou/archive/data/roms/scs/hycom_init.nc';
roms_dir = '/home/ou/archive/models/roms/roms_734/Apps/scs/in/';
GRDname = [roms_dir 'seagrid.nc'];
INIname = [roms_dir 'init.nc'];

CREATE = true;                   % logical switch to create NetCDF
%CREATE = false;                   % logical switch to create NetCDF
report = false;                  % report vertical grid information

% Get number of grid points.

[Lr,Mr]=size(nc_read(GRDname,'h'));

Lu = Lr-1;   Lv = Lr;
Mu = Mr;     Mv = Mr-1;

%--------------------------------------------------------------------------
%  Set application parameters in structure array, S.
%--------------------------------------------------------------------------

S.ncname      = INIname;     % output NetCDF file

S.spherical   = 1;           % spherical grid

S.Lm          = Lr-2;        % number of interior RHO-points, X-direction
S.Mm          = Mr-2;        % number of interior RHO-points, Y-direction
S.N           = 30;          % number of vertical levels at RHO-points
S.NT          = 2;           % total number of tracers

S.Vtransform  = 2;           % vertical transfomation equation
S.Vstretching = 4;           % vertical stretching function

S.theta_s     = 5.0;         % S-coordinate surface control parameter
S.theta_b     = 0.4;         % S-coordinate bottom control parameter
S.Tcline      = 50.0;       % S-coordinate surface/bottom stretching width
S.hc          = S.Tcline;    % S-coordinate stretching width

%--------------------------------------------------------------------------
%  Set grid variables.
%--------------------------------------------------------------------------

S.h           = nc_read(GRDname, 'h');            % bathymetry

S.lon_rho     = nc_read(GRDname, 'lon_rho');      % RHO-longitude
S.lat_rho     = nc_read(GRDname, 'lat_rho');      % RHO-latitude

S.lon_u       = nc_read(GRDname, 'lon_u');        % U-longitude
S.lat_u       = nc_read(GRDname, 'lat_u');        % U-latitude

S.lon_v       = nc_read(GRDname, 'lon_v');        % V-longitude
S.lat_v       = nc_read(GRDname, 'lat_v');        % V-latitude

S.mask_rho    = nc_read(GRDname, 'mask_rho');     % RHO-mask
S.mask_u      = nc_read(GRDname, 'mask_u');       % U-mask
S.mask_v      = nc_read(GRDname, 'mask_v');       % V-mask

S.angle       = nc_read(GRDname, 'angle');        % curvilinear angle

%  Set vertical grid variables.

kgrid=0;                                          % RHO-points

[S.s_rho, S.Cs_r]=stretching(S.Vstretching, ...
                             S.theta_s, S.theta_b, S.hc, S.N,         ...
                             kgrid, report);

kgrid=1;                                          % W-points			 

[S.s_w,   S.Cs_w]=stretching(S.Vstretching, ...
                             S.theta_s, S.theta_b, S.hc, S.N,         ...
                             kgrid, report);

%--------------------------------------------------------------------------
%  Interpolate initial conditions from Mercator data to application grid.
%--------------------------------------------------------------------------

disp(' ')
disp(['Interpolating from Mercator to ROMS grid ...']);
disp(' ')

%  Get Mercator grid.

lon = nc_varget( srcname, 'lon' ); 
%% roms longitude is -180 ~ 180
ind = find(lon > 180);
if (~isempty(ind)),
  lon(ind) = lon(ind) - 360;
end

lat = nc_varget( srcname, 'lat' );

depth = nc_varget( srcname, 'depth' );

% mercator2roms request 2d lat & lon
[lat, lon] = meshgrid( lat, lon); % lat: row, lon: column

%  Read in initial conditions fields.
%  origial dimension: depth x lat x lon, 
%  mercator2roms.m requires: lon x lat x depth

%Zeta = nc_varget( srcname, 'ssh' );  Zeta = Zeta';
%Temp = nc_varget( srcname, 'temp' ); Temp = permute(Temp, [3 2 1]);
%Salt = nc_varget( srcname, 'salt' ); Salt = permute(Salt, [3 2 1]);
%Uvel = nc_varget( srcname, 'u' );    Uvel = permute(Uvel, [3 2 1]);
%Vvel = nc_varget( srcname, 'v' );    Vvel = permute(Vvel, [3 2 1]);
Zeta = nc_varget( srcname, 'surf_el' );  Zeta = (squeeze(Zeta))';
Temp = nc_varget( srcname, 'water_temp' ); Temp = permute(squeeze(Temp), [3 2 1]);
Salt = nc_varget( srcname, 'salinity' ); Salt = permute(squeeze(Salt), [3 2 1]);
Uvel = nc_varget( srcname, 'water_u' );    Uvel = permute(squeeze(Uvel), [3 2 1]);
Vvel = nc_varget( srcname, 'water_v' );    Vvel = permute(squeeze(Vvel), [3 2 1]);

%  Determine Mercator Land/Sea mask.  Since Mercator is a Z-level
%  model, the mask is 3D.

Rmask3d = ones(size(Temp));
Rmask3d(isnan(Temp)) = 0; % land is 0, ocean is 1

%  Set initial conditions time (seconds). The time coordinate for this
%  ROMS application is "seconds since 2006-01-01 00:00:00". The 0.5
%  coefficient here is to account Mecator daily average.

%S.ocean_time = 86400;               % set to Jan 1, because of forcing
S.ocean_time = 8121600;

%  Interpolate free-surface initial conditions.

zeta=mercator2roms('zeta',S,Zeta,lon,lat,squeeze(Rmask3d(:,:,1)));

%  Compute ROMS model depths.  Ignore free-sruface contribution
%  so interpolation is bounded below mean sea level.

ssh=zeros(size(zeta));

igrid=1;
[S.z_r]=set_depth(S.Vtransform, S.Vstretching,                        ...
                  S.theta_s, S.theta_b, S.hc, S.N,                    ...
		  igrid, S.h, ssh, report);
	      
igrid=3;
[S.z_u]=set_depth(S.Vtransform, S.Vstretching,                        ...
                  S.theta_s, S.theta_b, S.hc, S.N,                    ...
		  igrid, S.h, ssh, report);

igrid=4;
[S.z_v]=set_depth(S.Vtransform, S.Vstretching,                        ...
                  S.theta_s, S.theta_b, S.hc, S.N,                    ...
		  igrid, S.h, ssh, report);

%  Compute ROMS vertical level thicknesses (m).
	      
N=S.N;
igrid=5;
[S.z_w]=set_depth(S.Vtransform, S.Vstretching,                        ...
                  S.theta_s, S.theta_b, S.hc, S.N,                    ...
		  igrid, S.h, zeta, report);

S.Hz=S.z_w(:,:,2:N+1)-S.z_w(:,:,1:N);
	      
%  Interpolate temperature and salinity.

temp=mercator2roms('temp',S,Temp,lon,lat,Rmask3d,depth);
salt=mercator2roms('salt',S,Salt,lon,lat,Rmask3d,depth);

% due to stagger grid, mask of u, v may be different than tracers
Rmask3d = ones(size(Uvel));
Rmask3d(isnan(Uvel)) = 0;
Urho=mercator2roms('u'   ,S,Uvel,lon,lat,Rmask3d,depth);

Rmask3d = ones(size(Vvel));
Rmask3d(isnan(Vvel)) = 0;
Vrho=mercator2roms('v'   ,S,Vvel,lon,lat,Rmask3d,depth);

%  Process velocity: rotate and/or average to staggered C-grid locations.

[u,v]=roms_vectors(Urho,Vrho,S.angle,S.mask_u,S.mask_v);

%  Compute barotropic velocities by vertically integrating (u,v).

[ubar,vbar]=uv_barotropic(u,v,S.Hz);

%--------------------------------------------------------------------------
%  Create initial condition Netcdf file.
%--------------------------------------------------------------------------

if (CREATE),
  [status]=c_initial(S);

%  Set attributes for "ocean_time".

  avalue='seconds since 2006-01-01 00:00:00';
  [status]=nc_attadd(INIname,'units',avalue,'ocean_time');
  
  avalue='gregorian';
  [status]=nc_attadd(INIname,'calendar',avalue,'ocean_time');

%  Set global attributes.

  avalue='South China Sea';
  [status]=nc_attadd(INIname,'title',avalue);

  avalue='HYCOM reanalysis, 1/12 resolution';
  [status]=nc_attadd(INIname,'data_source',avalue);

  [status]=nc_attadd(INIname,'grd_file',GRDname);
end,

%--------------------------------------------------------------------------
%  Write out initial conditions.
%--------------------------------------------------------------------------

if (CREATE),
  disp(' ')
  disp([ 'Writing initial conditions ...']);
  disp(' ')

  [status]=nc_write(INIname, 'spherical',   1);
  [status]=nc_write(INIname, 'Vtransform',  S.Vtransform);
  [status]=nc_write(INIname, 'Vstretching', S.Vstretching);
  [status]=nc_write(INIname, 'theta_s',     S.theta_s);
  [status]=nc_write(INIname, 'theta_b',     S.theta_b);
  [status]=nc_write(INIname, 'Tcline',      S.Tcline);
  [status]=nc_write(INIname, 'hc',          S.hc);
  [status]=nc_write(INIname, 's_rho',       S.s_rho);
  [status]=nc_write(INIname, 's_w',         S.s_w);
  [status]=nc_write(INIname, 'Cs_r',        S.Cs_r);
  [status]=nc_write(INIname, 'Cs_w',        S.Cs_w);

  [status]=nc_write(INIname, 'h',           S.h);
  [status]=nc_write(INIname, 'lon_rho',     S.lon_rho);
  [status]=nc_write(INIname, 'lat_rho',     S.lat_rho);
  [status]=nc_write(INIname, 'lon_u',       S.lon_u);
  [status]=nc_write(INIname, 'lat_u',       S.lat_u);
  [status]=nc_write(INIname, 'lon_v',       S.lon_v);
  [status]=nc_write(INIname, 'lat_v',       S.lat_v);
  
  IniRec = 1;

  [status]=nc_write(INIname, 'ocean_time', S.ocean_time, IniRec);

  [status]=nc_write(INIname, 'zeta', zeta, IniRec);
  [status]=nc_write(INIname, 'ubar', ubar, IniRec);
  [status]=nc_write(INIname, 'vbar', vbar, IniRec);
  [status]=nc_write(INIname, 'u',    u,    IniRec);
  [status]=nc_write(INIname, 'v',    v,    IniRec);
  [status]=nc_write(INIname, 'temp', temp, IniRec);
  [status]=nc_write(INIname, 'salt', salt, IniRec);
end,
