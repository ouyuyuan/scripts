
// Description: PHD plan 
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-09-25 19:11:42 CST
// Last Change: 2012-09-26 21:51:49 CST

import plan_going;
import mycolor;

string content, begin_date, unit;
int plan_days, total;
pair pos;
plan[] plans;

//size(10cm, 5cm);
real u = 10cm;
pen contentpen = black+fontsize(1cm);
currentpen = linewidth(0.6) + fontcommand("\scriptsize\ttfamily");
drawtype waitdraw = compose(shadow, filler(opacity(0.4)+mylightblue));
drawtype finishdraw = compose(shadow, filler(mylightgreen));
drawtype goingdraw = compose(shadow, filler(mylightgreen),
    doubledrawer(darkgreen+0.6));

content = "DEGREE";
begin_date = "2012-08-20";
plan_days = 547;
total = 547;
unit = "day";
pos = (0,0);
plan degree = newplan(content, begin_date, plan_days, total, unit, pos,
    contentpen, compose(shadow, filler(opacity(0.5)+myred), drawer(orange+2))); 

content = "Read PCOM";
begin_date = "2012-09-25";
plan_days = 90;
total = 5579;
unit = "lines";
pos = degree.pos + u*W;
plan readpcom = newplan(content, begin_date, plan_days, total, unit, pos,
    contentpen, waitdraw);
draw(readpcom -- degree @ shorten(1,5), Arrow);
plans.push(readpcom);

content = "Write GPEM";
begin_date = "2012-09-25";
plan_days = 30;
total = 2500;
unit = "lines";
pos = degree.pos + 0.8*u*NW;
plan writegpem = newplan(content, begin_date, plan_days, total, unit, pos,
    contentpen, waitdraw);
draw(writegpem -- degree @ shorten(1,5), Arrow);
plans.push(writegpem);

content = "Holton";
begin_date = "2012-08-16";
plan_days = 100;
total = 553;
unit = "page";
pos = degree.pos + u*E;
plan holton = newplan(content, begin_date, plan_days, total, unit, pos,
    contentpen, waitdraw);
draw(holton -- degree @ shorten(1,15), Arrow);
plans.push(holton);

content = "Thomas";
begin_date = "2012-08-16";
plan_days = 150;
total = 1564;
unit = "page";
pos = degree.pos + u*S;
plan thomas = newplan(content, begin_date, plan_days, total, unit, pos,
    contentpen, waitdraw);
draw(thomas -- degree @ shorten(1,15), Arrow);
plans.push(thomas);

content = "Feynman";
begin_date = "2012-08-21";
plan_days = 275;
total = 1376;
unit = "page";
pos = degree.pos + 1.1*u*N;
plan feynman = newplan(content, begin_date, plan_days, total, unit, pos,
    contentpen, waitdraw);
draw(feynman -- degree @ shorten, Arrow);
plans.push(feynman);

content = "Ice and Fire";
begin_date = "2012-08-21";
plan_days = 447;
total = 3125;
unit = "page";
pos = degree.pos + 1.2*u*SW;
plan icefire = newplan(content, begin_date, plan_days, total, unit, pos,
    contentpen, waitdraw);
draw(icefire -- degree @ shorten, Arrow);
plans.push(icefire);

content = "NCE4";
begin_date = "2012-08-16";
plan_days = 144;
total = 48;
unit = "lesson";
pos = icefire.pos + 0.9*u*SW;
plan nce4 = newplan(content, begin_date, plan_days, total, unit, pos,
    contentpen, waitdraw);
draw(nce4 -- icefire @ shorten, Arrow);
plans.push(nce4);

draw(degree);
draw(plans);
finished_draw(plans);

dailyrecord("2012-09-10", holton, 10);
dailyrecord("2012-09-10", holton, 10);
dailyrecord("2012-09-10", holton, 10);
dailyrecord("2012-09-10", holton, 400);
//q2 = newplan("$q_2$", q1.pos + u*E, contentpen, goingdraw),
//q4 = newplan("$q_4$", q3.pos + u*E + 0.5u*S, contentpen, waitdraw), 

//draw("[0-9]", q1 -- q2 @ shorten, Arrow);
//draw(Label("[eE]", LeftSide), q3 -- q4 @ shorten, Arrow);
//draw("[0-9]", q4 .. bendright .. q6 @ shorten, Arrow);
