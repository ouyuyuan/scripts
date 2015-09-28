% check woa09 global mean saline for ou nian sen
clc;clear;
%r = 6371220.0;
r = 1;
ncid=netcdf.open('/home/ou/archive/data/woa09/salinity_annual_1deg.nc','NOWRITE');
varid = netcdf.inqVarID(ncid,'lon');lon = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'lat');lat = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'depth');depth = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'lat_bnds');lat_bnds = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'lon_bnds');lon_bnds = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'s_an');s_an = netcdf.getVar(ncid,varid);
netcdf.close(ncid);
[nx,ny,nz] = size(s_an);
midz = zeros(nz,1);
dz = zeros(nz,1);
dz(1) = 5;
for i=1:nz-1
    midz(i) = (depth(i)+depth(i+1))/2;
end
midz(nz) = (6000+5500)/2;
for i=2:nz
    dz(i) = midz(i) - midz(i-1);
end

area = zeros(ny,1);
for i=1:ny
    area(i) = (pi/180)*(sin(lat_bnds(2,i)*pi/180)-sin(lat_bnds(1,i)*pi/180));
%    area(i) = cos(lat(i)*pi/180);
end

volume = zeros(nx,ny,nz);
for i=1:nx
    for j=1:ny
        for k=1:nz
            volume(i,j,k) = area(j)*dz(k);
        end
    end
end
volume(s_an>1000) = 0;
svol = sum(sum(sum(volume)));

s_an(s_an>1000) = 0;
s_an = s_an.*volume;
ss_an = sum(sum(sum(s_an)));

fprintf('%s %f \n','Global saline average is ',ss_an/svol);
