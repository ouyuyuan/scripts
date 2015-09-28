
// Description: manual P. 103
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-11-02 17:01:40 CST
// Last Change: 2012-11-22 23:08:58 CST

import graph;
from myfunctions access myshipout;

size(400, 200, IgnoreAspect);

real Sin(real t) { return sin(2pi*t); }
real Cos(real t) { return cos(2pi*t); }

guide gs = graph(Sin, 0, 1, operator ..);
guide gc = graph(Cos, 0, 1, operator ..);

string ls = "$\sin(2\pi x)$";
string lc = "$\cos(2\pi x)$";

draw(gs, ls);
draw(gc, dashed, lc);

xaxis("$x$", BottomTop, LeftTicks);
yaxis("$y$", LeftRight, RightTicks(trailingzero));

label(ls, (1/2, 0), UnFill(1mm));
label(lc, (1/4, 0), UnFill(1mm));
//attach(legend(), point(E), 20E, UnFill);
// UnFill option will delete ticks
attach(legend(), point(N), 5N);

myshipout();
