
// Description: Ref. manual p.111
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-11-28 15:38:12 CST
// Last Change: 2012-11-28 15:38:12 CST

import graph;
from myfunctions access myshipout;

import graph;
size(200,200,IgnoreAspect);
real f(real t) {return 1/t;}
scale(Log,Log);
draw(graph(f,0.1,10));
//xlimits(1,10,Crop);
//ylimits(0.1,1,Crop);
dot(Label("(3,5)",align=S),Scale((3,5)));
xaxis("$x$",BottomTop,LeftTicks);
yaxis("$y$",LeftRight,RightTicks);

myshipout();
