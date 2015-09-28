
// Description: Ref. manual p.104
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-11-09 16:13:51 CST
// Last Change: 2012-11-21 21:21:24 CST

import graph;
from myfunctions access myshipout;

size(8cm, 6cm, IgnoreAspect);

real[] x = {0,1,2,3};
real[] y = x^2;

draw(graph(x,y));

xaxis("$x$", BottomTop, LeftTicks);
yaxis("$y$", LeftRight, RightTicks(Label(fontsize(8pt)), 
    new real[]{0,4,9}));

myshipout();
