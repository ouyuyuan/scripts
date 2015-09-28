
clear;

%data_dir = '/home/ou/archive/models/roms/roms_734/Apps/latte';
data_dir = '/home/ou/archive/models/roms/roms_342/Apps/latte_c';
draw_dir = '/home/ou/archive/drawing/roms/latte';
img      = fullfile(draw_dir, 'out.png');
titlestr = 'Sea Surface Salinity';

nc       = fullfile(data_dir,'out','lattec_his_nof.nc');
grid     = roms_get_grid(nc,nc);

varname  = 'temp';
timestep = 1;
timestr  = '15-Apr-2006 00:00:00';
%depth    = -3;
jindex   = 33;
uvstride = 3;
uvscale  = 0.2;
uvstring = 'g';

roms_jview(nc, varname, timestr, jindex, grid);
%caxis([20 34]); 
%caxis([4 14]); 
%caxis([0 34]); 
caxis([4 12]); 
colorbar;
%title(titlestr);
saveas(gcf,img);
