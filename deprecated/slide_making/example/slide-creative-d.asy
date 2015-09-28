
// Description: creative examples from other people
//
//  @hierarchy: Creative Examples | Automata
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-11-19 22:56:51 CST
// Last Change: 2012-11-19 23:40:50 CST

import myslide;
import simplenode;

include "latexpre.asy";

fillslide();

title("\bf Automata");

picture picAut;
size(picAut, slide.x*2.5/4);
pair posAut = (slide.x*2.0/4, slide.y*0.8/4);

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

draw(picAut, start, q0, q1, q2, q3, q4, q5, q6, q7);

draw(picAut, start -- q0 @ shorten, Arrow);
draw(picAut, ".", q0 -- q1 @ shorten, Arrow);
draw(picAut, "[0-9]", q1 -- q2 @ shorten, Arrow);
draw(picAut, ".", q3 -- q2 @ shorten, Arrow);
draw(picAut, "[eE]", q2 -- q4 @ shorten(1,2), Arrow);
draw(picAut, Label("[0-9]", LeftSide), q0 -- q3 @ shorten, Arrow);
draw(picAut, Label("[eE]", LeftSide), q3 -- q4 @ shorten, Arrow);
draw(picAut, Label("[+-]", LeftSide), q4 -- q5 @ shorten, Arrow);
draw(picAut, Label("[0-9]", LeftSide), q5 -- q6 @ shorten, Arrow);
draw(picAut, Label("[fFlL]", LeftSide), q6 -- q7 @ shorten(1,2), Arrow);
draw(picAut, "[0-9]", loop(q3, N) @ shorten, Arrow);
draw(picAut, "[0-9]", loop(q2, S) @ shorten(1,2), Arrow);
draw(picAut, "[0-9]", loop(q6, N) @ shorten(1,2), Arrow);
draw(picAut, "[0-9]", q4 .. bendright .. q6 @ shorten, Arrow);
draw(picAut, "[fFlL]", q2 .. bendright .. q7 @ shorten(1,2), Arrow);

add(scale(1.5)*picAut.fit(), posAut, N);
label(scale(1.5)*"\citep[P.93]{Liu2009asy}", posAut, S);
