
xi_rho = 43;
eta_rho = 82;

outdir = '/home/ou/archive/models/roms/roms_734/case/upwelling';
fgrid  = fullfile(outdir, 'grid.nc');
fref   = fullfile(outdir, 'ocean_his.nc');

new_file = true;
%new_file = false;
spherical = false;

c_grid( xi_rho, eta_rho, fgrid, new_file, spherical );

var.name = 'spherical';
var.value = 0;
ncwrite(fgrid, var.name, var.value);

var.name = 'xl';
var.value = (xi_rho - 2) * 100;
ncwrite(fgrid, var.name, var.value);

var.name = 'el';
var.value = (xi_rho - 2) * 100;
ncwrite(fgrid, var.name, var.value);

var.name = 'pm';
var.value = ones(xi_rho, eta_rho, 'double') * 0.001;
ncwrite(fgrid, var.name, var.value);

var.name = 'pn';
var.value = ones(xi_rho, eta_rho, 'double') * 0.001;
ncwrite(fgrid, var.name, var.value);

var.name = 'f';
var.value = ones(xi_rho, eta_rho, 'double') * (-8.26e-5);
ncwrite(fgrid, var.name, var.value);

vars = {'h', 'x_rho', 'y_rho', 'x_psi', 'y_psi', 'x_u', 'y_u', 'x_v', 'y_v'};
for field = vars,
  var.name  = char(field);
  var.value = ncread(fref, var.name);
  ncwrite(fgrid, var.name, var.value);
end
