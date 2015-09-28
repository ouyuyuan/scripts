function [ obj ] = zhy_interp3d( obs,lat_obs,lon_obs,z_obs,lat_obj,lon_obj,z_obj )
%convert 3d field between different grid use matlab built-in function
nx=numel(lon_obj);ny=numel(lat_obj);nz=numel(z_obs);
obj1=zeros(nx,ny,nz);
for k=1:nz
    temp_obs=obs(:,:,k);
    [ temp_obj ] = zhy_interp2d( temp_obs,lat_obs,lon_obs,lat_obj,lon_obj );
    obj1(:,:,k)=temp_obj;
end

nz2=numel(z_obj);
obj=zeros(nx,ny,nz2);
for j=1:ny
    for i=1:nx
        temp_obs=reshape(obj1(i,j,:),nz,1);
        temp_obj=interp1(z_obs,temp_obs,z_obj,'pchip');
        obj(i,j,:)=temp_obj;
    end
end

end

