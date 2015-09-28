function [ obs ] = zhy_pre3d( obs,miss,pre_n )
%prepare 3d array for interpolation
nz=size(obs,3);
for k=1:nz
    temp=obs(:,:,k);
    [ temp ] = zhy_pre2d( temp,miss,pre_n );
    obs(:,:,k)=temp;
    fprintf('level %g finished \n',k);
end
end
