
// Description: standard graph package
//
//   @hierarchy: Graph Module | d
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-11-21 15:15:59 CST
// Last Change: 2012-12-03 22:56:05 CST

import myslide;
import graph;

include "latexpre.asy";

title("\bf d");

////////////////////////////////////////////////////////////////////////////////
//
// string axis
//
picture picStr;
size(picStr, slidex*1.0/4, slidey*1.0/4, IgnoreAspect);

real[] x=sequence(12);
real[] y=sin(2pi*x/12);
scale(false);
string[] month={"Jan","Feb","Mar","Apr","May","Jun",
"Jul","Aug","Sep","Oct","Nov","Dec"};
draw(picStr, graph(x,y),red,MarkFill[0]);

string xtick(real x) {
    int m = round(x%12);
    return month[m];
}

xaxis(picStr, BottomTop,LeftTicks(xtick));
yaxis(picStr, "$y$",LeftRight,RightTicks(4)); // show 4 ticks 

pair posStr = (slidex*0.7/4, slidey*2.4/4);
add(picStr.fit(), posStr, N);
label("{\bf string axis} {\color{red} \em (manual, 2004, P.109)}", posStr, S);

////////////////////////////////////////////////////////////////////////////////
//
// parameterized curve
//
picture picPar;
size(picPar, slidex*1.0/4);
real x(real t) {return cos(2pi*t);}
real y(real t) {return sin(2pi*t);}
draw(picPar, graph(x,y,0,1), blue);
xlimits(picPar, -0.5,1,Crop);
//ylimits(picPar, -1,0,Crop);
xaxis(picPar, "$x$",BottomTop,LeftTicks);
yaxis(picPar, "$y$",LeftRight,RightTicks(trailingzero));

pair posPar = (slidex*3.1/4, slidey*2.0/4);
add(picPar.fit(), posPar, N);
label("{\bf parameterized, crop} {\color{red} \em (manual, 2004, P.110)}", posPar, S);

////////////////////////////////////////////////////////////////////////////////
//
// scaling axis
//
picture picSca;
size(picSca, slidex*0.9/4, IgnoreAspect);

axiscoverage = 0.9; // the bigger, the more ticks

real[] x = {-1e-11,1e-11};
real[] y = {0,1e6};
real xscale = round(log10(max(x)));
real yscale = round(log10(max(y)))-1;

draw(picSca, graph(x*10^(-xscale),y*10^(-yscale)),red);
xaxis(picSca, "$x(10^{"+(string) xscale+"})$",BottomTop,LeftTicks);
yaxis(picSca, "$y(10^{"+(string) yscale+"})$",LeftRight,
    RightTicks(trailingzero), autorotate=false);

pair posSca = (slidex*1.3/4, slidey*2.2/4);
add(picSca.fit(), posSca, NE);
label("{\bf scaling axis} {\color{red} \em (manual, 2004, P.111)}", posSca, SE);

////////////////////////////////////////////////////////////////////////////////
//
// Log plot
//
pair posLoga = (slidex*0.7/4, slidey*0.4/4);
label(graphic("log-a.eps", "width=10cm"), posLoga, N);
label("{\bf lag-a} {\color{red} \em (manual, 2004, P.112)}", posLoga, S);

pair posLoga = (slidex*1.8/4, slidey*0.2/4);
label(graphic("log-b.eps", "width=10cm"), posLoga, N);
label("{\bf log-b} {\color{red} \em (manual, 2004, P.113)}", posLoga, S);

pair posLoga = (slidex*3.0/4, slidey*0.3/4);
label(graphic("log-c.eps", "width=15cm"), posLoga, N);
label("{\bf log-c} {\color{red} \em (manual, 2004, P.113)}", posLoga, S);
pagenumber(10);

shipout("slide-10.pdf");

