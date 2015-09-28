
// Description: triangle, circle, Chinese label, perpendicular mark, grid 
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-09-14 09:14:16 CST
// Last Change: 2012-11-19 20:50:59 CST

import math;
import mycolor;
from myfunctions access myshipout;

texpreamble("\usepackage{CJKutf8}\AtBeginDocument{\begin{CJK*}{UTF8}{gbsn}}
\AtEndDocument{\clearpage\end{CJK*}}");

unitsize(1cm);

// background grid
for (int i=0;i<=8;++i) {
    pen helpline = linewidth(0.2bp) + gray(0.7);
    pair a = (0,i);
    pair b = (8,i);
    pair c = (i,0);
    pair d = (i,8);
    draw (a--b^^c--d,helpline);
}

// triangle
pair a=(2,1), b=(7,3), c=(3,7);
draw(a--b--c--cycle);
label("A",a,SW);
label("B",b,E);
label("C",c,NW);

// outside circle
pair d=0.5(a+b), e=0.5(b+c), f=0.5(c+a);
pair o = extension (d, rotate(90,d)*b, e, rotate(90,e)*c);
path cir = circle(o, abs(o-a));
draw(cir, myred);
draw(o--d^^o--e^^o--f, myblue);
dot(o, myred);
label("D",d,SE);
label("E",e,NE);
label("F",f,NW);
label("O",o,SW);

// perpendicucar mark
path rightangle (pair a, pair b, pair c, real size=0.1) {
    // b is the vertex, a & c are two points on each side
    pair ba = size*unit(a-b);
    pair bc = size*unit(c-b);
    pair bb = ba+bc;
    return shift(b)*(ba--bb--bc);
}
draw(rightangle(o,d,b)^^rightangle(o,e,c)^^rightangle(o,f,a),myblue);

// text
string text = minipage("$\triangle ABC$~的外接圆~$\odot O$.\\ 
三角形的外心是三角形三条边的垂直平分线的交点.",2.5cm);
pair p = (8.2,5);
label(text, p, E);

myshipout();
