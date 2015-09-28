
clear;

%data_dir = '/home/ou/archive/models/roms/roms_734/Apps/latte';
%data_dir = '/home/ou/archive/models/roms/roms_342/Apps/latte_c';
data_dir = '/home/ou/archive/data/roms/latte/TH';
draw_dir = '/home/ou/archive/drawing/roms/latte';
img      = fullfile(draw_dir, 'out.png');

%varname  = 'salt';
varname  = 'temp';
timestr  = '15-Apr-2006 00:00:00';
titlestr = timestr;

nc       = fullfile(data_dir,'lattec_his_nof.nc');
grid     = roms_get_grid(nc,nc);

%timestep = 1;
%depth    = -3;
depth    = -0.0001;
uvstride = 3;
uvscale  = 0.5;
uvstring = 'k';

%roms_zview(nc, varname, timestep, depth, grid, uvstride, uvscale, uvstring);
%roms_zview(nc, varname, timestep, depth, grid);
%roms_zview(nc, varname, timestr, depth, grid);
roms_zview(nc, varname, timestr, depth, grid, uvstride, uvscale, uvstring);
%caxis([24 35]); 
caxis([4 14]); 
%caxis([0 34]); 
colorbar;
title(titlestr);
saveas(gcf,img);
