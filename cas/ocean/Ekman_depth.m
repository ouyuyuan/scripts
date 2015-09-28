
% Description: calculate Ekman layer depth, See Talley, s7, p23
%
%      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
%     Created: 2014-01-20 15:26:08 BJT
% Last Change: 2014-01-20 15:37:07 BJT

% rotating velocity of earth (rad/sec)
omg = 7.292e-5; 

% constant eddy viscosity (m^2/sec)
av = 0.05; 

% latitude (degree)
phi = 0:1:90; 

% depth of Ekman layer (m)
dep = sqrt( av ./ (omg.*sin(phi*pi/180.0)) ); 

plot(phi, dep);
