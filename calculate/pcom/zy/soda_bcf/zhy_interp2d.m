function [ obj ] = zhy_interp2d( obs,lat_obs,lon_obs,lat_obj,lon_obj )
%convert 2d field between different grid use matlab built-in function
% %change precision
% obs=double(obs);
% lat_obs=double(lat_obs);
% lon_obs=double(lon_obs);
% lat_obj=double(lat_obj);
% lon_obj=double(lon_obj);
%check size
s1=size(lat_obs,1);
s2=size(lat_obs,2);
if s1>s2
    lat_obs=lat_obs';
end
s1=size(lat_obj,1);
s2=size(lat_obj,2);
if s1>s2
    lat_obj=lat_obj';
end
s1=size(lon_obj,1);
s2=size(lon_obj,2);
if s1>s2
    lon_obj=lon_obj';
end
s1=size(lon_obs,1);
s2=size(lon_obs,2);
if s1>s2
    lon_obs=lon_obs';
end
%
nx=numel(lon_obs);ny=numel(lat_obs);ny_obj=numel(lat_obj);
lat_old=lat_obs;
s_id=1;
n_id=ny;
dlat=lat_obs(2)-lat_obs(1);
dlon=lon_obs(2)-lon_obs(1);
while lat_obs(1)>lat_obj(1)
    lat=lat_obs(1)-dlat;
    lat_obs=[lat lat_obs];
    s_id=s_id+1;
    n_id=n_id+1;
end
ny=numel(lat_obs);
while lat_obs(ny)<lat_obj(ny_obj)
    lat=lat_obs(ny)+dlat;
    lat_obs=[lat_obs lat];
    ny=numel(lat_obs);
end
ny=numel(lat_obs);

lat_check=lat_obs(s_id:n_id)-lat_old;
if sum(lat_check>0)
    fprintf('lat direction expand fail \n');
end

lat_obs_ex=lat_obs;
lon_obs_ex=zeros(1,nx+2);
obs_ex=zeros(nx+2,ny);

lon_obs_ex(2:nx+1)=lon_obs;
lon_obs_ex(1)=lon_obs_ex(2)-dlon;
lon_obs_ex(nx+2)=lon_obs_ex(nx+1)+dlon;

obs_ex(2:nx+1,s_id:n_id)=obs;
obs_ex(1,:)=obs_ex(nx+1,:);
obs_ex(nx+2,:)=obs_ex(2,:);

ex_num=ny-numel(lat_old);
if ex_num==2
for i=2:fix(nx/2)+1
    obs_ex(i,1)=obs_ex(i+fix(nx/2),2);
    obs_ex(i,ny)=obs_ex(i+fix(nx/2),ny-1);
end
for i=fix(nx/2)+1:nx+1
    obs_ex(i,1)=obs_ex(i-fix(nx/2),2);
    obs_ex(i,ny)=obs_ex(i-fix(nx/2),ny-1);
end
end

[XI,YI] = meshgrid(lat_obj,lon_obj);
obj=interp2(lat_obs_ex,lon_obs_ex,obs_ex,XI,YI,'linear');

obj_nan=obj(isnan(obj));
if numel(obj_nan)>0
    fprintf('Something is wrong \n');
end

end

