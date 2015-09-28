
// Description: kinetic energgy
//       Usage: /usr/bin/asy -globalwrite -nosafe xxx.asy
//
//      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
//     Created: 2013-03-22 15:11:07 CST
// Last Change: 2013-03-22 19:40:05 CST

import three;
import EmacsColors;
from myfunctions access myshipout;

currentprojection=perspective(
camera=(3.158625225403,-4.78635507275866,1.12904377821577),
up=(-4.03653373021144e-07,0.00106675858616062,0.0049193077071443),
target=(0.517420183494382,0.510083272556323,-0.019717162444197),
zoom=0.822702474791882,
angle=5.41086678783441,
autoadjust=false);

size(3cm);

pen zpen, kpen, upen, vpen;
zpen = red3;
kpen = tomato2;
upen = mediumblue;
vpen = green4;

triple A = (0,0,0), B = (1,0,0), C = (1,1,0), D = (0,1,0);
path3 square=A--B--C--D--cycle;

draw(square);

triple z, k, u, v;
z = (0,1,0);
k = z + 0.05*Z;
u = z + 0.5*X;
v = z - 0.5*Y;

dot(z, zpen);
label("$\phi$", z, SE, zpen);

dot(k, kpen);
label("$K$", k, Z, zpen);

dot(u, upen);
label("$u$", u, SE, upen);

dot(v, vpen);
label("$v$", v, N, vpen);

myshipout("3d","gpem");
