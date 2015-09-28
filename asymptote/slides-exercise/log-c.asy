
// Description: Ref. manual p.113
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-12-03 16:38:10 CST
// Last Change: 2012-12-03 16:47:14 CST

import graph;
from myfunctions access myshipout;

size(300,175,IgnoreAspect);
scale(Log,Log);
draw(graph(identity,5,20));
xlimits(5,20);
ylimits(1,100);
xaxis("$M/M_\odot$",BottomTop,LeftTicks(DefaultFormat, 
new real[] {6,10,12,14,16,18}));
yaxis("$\nu_{\rm upp}$ [Hz]",LeftRight,RightTicks(DefaultFormat));

myshipout();
