
% Description: extract bathymetry data from ETOPO1, and coastline from gshhs
%              adapted from arango's version
%
%      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
%     Created: 2014-07-22 09:13:57 BJT
% Last Change: 2014-08-23 08:33:12 BJT

out_dir  = '/home/ou/archive/data/seagrid/scs/';
gshhs = '/home/ou/archive/data/gshhs/gshhs_h.b';
etopo = '/home/ou/archive/data/etopo/etopo5.nc';
mat_coast = [out_dir 'coast.mat'];
mat_bath  = [out_dir 'bath.mat'];

Llon=100.0;              % Left   corner longitude
Rlon=125.0;              % Right  corner longitude
Blat=-5.0;                % Bottom corner latitude
Tlat=30.0;                % Top    corner latitude

if ( Llon < 0 ),
  Llon = Llon + 360;
end
if ( Rlon < 0 ),
  Rlon = Rlon + 360;
end

delta = 0;
disp(['Extract bathymetry from: ' etopo]);
[lon,lat,h]=x_etopo(Llon-delta,Rlon+delta,Blat-delta,Tlat+delta,etopo);

%-----------------------------------------------------------------------
%  Process extracted data for requested task.
%-----------------------------------------------------------------------

xbathy = reshape(lon,1,prod(size(lon)))';
ybathy = reshape(lat,1,prod(size(lat)))';
zbathy = reshape(h,1,prod(size(h)))';
zbathy = -zbathy;
ind    = find(zbathy<0);
if (~isempty(ind)),
  zbathy(ind)=0;
end;
disp(['Save extracted bathymetry to: ' mat_bath]);
save(mat_bath,'xbathy','ybathy','zbathy');

disp(['Extract coastline from: ' gshhs]);
[Coast]=r_gshhs(Llon-delta,Rlon+delta,Blat-delta,Tlat+delta,gshhs);
[C]=x_gshhs(Llon-delta,Rlon+delta,Blat-delta,Tlat+delta,Coast,'patch');

%---------------------------------------------------------------------------
%  Save extrated coastlines.
%---------------------------------------------------------------------------

lon=C.lon;
lat=C.lat;

disp(['Save extracted coastline to: ' mat_coast]);
save(mat_coast,'lon','lat');
