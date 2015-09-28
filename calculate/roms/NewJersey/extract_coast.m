
% Description: extract coastline data
%              adapted from Arango's version
%
%      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
%     Created: 2014-07-22 09:34:51 BJT
% Last Change: 2014-07-24 22:01:53 BJT

% GSHHS_DIR='/home/ou/archive/data/gshhg/gshhg-bin-2.3.1/'; % gshhg not work!
GSHHS_DIR = '/home/ou/archive/data/gshhs/';
out_dir   = '/home/ou/archive/data/seagrid/NewJersey/';
Oname = [out_dir 'coast.mat'];

Llon=-76.0;              % Left   corner longitude     % US west Coast
Rlon=-71.5;              % Right  corner longitude
Blat=38.0;                % Bottom corner latitude
Tlat=41.5;                % Top    corner latitude

%database='full';          % Full resolution database
database='high';          % High resolution database
% database='intermediate';  % Intermediate resolution database
%database='low';           % Low resolution database
%database='crude';         % crude resolution database

switch database,
  case 'full'
    Cname=strcat(GSHHS_DIR,'gshhs_f.b');
    name='gshhs_f.b';
  case 'high'
    Cname=strcat(GSHHS_DIR,'gshhs_h.b');
    name='gshhs_h.b';
  case 'intermediate'
    Cname=strcat(GSHHS_DIR,'gshhs_i.b');
    name='gshhs_i.b';
  case 'low'
    Cname=strcat(GSHHS_DIR,'gshhs_l.b');
    name='gshhs_l.b';
  case 'crude'
    Cname=strcat(GSHHS_DIR,'gshhs_c.b');
    name='gshhs_c.b';
end,

%---------------------------------------------------------------------------
%  Extract coastlines from GSHHS database.
%---------------------------------------------------------------------------

delta = 0;
disp(['Reading GSHHS database: ',name]);
[Coast]=r_gshhs(Llon-delta,Rlon+delta,Blat-delta,Tlat+delta,Cname);

disp(['Processing read coastline data']);
[C]=x_gshhs(Llon-delta,Rlon+delta,Blat-delta,Tlat+delta,Coast,'patch');

%---------------------------------------------------------------------------
%  Save extrated coastlines.
%---------------------------------------------------------------------------

lon=C.lon;
lat=C.lat;

save(Oname,'lon','lat');
