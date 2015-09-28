
// Description: Ref. manual p.113
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-12-03 16:30:00 CST
// Last Change: 2012-12-03 16:33:34 CST

import graph;
from myfunctions access myshipout;

size(200,200,IgnoreAspect);
real f(real t) {return 1/t;}
scale(Log,Log);
draw(graph(f,0.1,10),red);
pen thin=linewidth(0.5*linewidth());
xaxis("$x$",BottomTop,LeftTicks(begin=false,end=false,extend=true, ptick=thin));
yaxis("$y$",LeftRight,RightTicks(begin=false,end=false,extend=true, ptick=thin));

myshipout();
