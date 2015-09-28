
// Description: simple example
//
//  @hierarchy: Simple Examples
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-11-13 20:02:01 CST
// Last Change: 2012-12-03 16:29:32 CST

import myslide;
import graph;
import contour;

include "latexpre.asy";

fillslide();
title("\bf Simple Examples");
//====================================================================

// two circles
//--------------------------------------------------------------------
picture picCir;
unitsize(picCir, 2cm);

pair A = (0,0); label(picCir, "A",A, SW);
pair B = (1,0); label(picCir, "B",B, SE);
pair C = (1,1); label(picCir, "C",C, NE);
pair D = (0,1); label(picCir, "D",D, NW);

path circ = A..B..C..D..cycle;
path dcirc = scale(2)*circ;

filldraw(picCir, circ^^dcirc,evenodd+mylightblue,black);

pair posCir = (slide.x*1/8, slide.y*2.2/3);
add(picCir.fit(), posCir);

// curves
//--------------------------------------------------------------------
picture picCur;
unitsize(picCur, 4cm);

pair B = (1,0); label(picCur, "B",B, SE);
pair C = (1,1); label(picCur, "C",C, NE);
pair D = (0,1); label(picCur, "D",D, NW);

draw(picCur, B..D,mygreen, Arrow);
draw(picCur, B{up}..{down}D, myred, Arrow);
draw(picCur, B{right}..D, myblue, Arrow);
draw(picCur, B{up}..{left}D, Arrow);
draw(picCur, B{right}..{left}D, magenta, Arrow);
draw(picCur, B{right}..{right}D, myred, Arrow);
draw(picCur, B..C..D, mygreen);

pair posCur = (slide.x*1.2/3, slide.y * 1.6/3);
add(picCur.fit(), posCur);

// line proportion
//--------------------------------------------------------------------
picture picPro;
unitsize(picPro, 6cm);

pair A = (0,0); label(picPro, "A",A, SW);
pair B = (1,0); label(picPro, "B",B, SE);
pair C = (1,1); label(picPro, "C",C, NE);
pair D = (0,1); label(picPro, "D",D, NW);

draw(picPro, A -- B -- C -- D -- cycle);

real t = 1/5;

pair E = interp(A, B, t);
pair F = interp(B, C, t);
pair G = interp(C, D, t);
pair H = interp(D, A, t);

draw(picPro, E -- F -- G -- H -- cycle, dashed+myblue);

arrow(picPro, "$proportion=\frac{1}{5}$", E, SE, 
    arrow=Arrow(6)); 
label(picPro, "{\color{red} \em (Zhang, 2010, P.30)}", (A+B)/2, 10S);

pair posPro = (slide.x*3/4, slide.y * 1.8/3);
add(picPro.fit(), posPro);

// explicite function
//--------------------------------------------------------------------
picture picExp;

size(picExp, 15cm);

real f(real x) { return x; }
real g(real x) { return x^2; }
real h(real x) { return x^3; }

guide gf = graph(f, -2, 2, operator..);
guide gg = graph(g, -2, 2, operator..);
guide gh = graph(h, -2, 2, operator..);

draw(picExp, gf, myred+linewidth(1));
draw(picExp, gg, mygreen+linewidth(0.8));
draw(picExp, gh, myblue+linewidth(0.5));

label(picExp, Label("$y=x$",   position=EndPoint, align=E), gf);
label(picExp, Label("$y=x^2$", position=EndPoint, align=E), gg);
label(picExp, Label("$y=x^3$", position=EndPoint, align=E), gh);

xaxis(picExp, "$x$", Arrow(4));
yaxis(picExp, "$y$", Arrow(4));
label(picExp, "{\color{red} \em (Zhang, 2010, P.36)}", (0, 0), 5SE);

pair posExp = (slide.x*0.4/4, slide.y * 1.0/3);
add(picExp.fit(), posExp);

// implicit functions
//--------------------------------------------------------------------
picture picImp;

size(picImp, slide.x*1.2/4);

real x(real t) { return (1-t^2)/(1+t^2); }
real y(real t) { return t*(1-t^2)/(1+t^2); }
guide gf = graph(x,y,-2,2);

draw(picImp, gf, mygreen+linewidth(0.8));

string eqn = "$ x=\frac{1-t^2}{1+t^2},\,
                y=t\frac{1-t^2}{1+t^2} $";
label(picImp, Label(eqn, position=EndPoint, align=W), gf);
xaxis(picImp, "$x$",Arrow);
yaxis(picImp, "$y$",Arrow);

real[] z = {0}; // contour value(s)
real g(pair p) {
    real x = p.x, y = p.y;
    return x^3 + y^3 - 3*x*y; }

pair a = (-3, -3), b = (3, 3);
guide[][] gg = contour(g, a, b, z);
draw(picImp, gg, myblue+linewidth(0.8)+dashed);
label(picImp, "$x^3+y^3-3xy=0$", (1, -3));
label(picImp, "{\color{red} \em (Zhang, 2010, P.37)}", (0, -2), W);

pair posImp = (slide.x*1.8/4, slide.y * 1.0/3);
add(picImp.fit(), posImp);

// clip trick
//--------------------------------------------------------------------
picture picCli;

size(picCli, slide.x*1.2/4);

pair A = (-1, 0); 
pair B = (1, 0); 
pair C = (1, 1);

picture picCli2;

guide tri = A -- B -- C -- cycle;

filldraw(picCli2, tri, mylightblue, linewidth(1));
draw(picCli2, unitcircle, dashed);
clip(picCli2, tri);

draw(picCli, unitcircle);
add(picCli, picCli2);

label(picCli, "{\color{red} \em (Zhang, 2010, P.40)}", (0, -1), S);

pair posCli = (slide.x*3.2/4, slide.y * 0.8/3);
add(picCli.fit(), posCli);
pagenumber(03);

shipout("slide-03.pdf");

