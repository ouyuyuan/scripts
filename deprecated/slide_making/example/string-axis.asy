
// Description: label an axis with arbitary string. P. 109 manual
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-11-21 14:52:41 CST
// Last Change: 2012-11-26 14:07:54 CST


import graph;
from myfunctions access myshipout;

size(10cm);

real[] x=sequence(12);
real[] y=sin(2pi*x/12);
scale(false);
string[] month={"Jan","Feb","Mar","Apr","May","Jun",
"Jul","Aug","Sep","Oct","Nov","Dec"};
draw(graph(x,y),red,MarkFill[0]);

string xtick(real x) {
    int m = round(x%12);
    return month[m];
}

xaxis(BottomTop,LeftTicks(xtick));
yaxis("$y$",LeftRight,RightTicks(4)); // show 4 ticks 


myshipout();
