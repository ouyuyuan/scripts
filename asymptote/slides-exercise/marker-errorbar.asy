
// Description: marker and errorbar, ref. manual p.107
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-11-11 10:00:19 CST
// Last Change: 2012-11-22 23:08:51 CST

import graph;
import mycolor;
from myfunctions access myshipout;

picture pic;

real xsize = 8cm;
real ysize = 6cm;

size(pic, xsize, ysize, IgnoreAspect);

pair[] f  = {(5,5), (50,20), (90,90)};
pair[] df = {(0,0), (5, 7), (0,5)};

draw(pic, graph(f), "pairs", marker(scale(0.8mm)*unitcircle, red,
    FillDraw(blue),above=false));
errorbars(pic, f, df, red);

// automatically adust axes ticks, keep before xaxis, yaxis function
scale(pic, true); 
xaxis(pic, "$x$",BottomTop, LeftTicks(Label(fontsize(9pt))));
yaxis(pic, "$y$",LeftRight, RightTicks(Label(fontsize(9pt))));
add(pic, legend(pic, linelength=0.8cm, nullpen), point(pic, NW), 20SE);

picture pic2;
size(pic2, xsize, ysize, IgnoreAspect);

frame mark;
filldraw(mark, scale(0.8mm)*polygon(6), green, green);
draw(mark, scale(0.8mm)*cross(6), blue);
draw(pic2, graph(f), marker(mark, markuniform(5)));

scale(pic2, true); 

xaxis(pic2, "$x$",BottomTop, LeftTicks(Label(fontsize(9pt))));
yaxis(pic2, "$y$",LeftRight, RightTicks(Label(fontsize(9pt))));

yequals(pic2, 55.0, red+Dotted);
xequals(pic2, 70.0, red+Dotted);

add(pic.fit(), (0,0), W); // .fit() can have alignment
add(pic2.fit(), (5mm,0), E);

myshipout();
