
% Description: extract bathymetry data from ETOPO1
%              adapted from arango's version
%
%      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
%     Created: 2014-07-22 09:13:57 BJT
% Last Change: 2014-08-19 20:07:15 BJT

data_dir = '/home/ou/archive/data/etopo/';
out_dir  = '/home/ou/archive/data/seagrid/hyzx/';
etopo = [data_dir 'etopo5.nc'];
%etopo = [data_dir '/ETOPO1_Bed_g_gmt4.grd'];
Bname = [data_dir '/hyzx_box.nc'];
Oname = [out_dir 'bath.mat'];

isetopo1 = false;

Llon=30.0;              % Left   corner longitude
Rlon=200.0;              % Right  corner longitude
Blat=-20.0;                % Bottom corner latitude
Tlat=60.0;                % Top    corner latitude

% call cdo to substract a box of the topo, otherwise Matlab will 
% out of memory when read the whole etopo1 data
if (isetopo1)
  delta = 0.5;
  cmd = ['cdo sellonlatbox,' num2str(Llon-delta) ',' num2str(Rlon+delta) ',' ...
    num2str(Blat-delta) ',' num2str(Tlat+delta) ' ' etopo ' ' Bname];
  disp(cmd);
  [status,cmdout] = system(cmd);
  disp(cmdout);
end

if ( Llon < 0 ),
  Llon = Llon + 360;
end
if ( Rlon < 0 ),
  Rlon = Rlon + 360;
end

delta = 0;
if (isetopo1) 
  [lon,lat,h]=x_etopo1(Llon-delta,Rlon+delta,Blat-delta,Tlat+delta,Bname);
else
  [lon,lat,h]=x_etopo(Llon-delta,Rlon+delta,Blat-delta,Tlat+delta,etopo);
end

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
save(Oname,'xbathy','ybathy','zbathy');
