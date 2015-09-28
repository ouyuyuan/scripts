
// Description: 3D version of stagger grid
//       Usage: /usr/bin/asy -globalwrite -nosafe xxx.asy
//
//      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
//     Created: 2012-03-24 10:07:20 CST
// Last Change: 2013-03-22 16:12:15 CST

import three;
import EmacsColors;
from myfunctions access myshipout;

unitsize(2cm);

currentprojection=perspective(
camera=(5.00547458108566,7.67943283641286,3.348483558746),
up=(-0.00472278038548272,-0.00448207185997266,0.0163931786332591),
target=(-2.15297562431567,2.19452354605807,-0.213458100791961),
zoom=1,
angle=8.0677126968782,
autoadjust=false);

picture picb,picc,picd;

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
triple A = (1,0,0), B = (0,1,0), C = (-1,0,0), D = (0,-1,0);
path3 square=A--B--C--D--cycle;
draw(square,dashed);
label("A grid",0.5*(A+B),4*S);
draw(picb,square,dashed);
label(picb,"B grid",0.5*(A+B),4*S);
draw(picc,square,dashed);
label(picc,"C grid",0.5*(A+B),4*S);
draw(picd,square,dashed);
label(picd,"D grid",0.5*(A+B),4*S);

path3[] z=A^^B^^C^^D;
triple dzup=(0,0,0.06); 
path3[] u=(A+dzup)^^(B+dzup)^^(C+dzup)^^(D+dzup);
triple dzdown=(0,0,-0.06); 
path3[] v=(A+dzdown)^^(B+dzdown)^^(C+dzdown)^^(D+dzdown);

dot(z,red3); 
dot(picb,z,red3); 
dot(picc,z,red3); 
dot(picd,z,red3); 

dot(u,green4);
dot(v,mediumblue);

triple center = (1/4)*(A+B+C+D), dz = (0,0,0.03);
triple u = center + dz, v = center -dz;
dot(picb,u,green4);
label(picb,"$u$",u,N,green4);
dot(picb,v,mediumblue);
label(picb,"$v$",v,S,mediumblue);

path3[] u = ((1/2)*(A+B))^^((1/2)*(C+D));
path3[] v = ((1/2)*(C+B))^^((1/2)*(A+D));
dot(picc,u,green4);
label(picc,"$u$",(1/2)*(A+B),S,green4);
label(picc,"$u$",(1/2)*(C+D),N,green4);
dot(picc,v,mediumblue);
label(picc,"$v$",(1/2)*(C+B),E,mediumblue);
label(picc,"$v$",(1/2)*(A+D),W,mediumblue);
dot(picd,v,green4);
label(picd,"$u$",(1/2)*(C+B),E,green4);
label(picd,"$u$",(1/2)*(A+D),W,green4);
dot(picd,u,mediumblue);
label(picd,"$v$",(1/2)*(A+B),S,mediumblue);
label(picd,"$v$",(1/2)*(C+D),N,mediumblue);

label("$z$",A,W,red3);
label("$z$",B,E,red3);
label("$z$",C,E,red3);
label("$z$",D,W,red3);
label("$u$",A+dzup,N,green4);
label("$u$",B+dzup,N,green4);
label("$u$",C+dzup,N,green4);
label("$u$",D+dzup,N,green4);
label("$v$",A+dzdown,S,mediumblue);
label("$v$",B+dzdown,S,mediumblue);
label("$v$",C+dzdown,S,mediumblue);
label("$v$",D+dzdown,S,mediumblue);

label(picb,"$z$",A,W,red3);
label(picb,"$z$",B,E,red3);
label(picb,"$z$",C,E,red3);
label(picb,"$z$",D,W,red3);

label(picc,"$z$",A,W,red3);
label(picc,"$z$",B,E,red3);
label(picc,"$z$",C,E,red3);
label(picc,"$z$",D,W,red3);

label(picd,"$z$",A,W,red3);
label(picd,"$z$",B,E,red3);
label(picd,"$z$",C,E,red3);
label(picd,"$z$",D,W,red3);
//////////////////////////////////////////////////////////////////////////////
add(shift((-1.5,1.5,0))*picb);
add(shift((-3,3,0))*picc);
add(shift((-4.5,4.5,0))*picd);

myshipout("png");
