
// Description: Ref. manual P.104 
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-11-09 16:01:39 CST
// Last Change: 2012-11-21 22:25:37 CST

import graph;
import mycolor;
from myfunctions access myshipout;

size(8cm, 6cm, IgnoreAspect);

typedef real sinfn(real);
sinfn sinfn(real c) { 
    return new real(real x) { 
        return sin(c*x); 
    };
}

pen[] pens;
pens.push(black);
pens.push(myred);
pens.push(myblue);
pens.push(mygreen);

for (int i=1; i<5; ++i) {
    guide g = graph( sinfn(i*pi), 0, 1 );
    string label = "$\sin(" + ( i==1? "" : (string)i ) + "\pi x)$";
    draw(g, pens[i-1], label);
}

xaxis("$x$", BottomTop, LeftTicks);
yaxis("$y$", LeftRight, RightTicks(trailingzero));
attach(legend(2, linelength=0.5cm, nullpen), (point(S).x, truepoint(S).y), S); 
// can't use UnFill option after 10S as the manual!
// see Manual P.49 to find the point(..) truepoint(..) function

myshipout();
