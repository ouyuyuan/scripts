
// Description: stagger grid
//       Usage: /usr/bin/asy -globalwrite -nosafe xxx.asy
//
//      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
//     Created: 2012-03-24 10:07:07 CST
// Last Change: 2016-05-06 10:42:45 BJT

import EmacsColors;
from myfunctions access myshipout;
include "latexpre.asy";

// horizontalgrid <<<1

unitsize(3.5cm);

pair A,B,C,D;
real len=0.05, lena=0.08;
A=(0,0);
B=(1,0);
C=(1,1);
D=(0,1);

path square = A--B--C--D--cycle;

draw(square);
label("a)", D, 6*N);

dot(A,red3); label("$g_{3j}$",A,0.4*SW,red3);
dot(B,red3); label("$g_{2j}$",B,0.4*SE,red3);
dot(C,red3); label("$g_{1j}$",C,0.4*NE,red3);
dot(D,red3); label("$g_{4j}$",D,0.4*NW,red3);

pair p = 0.5*(A+B);
draw( p--A, Arrow );
draw( p--B, Arrow );
label("$g_{ns}$", p, green4, Fill(white));

p = 0.5*(C+D);
draw( p--C, Arrow );
draw( p--D, Arrow );
label("$g_{ns}$", p, green4, Fill(white));

p = 0.5*(B+C);
draw( p--B, Arrow );
draw( p--C, Arrow );
label("$g_{ew}$", p, mediumblue, Fill(white));

p = 0.5*(A+D);
draw( p--A, Arrow );
draw( p--D, Arrow );
label("$g_{ew}$", p, mediumblue, Fill(white));

p = 0.25*(A+B+C+D);
label(scale(0.8)*"东", p, 2*S);
label(scale(0.8)*"西", p, 2*N);
label(scale(0.8)*"南", p, 3*W);
label(scale(0.8)*"北", p, 3*E);

// D grid <<<1

picture picb;
label(picb, "b)", D, 6*N);

dot(picb,A,red3); label(picb,"$g_{i2}$",A,S,red3);
dot(picb,D,red3); label(picb,"$g_{i1}$",D,N,red3);

p = 0.5*(A+D);
draw( picb, p--A, Arrow );
draw( picb, p--D, Arrow );
label(picb,"$g_{ud}$",p, Fill(white));

label(picb, scale(0.8)*"上", D, 2*E);
label(picb, scale(0.8)*"下", A, 2*E);

add(shift(2*right)*picb);

myshipout("pdf", "phdthesis/");
