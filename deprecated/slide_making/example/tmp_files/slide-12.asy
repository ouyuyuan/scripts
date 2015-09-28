
// Description: standard graph package
//
//   @hierarchy: Graph Module | e
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-12-03 17:13:14 CST
// Last Change: 2012-12-13 19:58:12 CST

import myslide;
import graph;

include "latexpre.asy";

title("\bf d");

////////////////////////////////////////////////////////////////////////////////
//
// Log plot
//
pair posLoga = (slide.x*0.7/4, slide.y*2.0/4);
label(graphic("log-d.eps", "width=10cm"), posLoga, N);
label("{\bf other bases} {\color{red} \em (manual, 2004, P.114)}", posLoga, S);

pair posLogb = (slide.x*2.0/4, slide.y*2.0/4);
label(graphic("log-e.eps", "width=10cm"), posLogb, N);
label("{\bf broken axes} {\color{red} \em (manual, 2004, P.115)}", posLogb, S);
pagenumber(12);

shipout("slide-12.pdf");

