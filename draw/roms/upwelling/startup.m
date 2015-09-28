function startup

my_home     = getenv('HOME');
my_utility  = strcat(my_home, '/archive/models/roms/matlab/utility');
roms_wilkin = strcat(my_home, '/archive/codes/matlab/roms_wilkin');

path(path, fullfile(my_utility, ''))
path(path, fullfile(roms_wilkin, ''))

%path(path, fullfile(my_root, 'matlab', '4dvar', ''))
%path(path, fullfile(my_root, 'matlab', 'bathymetry', ''))
%path(path, fullfile(my_root, 'matlab', 'boundary', ''))
%path(path, fullfile(my_root, 'matlab', 'coastlines', ''))
%path(path, fullfile(my_root, 'matlab', 'forcing', ''))
%path(path, fullfile(my_root, 'matlab', 'grid', ''))
%path(path, fullfile(my_root, 'matlab', 'initial', ''))
%path(path, fullfile(my_root, 'matlab', 'landmask', ''))
%path(path, fullfile(my_root, 'matlab', 'mex', ''))
%path(path, fullfile(my_root, 'matlab', 'netcdf', ''))
%path(path, fullfile(my_root, 'matlab', 'seagrid', ''))
%path(path, fullfile(my_root, 'matlab', 'seagrid', 'presto', ''))
%path(path, fullfile(my_root, 'matlab', 'seawater', ''))
%path(path, fullfile(my_root, 'matlab', 't_tide', ''))
%path(path, fullfile(my_root, 'matlab', 'tidal_ellipse', ''))
%path(path, fullfile(my_root, 'matlab', 'utility', ''))

% Load NetCDF Toolbox for OpenDAP support for versions 2008b or higher. 
% However, this is not needed if version 2012a or higher since Matlab
% native NetCDF interface supports OpenDAP.  Users need to change the
% paths for SNCTOOLS and JAVA.

v = version('-release');
vyear = str2num(v(1:4));
load_toolbox = vyear >= 2008;
if ((vyear == 2008 && v(5:5) == 'a') || vyear >= 2012),
  load_toolbox = false;
end

if (load_toolbox),
  addpath (strcat(my_home, '/archive/codes/matlab/snctools'), '-end');
  javaaddpath (strcat(my_home, '/archive/codes/matlab/classes/toolsUI-4.3.jar'), '-end');
  javaaddpath (strcat(my_home, '/archive/codes/matlab/classes/netcdfAll-4.3.jar'), '-end');
  javaaddpath (strcat(my_home, '/archive/codes/matlab/snctools/classes'), '-end');
  setpref('SNCTOOLS','USE_JAVA', true);
end
