
% Description: extract bathymetry data from ETOPO1
%              adapted from arango's version
%
%      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
%     Created: 2014-07-22 09:13:57 BJT
% Last Change: 2014-07-23 19:20:28 BJT

data_dir = '/home/ou/archive/data/etopo';
out_dir  = '/home/ou/archive/data/seagrid/NewJersey';
etopo = [data_dir '/ETOPO1_Bed_g_gmt4.grd'];
Bname = [data_dir '/NewJersey_box.nc'];
Oname = [out_dir '/bath.mat'];

Llon=-76.0;              % Left   corner longitude
Rlon=-71.5;              % Right  corner longitude
Blat=38.0;                % Bottom corner latitude
Tlat=41.5;                % Top    corner latitude

% call cdo to substract a box of the topo, otherwise Matlab will 
% out of memory when read the whole etopo1 data
% the box will extend to 2 degree to the four edge 
if (1)
  delta = 1;
  cmd = ['cdo sellonlatbox,' num2str(Llon-delta) ',' num2str(Rlon+delta) ',' ...
    num2str(Blat-delta) ',' num2str(Tlat+delta) ' ' etopo ' ' Bname];
  disp(cmd);
  [status,cmdout] = system(cmd);
  disp(cmdout);
end

delta = 0;
[lon,lat,h]=x_etopo1(Llon-delta,Rlon+delta,Blat-delta,Tlat+delta,Bname);

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
