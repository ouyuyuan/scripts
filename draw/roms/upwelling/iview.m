
%data_dir = '/home/ou/archive/data/roms/upwelling';
data_dir = '/home/ou/archive/models/roms/roms_734/case/upwelling';
nc       = fullfile(data_dir,'ocean_avg.nc');
grid     = roms_get_grid(nc,nc);

roms_iview(nc, 'temp', 10, 10, grid);
colorbar;
