function [ obs ] = zhy_pre2d( obs,miss,pre_n )
%prepare 2d array for interpolation
nx=size(obs,1);ny=size(obs,2);
idx=zeros(nx,ny)+1;
idx(obs==miss)=0;
for pri=1:pre_n
    obs_temp=obs;
    for j=2:ny-1
        for i=2:nx-1
            if idx(i,j)==0
                temp=[obs_temp(i+1,  j) obs_temp(i-1,  j) obs_temp(i  ,j+1) obs_temp(i  ,j-1) ...
                      obs_temp(i+1,j+1) obs_temp(i+1,j-1) obs_temp(i-1,j+1) obs_temp(i-1,j-1)];
                temp=temp(temp~=miss);
                if ~isempty(temp)
                    obs(i,j)=mean(temp);
                    idx(i,j)=1;
                end
            end
        end
        if idx(1,j)==0
            temp=[obs_temp(2,  j) obs_temp(nx,  j) obs_temp(i ,j+1) obs_temp(i ,j-1) ...
                  obs_temp(2,j+1) obs_temp(2 ,j-1) obs_temp(nx,j+1) obs_temp(nx,j-1)];
            temp=temp(temp~=miss);
            if ~isempty(temp)
                obs(1,j)=mean(temp);
                idx(1,j)=1;
            end
        end
        if idx(nx,j)==0
            temp=[obs_temp(1,  j) obs_temp(nx-1,j) obs_temp(i   ,j+1) obs_temp(i   ,j-1) ...
                  obs_temp(1,j+1) obs_temp(1 ,j-1) obs_temp(nx-1,j+1) obs_temp(nx-1,j-1)];
            temp=temp(temp~=miss);
            if ~isempty(temp)
                obs(nx,j)=mean(temp);
                idx(nx,j)=1;
            end
        end
    end
    %j=1
    j=1;
    for i=2:nx-1
        if idx(i,1)==0
            temp=[obs_temp(i+1,j) obs_temp(i-1,j) obs_temp(i,j+1) obs_temp(i+1,j+1) obs_temp(i-1,j+1)];
            temp=temp(temp~=miss);
            if ~isempty(temp)
                obs(i,j)=mean(temp);
                idx(i,j)=1;
            end
        end
    end
    if idx(1,j)==0
        temp=[obs_temp(2,j) obs_temp(nx,j) obs_temp(i,j+1) obs_temp(2,j+1) obs_temp(nx,j+1)];
        temp=temp(temp~=miss);
        if ~isempty(temp)
            obs(1,j)=mean(temp);
            idx(1,j)=1;
        end
    end
    if idx(nx,j)==0
        temp=[obs_temp(1,j) obs_temp(nx-1,j) obs_temp(i,j+1) obs_temp(1,j+1) obs_temp(nx-1,j+1)];
        temp=temp(temp~=miss);
        if ~isempty(temp)
            obs(nx,j)=mean(temp);
            idx(nx,j)=1;
        end
    end
    %j=ny
    j=ny;
    for i=2:nx-1
        if idx(i,1)==0
            temp=[obs_temp(i+1,j) obs_temp(i-1,j) obs_temp(i,j-1) obs_temp(i+1,j-1) obs_temp(i-1,j-1)];
            temp=temp(temp~=miss);
            if ~isempty(temp)
                obs(i,j)=mean(temp);
                idx(i,j)=1;
            end
        end
    end
    if idx(1,j)==0
        temp=[obs_temp(2,j) obs_temp(nx,j) obs_temp(i,j-1) obs_temp(2,j-1) obs_temp(nx,j-1)];
        temp=temp(temp~=miss);
        if ~isempty(temp)
            obs(1,j)=mean(temp);
            idx(1,j)=1;
        end
    end
    if idx(nx,j)==0
        temp=[obs_temp(1,j) obs_temp(nx-1,j) obs_temp(i,j-1) obs_temp(1,j-1) obs_temp(nx-1,j-1)];
        temp=temp(temp~=miss);
        if ~isempty(temp)
            obs(nx,j)=mean(temp);
            idx(nx,j)=1;
        end
    end
end

end

