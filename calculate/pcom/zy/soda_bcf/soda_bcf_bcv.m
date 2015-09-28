%creat pcom bcs from soda data
clc;clear;
%read soda data
ncid = netcdf.open('tauy.cdf','NC_NOWRITE');
lonid = netcdf.inqVarID(ncid,'lon');
latid = netcdf.inqVarID(ncid,'lat');
tid = netcdf.inqVarID(ncid,'time');
lon_obs = netcdf.getVar(ncid,lonid);
lat_obs = netcdf.getVar(ncid,latid);
t_obs = netcdf.getVar(ncid,tid);
varid = netcdf.inqVarID(ncid,'tauy');
obs = netcdf.getVar(ncid,varid);
attname = netcdf.inqAttName(ncid,varid,4);
missvalue = netcdf.getAtt(ncid,varid,attname);
netcdf.close(ncid);
nx_obs=numel(lon_obs);ny_obs=numel(lat_obs);nt=numel(t_obs);
%read geographical info from pcom ini
ncid = netcdf.open('pcom_ini.nc','NC_NOWRITE');
lonid = netcdf.inqVarID(ncid,'lon');
latid = netcdf.inqVarID(ncid,'lat');
lon = netcdf.getVar(ncid,lonid);
lat = netcdf.getVar(ncid,latid);
varid = netcdf.inqVarID(ncid,'itn');
itn = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'idx');
idx = netcdf.getVar(ncid,varid);
netcdf.close(ncid);
nx=numel(lon);ny=numel(lat);
bcf=zeros(nx,ny,nt);
bcf_t=zeros(nt,1);
t=1;
for year=1958:2007
    for mon=1:12
        bcf_t(t)=year*100+mon;
        t=t+1;
    end
end
nyear=2007-1958+1;
idx_temp=idx(:,:,1);
%interpolation
obs=reshape(obs,nx_obs,ny_obs,nt);
pre_n=5;
[ obs ] = zhy_pre3d( obs,missvalue,pre_n );
obs(obs==missvalue)=0;
for t=1:nt
    obs_temp=obs(:,:,t);
    [ bcf_temp ] = zhy_interp2d( obs_temp,lat_obs,lon_obs,lat,lon );
    bcf_temp=bcf_temp.*double(idx_temp);
    bcf(:,:,t)=bcf_temp;
    fprintf('time %g finished \n',t);
end
bcf=bcf.*10;
bcf_yr=mean(bcf,3);
bcf_temp=reshape(bcf,nx,ny,12,nyear);
bcf_mn=mean(bcf_temp,4);
save bcv_soda bcf bcf_mn bcf_yr bcf_t
