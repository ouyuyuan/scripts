
// Description: Ref. manual p.114
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-12-03 16:38:10 CST
// Last Change: 2012-12-03 17:12:57 CST

import graph;
from myfunctions access myshipout;

size(200,IgnoreAspect);
// Base-2 logarithmic scale on y-axis:
real log2(real x) {static real log2=log(2); return log(x)/log2;}
real pow2(real x) {return 2^x;}
scaleT yscale=scaleT(log2,pow2,logarithmic=true);
scale(Linear,yscale);
real f(real x) {return 1+x^2;}
draw(graph(f,-4,4));
yaxis("$y$",ymin=1,ymax=f(5),RightTicks(Label()),EndArrow);
xaxis("$x$",xmin=-5,xmax=5,LeftTicks,EndArrow);

myshipout();
