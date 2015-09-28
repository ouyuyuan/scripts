//#_*_ coding: utf-8 _*_

// Description: Finite Automata Machine
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-09-19 15:04:10 CST
// Last Change: 2012-11-15 21:10:41 CST

import simplenode;
import mycolor;

settings.tex="xelatex";
usepackage("xeCJK");
texpreamble("\setCJKmainfont[BoldFont={Adobe Heiti Std},
    ItalicFont={Adobe Kaiti Std}]{Adobe Song Std}");

real sx=10cm, sy=6cm;
size(sx, sy);

real u = 2cm;
Arrow = Arrow(6);
pen textpen = black;
currentpen = linewidth(0.6) + fontcommand("\scriptsize\ttfamily");
drawtype statedraw = compose(shadow, filldrawer(mylightgreen, darkgreen+0.6));
drawtype acceptdraw = compose(shadow, filler(mylightgreen),
doubledrawer(darkgreen+0.6));

node q0 = circlenode("$q_0$", (0,0), textpen, statedraw),
q1 = circlenode("$q_1$", q0.pos + u*S, textpen, statedraw), 
q2 = circlenode("$q_2$", q1.pos + u*E, textpen, acceptdraw),
q3 = circlenode("$q_3$", q0.pos + u*E, textpen, statedraw), 
q4 = circlenode("$q_4$", q3.pos + u*E + 0.5u*S, textpen, statedraw), 
q5 = circlenode("$q_5$", q4.pos + u*E, textpen, statedraw), 
q6 = circlenode("$q_6$", q5.pos + u*E, textpen, acceptdraw), 
q7 = circlenode("$q_7$", q6.pos + u*E, textpen, acceptdraw);
node start = circlenode("开始", q0.pos + 0.7u*W, textpen, none);

draw(start, q0, q1, q2, q3, q4, q5, q6, q7);

draw(start -- q0 @ shorten, Arrow);
draw(".", q0 -- q1 @ shorten, Arrow);
draw("[0-9]", q1 -- q2 @ shorten, Arrow);
draw(".", q3 -- q2 @ shorten, Arrow);
draw("[eE]", q2 -- q4 @ shorten(1,2), Arrow);
draw(Label("[0-9]", LeftSide), q0 -- q3 @ shorten, Arrow);
draw(Label("[eE]", LeftSide), q3 -- q4 @ shorten, Arrow);
draw(Label("[+-]", LeftSide), q4 -- q5 @ shorten, Arrow);
draw(Label("[0-9]", LeftSide), q5 -- q6 @ shorten, Arrow);
draw(Label("[fFlL]", LeftSide), q6 -- q7 @ shorten(1,2), Arrow);
draw("[0-9]", loop(q3, N) @ shorten, Arrow);
draw("[0-9]", loop(q2, S) @ shorten(1,2), Arrow);
draw("[0-9]", loop(q6, N) @ shorten(1,2), Arrow);
draw("[0-9]", q4 .. bendright .. q6 @ shorten, Arrow);
draw("[fFlL]", q2 .. bendright .. q7 @ shorten(1,2), Arrow);
